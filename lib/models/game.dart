import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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
  UNKNOWN
}

// Extension to get UI-friendly properties for game categories
extension GameCategoryExtension on GameCategory {
  String localizedName(BuildContext context) {
    switch (this) {
      case GameCategory.LOGICAL_THINKING:
        return AppLocalizations.of(context)!.logicalThinking;
      case GameCategory.EDUCATION:
        return AppLocalizations.of(context)!.education;
      case GameCategory.RELAXATION:
        return AppLocalizations.of(context)!.relaxation;
      case GameCategory.EMOTIONS:
        return AppLocalizations.of(context)!.emotions;
      case GameCategory.NUMBERS:
        return AppLocalizations.of(context)!.numbers;
      case GameCategory.COLORS_SHAPES:
        return AppLocalizations.of(context)!.colorsAndShapes;
      case GameCategory.ANIMALS:
        return AppLocalizations.of(context)!.animals;
      case GameCategory.FRUITS_VEGETABLES:
        return AppLocalizations.of(context)!.fruitsAndVegetables;
      case GameCategory.UNKNOWN:
        return AppLocalizations.of(context)!.unknownCategory;
    }
  }

  static GameCategory fromString(String? value) {
    return GameCategory.values.firstWhereOrNull((e) => e.name == value) ??
        GameCategory.UNKNOWN;
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
      default:
        return Colors.black;
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
      default:
        return Icons.extension_outlined;
    }
  }
}

enum GameType {
  MULTIPLE_CHOICE,
  MEMORY_MATCH,
  PUZZLE,
  STORY,
  IDENTIFY_INTRUDER,
  UNKNOWN
}

extension GameTypeExtension on GameType {
  static GameType fromString(String? value) {
    return GameType.values.firstWhereOrNull((e) => e.name == value) ??
        GameType.UNKNOWN;
  }
}

class Game {
  final String gameId;
  final String name;
  final String? pictureUrl;
  final String? description;
  final GameCategory category;
  final GameType type;
  final String? themeColorCode;
  final String? iconName;
  final String? educatorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Game({
    required this.gameId,
    required this.name,
    this.pictureUrl,
    this.description,
    required this.category,
    required this.type,
    this.themeColorCode,
    this.iconName,
    this.educatorId,
    this.createdAt,
    this.updatedAt,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    DateTime? parseOptionalDateTime(String? dateStr) {
      return dateStr == null ? null : DateTime.tryParse(dateStr)?.toLocal();
    }

    return Game(
      gameId: json['game_id'] as String,
      name: json['name'] as String? ?? 'Unnamed Game',
      pictureUrl: json['picture_url'] as String?,
      description: json['description'] as String?,
      category: GameCategoryExtension.fromString(json['category'] as String?),
      type: GameTypeExtension.fromString(json['type'] as String?),
      themeColorCode: json['theme_color'] as String?,
      iconName: json['icon_name'] as String?,
      educatorId: json['educator_id'] as String?,
      createdAt: parseOptionalDateTime(json['created_at'] as String?),
      updatedAt: parseOptionalDateTime(json['updated_at'] as String?),
    );
  }
}
