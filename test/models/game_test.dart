import 'package:flutter_test/flutter_test.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/models/level.dart';
import 'package:pfa/models/screen.dart';

void main() {
  // --- Game Tests ---
  group('Game Model', () {
    test('should create a Game with all required fields and new properties',
        () {
      final game = Game(
        gameId: 'test-game-id-123',
        name: 'Colors Adventure',
        pictureUrl: 'game_assets/images/colors_adventure.png',
        description: 'Explore the world of colors!',
        category: GameCategory.COLORS_SHAPES,
        type: GameType.MULTIPLE_CHOICE,
        themeColorCode: '#FF5733',
        iconName: 'palette_icon',
        educatorId: 'educator-abc',
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 2),
      );

      expect(game.gameId, 'test-game-id-123');
      expect(game.name, 'Colors Adventure');
      expect(game.pictureUrl, 'game_assets/images/colors_adventure.png');
      expect(game.description, 'Explore the world of colors!');
      expect(game.category, GameCategory.COLORS_SHAPES);
      expect(game.type, GameType.MULTIPLE_CHOICE);
      expect(game.themeColorCode, '#FF5733');
      expect(game.iconName, 'palette_icon');
      expect(game.educatorId, 'educator-abc');
      expect(game.createdAt, DateTime(2023, 1, 1));
      expect(game.updatedAt, DateTime(2023, 1, 2));
    });

    test('fromJson should correctly parse Game data from map', () {
      final json = {
        'game_id': 'game-uuid-456',
        'name': 'Number Puzzle',
        'picture_url': 'puzzles/numbers.jpg',
        'description': 'Solve the number sequence.',
        'category': 'NUMBERS',
        'type': 'PUZZLE',
        'theme_color': '#8A2BE2',
        'icon_name': 'numbers_puzzle_icon',
        'educator_id': null,
        'created_at': '2023-03-15T10:00:00Z',
        'updated_at': '2023-03-16T11:00:00Z',
      };
      final game = Game.fromJson(json);

      expect(game.gameId, 'game-uuid-456');
      expect(game.name, 'Number Puzzle');
      expect(game.pictureUrl, 'puzzles/numbers.jpg');
      expect(game.description, 'Solve the number sequence.');
      expect(game.category, GameCategory.NUMBERS);
      expect(game.type, GameType.PUZZLE);
      expect(game.themeColorCode, '#8A2BE2');
      expect(game.iconName, 'numbers_puzzle_icon');
      expect(game.educatorId, isNull);
      expect(game.createdAt, DateTime.parse('2023-03-15T10:00:00Z').toLocal());
      expect(game.updatedAt, DateTime.parse('2023-03-16T11:00:00Z').toLocal());
    });

    test('fromJson should handle null or missing optional fields gracefully',
        () {
      final json = {
        'game_id': 'game-minimal-789',
        'name': 'Minimal Game',
        'category': 'EDUCATION',
        'type': 'STORY',
        // imagePath, description, themeColorCode, iconName, educatorId, timestamps are missing
      };
      final game = Game.fromJson(json);

      expect(game.gameId, 'game-minimal-789');
      expect(game.name, 'Minimal Game');
      expect(game.category, GameCategory.EDUCATION);
      expect(game.type, GameType.STORY);
      expect(game.pictureUrl, isNull);
      expect(game.description, isNull);
      expect(game.themeColorCode, isNull);
      expect(game.iconName, isNull);
      expect(game.educatorId, isNull);
      expect(game.createdAt, isNull);
      expect(game.updatedAt, isNull);
    });

    test('fromJson should use fallback for unknown enum values', () {
      final json = {
        'game_id': 'game-unknown-enum',
        'name': 'Unknown Game',
        'category': 'INVALID_CATEGORY',
        'type': 'INVALID_TYPE',
      };
      final game = Game.fromJson(json);

      expect(game.category, GameCategory.UNKNOWN);
      expect(game.type, GameType.UNKNOWN);
    });
  });

  // --- Level Tests ---
  group('Level Model', () {
    test('should create a Level with all required fields', () {
      final level = Level(
        levelId: 'level-id-abc',
        gameId: 'game-id-123',
        levelNumber: 1,
      );

      expect(level.levelId, 'level-id-abc');
      expect(level.gameId, 'game-id-123');
      expect(level.levelNumber, 1);
    });

    test('fromJson should correctly parse Level data from map', () {
      final json = {
        'level_id': 'level-uuid-xyz',
        'game_id': 'game-uuid-456',
        'level_number': 2,
      };
      final level = Level.fromJson(json);

      expect(level.levelId, 'level-uuid-xyz');
      expect(level.gameId, 'game-uuid-456');
      expect(level.levelNumber, 2);
    });

    // --- GameCategory & GameType Enum/Extension Tests ---
    group('Game Enums and Extensions', () {
      test('GameCategory should have correct enum values and UNKNOWN fallback',
          () {
        expect(GameCategory.values.length, 9);
        expect(GameCategory.values, contains(GameCategory.LOGICAL_THINKING));
        expect(GameCategory.values, contains(GameCategory.UNKNOWN));
        expect(GameCategoryExtension.fromString('COLORS_SHAPES'),
            GameCategory.COLORS_SHAPES);
        expect(
            GameCategoryExtension.fromString('INVALID'), GameCategory.UNKNOWN);
        expect(GameCategoryExtension.fromString(null), GameCategory.UNKNOWN);
      });

      test('GameType should have correct enum values and UNKNOWN fallback', () {
        expect(GameType.values.length, 6);
        expect(GameType.values, contains(GameType.MULTIPLE_CHOICE));
        expect(GameType.values, contains(GameType.UNKNOWN));
        expect(GameTypeExtension.fromString('MEMORY_MATCH'),
            GameType.MEMORY_MATCH);
        expect(GameTypeExtension.fromString('INVALID_TYPE'), GameType.UNKNOWN);
        expect(GameTypeExtension.fromString(null), GameType.UNKNOWN);
      });
    });
  });
}
