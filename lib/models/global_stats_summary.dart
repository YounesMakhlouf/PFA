class GlobalStatsSummary {
  final int sessionsPlayed;
  final double accuracy;
  final double avgTime;
  final double hintUsageRatio;

  GlobalStatsSummary({
    required this.sessionsPlayed,
    required this.accuracy,
    required this.avgTime,
    required this.hintUsageRatio,
  });

  factory GlobalStatsSummary.fromJson(Map<String, dynamic> json) {
    return GlobalStatsSummary(
      sessionsPlayed: (json['sessions_played'] ?? 0).toInt(),
      accuracy: double.parse(((json['accuracy'] ?? 0.0).toDouble()).toStringAsFixed(1)),
      avgTime: double.parse(((json['avg_time'] ?? 0.0).toDouble()).toStringAsFixed(1)),
      hintUsageRatio: double.parse(((json['hint_usage_ratio'] ?? 0.0).toDouble()).toStringAsFixed(1)),
    );
  }

  Map<String, dynamic> toJson() => {
    'sessions_played': sessionsPlayed,
    'accuracy': accuracy,
    'avg_time': avgTime,
    'hint_usage_ratio': hintUsageRatio,
  };
}
