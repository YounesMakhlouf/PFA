import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/l10n/app_localizations.dart';

enum GameCategory {
  LOGICAL_THINKING,
  EDUCATION,
  RELAXATION,
  EMOTIONS,
  NUMBERS,
  COLORS_SHAPES,
  ANIMALS,
  FRUITS_VEGETABLES,
}

// Extension to get UI-friendly properties for game categories
extension GameCategoryExtension on GameCategory {
  String localizedName(BuildContext context) {
    switch (this) {
      case GameCategory.LOGICAL_THINKING:
        return AppLocalizations.of(context).logicalThinking;
      case GameCategory.EDUCATION:
        return AppLocalizations.of(context).education;
      case GameCategory.RELAXATION:
        return AppLocalizations.of(context).relaxation;
      case GameCategory.EMOTIONS:
        return AppLocalizations.of(context).emotions;
      case GameCategory.NUMBERS:
        return AppLocalizations.of(context).numbers;
      case GameCategory.COLORS_SHAPES:
        return AppLocalizations.of(context).colorsAndShapes;
      case GameCategory.ANIMALS:
        return AppLocalizations.of(context).animals;
      case GameCategory.FRUITS_VEGETABLES:
        return AppLocalizations.of(context).fruitsAndVegetables;
    }
  }

  Color get themeColor {
    switch (this) {
      case GameCategory.LOGICAL_THINKING:
        return Colors.indigo;
      case GameCategory.EDUCATION:
        return Colors.teal;
      case GameCategory.RELAXATION:
        return Colors.lightBlue;
      case GameCategory.EMOTIONS:
        return Colors.pink;
      case GameCategory.NUMBERS:
        return Colors.purple;
      case GameCategory.COLORS_SHAPES:
        return Colors.cyan;
      case GameCategory.ANIMALS:
        return Colors.green;
      case GameCategory.FRUITS_VEGETABLES:
        return Colors.orange;
    }
  }

  IconData get icon {
    switch (this) {
      case GameCategory.LOGICAL_THINKING:
        return Icons.psychology;
      case GameCategory.EDUCATION:
        return Icons.school;
      case GameCategory.RELAXATION:
        return Icons.spa;
      case GameCategory.EMOTIONS:
        return Icons.emoji_emotions;
      case GameCategory.NUMBERS:
        return Icons.looks_one;
      case GameCategory.COLORS_SHAPES:
        return Icons.palette;
      case GameCategory.ANIMALS:
        return Icons.pets;
      case GameCategory.FRUITS_VEGETABLES:
        return Icons.eco;
    }
  }
}

enum GameType {
  MULTIPLE_CHOICE,
  MEMORY_MATCH,
  PUZZLE,
  STORY,
  IDENTIFY_INTRUDER,
}

class Game {
  final String gameId;
  final String name;
  final String pictureUrl;
  final String instruction;
  final GameCategory category;
  final GameType type;
  final List<Level> levels;
  final String? educatorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Game({
    String? gameId,
    required this.name,
    required this.pictureUrl,
    required this.instruction,
    required this.category,
    required this.type,
    required this.levels,
    this.educatorId,
    this.createdAt,
    this.updatedAt,
  }) : gameId = gameId ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'game_id': gameId,
      'name': name,
      'picture_url': pictureUrl,
      'description': instruction,
      'category': category.toString().split('.').last,
      'type': type.toString().split('.').last,
      'educator_id': educatorId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory Game.fromJson(Map<String, dynamic> json, {List<Level>? levels}) {
    return Game(
      gameId: json['game_id'],
      name: json['name'],
      pictureUrl: json['picture_url'] ?? '',
      instruction: json['description'] ?? '',
      category: GameCategory.values.firstWhere(
          (e) => e.toString() == 'GameCategory.${json['category']}'),
      type: GameType.values
          .firstWhere((e) => e.toString() == 'GameType.${json['type']}'),
      levels: levels ?? [],
      educatorId: json['educator_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Color get themeColor => category.themeColor;

  IconData get icon => category.icon;
}

class Level {
  final String levelId;
  final int levelNumber;
  final List<Screen> screens;
  final String? gameId;

  Level({
    String? levelId,
    required this.levelNumber,
    required this.screens,
    this.gameId,
  }) : levelId = levelId ?? const Uuid().v4();

  List<Screen> getScreens() {
    return screens;
  }

  Map<String, dynamic> toJson() {
    return {
      'level_id': levelId,
      'level_number': levelNumber,
      'game_id': gameId,
    };
  }

  factory Level.fromJson(Map<String, dynamic> json, {List<Screen>? screens}) {
    return Level(
      levelId: json['level_id'],
      levelNumber: json['level_number'],
      gameId: json['game_id'],
      screens: screens ?? [],
    );
  }
}
