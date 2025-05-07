import 'package:flutter_test/flutter_test.dart';
import 'package:pfa/models/screen.dart';

void main() {
  group('Option Model', () {
    test('should create an Option with all required and optional fields', () {
      final option = Option(
        optionId: 'opt-uuid-1',
        screenId: 'screen-uuid-1',
        labelText: 'Red Apple',
        picturePath: 'images/apple_red.png',
        audioPath: 'audio/apple.mp3',
        isCorrect: true,
        pairId: 'fruit-apple',
      );

      expect(option.optionId, 'opt-uuid-1');
      expect(option.screenId, 'screen-uuid-1');
      expect(option.labelText, 'Red Apple');
      expect(option.picturePath, 'images/apple_red.png');
      expect(option.audioPath, 'audio/apple.mp3');
      expect(option.isCorrect, isTrue);
      expect(option.pairId, 'fruit-apple');
    });

    test('should create an Option with only required fields', () {
      final option = Option(
        optionId: 'opt-uuid-2',
        screenId: 'screen-uuid-1',
        // labelText, picturePath, audioPath, pairId, config are optional
        isCorrect: false, // Required, but can be false
      );
      expect(option.optionId, 'opt-uuid-2');
      expect(option.screenId, 'screen-uuid-1');
      expect(option.isCorrect, isFalse);
      expect(option.labelText, isNull);
      expect(option.picturePath, isNull);
      expect(option.audioPath, isNull);
      expect(option.pairId, isNull);
    });

    // Test fromJson factory
    test('fromJson should correctly parse Option data from map', () {
      final json = {
        'option_id': 'opt-uuid-3',
        'screen_id': 'screen-uuid-2',
        'label_text': 'Blue Circle',
        'picture_url': 'shapes/circle_blue.png',
        'audio_url': null,
        'is_correct': true,
        'pair_id': null,
      };
      final option = Option.fromJson(json);

      expect(option.optionId, 'opt-uuid-3');
      expect(option.screenId, 'screen-uuid-2');
      expect(option.labelText, 'Blue Circle');
      expect(option.picturePath, 'shapes/circle_blue.png');
      expect(option.audioPath, isNull);
      expect(option.isCorrect, isTrue);
      expect(option.pairId, isNull);
    });

    test('fromJson should handle missing optional fields and default isCorrect',
        () {
      final json = {
        'option_id': 'opt-uuid-4',
        'screen_id': 'screen-uuid-3',
        // label, picture, audio, pair, is_correct missing
      };
      final option = Option.fromJson(json);

      expect(option.optionId, 'opt-uuid-4');
      expect(option.screenId, 'screen-uuid-3');
      expect(option.isCorrect, isNull);
      expect(option.labelText, isNull);
      expect(option.picturePath, isNull);
      expect(option.audioPath, isNull);
      expect(option.pairId, isNull);
    });
  });

  group('MultipleChoiceScreen Model', () {
    test('should create a MultipleChoiceScreen with all fields', () {
      final screen = MultipleChoiceScreen(
        screenId: 'mc-screen-1',
        levelId: 'level-abc',
        screenNumber: 1,
        instruction: 'Tap the largest shape',
      );

      expect(screen.screenId, 'mc-screen-1');
      expect(screen.levelId, 'level-abc');
      expect(screen.screenNumber, 1);
      expect(screen.type,
          ScreenType.MULTIPLE_CHOICE); // Check type set by constructor
      expect(screen.instruction, 'Tap the largest shape');
    });

    // Test fromJson factory
    test('fromJson should correctly parse MultipleChoiceScreen data', () {
      final json = {
        'screen_id': 'mc-screen-2',
        'level_id': 'level-xyz',
        'screen_number': 3,
        'type': 'MULTIPLE_CHOICE', // Type comes from DB
        'instruction': 'Which animal says "Moo"?',
      };
      final screen = MultipleChoiceScreen.fromJson(json);

      expect(screen, isA<MultipleChoiceScreen>());
      expect(screen.screenId, 'mc-screen-2');
      expect(screen.levelId, 'level-xyz');
      expect(screen.screenNumber, 3);
      expect(screen.type, ScreenType.MULTIPLE_CHOICE);
      expect(screen.instruction, 'Which animal says "Moo"?');
    });
  });

  group('MemoryScreen Model', () {
    test('should create a MemoryScreen with all fields', () {
      final screen = MemoryScreen(
        screenId: 'mem-screen-1',
        levelId: 'level-abc',
        screenNumber: 2,
        instruction: 'Match the pairs!',
      );

      expect(screen.screenId, 'mem-screen-1');
      expect(screen.levelId, 'level-abc');
      expect(screen.screenNumber, 2);
      expect(screen.type,
          ScreenType.MEMORY_MATCH); // Check type set by constructor
      expect(screen.instruction, 'Match the pairs!');
    });

    test('fromJson should correctly parse MemoryScreen data', () {
      final json = {
        'screen_id': 'mem-screen-2',
        'level_id': 'level-xyz',
        'screen_number': 1,
        'type': 'MEMORY_MATCH',
        'instruction': 'Find the matching fruits.',
      };
      final screen = MemoryScreen.fromJson(json);

      expect(screen, isA<MemoryScreen>());
      expect(screen.screenId, 'mem-screen-2');
      expect(screen.levelId, 'level-xyz');
      expect(screen.screenNumber, 1);
      expect(screen.type, ScreenType.MEMORY_MATCH);
      expect(screen.instruction, 'Find the matching fruits.');
    });
  });

  group('ScreenType Enum and Extension', () {
    test('should have correct enum values and UNKNOWN fallback', () {
      expect(ScreenType.values.length, 3);
      expect(ScreenType.values, contains(ScreenType.MULTIPLE_CHOICE));
      expect(ScreenType.values, contains(ScreenType.MEMORY_MATCH));
      expect(ScreenType.values, contains(ScreenType.UNKNOWN));
      expect(ScreenTypeExtension.fromString('MULTIPLE_CHOICE'),
          ScreenType.MULTIPLE_CHOICE);
      expect(ScreenTypeExtension.fromString('MEMORY'),
          ScreenType.UNKNOWN); // Test invalid value
      expect(ScreenTypeExtension.fromString(null), ScreenType.UNKNOWN);
    });

    test('toJson should return correct string name', () {
      expect(ScreenType.MULTIPLE_CHOICE.toJson(), 'MULTIPLE_CHOICE');
      expect(ScreenType.MEMORY_MATCH.toJson(), 'MEMORY_MATCH');
    });
  });
}
