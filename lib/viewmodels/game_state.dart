import 'package:pfa/models/game.dart';
import 'package:pfa/models/level.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/repositories/game_repository.dart';

enum GameStatus {
  initial,
  loadingGame,
  loadingLevel,
  loadingScreen,
  playing,
  error,
  completed
}

class GameState {
  final GameStatus status;
  final Game? game;
  final List<Level> levels; // List of levels for the current game
  final Level? currentLevel;
  final ScreenWithOptionsMenu? currentScreenData;
  final int currentLevelIndex;
  final int currentScreenIndex;
  final bool? isCorrect; // Feedback after an answer
  final String? errorMessage;
  final List<String> screenIdsInCurrentLevel;

  GameState({
    this.status = GameStatus.initial,
    this.game,
    this.levels = const [],
    this.currentLevel,
    this.currentScreenData,
    this.currentLevelIndex = 0,
    this.currentScreenIndex = 0,
    this.isCorrect,
    this.errorMessage,
    this.screenIdsInCurrentLevel = const [],
  });

  GameState copyWith({
    GameStatus? status,
    Game? game,
    List<Level>? levels,
    List<String>? screenIdsInCurrentLevel,
    Level? currentLevel,
    ScreenWithOptionsMenu? currentScreenData,
    bool clearCurrentScreenData = false, // Flag to clear screen data
    int? currentLevelIndex,
    int? currentScreenIndex,
    bool? isCorrect,
    bool clearIsCorrect = false, // Flag to clear feedback
    String? errorMessage,
    bool clearErrorMessage = false, // Flag to clear error
  }) {
    return GameState(
      status: status ?? this.status,
      game: game ?? this.game,
      levels: levels ?? this.levels,
      screenIdsInCurrentLevel:
          screenIdsInCurrentLevel ?? this.screenIdsInCurrentLevel,
      currentLevel: currentLevel ?? this.currentLevel,
      currentScreenData: clearCurrentScreenData
          ? null
          : (currentScreenData ?? this.currentScreenData),
      currentLevelIndex: currentLevelIndex ?? this.currentLevelIndex,
      currentScreenIndex: currentScreenIndex ?? this.currentScreenIndex,
      isCorrect: clearIsCorrect ? null : (isCorrect ?? this.isCorrect),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  // Helper getters
  MultipleChoiceScreen? get multipleChoiceScreen =>
      currentScreenData?.screen is MultipleChoiceScreen
          ? currentScreenData!.screen as MultipleChoiceScreen
          : null;

  MemoryScreen? get memoryScreen => currentScreenData?.screen is MemoryScreen
      ? currentScreenData!.screen as MemoryScreen
      : null;

  List<Option> get currentOptions => currentScreenData?.options ?? [];
}
