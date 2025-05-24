import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pfa/constants/const.dart';
import 'package:pfa/models/enums.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:pfa/services/settings_service.dart';
import 'settings_service_test.mocks.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([LoggingService, SharedPreferencesAsync])
void main() {
  late MockLoggingService mockLogger;
  late MockSharedPreferencesAsync mockPrefs;
  late SettingsService settingsService;

  setUp(() {
    mockLogger = MockLoggingService();
    mockPrefs = MockSharedPreferencesAsync();
    settingsService = SettingsService(mockLogger, mockPrefs);

    // Default stub for remove operations
    when(mockPrefs.remove(any)).thenAnswer((_) async => true);
    // Default stubs for setters to avoid null errors if not specifically testing them
    when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
    when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);
    when(mockPrefs.setDouble(any, any)).thenAnswer((_) async => true);
  });

  group('Last Active Child ID', () {
    test('setLastActiveChildId sets string in prefs', () async {
      const childId = 'test-child-id';
      when(mockPrefs.setString(keyLastActiveChildId, childId))
          .thenAnswer((_) async => true);

      await settingsService.setLastActiveChildId(childId);

      verify(mockPrefs.setString(keyLastActiveChildId, childId)).called(1);
      verify(mockLogger
              .info('SettingsService: Last active child ID set to $childId'))
          .called(1);
    });

    test('setLastActiveChildId removes key from prefs if childId is null',
        () async {
      when(mockPrefs.remove(keyLastActiveChildId))
          .thenAnswer((_) async => true);

      await settingsService.setLastActiveChildId(null);

      verify(mockPrefs.remove(keyLastActiveChildId)).called(1);
      verify(mockLogger.info('SettingsService: Last active child ID cleared.'))
          .called(1);
    });

    test('getLastActiveChildId retrieves string from prefs', () async {
      const childId = 'test-child-id';
      when(mockPrefs.getString(keyLastActiveChildId))
          .thenAnswer((_) async => childId);

      final result = await settingsService.getLastActiveChildId();

      expect(result, childId);
      verify(mockPrefs.getString(keyLastActiveChildId)).called(1);
      verify(mockLogger.debug(
              'SettingsService: Retrieved last active child ID: $childId'))
          .called(1);
    });

    test('getLastActiveChildId returns null if not set', () async {
      when(mockPrefs.getString(keyLastActiveChildId))
          .thenAnswer((_) async => null);

      final result = await settingsService.getLastActiveChildId();

      expect(result, null);
      verify(mockLogger
              .debug('SettingsService: Retrieved last active child ID: null'))
          .called(1);
    });
  });

  group('TTS Enabled', () {
    test('setTtsEnabled sets bool in prefs', () async {
      when(mockPrefs.setBool(keyTtsEnabled, true))
          .thenAnswer((_) async => true);
      await settingsService.setTtsEnabled(true);
      verify(mockPrefs.setBool(keyTtsEnabled, true)).called(1);
      verify(mockLogger.info('SettingsService: TTS enabled set to true'))
          .called(1);

      when(mockPrefs.setBool(keyTtsEnabled, false))
          .thenAnswer((_) async => true);
      await settingsService.setTtsEnabled(false);
      verify(mockPrefs.setBool(keyTtsEnabled, false)).called(1);
      verify(mockLogger.info('SettingsService: TTS enabled set to false'))
          .called(1);
    });

    test('isTtsEnabled retrieves bool from prefs, defaults to true', () async {
      when(mockPrefs.getBool(keyTtsEnabled)).thenAnswer((_) async => true);
      var result = await settingsService.isTtsEnabled();
      expect(result, true);
      verify(mockLogger.debug(
              'SettingsService: Retrieved TTS enabled: true (default: true)'))
          .called(1);

      when(mockPrefs.getBool(keyTtsEnabled)).thenAnswer((_) async => false);
      result = await settingsService.isTtsEnabled();
      expect(result, false);
      verify(mockLogger.debug(
              'SettingsService: Retrieved TTS enabled: false (default: true)'))
          .called(1);

      when(mockPrefs.getBool(keyTtsEnabled)).thenAnswer((_) async => null);
      result = await settingsService.isTtsEnabled(); // Should use default
      expect(result, true);
      verify(mockLogger.debug(
              'SettingsService: Retrieved TTS enabled: true (default: true)'))
          .called(1); // Called twice now for this specific log
    });

    test('isTtsEnabled uses provided default value', () async {
      when(mockPrefs.getBool(keyTtsEnabled)).thenAnswer((_) async => null);
      final result = await settingsService.isTtsEnabled(defaultValue: false);
      expect(result, false);
      verify(mockLogger.debug(
              'SettingsService: Retrieved TTS enabled: false (default: false)'))
          .called(1);
    });
  });

  group('TTS Speech Rate', () {
    test('setTtsSpeechRate sets double in prefs, clamped between 0.0 and 1.0',
        () async {
      when(mockPrefs.setDouble(keyTtsSpeechRate, 0.7))
          .thenAnswer((_) async => true);
      await settingsService.setTtsSpeechRate(0.7);
      verify(mockPrefs.setDouble(keyTtsSpeechRate, 0.7)).called(1);
      verify(mockLogger.info('SettingsService: TTS speech rate set to 0.7'))
          .called(1);

      when(mockPrefs.setDouble(keyTtsSpeechRate, 0.0))
          .thenAnswer((_) async => true);
      await settingsService.setTtsSpeechRate(-0.5); // Should be clamped to 0.0
      verify(mockPrefs.setDouble(keyTtsSpeechRate, 0.0)).called(1);
      verify(mockLogger.info('SettingsService: TTS speech rate set to 0.0'))
          .called(1);

      when(mockPrefs.setDouble(keyTtsSpeechRate, 1.0))
          .thenAnswer((_) async => true);
      await settingsService.setTtsSpeechRate(1.5); // Should be clamped to 1.0
      verify(mockPrefs.setDouble(keyTtsSpeechRate, 1.0)).called(1);
      verify(mockLogger.info('SettingsService: TTS speech rate set to 1.0'))
          .called(1);
    });

    test('getTtsSpeechRate retrieves double from prefs, defaults to 0.5',
        () async {
      when(mockPrefs.getDouble(keyTtsSpeechRate)).thenAnswer((_) async => 0.8);
      var result = await settingsService.getTtsSpeechRate();
      expect(result, 0.8);
      verify(mockLogger.debug(
              'SettingsService: Retrieved TTS speech rate: 0.8 (default: 0.5)'))
          .called(1);

      when(mockPrefs.getDouble(keyTtsSpeechRate)).thenAnswer((_) async => null);
      result = await settingsService.getTtsSpeechRate(); // Should use default
      expect(result, 0.5);
      verify(mockLogger.debug(
              'SettingsService: Retrieved TTS speech rate: 0.5 (default: 0.5)'))
          .called(1);
    });

    test('getTtsSpeechRate uses provided default value', () async {
      when(mockPrefs.getDouble(keyTtsSpeechRate)).thenAnswer((_) async => null);
      final result = await settingsService.getTtsSpeechRate(defaultValue: 0.3);
      expect(result, 0.3);
      verify(mockLogger.debug(
              'SettingsService: Retrieved TTS speech rate: 0.3 (default: 0.3)'))
          .called(1);
    });
  });

  group('Sound Effects Enabled', () {
    test('setSoundEffectsEnabled sets bool in prefs', () async {
      when(mockPrefs.setBool(keySoundEffectsEnabled, true))
          .thenAnswer((_) async => true);
      await settingsService.setSoundEffectsEnabled(true);
      verify(mockPrefs.setBool(keySoundEffectsEnabled, true)).called(1);
      verify(mockLogger
              .info('SettingsService: Sound effects enabled set to true'))
          .called(1);
    });

    test('areSoundEffectsEnabled retrieves bool from prefs, defaults to true',
        () async {
      when(mockPrefs.getBool(keySoundEffectsEnabled))
          .thenAnswer((_) async => false);
      final result = await settingsService.areSoundEffectsEnabled();
      expect(result, false);
      verify(mockLogger.debug(
              'SettingsService: Retrieved sound effects enabled: false (default: true)'))
          .called(1);

      when(mockPrefs.getBool(keySoundEffectsEnabled))
          .thenAnswer((_) async => null);
      final resultNull = await settingsService.areSoundEffectsEnabled();
      expect(resultNull, true);
      verify(mockLogger.debug(
              'SettingsService: Retrieved sound effects enabled: true (default: true)'))
          .called(1);
    });
  });

  group('Haptics Enabled', () {
    test('setHapticsEnabled sets bool in prefs', () async {
      when(mockPrefs.setBool(keyHapticFeedbackEnabled, true))
          .thenAnswer((_) async => true);
      await settingsService.setHapticsEnabled(true);
      verify(mockPrefs.setBool(keyHapticFeedbackEnabled, true)).called(1);
      verify(mockLogger
              .info('SettingsService: Haptic feedbacks enabled set to true'))
          .called(1);
    });

    test('areHapticsEnabled retrieves bool from prefs, defaults to true',
        () async {
      when(mockPrefs.getBool(keyHapticFeedbackEnabled))
          .thenAnswer((_) async => false);
      final result = await settingsService.areHapticsEnabled();
      expect(result, false);
      verify(mockLogger.debug(
              'SettingsService: Retrieved Haptic feedbacks enabled: false (default: true)'))
          .called(1);

      when(mockPrefs.getBool(keyHapticFeedbackEnabled))
          .thenAnswer((_) async => null);
      final resultNull = await settingsService.areHapticsEnabled();
      expect(resultNull, true);
      verify(mockLogger.debug(
              'SettingsService: Retrieved Haptic feedbacks enabled: true (default: true)'))
          .called(1);
    });
  });

  group('App Language', () {
    test('setAppLanguage sets string in prefs', () async {
      when(mockPrefs.setString(keyAppLanguage, AppLanguage.english.code))
          .thenAnswer((_) async => true);
      await settingsService.setAppLanguage(AppLanguage.english);
      verify(mockPrefs.setString(keyAppLanguage, AppLanguage.english.code))
          .called(1);
      verify(mockLogger.info('SettingsService: App language set to en'))
          .called(1);
    });

    test('getAppLanguage retrieves AppLanguage from prefs, defaults to arabic',
        () async {
      when(mockPrefs.getString(keyAppLanguage))
          .thenAnswer((_) async => AppLanguage.french.code);
      var result = await settingsService.getAppLanguage();
      expect(result, AppLanguage.french);
      verify(mockLogger.debug('SettingsService: Retrieved app language: fr'))
          .called(1);

      when(mockPrefs.getString(keyAppLanguage)).thenAnswer((_) async => null);
      result = await settingsService.getAppLanguage(); // Should use default
      expect(result, AppLanguage.arabic);
      verify(mockLogger.debug(
              'SettingsService: No app language set, returning default: ar'))
          .called(1);
    });

    test('getAppLanguage uses provided default value', () async {
      when(mockPrefs.getString(keyAppLanguage)).thenAnswer((_) async => null);
      final result = await settingsService.getAppLanguage(
          defaultValue: AppLanguage.english);
      expect(result, AppLanguage.english);
      verify(mockLogger.debug(
              'SettingsService: No app language set, returning default: en'))
          .called(1);
    });
  });

  group('clearAllAppSettings', () {
    test('removes all relevant keys from prefs', () async {
      await settingsService.clearAllAppSettings();

      verify(mockPrefs.remove(keyLastActiveChildId)).called(1);
      verify(mockPrefs.remove(keyTtsEnabled)).called(1);
      verify(mockPrefs.remove(keySoundEffectsEnabled)).called(1);
      verify(mockPrefs.remove(keyAppLanguage)).called(1);
      verify(mockPrefs.remove(onboardingCompletedKey)).called(1);
      verify(mockPrefs.remove(keyTtsSpeechRate)).called(1);
      verify(mockPrefs.remove(keyHapticFeedbackEnabled)).called(1);
      verify(mockLogger
              .info('SettingsService: All app-specific settings cleared.'))
          .called(1);
    });
  });
}
