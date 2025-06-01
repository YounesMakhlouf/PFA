import 'package:flutter_test/flutter_test.dart';
import 'package:pfa/repositories/game_repository.dart';
import 'package:pfa/viewmodels/game_state.dart';

import '../mocks/mock_data.dart';

void main() {
  group('GameState', () {
    test('should initialize with default values', () {
      final gameState = GameState();

      expect(gameState.status, GameStatus.initial);
      expect(gameState.game, isNull);
      expect(gameState.levels, isEmpty);
      expect(gameState.currentLevel, isNull);
      expect(gameState.currentScreenData, isNull);
      expect(gameState.currentLevelIndex, 0);
      expect(gameState.currentScreenIndex, 0);
      expect(gameState.isCorrect, isNull);
      expect(gameState.errorMessage, isNull);
      expect(gameState.screenIdsInCurrentLevel, isEmpty);
      expect(gameState.selectedMemoryCards, isEmpty);
      expect(gameState.isMemoryPairAttempted, false);
      expect(gameState.matchedPairIds, isEmpty);
      expect(gameState.isCameraInitialized, false);
      expect(gameState.detectedEmotion, isNull);
    });

    test('copyWith should update specified fields and keep others', () {
      final initialGameState = GameState();

      final testGame = mockGame(id: 'game-copyWith', name: 'CopyWith Game');
      final testLevel =
          mockLevel(id: 'level-copyWith', gameId: 'game-copyWith');
      final testOption =
          mockOption(id: 'option-copyWith', screenId: 'screen-copyWith');
      final testMcScreen =
          mockMCScreen(id: 'screen-copyWith', levelId: 'level-copyWith');
      final testScreenWithOptions =
          ScreenWithOptionsMenu(screen: testMcScreen, options: [testOption]);

      final updatedState = initialGameState.copyWith(
        status: GameStatus.playing,
        game: testGame,
        levels: [testLevel],
        screenIdsInCurrentLevel: ['scr1_copyWith', 'scr2_copyWith'],
        currentLevel: testLevel,
        currentScreenData: testScreenWithOptions,
        currentLevelIndex: 1,
        currentScreenIndex: 1,
        isCorrect: true,
        errorMessage: 'Test Error From CopyWith',
        selectedMemoryCards: [testOption],
        isMemoryPairAttempted: true,
        matchedPairIds: {'pair1_copyWith'},
        isCameraInitialized: true,
        detectedEmotion: 'happy_copyWith',
      );

      expect(updatedState.status, GameStatus.playing);
      expect(updatedState.game, testGame);
      expect(updatedState.levels.length, 1);
      expect(updatedState.levels.first, testLevel);
      expect(updatedState.screenIdsInCurrentLevel,
          ['scr1_copyWith', 'scr2_copyWith']);
      expect(updatedState.currentLevel, testLevel);
      expect(updatedState.currentScreenData, testScreenWithOptions);
      expect(updatedState.currentLevelIndex, 1);
      expect(updatedState.currentScreenIndex, 1);
      expect(updatedState.isCorrect, true);
      expect(updatedState.errorMessage, 'Test Error From CopyWith');
      expect(updatedState.selectedMemoryCards.length, 1);
      expect(updatedState.selectedMemoryCards.first, testOption);
      expect(updatedState.isMemoryPairAttempted, true);
      expect(updatedState.matchedPairIds, {'pair1_copyWith'});
      expect(updatedState.isCameraInitialized, true);
      expect(updatedState.detectedEmotion, 'happy_copyWith');

      // Check that a field not specified in copyWith remains from initial state
      final minimalUpdate =
          initialGameState.copyWith(status: GameStatus.completed);
      expect(minimalUpdate.status, GameStatus.completed);
      expect(minimalUpdate.game, initialGameState.game); // Should be null
    });

    test('copyWith clear flags should work correctly', () {
      final mcScreenForClearTest = mockMCScreen(id: 'clearTestScreen');
      final screenWithOptionsForClearTest =
          ScreenWithOptionsMenu(screen: mcScreenForClearTest, options: []);

      final initialGameState = GameState(
        currentScreenData: screenWithOptionsForClearTest,
        isCorrect: true,
        errorMessage: 'Old Error To Clear',
        detectedEmotion: 'sad To Clear',
      );

      // Test clearing currentScreenData
      var updatedState =
          initialGameState.copyWith(clearCurrentScreenData: true);
      expect(updatedState.currentScreenData, isNull,
          reason: "currentScreenData should be cleared");
      expect(updatedState.isCorrect, true,
          reason: "isCorrect should remain after clearing screen data");

      // Test clearing isCorrect
      updatedState = initialGameState.copyWith(clearIsCorrect: true);
      expect(updatedState.isCorrect, isNull,
          reason: "isCorrect should be cleared");
      expect(updatedState.errorMessage, 'Old Error To Clear',
          reason: "errorMessage should remain after clearing isCorrect");

      // Test clearing errorMessage
      updatedState = initialGameState.copyWith(clearErrorMessage: true);
      expect(updatedState.errorMessage, isNull,
          reason: "errorMessage should be cleared");
      expect(updatedState.detectedEmotion, 'sad To Clear',
          reason: "detectedEmotion should remain after clearing error message");

      // Test clearing detectedEmotion
      updatedState = initialGameState.copyWith(clearDetectedEmotion: true);
      expect(updatedState.detectedEmotion, isNull,
          reason: "detectedEmotion should be cleared");
      expect(updatedState.currentScreenData, screenWithOptionsForClearTest,
          reason:
              "currentScreenData should remain after clearing detected emotion");
    });

    group('Helper Getters', () {
      test('multipleChoiceScreen returns correct type or null', () {
        final mcScreen = mockMCScreen(id: 'getter_mc');
        final memScreen = mockMemoryScreen(id: 'getter_mem');
        final screenDataMC =
            ScreenWithOptionsMenu(screen: mcScreen, options: []);
        final screenDataMem =
            ScreenWithOptionsMenu(screen: memScreen, options: []);

        final stateWithMC = GameState(currentScreenData: screenDataMC);
        final stateWithMem = GameState(currentScreenData: screenDataMem);
        final stateWithNoScreen = GameState();

        expect(stateWithMC.multipleChoiceScreen, mcScreen);
        expect(stateWithMC.memoryScreen, isNull);

        expect(stateWithMem.multipleChoiceScreen, isNull);
        expect(stateWithMem.memoryScreen, memScreen);

        expect(stateWithNoScreen.multipleChoiceScreen, isNull);
        expect(stateWithNoScreen.memoryScreen, isNull);
      });

      test(
          'currentOptions returns options from currentScreenData or empty list',
          () {
        final option1 = mockOption(id: 'getter_opt1');
        final option2 = mockOption(id: 'getter_opt2');
        final mcScreenForOptions = mockMCScreen(id: 'options_screen');
        final screenDataWithOptions = ScreenWithOptionsMenu(
            screen: mcScreenForOptions, options: [option1, option2]);
        final screenDataNoOptions =
            ScreenWithOptionsMenu(screen: mcScreenForOptions, options: []);

        final stateWithOptions =
            GameState(currentScreenData: screenDataWithOptions);
        final stateWithNoScreenOptions =
            GameState(currentScreenData: screenDataNoOptions);
        final stateWithNoScreen = GameState();

        expect(stateWithOptions.currentOptions.length, 2);
        expect(
            stateWithOptions.currentOptions, containsAll([option1, option2]));
        expect(stateWithNoScreenOptions.currentOptions, isEmpty);
        expect(stateWithNoScreen.currentOptions, isEmpty);
      });
    });
  });
}
