import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pfa/models/enums.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:pfa/services/settings_service.dart';

class TtsService {
  final LoggingService _logger;
  final SettingsService _settingsService;
  final Ref _ref;
  final FlutterTts _flutterTts;

  bool _isInitialized = false;
  String _lastSetTtsEngineLanguage = AppLanguage.arabic.code;
  double _currentSpeechRate = 1.0;

  TtsService(this._logger, this._settingsService, this._ref, this._flutterTts) {
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    if (_isInitialized) return;
    _logger.info('Initializing TTS Service...');

    _flutterTts.setCompletionHandler(() {
      _logger.debug("TTS: Speech completed.");
    });

    _flutterTts.setErrorHandler((msg) {
      _logger.error("TTS Error: $msg");
    });

    _ref.listen<AppLanguage>(appLanguageProvider,
        (previousLanguage, newLanguage) {
      _logger.info(
          'TTS Service: App language changed from ${previousLanguage?.code} to ${newLanguage.code}. Updating TTS engine.');
      _updateTtsEngineLanguage(newLanguage.code);
    });

    final initialAppLanguage = _ref.read(appLanguageProvider);
    await _updateTtsEngineLanguage(initialAppLanguage.code);

    _currentSpeechRate = await _settingsService.getTtsSpeechRate();
    await _applySpeechRate(_currentSpeechRate);
    _isInitialized = true;
    _logger.info(
        'TTS Service Initialized. Initial language set attempt for: ${initialAppLanguage.code}');
  }

  Future<void> _updateTtsEngineLanguage(String languageCode) async {
    String ttsLangCode = languageCode;
    if (languageCode == 'en') ttsLangCode = 'en-US';
    if (languageCode == 'ar') ttsLangCode = 'ar';
    if (languageCode == 'fr') ttsLangCode = 'fr-FR';

    _logger.info(
        'TTS: Attempting to set engine language to $ttsLangCode (app lang: $languageCode)');
    try {
      var result = await _flutterTts.setLanguage(ttsLangCode);
      if (result == 1) {
        _lastSetTtsEngineLanguage = ttsLangCode;
        _logger.info('TTS: Engine language set successfully to $ttsLangCode.');
      } else {
        _logger.warning(
            'TTS: Failed to set engine language $ttsLangCode (result code: $result). Might not be supported. Last set: $_lastSetTtsEngineLanguage');
      }
    } catch (e, st) {
      _logger.error('TTS: Error setting engine language $ttsLangCode', e, st);
    }
  }

  Future<void> _applySpeechRate(double rate) async {
    try {
      var result = await _flutterTts.setSpeechRate(rate);
      if (result == 1) {
        _currentSpeechRate = rate;
        _logger.info("TTS: Speech rate set to $rate");
      } else {
        _logger.warning(
            "TTS: Failed to set speech rate to $rate (result: $result)");
      }
    } catch (e, st) {
      _logger.error("TTS: Error setting speech rate to $rate", e, st);
    }
  }

  Future<void> changeSpeechRate(double newRate) async {
    if (!_isInitialized) return;
    await _settingsService.setTtsSpeechRate(newRate);
    await _applySpeechRate(newRate);
  }

  Future<void> speak(String text) async {
    final bool ttsEnabled = await _settingsService.isTtsEnabled();
    if (!_isInitialized || !ttsEnabled || text.isEmpty) {
      if (!ttsEnabled) {
        _logger.debug("TTS: Speak skipped, TTS is disabled by user settings.");
      } else {
        _logger
            .warning('TTS service not ready or text is empty, cannot speak.');
      }
      return;
    }

    try {
      // Stop any ongoing speech before starting new one
      await _flutterTts.stop();
      _logger.debug('TTS: Attempting to speak: "$text"');
      var result = await _flutterTts.speak(text);
      if (result == 1) {
        _logger.debug('TTS: Speak command successful.');
      } else {
        _logger.warning('TTS: Speak command failed (result code: $result).');
      }
    } catch (e, st) {
      _logger.error('TTS: Error during speak command', e, st);
    }
  }

  Future<void> stop() async {
    if (!_isInitialized) return;
    try {
      var result = await _flutterTts.stop();
      if (result == 1) _logger.debug('TTS: Stop command successful.');
    } catch (e, st) {
      _logger.error('TTS: Error during stop command', e, st);
    }
  }
}
