import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:pfa/models/game_session.dart';

void main() {
  const uuid = Uuid();
  group('GameSession Model', () {
    // Define test IDs
    final testSessionId = uuid.v4();
    final testChildId = uuid.v4();
    final testGameId = uuid.v4();
    final testLevelId = uuid.v4();
    final testStartTime = DateTime(2024, 1, 10, 10, 0, 0);
    final testEndTime = DateTime(2024, 1, 10, 10, 15, 0);

    test('should create a GameSession with all required fields', () {
      final session = GameSession(
        sessionId: testSessionId,
        childId: testChildId,
        gameId: testGameId,
        levelId: testLevelId,
        startTime: testStartTime,
        completed: false, // Initial state
        totalAttempts: 0, // Initial state
        correctAttempts: 0, // Initial state
        hintsUsed: 0, // Initial state
      );

      expect(session.sessionId, testSessionId);
      expect(session.childId, testChildId);
      expect(session.gameId, testGameId);
      expect(session.levelId, testLevelId);
      expect(session.startTime, testStartTime);
      expect(session.endTime, isNull);
      expect(session.completed, isFalse);
      expect(session.totalAttempts, 0);
      expect(session.correctAttempts, 0);
      expect(session.hintsUsed, 0);
      expect(session.overallResult, isNull);
    });

    test('should create a GameSession with optional fields', () {
      final session = GameSession(
        sessionId: testSessionId,
        childId: testChildId,
        gameId: testGameId,
        levelId: testLevelId,
        startTime: testStartTime,
        endTime: testEndTime,
        completed: true,
        totalAttempts: 5,
        correctAttempts: 3,
        hintsUsed: 1,
        overallResult: 'Good effort!',
      );

      expect(session.sessionId, testSessionId);
      expect(session.childId, testChildId);
      expect(session.gameId, testGameId);
      expect(session.levelId, testLevelId);
      expect(session.startTime, testStartTime);
      expect(session.endTime, testEndTime);
      expect(session.completed, isTrue);
      expect(session.totalAttempts, 5);
      expect(session.correctAttempts, 3);
      expect(session.hintsUsed, 1);
      expect(session.overallResult, 'Good effort!');
    });

    test('should calculate duration correctly when ended', () {
      final session = GameSession(
        sessionId: testSessionId,
        childId: testChildId,
        gameId: testGameId,
        levelId: testLevelId,
        startTime: testStartTime,
        endTime: testEndTime,
        completed: true,
        totalAttempts: 5,
        correctAttempts: 3,
        hintsUsed: 1,
      );

      expect(session.duration, isNotNull);
      expect(session.duration!.inMinutes, 15);
    });

    test('should return null duration when not ended', () {
      final session = GameSession(
        sessionId: testSessionId,
        childId: testChildId,
        gameId: testGameId,
        levelId: testLevelId,
        startTime: testStartTime,
        endTime: null, // End time is null
        completed: false,
        totalAttempts: 2,
        correctAttempts: 1,
        hintsUsed: 0,
      );

      expect(session.duration, isNull);
    });
  });

  group('ScreenAttempt Model', () {
    final testAttemptId = uuid.v4();
    final testSessionId = uuid.v4();
    final testScreenId = uuid.v4();
    final testOptionId1 = uuid.v4();
    final testOptionId2 = uuid.v4();
    final testTimestamp = DateTime(2024, 1, 10, 10, 5, 30);

    test(
        'should create a ScreenAttempt with all required fields and some optional',
        () {
      final attempt = ScreenAttempt(
        attemptId: testAttemptId,
        sessionId: testSessionId,
        screenId: testScreenId,
        isCorrect: true,
        timeTakenMs: 1500,
        hintsUsed: 1,
        timestamp: testTimestamp,
        selectedOptionIds: [testOptionId1],
      );

      expect(attempt.attemptId, testAttemptId);
      expect(attempt.sessionId, testSessionId);
      expect(attempt.screenId, testScreenId);
      expect(attempt.timestamp, testTimestamp);
      expect(attempt.isCorrect, isTrue);
      expect(attempt.timeTakenMs, 1500);
      expect(attempt.hintsUsed, 1);
      expect(attempt.selectedOptionIds, isNotNull);
      expect(attempt.selectedOptionIds, contains(testOptionId1));
      expect(attempt.selectedOptionIds!.length, 1);
    });

    test('should create a ScreenAttempt with multiple selected options', () {
      final attempt = ScreenAttempt(
        attemptId: testAttemptId,
        sessionId: testSessionId,
        screenId: testScreenId,
        isCorrect: false,
        timeTakenMs: 3200,
        hintsUsed: 0,
        timestamp: testTimestamp,
        selectedOptionIds: [testOptionId1, testOptionId2], // Multiple IDs
      );

      expect(attempt.selectedOptionIds, isNotNull);
      expect(attempt.selectedOptionIds,
          containsAll([testOptionId1, testOptionId2]));
      expect(attempt.selectedOptionIds!.length, 2);
    });

    test('should create a ScreenAttempt with minimum required fields', () {
      final attempt = ScreenAttempt(
        attemptId: testAttemptId,
        sessionId: testSessionId,
        screenId: testScreenId,
        isCorrect: false,
        // timeTakenMs is nullable
        hintsUsed: 0,
        timestamp: testTimestamp,
        // selectedOptionIds is nullable
      );

      expect(attempt.attemptId, testAttemptId);
      expect(attempt.sessionId, testSessionId);
      expect(attempt.screenId, testScreenId);
      expect(attempt.timestamp, testTimestamp);
      expect(attempt.isCorrect, isFalse);
      expect(attempt.timeTakenMs, isNull);
      expect(attempt.hintsUsed, 0);
      expect(attempt.selectedOptionIds, isNull);
    });

    // Test the ScreenAttempt.fromJson factory
    test('ScreenAttempt.fromJson parses correctly', () {
      final jsonData = {
        'attempt_id': testAttemptId,
        'session_id': testSessionId,
        'screen_id': testScreenId,
        'selected_option_ids': [testOptionId1, testOptionId2],
        'timestamp': testTimestamp.toIso8601String(),
        'is_correct': true,
        'time_taken_ms': 2100,
        'hints_used': 1,
      };

      final attempt = ScreenAttempt.fromJson(jsonData);

      expect(attempt.attemptId, testAttemptId);
      expect(attempt.sessionId, testSessionId);
      expect(attempt.screenId, testScreenId);
      expect(attempt.selectedOptionIds, isNotNull);
      expect(attempt.selectedOptionIds,
          containsAll([testOptionId1, testOptionId2]));
      expect(
          attempt.timestamp.isAtSameMomentAs(testTimestamp.toLocal()), isTrue);
      expect(attempt.isCorrect, isTrue);
      expect(attempt.timeTakenMs, 2100);
      expect(attempt.hintsUsed, 1);
    });

    test('ScreenAttempt.fromJson handles null optionals', () {
      final jsonData = {
        'attempt_id': testAttemptId,
        'session_id': testSessionId,
        'screen_id': testScreenId,
        'selected_option_ids': null,
        'timestamp': testTimestamp.toIso8601String(),
        'is_correct': false,
        'time_taken_ms': null,
        'hints_used': 0,
      };

      final attempt = ScreenAttempt.fromJson(jsonData);

      expect(attempt.selectedOptionIds, isNull);
      expect(attempt.timeTakenMs, isNull);
      expect(attempt.hintsUsed, 0);
      expect(attempt.isCorrect, false);
    });
  });
}
