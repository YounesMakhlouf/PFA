import 'package:collection/collection.dart';

enum ScreenType { MULTIPLE_CHOICE, MEMORY_MATCH, UNKNOWN }

/// Helper extension for safe parsing from string (DB value) to enum.
extension ScreenTypeExtension on ScreenType {
  static ScreenType fromString(String? value) {
    return ScreenType.values.firstWhereOrNull((e) => e.name == value) ??
        ScreenType.UNKNOWN;
  }

  String toJson() => name;
}

class Screen {
  final String screenId;
  final int screenNumber;
  final ScreenType type;
  final String levelId;
  final String? instruction;

  Screen({
    required this.screenId,
    required this.levelId,
    required this.type,
    required this.screenNumber,
    this.instruction,
  });
}

class Option {
  final String optionId;
  final String screenId;
  final bool? isCorrect; // Flag for multiple choice correct answer
  final String? labelText;
  final String? picturePath;
  final String? audioPath;
  final String? pairId; // Used for Memory games to identify matching pairs

  Option({
    required this.optionId,
    required this.screenId,
    this.labelText,
    this.picturePath,
    this.audioPath,
    this.isCorrect,
    this.pairId,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      optionId: json['option_id'] as String,
      screenId: json['screen_id'] as String,
      labelText: json['label_text'] as String?,
      picturePath: json['picture_url'] as String?,
      audioPath: json['audio_url'] as String?,
      isCorrect: json['is_correct'] as bool?,
      pairId: json['pair_id'] as String?,
    );
  }
}

class MemoryScreen extends Screen {
  MemoryScreen({
    required super.screenId,
    required super.levelId,
    required super.screenNumber,
    super.instruction,
  }) : super(type: ScreenType.MEMORY_MATCH);

  factory MemoryScreen.fromJson(Map<String, dynamic> json) {
    // Note: The 'options' are handled by the repository or service
    return MemoryScreen(
      screenId: json['screen_id'] as String,
      levelId: json['level_id'] as String,
      screenNumber: json['screen_number'] as int? ?? 0,
      instruction: json['instruction'] as String?,
    );
  }
}

class MultipleChoiceScreen extends Screen {
  MultipleChoiceScreen({
    required super.screenId,
    required super.levelId,
    required super.screenNumber,
    super.instruction,
  }) : super(type: ScreenType.MULTIPLE_CHOICE);

  factory MultipleChoiceScreen.fromJson(Map<String, dynamic> json) {
    // Note: The 'options' and 'correctAnswer' derived from the options list
    // are handled by the repository or service constructing this object.
    return MultipleChoiceScreen(
      screenId: json['screen_id'] as String,
      levelId: json['level_id'] as String,
      screenNumber: json['screen_number'] as int? ?? 0,
      instruction: json['instruction'] as String?,
    );
  }
}
