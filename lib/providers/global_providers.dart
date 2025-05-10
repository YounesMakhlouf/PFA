import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/services/multiple_choice_game_service.dart';
import 'package:pfa/services/translation_service.dart';
import 'package:pfa/view_models/game_screen/game_screen_state.dart';
import 'package:pfa/view_models/game_screen/game_screen_view_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:pfa/services/supabase_service.dart';
import 'package:pfa/repositories/child_repository.dart';
import 'package:pfa/repositories/game_repository.dart';
import 'package:pfa/repositories/game_session_repository.dart';

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

final gameScreenViewModelProvider =
    StateNotifierProvider<GameScreenViewModel, GameScreenState>(
  (ref) => GameScreenViewModel(),
);

final multipleChoiceGameServiceProvider =
    Provider<MultipleChoiceGameService>((ref) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final logger = ref.watch(loggingServiceProvider);
  return MultipleChoiceGameService(
      gameRepository: gameRepository, logger: logger);
});
