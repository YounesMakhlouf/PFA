import 'package:audioplayers/audioplayers.dart';
import 'package:pfa/services/logging_service.dart';

enum SoundType { correct, incorrect, levelComplete, uiClick, gameComplete }

class AudioService {
  final LoggingService _logger;
  final AudioPlayer _feedbackPlayer = AudioPlayer();

  bool _isInitialized = false;
  bool _soundsEnabled = true; // TODO: Add to settings

  AudioService(this._logger) {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;
    _logger.info('Initializing Audio Service...');
    _feedbackPlayer.setReleaseMode(ReleaseMode.stop);
    _isInitialized = true;
    _logger.info('Audio Service Initialized.');
  }

  void setSoundsEnabled(bool enabled) {
    _soundsEnabled = enabled;
    _logger.info('AudioService: Sounds enabled set to $enabled');
    if (!enabled) {
      _feedbackPlayer.stop();
    }
  }

  Future<void> playSound(SoundType soundType, {double volume = 1.0}) async {
    if (!_isInitialized || !_soundsEnabled) {
      _logger.debug(
          'AudioService: Sound playback skipped (not initialized or sounds disabled).');
      return;
    }

    String? soundPath;
    switch (soundType) {
      case SoundType.correct:
        soundPath = 'audio/correct_feedback.mp3';
        break;
      case SoundType.incorrect:
        soundPath = 'audio/incorrect_feedback.mp3';
        break;
      case SoundType.levelComplete:
        soundPath = 'audio/level_complete.mp3';
        break;
      case SoundType.gameComplete:
        soundPath = 'audio/game_complete.mp3';
        break;
      default:
        _logger
            .warning('AudioService: Unknown sound type requested: $soundType');
        return;
    }

    try {
      _logger.debug('AudioService: Playing sound - $soundPath');
      await _feedbackPlayer.play(AssetSource(soundPath), volume: volume);
      _logger.debug('AudioService: Sound playback initiated for $soundPath.');
    } catch (e, stackTrace) {
      _logger.error(
          'AudioService: Error playing sound $soundPath', e, stackTrace);
    }
  }

  Future<void> dispose() async {
    _logger.info('Disposing Audio Service...');
    await _feedbackPlayer.dispose();
    _isInitialized = false;
  }
}
