import 'package:flutter_tts/flutter_tts.dart';
import 'package:pfa/services/logging_service.dart';

class TtsService {
  final LoggingService _logger;
  final FlutterTts _flutterTts = FlutterTts();

  bool _isInitialized = false;
  String _currentLanguage = 'ar';

  TtsService(this._logger) {
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

    await setLanguage(_currentLanguage);

    _isInitialized = true;
    _logger.info('TTS Service Initialized.');
  }

  Future<void> setLanguage(String languageCode) async {
    _logger.info('TTS: Setting language to $languageCode');
    try {
      var result = await _flutterTts.setLanguage(languageCode);
      if (result == 1) {
        // 1 indicates success
        _currentLanguage = languageCode;
        _logger.info('TTS: Language set successfully.');
      } else {
        _logger.warning(
            'TTS: Failed to set language $languageCode (result code: $result). Might not be supported.');
        await _flutterTts.setLanguage("ar");
        _currentLanguage = "ar";
      }
    } catch (e, st) {
      _logger.error('TTS: Error setting language $languageCode', e, st);
    }
  }

  Future<void> speak(String text) async {
    if (!_isInitialized || text.isEmpty) {
      _logger.warning('TTS service not ready or text is empty, cannot speak.');
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
