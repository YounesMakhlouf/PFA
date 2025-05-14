import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/models/user.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ActiveChildNotifier extends StateNotifier<Child?> {
  final Ref _ref;

  ActiveChildNotifier(this._ref) : super(null) {
    final logger = _ref.read(loggingServiceProvider);
    _loadInitialActiveChild();

    _ref.listen<AsyncValue<List<Child>>>(initialChildProfilesProvider,
        (previous, next) {
      logger.debug(
          "ActiveChildNotifier: Listener initialChildProfilesProvider fired: ${next.toString()}");
      _updateActiveChild(next);
    });

    _ref.listen<AsyncValue<AuthState>>(supabaseAuthStateProvider,
        (previous, next) {
      logger.debug(
          "ActiveChildNotifier: Listener supabaseAuthStateProvider fired: ${next.toString()}");
      if (next is AsyncData<AuthState>) {
        final authState = next.value;
        if (authState.session == null && state != null) {
          logger.info(
              "ActiveChildNotifier: Auth session is null, clearing active child.");
          state = null; // Clear active child on logout
        }
      } else if (next is AsyncError) {
        logger.error(
            "ActiveChildNotifier: Error in auth stream, clearing active child.",
            next.error,
            next.stackTrace);
        state = null;
      }
    });
  }

  Future<void> _loadInitialActiveChild() async {
    final logger = _ref.read(loggingServiceProvider);
    final settingsService = _ref.read(settingsServiceProvider);
    final childRepository = _ref.read(childRepositoryProvider);

    final lastActiveId = await settingsService.getLastActiveChildId();
    if (lastActiveId != null) {
      logger.info(
          "ActiveChildNotifier: Found last active child ID: $lastActiveId. Verifying...");
      try {
        // Verify this child still exists and belongs to the current user
        final profile = await childRepository.getChildProfileById(lastActiveId);
        if (profile != null) {
          // Check if current user (from auth state) matches profile's account_id
          final currentAuthUser =
              _ref.read(supabaseAuthStateProvider).valueOrNull?.session?.user;
          if (currentAuthUser != null &&
              profile.accountId == currentAuthUser.id) {
            logger.info(
                "ActiveChildNotifier: Setting last active child: ${profile.childId}");
            state = profile;
          } else {
            logger.warning(
                "ActiveChildNotifier: Last active child $lastActiveId does not belong to current user or user not found. Clearing persisted ID.");
            await settingsService.setLastActiveChildId(null);
          }
        } else {
          logger.warning(
              "ActiveChildNotifier: Last active child $lastActiveId not found in DB. Clearing persisted ID.");
          await settingsService.setLastActiveChildId(null);
        }
      } catch (e, st) {
        logger.error(
            "ActiveChildNotifier: Error verifying last active child $lastActiveId",
            e,
            st);
        await settingsService.setLastActiveChildId(null);
      }
    } else {
      logger.debug(
          "ActiveChildNotifier: No last active child ID found in settings.");
    }
  }

  void _updateActiveChild(AsyncValue<List<Child>> asyncProfiles) {
    final logger = _ref.read(loggingServiceProvider);
    final currentSession =
        _ref.read(supabaseAuthStateProvider).valueOrNull?.session;
    if (currentSession == null) {
      logger.debug("_updateActiveChild: Skipping update, no active session.");
      return;
    }

    if (asyncProfiles is AsyncData<List<Child>>) {
      final profiles = asyncProfiles.value;
      if (state == null) {
        if (profiles.isNotEmpty) {
          logger
              .info("ActiveChildNotifier: Setting active child (first found).");
          state = profiles.first; //TODO: Add logic for selecting profile
        } else {
          logger.info(
              "ActiveChildNotifier: No profiles found for logged-in user.");
          state = null;
        }
      } else {
        // Active child already set, check if it still exists in the new list
        if (!profiles.any((p) => p.childId == state!.childId)) {
          logger.warning(
              "ActiveChildNotifier: Currently active child ${state!.childId} no longer found in profile list. Clearing.");
          state = null;
        }
      }
    } else if (asyncProfiles is AsyncError) {
      logger.error("ActiveChildNotifier: Error loading profiles",
          asyncProfiles.error, asyncProfiles.stackTrace);
      state = null;
    }
  }

  void set(Child? child) {
    final settingsService = _ref.read(settingsServiceProvider);
    if (state?.childId != child?.childId) {
      _ref.read(loggingServiceProvider).info(
          "ActiveChildNotifier: Manually setting active child to ${child?.childId ?? 'null'}");
      state = child;
      settingsService.setLastActiveChildId(child?.childId);
    }
  }
}
