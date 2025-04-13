import 'package:flutter_test/flutter_test.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/models/game_session.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/models/user.dart';

void main() {
  group('GameSession', () {
    late Child testChild;
    late Game testGame;
    late Screen testScreen;

    setUp(() {
      testChild = Child(
        email: 'test@example.com',
        firstName: 'Ahmed',
        lastName: 'Ali',
        birthdate: DateTime(2015, 5, 10),
        specialConditions: [SpecialCondition.AUTISM],
      );

      testGame = Game(
        name: 'Colors Game',
        pictureUrl: 'assets/images/colors_game.png',
        instruction: 'Choose the correct color',
        category: GameCategory.COLORS_SHAPES,
        type: GameType.MULTIPLE_CHOICE,
        levels: [],
      );

      testScreen = Screen(screenNumber: 1);
    });

    test('should create a GameSession with all required fields', () {
      final session = GameSession(
        child: testChild,
        game: testGame,
      );

      expect(session.sessionId, isNotEmpty);
      expect(session.startTime, isNotNull);
      expect(session.endTime, isNull);
      expect(session.overallResult, isNull);
      expect(session.child, testChild);
      expect(session.game, testGame);
      expect(session.attempts, isEmpty);
    });

    test('should calculate duration correctly', () {
      final startTime = DateTime.now().subtract(const Duration(minutes: 5));
      final session = GameSession(
        startTime: startTime,
        child: testChild,
        game: testGame,
      );

      // For an ongoing session
      expect(session.duration.inMinutes,
          greaterThanOrEqualTo(4)); // Allow for slight timing differences

      // For a completed session
      final endTime = startTime.add(const Duration(minutes: 10));
      final completedSession = GameSession(
        startTime: startTime,
        endTime: endTime,
        child: testChild,
        game: testGame,
      );

      expect(completedSession.duration.inMinutes, 10);
    });

    test('should add attempts correctly', () {
      final session = GameSession(
        child: testChild,
        game: testGame,
      );

      final attempt = ScreenAttempt(
        isCorrect: true,
        timeTakenMs: 1500,
        screen: testScreen,
      );

      session.addAttempt(attempt);

      expect(session.attempts.length, 1);
      expect(session.attempts.first, attempt);
    });

    test('should end session correctly', () {
      final session = GameSession(
        child: testChild,
        game: testGame,
      );

      session.endSession('Completed successfully');

      expect(session.endTime, isNotNull);
      expect(session.overallResult, 'Completed successfully');
    });

    test('should calculate success rate correctly', () {
      final session = GameSession(
        child: testChild,
        game: testGame,
      );

      // No attempts yet
      expect(session.successRate, 0.0);

      // Add some attempts
      session.addAttempt(ScreenAttempt(
        isCorrect: true,
        timeTakenMs: 1000,
        screen: testScreen,
      ));

      session.addAttempt(ScreenAttempt(
        isCorrect: false,
        timeTakenMs: 2000,
        screen: testScreen,
      ));

      session.addAttempt(ScreenAttempt(
        isCorrect: true,
        timeTakenMs: 1500,
        screen: testScreen,
      ));

      // 2 out of 3 attempts are correct
      expect(session.successRate, 2 / 3);
    });
  });

  group('ScreenAttempt', () {
    test('should create a ScreenAttempt with all required fields', () {
      final screen = Screen(screenNumber: 1);
      final option = Option(labelText: 'Red');

      final attempt = ScreenAttempt(
        isCorrect: true,
        timeTakenMs: 1500,
        hintsUsed: 1,
        screen: screen,
        selectedOption: option,
      );

      expect(attempt.attemptId, isNotEmpty);
      expect(attempt.timestamp, isNotNull);
      expect(attempt.isCorrect, isTrue);
      expect(attempt.timeTakenMs, 1500);
      expect(attempt.hintsUsed, 1);
      expect(attempt.screen, screen);
      expect(attempt.selectedOption, option);
    });

    test('should use default values when not provided', () {
      final screen = Screen(screenNumber: 1);

      final attempt = ScreenAttempt(
        isCorrect: false,
        timeTakenMs: 2000,
        screen: screen,
      );

      expect(attempt.hintsUsed, 0);
      expect(attempt.selectedOption, isNull);
    });
  });
}
