import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:pfa/services/settings_service.dart';
import 'package:pfa/services/tts_service.dart';

class TtsSpeechRateNotifier extends StateNotifier<double> {
  final SettingsService _settingsService;
  final TtsService _ttsService;
  final LoggingService _logger;

  TtsSpeechRateNotifier(this._settingsService, this._ttsService, this._logger)
      : super(1.0) {
    _loadInitialRate();
  }

  Future<void> _loadInitialRate() async {
    state = await _settingsService.getTtsSpeechRate();
    _logger.debug("TtsSpeechRateNotifier: Initial rate loaded: $state");
  }

  Future<void> updateSpeechRate(double newRate) async {
    final clampedRate = newRate.clamp(0.1, 2.0);
    if (state != clampedRate) {
      await _ttsService.changeSpeechRate(clampedRate);
      state = clampedRate;
      _logger.info("TtsSpeechRateNotifier: Speech rate updated to $state");
    }
  }
}
