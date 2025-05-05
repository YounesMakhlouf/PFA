class GameSession {
  final String sessionId;
  final String childId;
  final String gameId;
  final String levelId;
  final DateTime startTime;
  final DateTime? endTime;
  final bool completed;
  final int totalAttempts;
  final int correctAttempts;
  final int hintsUsed;
  final String? overallResult;

  GameSession({
    required this.sessionId,
    required this.childId,
    required this.gameId,
    required this.levelId,
    required this.startTime,
    this.endTime,
    required this.completed,
    required this.totalAttempts,
    required this.correctAttempts,
    required this.hintsUsed,
    this.overallResult,
  });

  factory GameSession.fromJson(Map<String, dynamic> json) {
    DateTime? parseOptionalDateTime(String? dateStr) {
      return dateStr == null ? null : DateTime.tryParse(dateStr)?.toLocal();
    }

    DateTime parseRequiredDateTime(String? dateStr) {
      if (dateStr == null) {
        return DateTime.now();
      }
      return DateTime.parse(dateStr).toLocal();
    }

    return GameSession(
      sessionId: json['session_id'] as String,
      childId: json['child_id'] as String,
      gameId: json['game_id'] as String,
      levelId: json['level_id'] as String,
      startTime: parseRequiredDateTime(json['start_time'] as String?),
      endTime: parseOptionalDateTime(json['end_time'] as String?),
      completed: json['completed'] as bool? ?? (json['end_time'] != null),
      totalAttempts: json['total_attempts'] as int? ?? 0,
      correctAttempts: json['correct_attempts'] as int? ?? 0,
      hintsUsed: json['hints_used'] as int? ?? 0,
      overallResult: json['overall_result'] as String?,
    );
  }

  Duration? get duration {
    if (endTime == null) {
      return null;
    }
    return endTime!.difference(startTime);
  }
}

class ScreenAttempt {
  final String attemptId;
  final String sessionId;
  final String screenId;
  final List<String>? selectedOptionIds;
  final DateTime timestamp;
  final bool isCorrect;
  final int? timeTakenMs;
  final int hintsUsed;

  ScreenAttempt({
    required this.attemptId,
    required this.sessionId,
    required this.screenId,
    this.selectedOptionIds,
    required this.timestamp,
    required this.isCorrect,
    this.timeTakenMs,
    required this.hintsUsed,
  });

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'screen_id': screenId,
      'selected_option_ids': selectedOptionIds,
      'timestamp': timestamp.toUtc().toIso8601String(),
      'is_correct': isCorrect,
      'time_taken_ms': timeTakenMs,
      'hints_used': hintsUsed,
    };
  }

  factory ScreenAttempt.fromJson(Map<String, dynamic> json) {
    List<String>? parseSelectedIds(dynamic data) {
      if (data is List) {
        return data.map((item) => item?.toString()).nonNulls.toList();
      }
      return null;
    }

    DateTime parseRequiredDateTime(String? dateStr) {
      if (dateStr == null) {
        return DateTime.now();
      }
      return DateTime.parse(dateStr).toLocal();
    }

    return ScreenAttempt(
      attemptId: json['attempt_id'] as String,
      sessionId: json['session_id'] as String,
      screenId: json['screen_id'] as String,
      selectedOptionIds: parseSelectedIds(json['selected_option_ids']),
      timestamp: parseRequiredDateTime(json['timestamp'] as String?),
      isCorrect: json['is_correct'] as bool? ?? false,
      timeTakenMs: json['time_taken_ms'] as int?,
      hintsUsed: json['hints_used'] as int? ?? 0,
    );
  }
}
