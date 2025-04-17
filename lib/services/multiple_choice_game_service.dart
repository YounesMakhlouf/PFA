import 'package:pfa/models/game.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/repositories/game_repository.dart';
import 'package:pfa/services/logging_service.dart';

class MultipleChoiceGameService {
  final GameRepository _gameRepository;
  final LoggingService _logger = LoggingService();

  Game? game;
  Level? currentLevel;
  MultipleChoiceScreen? currentScreen;
  int currentLevelIndex = 0;
  int currentScreenIndex = 0;
  bool? isCorrect;
  bool isLoading = true;
  String? errorMessage;

  MultipleChoiceGameService({required GameRepository gameRepository})
      : _gameRepository = gameRepository;

  Future<void> loadGameData(String gameId) async {
    try {
      isLoading = true;
      errorMessage = null;

      final loadedGame = await _gameRepository.getGameById(gameId);

      if (loadedGame == null) {
        isLoading = false;
        errorMessage = 'Game not found';
        return;
      }

      game = loadedGame;
      isLoading = false;

      if (game!.levels.isNotEmpty) {
        currentLevel = game!.levels[currentLevelIndex];
        if (currentLevel!.screens.isNotEmpty) {
          final screen = currentLevel!.screens[currentScreenIndex];
          if (screen is MultipleChoiceScreen) {
            currentScreen = screen;
          } else {
            errorMessage = 'Invalid screen type';
          }
        } else {
          errorMessage = 'No screens found for this level';
        }
      } else {
        errorMessage = 'No levels found for this game';
      }
    } catch (e, stackTrace) {
      _logger.error('Error loading game data', e, stackTrace);
      isLoading = false;
      errorMessage = 'Failed to load game: ${e.toString()}';
    }
  }

  void moveToNextScreen() {
    // Reset feedback
    isCorrect = null;

    // Check if there are more screens in the current level
    if (currentScreenIndex < currentLevel!.screens.length - 1) {
      currentScreenIndex++;
      final screen = currentLevel!.screens[currentScreenIndex];
      if (screen is MultipleChoiceScreen) {
        currentScreen = screen;
      } else {
        errorMessage = 'Invalid screen type';
      }
    } else if (currentLevelIndex < game!.levels.length - 1) {
      // Move to the next level
      currentLevelIndex++;
      currentScreenIndex = 0;
      currentLevel = game!.levels[currentLevelIndex];
      final screen = currentLevel!.screens[currentScreenIndex];
      if (screen is MultipleChoiceScreen) {
        currentScreen = screen;
      } else {
        errorMessage = 'Invalid screen type';
      }
    } else {
      // Game completed, restart
      currentLevelIndex = 0;
      currentScreenIndex = 0;
      currentLevel = game!.levels[currentLevelIndex];
      final screen = currentLevel!.screens[currentScreenIndex];
      if (screen is MultipleChoiceScreen) {
        currentScreen = screen;
      } else {
        errorMessage = 'Invalid screen type';
      }
    }
  }

  bool checkAnswer(Option selectedOption) {
    return selectedOption.optionId == currentScreen!.correctAnswer.optionId;
  }

  void reset() {
    currentLevelIndex = 0;
    currentScreenIndex = 0;
    isCorrect = null;
    if (game != null && game!.levels.isNotEmpty) {
      currentLevel = game!.levels[currentLevelIndex];
      if (currentLevel!.screens.isNotEmpty) {
        final screen = currentLevel!.screens[currentScreenIndex];
        if (screen is MultipleChoiceScreen) {
          currentScreen = screen;
        }
      }
    }
  }

  double getProgress() {
    if (game == null || game!.levels.isEmpty) return 0.0;

    int totalScreens = 0;
    for (var level in game!.levels) {
      totalScreens += level.screens.length;
    }

    int completedScreens = 0;
    for (int i = 0; i < currentLevelIndex; i++) {
      completedScreens += game!.levels[i].screens.length;
    }
    completedScreens += currentScreenIndex;

    return totalScreens > 0 ? completedScreens / totalScreens : 0.0;
  }
}
