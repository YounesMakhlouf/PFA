class CategoryStatsSummary {
  final String category;
  final int sessionsPlayed;
  final double accuracy;
  final double avgTime;
  final double hintUsageRatio;

  CategoryStatsSummary({
    required this.category,
    required this.sessionsPlayed,
    required this.accuracy,
    required this.avgTime,
    required this.hintUsageRatio,
  });

  factory CategoryStatsSummary.fromJson(Map<String, dynamic> json) {
    return CategoryStatsSummary(
      category: json['category'] ?? 'UNKNOWN',
      sessionsPlayed: (json['sessions_played'] ?? 0).toInt(),
      accuracy: double.parse(((json['accuracy'] ?? 0.0).toDouble()).toStringAsFixed(1)),
      avgTime: double.parse(((json['avg_time'] ?? 0.0).toDouble()).toStringAsFixed(1)),
      hintUsageRatio: double.parse(((json['hint_usage_ratio'] ?? 0.0).toDouble()).toStringAsFixed(1)),
    );
  }

  Map<String, dynamic> toJson() => {
    'category': category,
    'sessions_played': sessionsPlayed,
    'accuracy': accuracy,
    'avg_time': avgTime,
    'hint_usage_ratio': hintUsageRatio,
  };
}
