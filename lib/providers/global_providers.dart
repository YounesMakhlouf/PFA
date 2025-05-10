import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/models/user.dart';
import 'package:pfa/providers/active_child_notifier.dart';
import 'package:pfa/services/multiple_choice_game_service.dart';
import 'package:pfa/services/translation_service.dart';
import 'package:pfa/view_models/game_screen/game_screen_state.dart';
import 'package:pfa/view_models/game_screen/game_screen_view_model.dart';
import 'package:pfa/viewmodels/game_state.dart';
import 'package:pfa/viewmodels/game_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:pfa/services/supabase_service.dart';
import 'package:pfa/repositories/child_repository.dart';
import 'package:pfa/repositories/game_repository.dart';
import 'package:pfa/repositories/game_session_repository.dart';

import '../repositories/child_stats_repository.dart';
import '../services/child_stats_service.dart';

final loggingServiceProvider = Provider<LoggingService>((ref) {
  return LoggingService();
});

final translationServiceProvider = Provider<TranslationService>((ref) {
  return TranslationService();
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
  final translationService = ref.watch(translationServiceProvider);
  return GameRepository(supabaseService: supabaseService, logger: logger);
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

final activeChildProvider =
    StateNotifierProvider<ActiveChildNotifier, Child?>((ref) {
  return ActiveChildNotifier(ref);
});

// stats providers
final childStatsRepositoryProvider = Provider<ChildStatsRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  final logger = ref.watch(loggingServiceProvider);
  return ChildStatsRepository(supabaseService: supabaseService, logger: logger);
});

final childStatsServiceProvider = Provider<ChildStatsService>((ref) {
  final childStatsRepository = ref.watch(childStatsRepositoryProvider);
  return ChildStatsService(
    statsRepository: childStatsRepository,
  );
});

final gameViewModelProvider = StateNotifierProvider.family<GameViewModel,
    GameState, String /* gameId */ >(
  (ref, gameId) {
    final gameRepo = ref.read(gameRepositoryProvider);
    final sessionRepo = ref.read(gameSessionRepositoryProvider);
    final logger = ref.read(loggingServiceProvider);

    final activeChild = ref.watch(activeChildProvider);

    if (activeChild == null) {
      logger.error(
          "GameViewModelProvider: Attempted to create GameViewModel for game '$gameId' but no active child is set. This indicates a UI flow error.");
      throw StateError(
          "Cannot initialize GameViewModel: No active child selected. Please select a child profile first.");
    }

    return GameViewModel(
      gameId,
      activeChild.childId,
      gameRepo,
      logger,
      sessionRepo,
    );
  },
);

final gamesByCategoryProvider = FutureProvider.family<List<Game>, GameCategory>((ref, category) async {
  final logger = ref.read(loggingServiceProvider);
  logger.debug("gamesByCategoryProvider: Fetching games for category $category...");

  final gameRepository = ref.read(gameRepositoryProvider);

  try {

    final games = await gameRepository.getGamesByCategory(category);
    logger.info("gamesByCategoryProvider: Successfully fetched ${games.length} games for category $category.");
    return games;
  } catch (e, stackTrace) {
    logger.error("gamesByCategoryProvider: Error fetching games for category $category", e, stackTrace);
    rethrow;
  }
});