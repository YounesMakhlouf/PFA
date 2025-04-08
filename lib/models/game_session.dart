import 'package:uuid/uuid.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/models/user.dart';

class GameSession {
  final String sessionId;
  final DateTime startTime;
  DateTime? endTime;
  String? overallResult;
  final Child child;
  final Game game;
  final List<ScreenAttempt> attempts;

  GameSession({
    String? sessionId,
    DateTime? startTime,
    this.endTime,
    this.overallResult,
    required this.child,
    required this.game,
    List<ScreenAttempt>? attempts,
  })  : sessionId = sessionId ?? const Uuid().v4(),
        startTime = startTime ?? DateTime.now(),
        attempts = attempts ?? [];

  /// Calculates the duration of the session
  Duration get duration {
    if (endTime == null) {
      return DateTime.now().difference(startTime);
    }
    return endTime!.difference(startTime);
  }

  void addAttempt(ScreenAttempt attempt) {
    attempts.add(attempt);
  }

  /// Ends the session and calculates the overall result
  void endSession(String result) {
    endTime = DateTime.now();
    overallResult = result;
  }

  double get successRate {
    if (attempts.isEmpty) return 0.0;
    int correctAttempts = attempts.where((attempt) => attempt.isCorrect).length;
    return correctAttempts / attempts.length;
  }
}

class ScreenAttempt {
  final String attemptId;
  final DateTime timestamp;
  final bool isCorrect;
  final int timeTakenMs;
  final int hintsUsed;
  final Screen screen;
  final Option? selectedOption;

  ScreenAttempt({
    String? attemptId,
    DateTime? timestamp,
    required this.isCorrect,
    required this.timeTakenMs,
    this.hintsUsed = 0,
    required this.screen,
    this.selectedOption,
  })  : attemptId = attemptId ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();
}
