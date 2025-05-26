import 'package:audioplayers/audioplayers.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:pfa/services/settings_service.dart';

enum SoundType { correct, incorrect, levelComplete, uiClick, gameComplete }

class AudioService {
  final LoggingService _logger;
  final AudioPlayer _feedbackPlayer;
  final SettingsService _settingsService;
  bool _isInitialized = false;

  AudioService(this._logger, this._settingsService, this._feedbackPlayer) {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;
    _logger.info('Initializing Audio Service...');
    _feedbackPlayer.setReleaseMode(ReleaseMode.stop);
    _isInitialized = true;
    _logger.info('Audio Service Initialized.');
  }

  Future<void> playSound(SoundType soundType, {double volume = 1.0}) async {
    final bool soundEffectsEnabled =
        await _settingsService.areSoundEffectsEnabled();
    if (!_isInitialized || !soundEffectsEnabled) {
      if (!soundEffectsEnabled) {
        _logger.debug(
            "AudioService: Sound playback skipped, sound effects disabled by user settings.");
      } else {
        _logger
            .debug('AudioService: Sound playback skipped (not initialized).');
      }
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
