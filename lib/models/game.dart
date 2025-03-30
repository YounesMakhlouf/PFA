import 'package:flutter/material.dart';
import 'package:pfa/models/screen.dart';

enum GameCategory {
  COLORS,
  ANIMALS,
  FRUITS_VEGETABLES,
  NUMBERS,
  EMOTIONS,
}

// Extension to get UI-friendly properties for game categories
extension GameCategoryExtension on GameCategory {
  String get arabicName {
    switch (this) {
      case GameCategory.COLORS:
        return 'ألوان وأشكال';
      case GameCategory.ANIMALS:
        return 'الحيوانات';
      case GameCategory.FRUITS_VEGETABLES:
        return 'خضر و غلال';
      case GameCategory.NUMBERS:
        return 'الأرقام';
      case GameCategory.EMOTIONS:
        return 'تطابق المشاعر';
    }
  }

  Color get themeColor {
    switch (this) {
      case GameCategory.COLORS:
        return Colors.lightBlue;
      case GameCategory.ANIMALS:
        return Colors.green;
      case GameCategory.FRUITS_VEGETABLES:
        return Colors.orange;
      case GameCategory.NUMBERS:
        return Colors.purple;
      case GameCategory.EMOTIONS:
        return Colors.pink;
    }
  }

  IconData get icon {
    switch (this) {
      case GameCategory.COLORS:
        return Icons.palette;
      case GameCategory.ANIMALS:
        return Icons.pets;
      case GameCategory.FRUITS_VEGETABLES:
        return Icons.eco;
      case GameCategory.NUMBERS:
        return Icons.looks_one;
      case GameCategory.EMOTIONS:
        return Icons.emoji_emotions;
    }
  }
}

enum GameType {
  MEMORY,
  MULTIPLE_CHOICE,
  MATCHING,
}

class Game {
  final String name;
  final String picture;
  final String instruction;
  final GameCategory category;
  final GameType type;
  final List<Level> levels;

  Game({
    required this.name,
    required this.picture,
    required this.instruction,
    required this.category,
    required this.type,
    required this.levels,
  });
  
  // Helper method to get theme color
  Color get themeColor => category.themeColor;
  
  // Helper method to get icon
  IconData get icon => category.icon;
}

class Level {
  final int levelNumber;
  final List<Screen> screens;

  Level({
    required this.levelNumber,
    required this.screens,
  });

  Future<void> fetchNextLevel() async {
    // Implementation to fetch the next level
  }
}
