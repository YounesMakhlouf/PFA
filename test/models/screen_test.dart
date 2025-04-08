import 'package:flutter_test/flutter_test.dart';
import 'package:pfa/models/screen.dart';

void main() {
  group('Screen', () {
    test('should create a Screen with all required fields', () {
      final screen = Screen(screenNumber: 1);

      expect(screen.screenId, isNotEmpty);
      expect(screen.screenNumber, 1);
    });

    test('getOptions should return empty list by default', () {
      final screen = Screen(screenNumber: 1);
      expect(screen.getOptions(), isEmpty);
    });

    test('checkAnswer should return false by default', () {
      final screen = Screen(screenNumber: 1);
      expect(screen.checkAnswer([]), isFalse);
    });
  });

  group('Option', () {
    test('should create an Option with all fields', () {
      final option = Option(
        labelText: 'Red',
        pictureUrl: 'assets/images/red.png',
        pairId: 'color-red',
      );

      expect(option.optionId, isNotEmpty);
      expect(option.labelText, 'Red');
      expect(option.pictureUrl, 'assets/images/red.png');
      expect(option.pairId, 'color-red');
    });

    test('should handle null fields', () {
      final option = Option();

      expect(option.optionId, isNotEmpty);
      expect(option.labelText, isNull);
      expect(option.pictureUrl, isNull);
      expect(option.pairId, isNull);
    });

    test('should handle nullable fields correctly', () {
      final option =
          Option(labelText: 'Red', pictureUrl: 'assets/images/red.png');

      expect(option.labelText, 'Red');
      expect(option.pictureUrl, 'assets/images/red.png');

      final emptyOption = Option();
      expect(emptyOption.labelText, isNull);
      expect(emptyOption.pictureUrl, isNull);
    });
  });

  group('MultipleChoiceScreen', () {
    test('should create a MultipleChoiceScreen with all required fields', () {
      final option1 = Option(labelText: 'Red');
      final option2 = Option(labelText: 'Blue');
      final option3 = Option(labelText: 'Green');

      final screen = MultipleChoiceScreen(
        screenNumber: 1,
        options: [option1, option2, option3],
        correctAnswer: option2,
      );

      expect(screen.screenId, isNotEmpty);
      expect(screen.screenNumber, 1);
      expect(screen.options.length, 3);
      expect(screen.correctAnswer, option2);
    });

    test('getOptions should return all options', () {
      final option1 = Option(labelText: 'Red');
      final option2 = Option(labelText: 'Blue');

      final screen = MultipleChoiceScreen(
        screenNumber: 1,
        options: [option1, option2],
        correctAnswer: option1,
      );

      final options = screen.getOptions();
      expect(options.length, 2);
      expect(options[0], option1);
      expect(options[1], option2);
    });

    test('checkAnswer should return true for correct answer', () {
      final option1 = Option(labelText: 'Red');
      final option2 = Option(labelText: 'Blue');

      final screen = MultipleChoiceScreen(
        screenNumber: 1,
        options: [option1, option2],
        correctAnswer: option1,
      );

      expect(screen.checkAnswer([option1]), isTrue);
      expect(screen.checkAnswer([option2]), isFalse);
      expect(screen.checkAnswer([]), isFalse);
    });
  });

  group('MemoryScreen', () {
    test('should create a MemoryScreen with all required fields', () {
      final option1 = Option(labelText: 'Dog', pairId: 'animal-1');
      final option2 = Option(labelText: 'Dog Picture', pairId: 'animal-1');
      final option3 = Option(labelText: 'Cat', pairId: 'animal-2');
      final option4 = Option(labelText: 'Cat Picture', pairId: 'animal-2');

      final screen = MemoryScreen(
        screenNumber: 1,
        options: [option1, option2, option3, option4],
      );

      expect(screen.screenId, isNotEmpty);
      expect(screen.screenNumber, 1);
      expect(screen.options.length, 4);
    });

    test('getOptions should return all options', () {
      final option1 = Option(labelText: 'Dog', pairId: 'animal-1');
      final option2 = Option(labelText: 'Dog Picture', pairId: 'animal-1');

      final screen = MemoryScreen(
        screenNumber: 1,
        options: [option1, option2],
      );

      final options = screen.getOptions();
      expect(options.length, 2);
      expect(options[0], option1);
      expect(options[1], option2);
    });

    test('checkAnswer should return true for matching pairs', () {
      final option1 = Option(labelText: 'Dog', pairId: 'animal-1');
      final option2 = Option(labelText: 'Dog Picture', pairId: 'animal-1');
      final option3 = Option(labelText: 'Cat', pairId: 'animal-2');

      final screen = MemoryScreen(
        screenNumber: 1,
        options: [option1, option2, option3],
      );

      expect(screen.checkAnswer([option1, option2]), isTrue); // Same pairId
      expect(
          screen.checkAnswer([option1, option3]), isFalse); // Different pairId
      expect(screen.checkAnswer([option1]), isFalse); // Not enough options
      expect(screen.checkAnswer([]), isFalse); // Empty selection

      // Test with null pairId
      final optionNoPair = Option(labelText: 'No Pair');
      expect(screen.checkAnswer([option1, optionNoPair]), isFalse);
    });
  });
}
