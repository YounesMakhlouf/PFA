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

  Game({
    String? gameId,
    required this.name,
    required this.pictureUrl,
    required this.instruction,
    required this.category,
    required this.type,
    required this.levels,
  }) : gameId = gameId ?? const Uuid().v4();

  Color get themeColor => category.themeColor;

  IconData get icon => category.icon;
}

class Level {
  final String levelId;
  final int levelNumber;
  final List<Screen> screens;

  Level({
    String? levelId,
    required this.levelNumber,
    required this.screens,
  }) : levelId = levelId ?? const Uuid().v4();

  List<Screen> getScreens() {
    return screens;
  }
}
