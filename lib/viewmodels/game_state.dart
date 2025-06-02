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
  final List<Level> levels;
  final Level? currentLevel;
  final ScreenWithOptionsMenu? currentScreenData;
  final int currentLevelIndex;
  final int currentScreenIndex;
  final bool? isCorrect;
  final String? errorMessage;
  final List<String> screenIdsInCurrentLevel;

  // --- Memory Game Specific State ---
  final List<Option>
      selectedMemoryCards; // Holds up to 2 selected cards for a pair attempt
  final bool isMemoryPairAttempted; // True after 2 cards are selected
  final Set<String>
      matchedPairIds; // Stores pairIds of successfully matched pairs on current screen

  // Camera-related light state
  final bool isCameraInitialized;
  final String? detectedEmotion;

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
    this.selectedMemoryCards = const [],
    this.isMemoryPairAttempted = false,
    this.matchedPairIds = const {},
    this.isCameraInitialized = false,
    this.detectedEmotion,
  });

  GameState copyWith({
    GameStatus? status,
    Game? game,
    List<Level>? levels,
    List<String>? screenIdsInCurrentLevel,
    Level? currentLevel,
    ScreenWithOptionsMenu? currentScreenData,
    bool clearCurrentScreenData = false,
    int? currentLevelIndex,
    int? currentScreenIndex,
    bool? isCorrect,
    bool clearIsCorrect = false,
    List<Option>? selectedMemoryCards,
    bool? isMemoryPairAttempted,
    Set<String>? matchedPairIds,
    String? errorMessage,
    bool clearErrorMessage = false,

    // Camera state
    bool? isCameraInitialized,
    String? detectedEmotion,
    bool clearDetectedEmotion = false,
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
      selectedMemoryCards: selectedMemoryCards ?? this.selectedMemoryCards,
      isMemoryPairAttempted:
          isMemoryPairAttempted ?? this.isMemoryPairAttempted,
      matchedPairIds: matchedPairIds ?? this.matchedPairIds,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
      detectedEmotion: clearDetectedEmotion
          ? null
          : (detectedEmotion ?? this.detectedEmotion),
    );
  }

  MultipleChoiceScreen? get multipleChoiceScreen =>
      currentScreenData?.screen is MultipleChoiceScreen
          ? currentScreenData!.screen as MultipleChoiceScreen
          : null;

  MemoryScreen? get memoryScreen => currentScreenData?.screen is MemoryScreen
      ? currentScreenData!.screen as MemoryScreen
      : null;

  List<Option> get currentOptions => currentScreenData?.options ?? [];
}
