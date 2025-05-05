import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/models/user.dart';
import 'package:pfa/providers/active_child_notifier.dart';
import 'package:pfa/services/multiple_choice_game_service.dart';
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

final activeChildProvider =
    StateNotifierProvider<ActiveChildNotifier, Child?>((ref) {
  return ActiveChildNotifier(ref);
});

// stats providers
final childStatsRepositoryProvider = Provider<ChildStatsRepository>((ref){
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
