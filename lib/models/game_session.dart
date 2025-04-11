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

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'overall_result': overallResult,
      'child_id': child.userId,
      'game_id': game.gameId,
    };
  }

  factory GameSession.fromJson(Map<String, dynamic> json,
      {required Child child,
      required Game game,
      List<ScreenAttempt>? attempts}) {
    return GameSession(
      sessionId: json['session_id'],
      startTime: DateTime.parse(json['start_time']),
      endTime:
          json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      overallResult: json['overall_result'],
      child: child,
      game: game,
      attempts: attempts ?? [],
    );
  }

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
  final String? sessionId;

  ScreenAttempt({
    String? attemptId,
    DateTime? timestamp,
    required this.isCorrect,
    required this.timeTakenMs,
    this.hintsUsed = 0,
    required this.screen,
    this.selectedOption,
    this.sessionId,
  })  : attemptId = attemptId ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'attempt_id': attemptId,
      'timestamp': timestamp.toIso8601String(),
      'is_correct': isCorrect,
      'time_taken_ms': timeTakenMs,
      'hints_used': hintsUsed,
      'screen_id': screen.screenId,
      'selected_option_ids':
          selectedOption != null ? [selectedOption!.optionId] : [],
      'session_id': sessionId,
    };
  }

  factory ScreenAttempt.fromJson(Map<String, dynamic> json,
      {required Screen screen, Option? selectedOption}) {
    return ScreenAttempt(
      attemptId: json['attempt_id'],
      timestamp: DateTime.parse(json['timestamp']),
      isCorrect: json['is_correct'],
      timeTakenMs: json['time_taken_ms'],
      hintsUsed: json['hints_used'] ?? 0,
      screen: screen,
      selectedOption: selectedOption,
      sessionId: json['session_id'],
    );
  }
}
