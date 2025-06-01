import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pfa/constants/const.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/models/enums.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/models/user.dart';
import 'package:pfa/providers/active_child_notifier.dart';
import 'package:pfa/providers/app_language_notifier.dart';
import 'package:pfa/providers/haptics_enabled_notifier.dart';
import 'package:pfa/providers/tts_speech_rate_notifier.dart';
import 'package:pfa/services/audio_service.dart';
import 'package:pfa/services/settings_service.dart';
import 'package:pfa/services/tts_service.dart';
import 'package:pfa/services/translation_service.dart';
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
import '../services/child_service.dart';
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

final ttsServiceProvider = Provider<TtsService>((ref) {
  final logger = ref.watch(loggingServiceProvider);
  final settingsService = ref.watch(settingsServiceProvider);
  final flutterTts = FlutterTts();
  return TtsService(logger, settingsService, ref, flutterTts);
});

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});

final audioServiceProvider = Provider<AudioService>((ref) {
  final logger = ref.watch(loggingServiceProvider);
  final settingsService = ref.watch(settingsServiceProvider);
  final audioPlayer = ref.watch(audioPlayerProvider);
  final audioService = AudioService(logger, settingsService, audioPlayer);
  ref.onDispose(() => audioService.dispose());
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

final childServiceProvider = Provider<ChildService>((ref) {
  final childRepository = ref.watch(childRepositoryProvider);
  return ChildService(childRepository: childRepository);
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
    final Locale currentLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final AppLocalizations l10n = lookupAppLocalizations(currentLocale);
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
      ref,
      l10n,
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
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return prefs.getBool(onboardingCompletedKey) ?? false;
});

final sharedPreferencesAsyncProvider = Provider<SharedPreferencesAsync>((ref) {
  return SharedPreferencesAsync();
});

final settingsServiceProvider = Provider<SettingsService>((ref) {
  final logger = ref.watch(loggingServiceProvider);
  final prefs = ref.watch(sharedPreferencesAsyncProvider);
  return SettingsService(logger, prefs);
});

final ttsEnabledProvider = FutureProvider<bool>((ref) async {
  return await ref.watch(settingsServiceProvider).isTtsEnabled();
});

final ttsSpeechRateProvider =
    StateNotifierProvider<TtsSpeechRateNotifier, double>((ref) {
  final settingsService = ref.watch(settingsServiceProvider);
  final ttsService = ref.watch(ttsServiceProvider);
  final logger = ref.watch(loggingServiceProvider);
  return TtsSpeechRateNotifier(settingsService, ttsService, logger);
});

final soundEffectsEnabledProvider = FutureProvider<bool>((ref) async {
  return await ref.watch(settingsServiceProvider).areSoundEffectsEnabled();
});

final appLanguageProvider =
    StateNotifierProvider<AppLanguageNotifier, AppLanguage>((ref) {
  final settingsService = ref.watch(settingsServiceProvider);
  final logger = ref.watch(loggingServiceProvider);
  return AppLanguageNotifier(settingsService, logger);
});

final localeProvider = Provider<Locale>((ref) {
  final appLanguage = ref.watch(appLanguageProvider);
  return Locale(appLanguage.code);
});

final hapticsEnabledProvider =
    StateNotifierProvider<HapticsEnabledNotifier, bool>((ref) {
  final settingsService = ref.watch(settingsServiceProvider);
  final logger = ref.watch(loggingServiceProvider);
  return HapticsEnabledNotifier(settingsService, logger);
});
