import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pfa/services/audio_service.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:pfa/services/settings_service.dart';
import 'package:audioplayers/audioplayers.dart';

@GenerateMocks([LoggingService, SettingsService, AudioPlayer])
import 'audio_service_test.mocks.dart';

void main() {
  late MockLoggingService mockLogger;
  late MockSettingsService mockSettingsService;
  late MockAudioPlayer mockAudioPlayer;
  late AudioService audioService;

  setUp(() {
    mockLogger = MockLoggingService();
    mockSettingsService = MockSettingsService();
    mockAudioPlayer = MockAudioPlayer();

    audioService =
        AudioService(mockLogger, mockSettingsService, mockAudioPlayer);
  });

  group('AudioService Initialization', () {
    test('initializes and logs correctly', () async {
      await Future.delayed(Duration.zero);

      verify(mockLogger.info('Initializing Audio Service...')).called(1);
      verify(mockLogger.info('Audio Service Initialized.')).called(1);
      verify(mockAudioPlayer.setReleaseMode(ReleaseMode.stop)).called(1);
    });
  });

  group('playSound', () {
    setUp(() {
      when(mockSettingsService.areSoundEffectsEnabled())
          .thenAnswer((_) async => true);
      when(mockAudioPlayer.play(any, volume: anyNamed('volume')))
          .thenAnswer((_) async => {});
    });

    test('plays correct sound when sound effects are enabled', () async {
      clearInteractions(mockLogger);
      clearInteractions(mockAudioPlayer);
      when(mockSettingsService.areSoundEffectsEnabled())
          .thenAnswer((_) async => true);
      when(mockAudioPlayer.play(any, volume: anyNamed('volume')))
          .thenAnswer((_) async => {});

      await audioService.playSound(SoundType.correct);

      verify(mockLogger.debug(
              'AudioService: Playing sound - audio/correct_feedback.mp3'))
          .called(1);
      verify(mockAudioPlayer.play(
              argThat(isA<AssetSource>().having((source) => source.path, 'path',
                  'audio/correct_feedback.mp3')),
              volume: 1.0))
          .called(1);
      verify(mockLogger.debug(
              'AudioService: Sound playback initiated for audio/correct_feedback.mp3.'))
          .called(1);
    });

    test('plays incorrect sound when sound effects are enabled', () async {
      clearInteractions(mockLogger);
      clearInteractions(mockAudioPlayer);
      when(mockSettingsService.areSoundEffectsEnabled())
          .thenAnswer((_) async => true);
      when(mockAudioPlayer.play(any, volume: anyNamed('volume')))
          .thenAnswer((_) async => {});

      await audioService.playSound(SoundType.incorrect);
      verify(mockLogger.debug(
              'AudioService: Playing sound - audio/incorrect_feedback.mp3'))
          .called(1);
      verify(mockAudioPlayer.play(
              argThat(isA<AssetSource>().having((source) => source.path, 'path',
                  'audio/incorrect_feedback.mp3')),
              volume: 1.0))
          .called(1);
      verify(mockLogger.debug(
              'AudioService: Sound playback initiated for audio/incorrect_feedback.mp3.'))
          .called(1);
    });

    test('plays level complete sound when sound effects are enabled', () async {
      clearInteractions(mockLogger);
      clearInteractions(mockAudioPlayer);
      when(mockSettingsService.areSoundEffectsEnabled())
          .thenAnswer((_) async => true);
      when(mockAudioPlayer.play(any, volume: anyNamed('volume')))
          .thenAnswer((_) async => {});

      await audioService.playSound(SoundType.levelComplete);
      verify(mockLogger
              .debug('AudioService: Playing sound - audio/level_complete.mp3'))
          .called(1);
      verify(mockAudioPlayer.play(
              argThat(isA<AssetSource>().having(
                  (source) => source.path, 'path', 'audio/level_complete.mp3')),
              volume: 1.0))
          .called(1);
      verify(mockLogger.debug(
              'AudioService: Sound playback initiated for audio/level_complete.mp3.'))
          .called(1);
    });

    test('plays game complete sound when sound effects are enabled', () async {
      clearInteractions(mockLogger);
      clearInteractions(mockAudioPlayer);
      when(mockSettingsService.areSoundEffectsEnabled())
          .thenAnswer((_) async => true);
      when(mockAudioPlayer.play(any, volume: anyNamed('volume')))
          .thenAnswer((_) async => {});

      await audioService.playSound(SoundType.gameComplete);
      verify(mockLogger
              .debug('AudioService: Playing sound - audio/game_complete.mp3'))
          .called(1);
      verify(mockAudioPlayer.play(
              argThat(isA<AssetSource>().having(
                  (source) => source.path, 'path', 'audio/game_complete.mp3')),
              volume: 1.0))
          .called(1);
      verify(mockLogger.debug(
              'AudioService: Sound playback initiated for audio/game_complete.mp3.'))
          .called(1);
    });

    test('does not play sound when sound effects are disabled', () async {
      clearInteractions(mockLogger);
      clearInteractions(mockAudioPlayer);
      when(mockSettingsService.areSoundEffectsEnabled())
          .thenAnswer((_) async => false);

      await audioService.playSound(SoundType.correct);

      verify(mockLogger.debug(
              'AudioService: Sound playback skipped, sound effects disabled by user settings.'))
          .called(1);
      verifyNever(mockLogger.debug(any));
      verifyNever(mockAudioPlayer.play(any, volume: anyNamed('volume')));
    });

    test('logs warning for unknown sound type', () async {
      clearInteractions(mockLogger);
      clearInteractions(mockAudioPlayer);
      when(mockSettingsService.areSoundEffectsEnabled())
          .thenAnswer((_) async => true);
      when(mockAudioPlayer.play(any, volume: anyNamed('volume')))
          .thenAnswer((_) async => {});

      await audioService.playSound(SoundType.uiClick);

      verify(mockLogger.warning(
              'AudioService: Unknown sound type requested: SoundType.uiClick'))
          .called(1);
      verifyNever(mockLogger.debug(any));
      verifyNever(mockAudioPlayer.play(any, volume: anyNamed('volume')));
    });

    test('logs error if playing sound fails', () async {
      clearInteractions(mockLogger);
      clearInteractions(mockAudioPlayer);
      when(mockSettingsService.areSoundEffectsEnabled())
          .thenAnswer((_) async => true);
      final exception = Exception('Failed to play');
      when(mockAudioPlayer.play(any, volume: anyNamed('volume')))
          .thenThrow(exception);

      await audioService.playSound(SoundType.correct);
      verify(mockLogger.error(
              'AudioService: Error playing sound audio/correct_feedback.mp3',
              exception,
              any))
          .called(1);
    });
  });

  group('dispose', () {
    test('disposes player and logs correctly', () async {
      await audioService.dispose();

      verify(mockLogger.info('Disposing Audio Service...')).called(1);
      verify(mockAudioPlayer.dispose()).called(1);
    });
  });
}
