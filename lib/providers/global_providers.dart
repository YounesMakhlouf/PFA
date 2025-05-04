import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/models/user.dart';
import 'package:pfa/services/multiple_choice_game_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:pfa/services/supabase_service.dart';
import 'package:pfa/repositories/child_repository.dart';
import 'package:pfa/repositories/game_repository.dart';
import 'package:pfa/repositories/game_session_repository.dart';

final loggingServiceProvider = Provider<LoggingService>((ref) {
  return LoggingService();
});

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  final logger = ref.watch(loggingServiceProvider);
  return SupabaseService(logger);
});

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return supabaseService.client;
});

final supabaseAuthStateProvider = StreamProvider<AuthState>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return supabaseClient.auth.onAuthStateChange;
});

final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(supabaseAuthStateProvider);
  return authState.valueOrNull?.session?.user.id;
});

final childRepositoryProvider = Provider<ChildRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  final logger = ref.watch(loggingServiceProvider);
  return ChildRepository(supabaseService: supabaseService, logger: logger);
});

final gameSessionRepositoryProvider = Provider<GameSessionRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  final logger = ref.watch(loggingServiceProvider);
  return GameSessionRepository(
      supabaseService: supabaseService, logger: logger);
});

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  final logger = ref.watch(loggingServiceProvider);
  return GameRepository(supabaseService: supabaseService, logger: logger);
});

final multipleChoiceGameServiceProvider =
    Provider<MultipleChoiceGameService>((ref) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final logger = ref.watch(loggingServiceProvider);
  return MultipleChoiceGameService(
      gameRepository: gameRepository, logger: logger);
});

final initialChildProfilesProvider = FutureProvider<List<Child>>((ref) async {
  final logger = ref.read(loggingServiceProvider);

  final currentUserId = ref.watch(currentUserIdProvider);

  if (currentUserId != null) {
    logger.debug(
        "initialChildProfilesProvider: User ID $currentUserId detected. Fetching profiles...");
    final repo = ref.read(childRepositoryProvider);
    try {
      final profiles = await repo.getChildProfilesForParent();
      logger.debug(
          "initialChildProfilesProvider: Found ${profiles.length} profiles for user $currentUserId.");
      return profiles;
    } catch (e, stackTrace) {
      logger.error(
          "initialChildProfilesProvider: Error fetching profiles for user $currentUserId",
          e,
          stackTrace);
      rethrow;
    }
  } else {
    logger.debug(
        "initialChildProfilesProvider: No user ID available. Returning empty profile list.");
    return [];
  }
});

class ActiveChildNotifier extends StateNotifier<Child?> {
  final Ref _ref;

  ActiveChildNotifier(this._ref) : super(null) {
    final logger = _ref.read(loggingServiceProvider);

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
          _updateActiveChild(asyncProfiles);
        }
      }
    } else if (asyncProfiles is AsyncError) {
      logger.error("ActiveChildNotifier: Error loading profiles",
          asyncProfiles.error, asyncProfiles.stackTrace);
      state = null;
    }
  }

  void set(Child? child) {
    _ref.read(loggingServiceProvider).info(
        "ActiveChildNotifier: Manually setting active child to ${child?.childId ?? 'null'}");
    state = child;
  }
}

final activeChildProvider =
    StateNotifierProvider<ActiveChildNotifier, Child?>((ref) {
  return ActiveChildNotifier(ref);
});
