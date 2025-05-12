import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/constants/const.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/models/user.dart';
import 'package:pfa/providers/active_child_notifier.dart';
import 'package:pfa/services/audio_service.dart';
import 'package:pfa/services/child_service.dart';
import 'package:pfa/services/tts_service.dart';
import 'package:pfa/viewmodels/game_state.dart';
import 'package:pfa/viewmodels/game_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  final logger = ref.watch(loggingServiceProvider);
  return SupabaseService(logger);
});

final ttsServiceProvider = Provider<TtsService>((ref) {
  final logger = ref.watch(loggingServiceProvider);
  return TtsService(logger);
});

final audioServiceProvider = Provider<AudioService>((ref) {
  final logger = ref.watch(loggingServiceProvider);
  final audioService = AudioService(logger);
  ref.onDispose(() {
    audioService.dispose();
  });
  return audioService;
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

/// child providers
final childRepositoryProvider = Provider<ChildRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  final logger = ref.watch(loggingServiceProvider);
  return ChildRepository(supabaseService: supabaseService, logger: logger);
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

final childServiceProvider = Provider<ChildService>((ref){
  final childRepository = ref.watch(childRepositoryProvider);
  return ChildService(childRepository: childRepository);
});

/// game providers
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

final gameViewModelProvider = StateNotifierProvider.family<GameViewModel,
    GameState, String /* gameId */ >(
      (ref, gameId) {
    final gameRepo = ref.read(gameRepositoryProvider);
    final sessionRepo = ref.read(gameSessionRepositoryProvider);
    final logger = ref.read(loggingServiceProvider);
    final ttsService = ref.read(ttsServiceProvider);
    final audioService = ref.read(audioServiceProvider);
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
      ttsService,
      audioService,
    );
  },
);

final gamesByCategoryProvider =
FutureProvider.family<List<Game>, GameCategory>((ref, category) async {
  final logger = ref.read(loggingServiceProvider);
  logger.debug(
      "gamesByCategoryProvider: Fetching games for category $category...");

  final gameRepository = ref.read(gameRepositoryProvider);

  try {
    final games = await gameRepository.getGamesByCategory(category);
    logger.info(
        "gamesByCategoryProvider: Successfully fetched ${games.length} games for category $category.");
    return games;
  } catch (e, stackTrace) {
    logger.error(
        "gamesByCategoryProvider: Error fetching games for category $category",
        e,
        stackTrace);
    rethrow;
  }
});

/// stats providers
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


final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return prefs.getBool(onboardingCompletedKey) ?? false;
});