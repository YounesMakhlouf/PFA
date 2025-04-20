import 'package:flutter_test/flutter_test.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/models/screen.dart';

void main() {
  group('Game', () {
    test('should create a Game with all required fields', () {
      final level = Level(
        levelNumber: 1,
        screens: [],
      );

      final game = Game(
        name: 'Colors Game',
        pictureUrl: 'assets/images/colors_game.png',
        instruction: 'Choose the correct color',
        category: GameCategory.COLORS_SHAPES,
        type: GameType.MULTIPLE_CHOICE,
        levels: [level],
      );

      expect(game.gameId, isNotEmpty);
      expect(game.name, 'Colors Game');
      expect(game.pictureUrl, 'assets/images/colors_game.png');
      expect(game.instruction, 'Choose the correct color');
      expect(game.category, GameCategory.COLORS_SHAPES);
      expect(game.type, GameType.MULTIPLE_CHOICE);
      expect(game.levels.length, 1);
      expect(game.themeColor, GameCategory.COLORS_SHAPES.themeColor);
      expect(game.icon, GameCategory.COLORS_SHAPES.icon);
    });

    test('should create a Game with a different type and category', () {
      final level = Level(levelNumber: 1, screens: []);
      final game = Game(
        name: 'Memory Game',
        pictureUrl: 'assets/images/memory_game.png',
        instruction: 'Match the pairs',
        category: GameCategory.LOGICAL_THINKING,
        type: GameType.MEMORY_MATCH,
        levels: [level],
      );

      expect(game.name, 'Memory Game');
      expect(game.category, GameCategory.LOGICAL_THINKING);
      expect(game.type, GameType.MEMORY_MATCH);
      expect(game.themeColor, GameCategory.LOGICAL_THINKING.themeColor);
      expect(game.icon, GameCategory.LOGICAL_THINKING.icon);
    });
  });

  group('Level', () {
    test('should create a Level with all required fields', () {
      final level = Level(
        levelNumber: 1,
        screens: [],
      );

      expect(level.levelId, isNotEmpty);
      expect(level.levelNumber, 1);
      expect(level.screens, isEmpty);
    });

    test('getScreens should return an empty list if no screens', () {
      final level = Level(levelNumber: 1, screens: []);
      expect(level.getScreens(), isEmpty);
    });

    test('getScreens should return all screens', () {
      final screen1 = Screen(screenNumber: 1);
      final screen2 = Screen(screenNumber: 2);

      final level = Level(
        levelNumber: 1,
        screens: [screen1, screen2],
      );

      final screens = level.getScreens();
      expect(screens.length, 2);
      expect(screens[0], screen1);
      expect(screens[1], screen2);
    });
  });

  group('GameCategory', () {
    test('should have correct enum values', () {
      expect(GameCategory.values.length, 8);
      expect(GameCategory.values, contains(GameCategory.LOGICAL_THINKING));
      expect(GameCategory.values, contains(GameCategory.EDUCATION));
      expect(GameCategory.values, contains(GameCategory.RELAXATION));
      expect(GameCategory.values, contains(GameCategory.EMOTIONS));
      expect(GameCategory.values, contains(GameCategory.NUMBERS));
      expect(GameCategory.values, contains(GameCategory.COLORS_SHAPES));
      expect(GameCategory.values, contains(GameCategory.ANIMALS));
      expect(GameCategory.values, contains(GameCategory.FRUITS_VEGETABLES));
    });

    test('should return correct theme color for each category', () {
      expect(GameCategory.LOGICAL_THINKING.themeColor, isNotNull);
      expect(GameCategory.EDUCATION.themeColor, isNotNull);
      expect(GameCategory.RELAXATION.themeColor, isNotNull);
      expect(GameCategory.EMOTIONS.themeColor, isNotNull);
      expect(GameCategory.NUMBERS.themeColor, isNotNull);
      expect(GameCategory.COLORS_SHAPES.themeColor, isNotNull);
      expect(GameCategory.ANIMALS.themeColor, isNotNull);
      expect(GameCategory.FRUITS_VEGETABLES.themeColor, isNotNull);
    });

    test('should return correct icon for each category', () {
      expect(GameCategory.LOGICAL_THINKING.icon, isNotNull);
      expect(GameCategory.EDUCATION.icon, isNotNull);
      expect(GameCategory.RELAXATION.icon, isNotNull);
      expect(GameCategory.EMOTIONS.icon, isNotNull);
      expect(GameCategory.NUMBERS.icon, isNotNull);
      expect(GameCategory.COLORS_SHAPES.icon, isNotNull);
      expect(GameCategory.ANIMALS.icon, isNotNull);
      expect(GameCategory.FRUITS_VEGETABLES.icon, isNotNull);
    });

    test('should have unique theme colors for different categories', () {
      final colors = GameCategory.values.map((c) => c.themeColor).toSet();
      expect(colors.length, greaterThan(1));
    });

    test('should have unique icons for different categories', () {
      final icons = GameCategory.values.map((c) => c.icon).toSet();
      expect(icons.length, greaterThan(1));
    });
  });
}
