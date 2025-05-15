import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/repositories/game_repository.dart';
import 'package:pfa/services/audio_service.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:pfa/repositories/game_session_repository.dart';
import 'package:pfa/models/game_session.dart' as gs_model;
import 'package:pfa/services/tts_service.dart';
import 'package:pfa/viewmodels/game_state.dart';

class GameViewModel extends StateNotifier<GameState> {
  final String _gameId;
  final String _childId;
  final GameRepository _gameRepository;
  final LoggingService _logger;
  final GameSessionRepository _sessionRepository;

  bool _isDetecting = false;
  final TtsService _ttsService;
  final AudioService _audioService;

  // Cache
  final Map<String, ScreenWithOptionsMenu> _screenCache = {};
  gs_model.GameSession? _currentGameSession;

  // Emotion detection
  late final EmotionDetectionService _emotionService;
  CameraController? _cameraController;

  GameViewModel(
    this._gameId,
    this._childId,
    this._gameRepository,
    this._logger,
    this._sessionRepository,
    this._ttsService,
    this._audioService,
  ) : super(GameState(status: GameStatus.initial)) {
    _logger.info(
        'GameViewModel initialized for game ID: $_gameId, child ID: $_childId');
    _initializeGame();
    _emotionService = EmotionDetectionService();
  }

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
            status: GameStatus.error,
            errorMessage: 'No levels found for this game');
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

  Future<void> _loadLevel(int levelIndex) async {
    if (state.levels.isEmpty ||
        levelIndex < 0 ||
        levelIndex >= state.levels.length) {
      _logger.error('Invalid level index: $levelIndex');
      state = state.copyWith(
          status: GameStatus.error, errorMessage: 'Invalid level');
      return;
    }

    final levelToLoad = state.levels[levelIndex];
    state = state.copyWith(
      status: GameStatus.loadingLevel,
      currentLevelIndex: levelIndex,
      currentLevel: levelToLoad,
      currentScreenIndex: 0,
      clearCurrentScreenData: true,
      clearErrorMessage: true,
      screenIdsInCurrentLevel: [],
    );
    _logger.debug('Loading level ${levelIndex + 1} (${levelToLoad.levelId})');
    await _startNewGameSession(levelToLoad.levelId);

    try {
      final screenIds =
          await _gameRepository.getScreenIdsForLevel(levelToLoad.levelId);
      state = state.copyWith(screenIdsInCurrentLevel: screenIds);
      _logger.debug(
          'Loaded ${screenIds.length} screen IDs for level ${levelToLoad.levelId}');

      if (screenIds.isNotEmpty) {
        await _loadScreen(0);
      } else {
        _logger.warning(
            'No screens found for level ${levelToLoad.levelId}. Marking level complete.');
        await _handleLevelCompletion();
      }
    } catch (e, stackTrace) {
      _logger.error(
          'Error fetching screen IDs for level ${levelToLoad.levelId}',
          e,
          stackTrace);
      state = state.copyWith(
          status: GameStatus.error,
          errorMessage: 'Failed to load level screens');
    }
  }

  Future<void> _loadScreen(int screenIndex) async {
    if (state.currentLevel == null) {
      _logger.error('Current level is null, cannot load screen.');
      state = state.copyWith(
          status: GameStatus.error, errorMessage: 'Level data missing');
      return;
    }

    final screenIdsInLevel = state.screenIdsInCurrentLevel;
    if (screenIdsInLevel.isEmpty ||
        screenIndex < 0 ||
        screenIndex >= screenIdsInLevel.length) {
      _logger.warning(
          'Invalid screen index $screenIndex. Marking level complete.');
      await _handleLevelCompletion();
      return;
    }

    state = state.copyWith(
        status: GameStatus.loadingScreen,
        currentScreenIndex: screenIndex,
        clearCurrentScreenData: true);
    final screenIdToLoad = screenIdsInLevel[screenIndex];
    _logger.debug('Loading screen ${screenIndex + 1} (ID: $screenIdToLoad)');

    try {
      ScreenWithOptionsMenu? screenData;
      if (_screenCache.containsKey(screenIdToLoad)) {
        screenData = _screenCache[screenIdToLoad];
        _logger.debug('Screen $screenIdToLoad found in cache.');
      } else {
        screenData = await _gameRepository.getScreenWithDetails(screenIdToLoad);
        if (screenData != null) {
          _screenCache[screenIdToLoad] = screenData;
        }
      }

      if (screenData == null) {
        _logger.error('Failed to load screen details for ID: $screenIdToLoad');
        state = state.copyWith(
            status: GameStatus.error, errorMessage: 'Failed to load screen');
        return;
      }

      if (screenData.screen.type != ScreenType.MULTIPLE_CHOICE &&
          screenData.screen.type != ScreenType.MEMORY_MATCH) {
        _logger.error('Unsupported screen type: ${screenData.screen.type}');
        state = state.copyWith(
            status: GameStatus.error, errorMessage: 'Unsupported screen type');
        return;
      }

      state = state.copyWith(
          currentScreenData: screenData,
          status: GameStatus.playing,
          clearIsCorrect: true);

      final instructionToSpeak = screenData.screen.instruction;
      if (instructionToSpeak != null && instructionToSpeak.isNotEmpty) {
        _logger.debug(
            'GameViewModel: Speaking screen instruction: "$instructionToSpeak"');
        _ttsService.speak(instructionToSpeak);
      }
    } catch (e, stackTrace) {
      _logger.error('Error loading screen $screenIdToLoad', e, stackTrace);
      state = state.copyWith(
          status: GameStatus.error,
          errorMessage: 'Failed to load screen content');
    }
  }

  void repeatCurrentScreenInstruction() {
    if (state.status == GameStatus.playing && state.currentScreenData != null) {
      final instructionToSpeak = state.currentScreenData!.screen.instruction;
      if (instructionToSpeak != null && instructionToSpeak.isNotEmpty) {
        _logger.debug(
            'GameViewModel: Re-speaking screen instruction: "$instructionToSpeak"');
        _ttsService.speak(instructionToSpeak);
      }
    } else {
      _logger.warning(
          "repeatCurrentScreenInstruction called but no screen is active or instruction available.");
    }
  }

  Future<void> _startNewGameSession(String levelId) async {
    if (_currentGameSession != null && _currentGameSession!.endTime == null) {
      await _sessionRepository.endSession(
          sessionId: _currentGameSession!.sessionId, completed: false);
    }
    try {
      _currentGameSession = await _sessionRepository.createSession(
        childId: _childId,
        gameId: state.game!.gameId,
        levelId: levelId,
      );
      _logger.info("Started new session: ${_currentGameSession!.sessionId}");
    } catch (e, st) {
      _logger.error("Failed to create session", e, st);
    }
  }

  Future<void> recordAttempt(
      Option selectedOption, bool? isCorrectAnswer) async {
    if (isCorrectAnswer == null ||
        _currentGameSession == null ||
        state.currentScreenData == null) return;
    final startTime = DateTime.now();

    await Future.delayed(const Duration(milliseconds: 200));
    final timeTakenMs = DateTime.now().difference(startTime).inMilliseconds;

    try {
      await _sessionRepository.addAttemptToSession(
        sessionId: _currentGameSession!.sessionId,
        screenId: state.currentScreenData!.screen.screenId,
        selectedOptionIds: [selectedOption.optionId],
        isCorrect: isCorrectAnswer,
        timeTakenMs: timeTakenMs,
      );
      _logger.debug("Recorded attempt");
    } catch (e, st) {
      _logger.error("Failed to record attempt", e, st);
    }
  }

  void checkAnswer(
      {required Option selectedOption,
      required String correctFeedbackText,
      required String tryAgainFeedbackText}) {
    if (state.status != GameStatus.playing || state.currentScreenData == null) {
      return;
    }
    bool? isCorrect = false;
    final screen = state.currentScreenData!.screen;

    if (screen is MultipleChoiceScreen) {
      if (_isDetecting) {
        isCorrect = state.detectedEmotion == selectedOption.labelText;
      } else {
        isCorrect = selectedOption.isCorrect;
      }
    } else if (screen is MemoryScreen) {
      _logger.warning("Memory game logic not fully implemented.");
    } else {
      _logger.error("Unsupported screen type in checkAnswer.");
      state = state.copyWith(isCorrect: false, clearErrorMessage: true);
      return;
    }

    state =
        state.copyWith(isCorrect: isCorrectCurrently, clearErrorMessage: true);
    recordAttempt(selectedOption, isCorrectCurrently);
    final feedbackText =
        isCorrectCurrently ? correctFeedbackText : tryAgainFeedbackText;
    _ttsService.speak(feedbackText);
    if (isCorrectCurrently) {
      _audioService.playSound(SoundType.correct);
    } else {
      _audioService.playSound(SoundType.incorrect);
    }
    if (isCorrectCurrently) {
      // Delay moving to the next screen
      Timer(const Duration(seconds: 1), () {
        if (mounted) moveToNextScreen();
      });
    }
  }

  Future<void> moveToNextScreen() async {
    if (state.game == null || state.currentLevel == null) return;
    state =
        state.copyWith(clearIsCorrect: true, status: GameStatus.loadingScreen);

    final screenIdsInLevel = state.screenIdsInCurrentLevel;
    if (state.currentScreenIndex < screenIdsInLevel.length - 1) {
      await _loadScreen(state.currentScreenIndex + 1);
    } else {
      await _handleLevelCompletion();
    }
  }

  Future<void> _handleLevelCompletion() async {
    _logger.info("Level completed.");
    if (_currentGameSession != null) {
      await _sessionRepository.endSession(
          sessionId: _currentGameSession!.sessionId, completed: true);
      _audioService.playSound(SoundType.levelComplete);
      _currentGameSession = null; // Clear for next level
    }

    if (state.currentLevelIndex < state.levels.length - 1) {
      await _loadLevel(state.currentLevelIndex + 1);
    } else {
      _logger.info("Game completed.");
      state = state.copyWith(
          status: GameStatus.completed, clearCurrentScreenData: true);
      _audioService.playSound(SoundType.gameComplete);
    }
  }

  void restartGame() {
    _logger.info("Restarting game.");
    _screenCache.clear();
    _initializeGame();
  }

  Future<void> endCurrentSession({required bool completed}) async {
    if (_currentGameSession != null && _currentGameSession!.endTime == null) {
      try {
        await _sessionRepository.endSession(
          sessionId: _currentGameSession!.sessionId,
          completed: completed,
        );
        _currentGameSession = null;
      } catch (e, st) {
        _logger.error("Failed to end session", e, st);
      }
    }
  }

  void startEmotionDetection() {
    if (!_isDetecting) {
      _isDetecting = true;
      _detectEmotionLoop();
    }
  }

  void _detectEmotionLoop() async {
    while (_isDetecting) {
      await captureAndDetectEmotion();
      await Future.delayed(const Duration(seconds: 3)); // Detect every 3 secs
    }
  }

  void stopEmotionDetection() {
    _isDetecting = false;
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);

    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    await _cameraController!.initialize();
    _logger.debug('Camera initialized: ${_cameraController!.description}');

    state = state.copyWith(isCameraInitialized: true);
  }

  Future<void> captureAndDetectEmotion() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final image = await _cameraController!.takePicture();
      _logger.debug('Captured image at: ${image.path}');

      final detectedEmotion = await _emotionService.detectEmotion(image.path);
      _logger.info('Detected Emotion: $detectedEmotion');
      bool isCorrectEmotion =
          detectedEmotion == state.currentScreenData?.options.first.labelText;
      state = state.copyWith(detectedEmotion: detectedEmotion);
      if (isCorrectEmotion == true) {
        state = state.copyWith(isCorrect: isCorrectEmotion);
        Timer(const Duration(seconds: 1), () {
          if (mounted) moveToNextScreen();
        });
      }
      _logger.info('Is Correct Emotion: $isCorrectEmotion');
    }
  }

  Future<void> disposeCamera() async {
    await _cameraController?.dispose();
    _cameraController = null;
    stopEmotionDetection();
    _isDetecting = false;
    state = state.copyWith(isCameraInitialized: false);
  }

  CameraController? get cameraController => _cameraController;
}
