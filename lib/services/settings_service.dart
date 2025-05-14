import 'package:pfa/constants/const.dart';
import 'package:pfa/models/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pfa/services/logging_service.dart';

class SettingsService {
  final LoggingService _logger;
  SharedPreferences? _prefs;

  SettingsService(this._logger);

  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
    _logger.debug("SettingsService: SharedPreferences instance ensured.");
  }

  Future<void> setAppLanguage(AppLanguage language) async {
    await _ensureInitialized();
    await _prefs!.setString(keyAppLanguage, language.code);
    _logger.info("SettingsService: App language set to ${language.code}");
  }

  Future<AppLanguage> getAppLanguage(
      {AppLanguage defaultValue = AppLanguage.arabic}) async {
    await _ensureInitialized();
    final languageCode = _prefs!.getString(keyAppLanguage);
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
    await _ensureInitialized();
    if (childId == null) {
      await _prefs!.remove(keyLastActiveChildId);
      _logger.info("SettingsService: Last active child ID cleared.");
    } else {
      await _prefs!.setString(keyLastActiveChildId, childId);
      _logger.info("SettingsService: Last active child ID set to $childId");
    }
  }

  Future<String?> getLastActiveChildId() async {
    await _ensureInitialized();
    final id = _prefs!.getString(keyLastActiveChildId);
    _logger.debug("SettingsService: Retrieved last active child ID: $id");
    return id;
  }

  Future<void> setTtsEnabled(bool enabled) async {
    await _ensureInitialized();
    await _prefs!.setBool(keyTtsEnabled, enabled);
    _logger.info("SettingsService: TTS enabled set to $enabled");
  }

  Future<bool> isTtsEnabled({bool defaultValue = true}) async {
    await _ensureInitialized();
    final enabled = _prefs!.getBool(keyTtsEnabled) ?? defaultValue;
    _logger.debug(
        "SettingsService: Retrieved TTS enabled: $enabled (default: $defaultValue)");
    return enabled;
  }

  Future<void> setTtsSpeechRate(double rate) async {
    await _ensureInitialized();
    final clampedRate = rate.clamp(0.1, 2.0);
    await _prefs!.setDouble(keyTtsSpeechRate, clampedRate);
    _logger.info("SettingsService: TTS speech rate set to $clampedRate");
  }

  Future<double> getTtsSpeechRate({double defaultValue = 1.0}) async {
    await _ensureInitialized();
    final rate = _prefs!.getDouble(keyTtsSpeechRate) ?? defaultValue;
    _logger.debug(
        "SettingsService: Retrieved TTS speech rate: $rate (default: $defaultValue)");
    return rate;
  }

  Future<void> setSoundEffectsEnabled(bool enabled) async {
    await _ensureInitialized();
    await _prefs!.setBool(keySoundEffectsEnabled, enabled);
    _logger.info("SettingsService: Sound effects enabled set to $enabled");
  }

  Future<bool> areSoundEffectsEnabled({bool defaultValue = true}) async {
    await _ensureInitialized();
    final enabled = _prefs!.getBool(keySoundEffectsEnabled) ?? defaultValue;
    _logger.debug(
        "SettingsService: Retrieved sound effects enabled: $enabled (default: $defaultValue)");
    return enabled;
  }

  // Method to clear all app-specific settings (e.g., on logout or factory reset)
  Future<void> clearAllAppSettings() async {
    await _ensureInitialized();
    await _prefs!.remove(keyLastActiveChildId);
    await _prefs!.remove(keyTtsEnabled);
    await _prefs!.remove(keySoundEffectsEnabled);
    await _prefs!.remove(keyAppLanguage);
    await _prefs!.remove(onboardingCompletedKey);
    await _prefs!.remove(keyTtsSpeechRate);
    _logger.info("SettingsService: All app-specific settings cleared.");
  }
}
