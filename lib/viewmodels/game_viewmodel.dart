import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/models/level.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/repositories/game_repository.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:pfa/repositories/game_session_repository.dart'; // For progress tracking
import 'package:pfa/models/game_session.dart' as gs_model;
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/viewmodels/game_state.dart';

class GameViewModel extends StateNotifier<GameState> {
  final String _gameId;
  final GameRepository _gameRepository;
  final LoggingService _logger;
  final GameSessionRepository _sessionRepository;
  final String _childId;

  // Store fetched screen details to avoid re-fetching if user goes back/forth quickly
  // This is a simple cache, could be more sophisticated.
  final Map<String, ScreenWithOptionsMenu> _screenCache = {};
  gs_model.GameSession? _currentGameSession;

  GameViewModel(
    this._gameId,
    this._childId,
    this._gameRepository,
    this._logger,
    this._sessionRepository,
  ) : super(GameState(status: GameStatus.initial)) {
    _logger.info(
        'GameViewModel initialized for game ID: $_gameId, child ID: $_childId');
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    _logger.debug('GameViewModel: Initializing game...');
    state =
        state.copyWith(status: GameStatus.loadingGame, clearErrorMessage: true);
    try {
      // 1. Fetch game summary (should be quick)
      // Assuming GameRepository.getGameById fetches only game summary now
      final loadedGame =
          await _gameRepository.getGameById(_gameId); // Adjusted repo method
      if (loadedGame == null) {
        _logger.error('GameViewModel: Game not found with ID: $_gameId');
        state = state.copyWith(
            status: GameStatus.error, errorMessage: 'Game not found');
        return;
      }
      state = state.copyWith(game: loadedGame, status: GameStatus.loadingLevel);

      // 2. Fetch levels for this game
      final loadedLevels = await _gameRepository.getLevelsForGame(_gameId);
      if (loadedLevels.isEmpty) {
        _logger.error('GameViewModel: No levels found for game: $_gameId');
        state = state.copyWith(
            status: GameStatus.error,
            errorMessage: 'No levels found for this game');
        return;
      }
      state = state.copyWith(levels: loadedLevels);

      // 3. Set initial level and load its first screen
      await _loadLevel(0); // Load the first level
    } catch (e, stackTrace) {
      _logger.error('GameViewModel: Error initializing game', e, stackTrace);
      state = state.copyWith(
          status: GameStatus.error,
          errorMessage: 'Failed to load game: ${e.toString()}');
    }
  }

