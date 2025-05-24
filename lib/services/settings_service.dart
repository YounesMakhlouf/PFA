import 'package:pfa/constants/const.dart';
import 'package:pfa/models/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pfa/services/logging_service.dart';

class SettingsService {
  final LoggingService _logger;
  final SharedPreferencesAsync _prefs;

  SettingsService(this._logger, this._prefs);

  Future<void> setLastActiveChildId(String? childId) async {
    if (childId == null) {
      await _prefs.remove(keyLastActiveChildId);
      _logger.info("SettingsService: Last active child ID cleared.");
    } else {
      await _prefs.setString(keyLastActiveChildId, childId);
      _logger.info("SettingsService: Last active child ID set to $childId");
    }
  }

  Future<String?> getLastActiveChildId() async {
    final id = await _prefs.getString(keyLastActiveChildId);
    _logger.debug("SettingsService: Retrieved last active child ID: $id");
    return id;
  }

  Future<void> setTtsEnabled(bool enabled) async {
    await _prefs.setBool(keyTtsEnabled, enabled);
    _logger.info("SettingsService: TTS enabled set to $enabled");
  }

  Future<bool> isTtsEnabled({bool defaultValue = true}) async {
    final enabled = await _prefs.getBool(keyTtsEnabled) ?? defaultValue;
    _logger.debug(
        "SettingsService: Retrieved TTS enabled: $enabled (default: $defaultValue)");
    return enabled;
  }

  Future<void> setTtsSpeechRate(double rate) async {
    final clampedRate = rate.clamp(0.0, 1.0);
    await _prefs.setDouble(keyTtsSpeechRate, clampedRate);
    _logger.info("SettingsService: TTS speech rate set to $clampedRate");
  }

  Future<double> getTtsSpeechRate({double defaultValue = 0.5}) async {
    final rate = await _prefs.getDouble(keyTtsSpeechRate) ?? defaultValue;
    _logger.debug(
        "SettingsService: Retrieved TTS speech rate: $rate (default: $defaultValue)");
    return rate;
  }

  Future<void> setSoundEffectsEnabled(bool enabled) async {
    await _prefs.setBool(keySoundEffectsEnabled, enabled);
    _logger.info("SettingsService: Sound effects enabled set to $enabled");
  }

  Future<bool> areSoundEffectsEnabled({bool defaultValue = true}) async {
    final enabled =
        await _prefs.getBool(keySoundEffectsEnabled) ?? defaultValue;
    _logger.debug(
        "SettingsService: Retrieved sound effects enabled: $enabled (default: $defaultValue)");
    return enabled;
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    await _prefs.setBool(keyHapticFeedbackEnabled, enabled);
    _logger.info("SettingsService: Haptic feedbacks enabled set to $enabled");
  }

  Future<bool> areHapticsEnabled({bool defaultValue = true}) async {
    final enabled =
        await _prefs.getBool(keyHapticFeedbackEnabled) ?? defaultValue;
    _logger.debug(
        "SettingsService: Retrieved Haptic feedbacks enabled: $enabled (default: $defaultValue)");
    return enabled;
  }

  Future<void> setAppLanguage(AppLanguage language) async {
    await _prefs.setString(keyAppLanguage, language.code);
    _logger.info("SettingsService: App language set to ${language.code}");
  }

  Future<AppLanguage> getAppLanguage(
      {AppLanguage defaultValue = AppLanguage.arabic}) async {
    final languageCode = await _prefs.getString(keyAppLanguage);
    if (languageCode != null) {
      final lang = AppLanguageExtension.fromCode(languageCode);
      _logger.debug("SettingsService: Retrieved app language: ${lang.code}");
      return lang;
    }
    _logger.debug(
        "SettingsService: No app language set, returning default: ${defaultValue.code}");
    return defaultValue;
  }

  Future<void> clearAllAppSettings() async {
    await _prefs.remove(keyLastActiveChildId);
    await _prefs.remove(keyTtsEnabled);
    await _prefs.remove(keySoundEffectsEnabled);
    await _prefs.remove(keyAppLanguage);
    await _prefs.remove(onboardingCompletedKey);
    await _prefs.remove(keyTtsSpeechRate);
    await _prefs.remove(keyHapticFeedbackEnabled);
    _logger.info("SettingsService: All app-specific settings cleared.");
  }
}
