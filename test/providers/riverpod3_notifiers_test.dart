import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:arc_en_jeu/models/user.dart';
import 'package:arc_en_jeu/providers/active_child_notifier.dart';
import 'package:arc_en_jeu/providers/global_providers.dart';
import 'package:arc_en_jeu/repositories/child_repository.dart';
import 'package:arc_en_jeu/repositories/game_session_repository.dart';
import 'package:arc_en_jeu/services/translation_service.dart';
import 'package:arc_en_jeu/viewmodels/game_state.dart';

import '../mocks/mock_services.mocks.dart';

void main() {
  late MockSettingsService settingsService;
  late MockLoggingService loggingService;

  setUp(() {
    settingsService = MockSettingsService();
    loggingService = MockLoggingService();
    when(loggingService.debug(any)).thenReturn(null);
    when(loggingService.info(any)).thenReturn(null);
    when(loggingService.warning(any, any, any)).thenReturn(null);
    when(loggingService.error(any, any, any)).thenReturn(null);
  });

  group('settings notifiers', () {
    test('loads and clamps the TTS speech rate', () async {
      final ttsService = MockTtsService();
      when(settingsService.getTtsSpeechRate(defaultValue: 0.5))
          .thenAnswer((_) async => 0.65);
      when(ttsService.changeSpeechRate(any)).thenAnswer((_) async {});
      final container = ProviderContainer(
        overrides: [
          settingsServiceProvider.overrideWithValue(settingsService),
          loggingServiceProvider.overrideWithValue(loggingService),
          ttsServiceProvider.overrideWithValue(ttsService),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(ttsSpeechRateProvider), 1.0);
      await Future<void>.delayed(Duration.zero);
      expect(container.read(ttsSpeechRateProvider), 0.65);

      await container
          .read(ttsSpeechRateProvider.notifier)
          .updateSpeechRate(2.0);

      expect(container.read(ttsSpeechRateProvider), 1.0);
      verify(ttsService.changeSpeechRate(1.0)).called(1);
    });

    test('loads and persists haptics changes', () async {
      when(settingsService.areHapticsEnabled(defaultValue: true))
          .thenAnswer((_) async => false);
      when(settingsService.setHapticsEnabled(any)).thenAnswer((_) async {});
      final container = ProviderContainer(
        overrides: [
          settingsServiceProvider.overrideWithValue(settingsService),
          loggingServiceProvider.overrideWithValue(loggingService),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(hapticsEnabledProvider), isTrue);
      await Future<void>.delayed(Duration.zero);
      expect(container.read(hapticsEnabledProvider), isFalse);

      await container
          .read(hapticsEnabledProvider.notifier)
          .setHapticsEnabled(true);

      expect(container.read(hapticsEnabledProvider), isTrue);
      verify(settingsService.setHapticsEnabled(true)).called(1);
    });
  });

  test('active child selection updates provider state and settings', () async {
    when(settingsService.getLastActiveChildId()).thenAnswer((_) async => null);
    when(settingsService.setLastActiveChildId(any)).thenAnswer((_) async {});
    final supabaseService = MockSupabaseService();
    final container = ProviderContainer(
      overrides: [
        settingsServiceProvider.overrideWithValue(settingsService),
        loggingServiceProvider.overrideWithValue(loggingService),
        childRepositoryProvider.overrideWithValue(ChildRepository(
          supabaseService: supabaseService,
          logger: loggingService,
        )),
        initialChildProfilesProvider
            .overrideWith((ref) async => <Child>[]),
        supabaseAuthStateProvider
            .overrideWith((ref) => const Stream<AuthState>.empty()),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(activeChildProvider), isNull);
    await Future<void>.delayed(Duration.zero);

    final child = Child(
      childId: 'child-1',
      accountId: 'parent-1',
      firstName: 'Alex',
      birthdate: DateTime(2018),
      specialConditions: {},
      createdAt: DateTime(2024),
      updatedAt: DateTime(2024),
    );
    container.read(activeChildProvider.notifier).set(child);

    expect(container.read(activeChildProvider), same(child));
    verify(settingsService.setLastActiveChildId('child-1')).called(1);
  });

  test('game view model initializes and reports a missing game', () async {
    final gameRepository = MockGameRepository();
    when(gameRepository.getGameById('missing-game'))
        .thenAnswer((_) async => null);
    final supabaseService = MockSupabaseService();
    final child = Child(
      childId: 'child-1',
      accountId: 'parent-1',
      firstName: 'Alex',
      birthdate: DateTime(2018),
      specialConditions: {},
      createdAt: DateTime(2024),
      updatedAt: DateTime(2024),
    );
    final container = ProviderContainer(
      overrides: [
        activeChildProvider.overrideWith(() => _FixedActiveChildNotifier(child)),
        gameRepositoryProvider.overrideWithValue(gameRepository),
        gameSessionRepositoryProvider.overrideWithValue(GameSessionRepository(
          supabaseService: supabaseService,
          logger: loggingService,
        )),
        loggingServiceProvider.overrideWithValue(loggingService),
        ttsServiceProvider.overrideWithValue(MockTtsService()),
        audioServiceProvider.overrideWithValue(MockAudioService()),
        translationServiceProvider
            .overrideWithValue(TranslationService(() => 'en')),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(gameViewModelProvider('missing-game')).status,
        GameStatus.initial);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(gameViewModelProvider('missing-game')).status,
        GameStatus.error);
    verify(gameRepository.getGameById('missing-game')).called(1);
  });
}

class _FixedActiveChildNotifier extends ActiveChildNotifier {
  _FixedActiveChildNotifier(this.child);

  final Child child;

  @override
  Child? build() => child;
}
