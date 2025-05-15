import 'package:pfa/constants/const.dart';
import 'package:pfa/models/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pfa/services/logging_service.dart';

class SettingsService {
  final LoggingService _logger;

  SettingsService(this._logger);

  Future<void> setAppLanguage(AppLanguage language) async {
    final prefs = SharedPreferencesAsync();
    await prefs.setString(keyAppLanguage, language.code);
    _logger.info("SettingsService: App language set to ${language.code}");
  }

  Future<AppLanguage> getAppLanguage(
      {AppLanguage defaultValue = AppLanguage.arabic}) async {
    final prefs = SharedPreferencesAsync();
    final languageCode = await prefs.getString(keyAppLanguage);
    if (languageCode != null) {
      final lang = AppLanguageExtension.fromCode(languageCode);
      _logger.debug("SettingsService: Retrieved app language: ${lang.code}");
      return lang;
    }
    _logger.debug(
        "SettingsService: No app language set, returning default: ${defaultValue.code}");
    return defaultValue;
  }

  Future<void> setLastActiveChildId(String? childId) async {
    final prefs = SharedPreferencesAsync();
    if (childId == null) {
      await prefs.remove(keyLastActiveChildId);
      _logger.info("SettingsService: Last active child ID cleared.");
    } else {
      await prefs.setString(keyLastActiveChildId, childId);
      _logger.info("SettingsService: Last active child ID set to $childId");
    }
  }

  Future<String?> getLastActiveChildId() async {
    final prefs = SharedPreferencesAsync();
    final id = await prefs.getString(keyLastActiveChildId);
    _logger.debug("SettingsService: Retrieved last active child ID: $id");
    return id;
  }

  Future<void> setTtsEnabled(bool enabled) async {
    final prefs = SharedPreferencesAsync();
    await prefs.setBool(keyTtsEnabled, enabled);
    _logger.info("SettingsService: TTS enabled set to $enabled");
  }

  Future<bool> isTtsEnabled({bool defaultValue = true}) async {
    final prefs = SharedPreferencesAsync();
    final enabled = await prefs.getBool(keyTtsEnabled) ?? defaultValue;
    _logger.debug(
        "SettingsService: Retrieved TTS enabled: $enabled (default: $defaultValue)");
    return enabled;
  }

  Future<void> setTtsSpeechRate(double rate) async {
    final prefs = SharedPreferencesAsync();
    final clampedRate = rate.clamp(0.0, 1.0);
    await prefs.setDouble(keyTtsSpeechRate, clampedRate);
    _logger.info("SettingsService: TTS speech rate set to $clampedRate");
  }

  Future<double> getTtsSpeechRate({double defaultValue = 0.5}) async {
    final prefs = SharedPreferencesAsync();
    final rate = await prefs.getDouble(keyTtsSpeechRate) ?? defaultValue;
    _logger.debug(
        "SettingsService: Retrieved TTS speech rate: $rate (default: $defaultValue)");
    return rate;
  }

  Future<void> setSoundEffectsEnabled(bool enabled) async {
    final prefs = SharedPreferencesAsync();
    await prefs.setBool(keySoundEffectsEnabled, enabled);
    _logger.info("SettingsService: Sound effects enabled set to $enabled");
  }

  Future<bool> areSoundEffectsEnabled({bool defaultValue = true}) async {
    final prefs = SharedPreferencesAsync();
    final enabled = await prefs.getBool(keySoundEffectsEnabled) ?? defaultValue;
    _logger.debug(
        "SettingsService: Retrieved sound effects enabled: $enabled (default: $defaultValue)");
    return enabled;
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    final prefs = SharedPreferencesAsync();
    await prefs.setBool(keyHapticFeedbackEnabled, enabled);
    _logger.info("SettingsService: Haptic feedbacks enabled set to $enabled");
  }

  Future<bool> areHapticsEnabled({bool defaultValue = true}) async {
    final prefs = SharedPreferencesAsync();
    final enabled =
        await prefs.getBool(keyHapticFeedbackEnabled) ?? defaultValue;
    _logger.debug(
        "SettingsService: Retrieved Haptic feedbacks enabled: $enabled (default: $defaultValue)");
    return enabled;
  }

  // Method to clear all app-specific settings (e.g., on logout or factory reset)
  Future<void> clearAllAppSettings() async {
    final prefs = SharedPreferencesAsync();
    await prefs.remove(keyLastActiveChildId);
    await prefs.remove(keyTtsEnabled);
    await prefs.remove(keySoundEffectsEnabled);
    await prefs.remove(keyAppLanguage);
    await prefs.remove(onboardingCompletedKey);
    await prefs.remove(keyTtsSpeechRate);
    _logger.info("SettingsService: All app-specific settings cleared.");
  }
}
