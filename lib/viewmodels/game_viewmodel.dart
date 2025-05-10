import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/repositories/game_repository.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:pfa/repositories/game_session_repository.dart';
import 'package:pfa/models/game_session.dart' as gs_model;
import 'package:pfa/services/emotion_detection_service.dart';
import 'package:pfa/viewmodels/game_state.dart';

class GameViewModel extends StateNotifier<GameState> {
  final String _gameId;
  final GameRepository _gameRepository;
  final LoggingService _logger;
  final GameSessionRepository _sessionRepository;
  final String _childId;

  final Map<String, ScreenWithOptionsMenu> _screenCache = {};
  gs_model.GameSession? _currentGameSession;

  late final EmotionDetectionService _emotionService;
  CameraController? _cameraController;

  GameViewModel(
    this._gameId,
    this._childId,
    this._gameRepository,
    this._logger,
    this._sessionRepository,
  ) : super(GameState(status: GameStatus.initial)) {
    _logger.info(
        'GameViewModel initialized for game ID: $_gameId, child ID: $_childId');
    _emotionService = EmotionDetectionService();
    _initializeGame();
  }

  // ------------ Game Initialization ------------
  Future<void> _initializeGame() async {
    _logger.debug('GameViewModel: Initializing game...');
    state =
        state.copyWith(status: GameStatus.loadingGame, clearErrorMessage: true);
    try {
      final loadedGame = await _gameRepository.getGameById(_gameId);
      if (loadedGame == null) {
        _logger.error('Game not found with ID: $_gameId');
        state = state.copyWith(
            status: GameStatus.error, errorMessage: 'Game not found');
        return;
      }
      state = state.copyWith(game: loadedGame, status: GameStatus.loadingLevel);
      final loadedLevels = await _gameRepository.getLevelsForGame(_gameId);
      if (loadedLevels.isEmpty) {
        _logger.error('No levels found for game: $_gameId');
        state = state.copyWith(
            status: GameStatus.error, errorMessage: 'No levels found');
        return;
      }
      state = state.copyWith(levels: loadedLevels);
      await _loadLevel(0);
    } catch (e, stackTrace) {
      _logger.error('Error initializing game', e, stackTrace);
      state = state.copyWith(
          status: GameStatus.error,
          errorMessage: 'Failed to load game: ${e.toString()}');
    }
  }

  // ------------ Camera Handling ------------
  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    await _cameraController!.initialize();

    // Update UI if needed
    state = state.copyWith(isCameraInitialized: true);
  }

  Future<void> takePhotoAndDetectEmotion() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final image = await _cameraController!.takePicture();
      _logger.info('Photo captured at: ${image.path}');

      final detectedEmotion = await _emotionService.detectEmotion(image.path);
      _logger.info('Detected Emotion: $detectedEmotion');

      state = state.copyWith(detectedEmotion: detectedEmotion);
    } else {
      _logger.warning('Camera not initialized. Skipping photo capture.');
    }
  }

  // ------------ Level Loading Logic (existing untouched) ------------
  Future<void> _loadLevel(int levelIndex) async {/* ... same as before ... */}

  Future<void> _loadScreen(int screenIndex) async {/* ... same as before ... */}

  Future<void> _startNewGameSession(String levelId) async {
    /* ... same as before ... */
  }

  // ------------ Answer Check Logic ------------
  void checkAnswer(Option selectedOption) {
    if (state.status != GameStatus.playing || state.currentScreenData == null)
      return;

    bool isCorrectCurrently = false;
    final screen = state.currentScreenData!.screen;

    if (screen is MultipleChoiceScreen) {
      isCorrectCurrently = selectedOption.isCorrect!;
    } else if (screen is MemoryScreen) {
      _logger.warning("Memory game checkAnswer logic not fully implemented.");
    } else {
      _logger.error("Unsupported screen type: ${screen.runtimeType}");
      state = state.copyWith(isCorrect: false, clearErrorMessage: true);
      return;
    }

    state =
        state.copyWith(isCorrect: isCorrectCurrently, clearErrorMessage: true);
    recordAttempt(selectedOption, isCorrectCurrently);

    if (isCorrectCurrently) {
      Timer(const Duration(seconds: 1), () {
        if (mounted) moveToNextScreen();
      });
    }
  }

  Future<void> recordAttempt(
      Option selectedOption, bool isCorrectAnswer) async {
    /* ... same as before ... */
  }

  Future<void> moveToNextScreen() async {/* ... same as before ... */}

  Future<void> _handleLevelCompletion() async {/* ... same as before ... */}

  void restartGame() {
    _logger.info("Restarting game $_gameId");
    _screenCache.clear();
    _initializeGame();
  }

  Future<void> endCurrentSession({required bool completed}) async {
    if (_currentGameSession != null && _currentGameSession!.endTime == null) {
      final sessionId = _currentGameSession!.sessionId;
      _logger.info("Ending session $sessionId (completed: $completed)");
      try {
        await _sessionRepository.endSession(
            sessionId: sessionId, completed: completed);
        _currentGameSession = null;
      } catch (e, st) {
        _logger.error("Failed to end session $sessionId", e, st);
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _emotionService.dispose();
    super.dispose();
  }
}
