class Level {
  final String levelId;
  final String gameId;
  final int levelNumber;

  Level({
    required this.levelId,
    required this.gameId,
    required this.levelNumber,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      levelId: json['level_id'] as String,
      gameId: json['game_id'] as String,
      levelNumber: json['level_number'] as int? ?? 0,
    );
  }
}