  Future<void> _loadLevel(int levelIndex) async {
    if (state.levels.isEmpty ||
        levelIndex < 0 ||
        levelIndex >= state.levels.length) {
      _logger.error('GameViewModel: Invalid level index: $levelIndex');
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
    _logger.debug(
        'GameViewModel: Loading level ${levelIndex + 1} (${levelToLoad.levelId})');
    await _startNewGameSession(levelToLoad.levelId);

    try {
      // Fetch screen IDs for the newly loaded level
      final screenIds =
          await _gameRepository.getScreenIdsForLevel(levelToLoad.levelId);
      state = state.copyWith(screenIdsInCurrentLevel: screenIds);
      _logger.debug(
          'GameViewModel: Loaded ${screenIds.length} screen IDs for level ${levelToLoad.levelId}');

      if (screenIds.isNotEmpty) {
        await _loadScreen(0); // Load the first screen of this level
      } else {
        _logger.warning(
            'GameViewModel: No screens found for level ${levelToLoad.levelId}. Marking level complete.');
        await _handleLevelCompletion(); // No screens in this level
      }
    } catch (e, stackTrace) {
      _logger.error(
          'GameViewModel: Error fetching screen IDs for level ${levelToLoad.levelId}',
          e,
          stackTrace);
      state = state.copyWith(
          status: GameStatus.error,
          errorMessage: 'Failed to load level screens');
    }
  }

  Future<void> _loadScreen(int screenIndex) async {
    if (state.currentLevel == null) {
      _logger
          .error('GameViewModel: Current level is null, cannot load screen.');
      state = state.copyWith(
          status: GameStatus.error, errorMessage: 'Level data missing');
      return;
    }

    final screenIdsInLevel = state.screenIdsInCurrentLevel;

    if (screenIdsInLevel.isEmpty ||
        screenIndex < 0 ||
        screenIndex >= screenIdsInLevel.length) {
      _logger.warning(
          'GameViewModel: No screens in level or invalid screen index $screenIndex for level ${state.currentLevel!.levelId}. Marking level complete.');
      await _handleLevelCompletion();
      return;
    }

    state = state.copyWith(
        status: GameStatus.loadingScreen,
        currentScreenIndex: screenIndex,
        clearCurrentScreenData: true);
    final screenIdToLoad = screenIdsInLevel[screenIndex];
    _logger.debug(
        'GameViewModel: Loading screen ${screenIndex + 1} (ID: $screenIdToLoad)');

    try {
      ScreenWithOptionsMenu? screenData;
      if (_screenCache.containsKey(screenIdToLoad)) {
        screenData = _screenCache[screenIdToLoad];
        _logger.debug('GameViewModel: Screen $screenIdToLoad found in cache.');
      } else {
        screenData = await _gameRepository.getScreenWithDetails(screenIdToLoad);
        if (screenData != null) {
          _screenCache[screenIdToLoad] = screenData;
        }
      }

      if (screenData == null) {
        _logger.error(
            'GameViewModel: Failed to load screen details for ID: $screenIdToLoad');
        state = state.copyWith(
            status: GameStatus.error, errorMessage: 'Failed to load screen');
        return;
      }
      if (screenData.screen.type != ScreenType.MULTIPLE_CHOICE &&
          screenData.screen.type != ScreenType.MEMORY_MATCH) {
        _logger.error(
            'GameViewModel: Loaded screen $screenIdToLoad is not a supported type: ${screenData.screen.type}');
        state = state.copyWith(
            status: GameStatus.error, errorMessage: 'Unsupported screen type');
        return;
      }
      state = state.copyWith(
          currentScreenData: screenData,
          status: GameStatus.playing,
          clearIsCorrect: true);
    } catch (e, stackTrace) {
      _logger.error(
          'GameViewModel: Error loading screen $screenIdToLoad', e, stackTrace);
      state = state.copyWith(
          status: GameStatus.error,
          errorMessage: 'Failed to load screen content');
    }
  }

  Future<void> _startNewGameSession(String levelId) async {
    if (_currentGameSession != null && _currentGameSession!.endTime == null) {
      // End previous session if it wasn't ended properly
      await _sessionRepository.endSession(
          sessionId: _currentGameSession!.sessionId, completed: false);
    }
    try {
      _currentGameSession = await _sessionRepository.createSession(
        childId: _childId,
        gameId: state.game!.gameId,
        levelId: levelId,
      );
      _logger.info(
          "GameViewModel: Started new game session: ${_currentGameSession!.sessionId}");
    } catch (e, st) {
      _logger.error("GameViewModel: Failed to create game session", e, st);
    }
  }

  Future<void> recordAttempt(
      Option selectedOption, bool isCorrectAnswer) async {
    if (_currentGameSession == null || state.currentScreenData == null) return;
    final startTime = DateTime.now();

    // Simulate time taken (replace with actual timing if you have it)
    await Future.delayed(const Duration(milliseconds: 200));
    final timeTakenMs = DateTime.now().difference(startTime).inMilliseconds;

    try {
      await _sessionRepository.addAttemptToSession(
        sessionId: _currentGameSession!.sessionId,
        screenId: state.currentScreenData!.screen.screenId,
        selectedOptionIds: [
          selectedOption.optionId
        ], // Assuming single selection
        isCorrect: isCorrectAnswer,
        timeTakenMs: timeTakenMs,
        // hintsUsed: ... // TODO: Implement hint tracking
      );
      _logger.debug(
          "GameViewModel: Recorded attempt for session ${_currentGameSession!.sessionId}");
    } catch (e, st) {
      _logger.error("GameViewModel: Failed to record attempt", e, st);
    }
  }

  void checkAnswer(Option selectedOption) {
    if (state.status != GameStatus.playing || state.currentScreenData == null)
      return;

    bool isCorrectCurrently = false;
    final screen = state.currentScreenData!.screen;

    if (screen is MultipleChoiceScreen) {
      // Correct answer is determined by the Option's `isCorrect` flag
      isCorrectCurrently = selectedOption.isCorrect!;
    } else if (screen is MemoryScreen) {
      // TODO: Implement memory game selection logic (select 2 cards)
      // This method might need to be adapted to handle pair selection
      _logger
          .warning("Memory game checkAnswer logic not fully implemented here.");
      // For now, let's assume single selection and a memory match is always "incorrect"
      // until pair logic is in place. You'll need a temporary list of selected cards.
    } else {
      _logger.error(
          "Unsupported screen type for checkAnswer: ${screen.runtimeType}");
      state = state.copyWith(isCorrect: false, clearErrorMessage: true);
      return;
    }

    state =
        state.copyWith(isCorrect: isCorrectCurrently, clearErrorMessage: true);
    recordAttempt(selectedOption, isCorrectCurrently); // Record the attempt

    if (isCorrectCurrently) {
      // Use a Timer to delay moving to the next screen
      Timer(const Duration(seconds: 1), () {
        if (mounted) {
          // StateNotifier is always "mounted"
          moveToNextScreen();
        }
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
      // End of current level
      await _handleLevelCompletion();
    }
  }

  Future<void> _handleLevelCompletion() async {
    _logger.info(
        "GameViewModel: Level ${state.currentLevel!.levelNumber} completed.");
    // End the current game session for this level
    if (_currentGameSession != null) {
      await _sessionRepository.endSession(
          sessionId: _currentGameSession!.sessionId, completed: true);
      _currentGameSession = null; // Clear for next level
    }

    if (state.currentLevelIndex < state.levels.length - 1) {
      // Move to the next level
      await _loadLevel(state.currentLevelIndex + 1);
    } else {
      // All levels completed
      _logger.info(
          "GameViewModel: All levels completed for game ${state.game!.name}.");
      state = state.copyWith(
          status: GameStatus.completed, clearCurrentScreenData: true);
    }
  }

  void restartGame() {
    _logger.info("GameViewModel: Restarting game ${_gameId}");
    _screenCache.clear();
    _initializeGame();
  }

  double getProgress() {
    if (state.game == null || state.levels.isEmpty) return 0.0;

    int totalScreensInGame = 0;
    List<Future<List<String>>> screenIdFutures = [];

    // This is becoming complex if we need to fetch screen counts for all levels on the fly
    // For a simpler progress, we might just base it on levels completed.
    // Or, Game/Level models could eventually store a 'screen_count'.

    // Simplified progress based on levels completed and screens within current level
    if (state.levels.isEmpty) return 0.0;

    int totalLevels = state.levels.length;
    if (totalLevels == 0) return 0.0;

    double levelProgress = state.currentLevelIndex / totalLevels.toDouble();

    double screenProgressInCurrentLevel = 0.0;
    if (state.screenIdsInCurrentLevel.isNotEmpty) {
      screenProgressInCurrentLevel = (state.currentScreenIndex) /
          state.screenIdsInCurrentLevel.length.toDouble();
    }

    // Combine, giving more weight to level progress
    return levelProgress +
        (screenProgressInCurrentLevel / totalLevels.toDouble());
  }
}
