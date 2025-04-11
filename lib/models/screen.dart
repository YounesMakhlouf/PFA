import 'package:uuid/uuid.dart';

class Screen {
  final String screenId;
  final int screenNumber;
  final String? levelId;

  Screen({
    String? screenId,
    required this.screenNumber,
    this.levelId,
  }) : screenId = screenId ?? const Uuid().v4();

  List<Option> getOptions() {
    return []; // Base implementation, to be overridden
  }

  bool checkAnswer(List<Option> selectedOptions) {
    return false; // Base implementation, to be overridden
  }

  Map<String, dynamic> toJson() {
    return {
      'screen_id': screenId,
      'screen_number': screenNumber,
      'level_id': levelId,
      'screen_type': runtimeType.toString(),
    };
  }

  static Screen fromJson(Map<String, dynamic> json) {
    return Screen(
      screenId: json['screen_id'],
      screenNumber: json['screen_number'],
      levelId: json['level_id'],
    );
  }
}

class Option {
  final String optionId;
  final String? labelText;
  final String? pictureUrl;
  final String? pairId; // Used for Memory games to identify matching pairs
  final String? screenId;

  Option({
    String? optionId,
    this.labelText,
    this.pictureUrl,
    this.pairId,
    this.screenId,
  }) : optionId = optionId ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'option_id': optionId,
      'label_text': labelText,
      'picture_url': pictureUrl,
      'pair_id': pairId,
      'screen_id': screenId,
    };
  }

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      optionId: json['option_id'],
      labelText: json['label_text'],
      pictureUrl: json['picture_url'],
      pairId: json['pair_id'],
      screenId: json['screen_id'],
    );
  }
}

class MemoryScreen extends Screen {
  final List<Option> options;

  MemoryScreen({
    super.screenId,
    required super.screenNumber,
    super.levelId,
    required this.options,
  });

  @override
  List<Option> getOptions() {
    return options;
  }

  @override
  bool checkAnswer(List<Option> selectedOptions) {
    if (selectedOptions.length != 2) return false;
    if (selectedOptions[0].pairId == null ||
        selectedOptions[1].pairId == null) {
      return false;
    }

    // Check if the pairIds match
    return selectedOptions[0].pairId == selectedOptions[1].pairId;
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    return {
      ...baseJson,
      'screen_type': 'MemoryScreen',
    };
  }

  static MemoryScreen fromJson(
      Map<String, dynamic> json, List<Option> options) {
    return MemoryScreen(
      screenId: json['screen_id'],
      screenNumber: json['screen_number'],
      levelId: json['level_id'],
      options: options,
    );
  }
}

class MultipleChoiceScreen extends Screen {
  final List<Option> options;
  final Option correctAnswer;

  MultipleChoiceScreen({
    super.screenId,
    required super.screenNumber,
    super.levelId,
    required this.options,
    required this.correctAnswer,
  });

  @override
  List<Option> getOptions() {
    return options;
  }

  @override
  bool checkAnswer(List<Option> selectedOptions) {
    if (selectedOptions.isEmpty) return false;
    return selectedOptions.first.optionId == correctAnswer.optionId;
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    return {
      ...baseJson,
      'screen_type': 'MultipleChoiceScreen',
      'correct_option_id': correctAnswer.optionId,
    };
  }

  static MultipleChoiceScreen fromJson(
      Map<String, dynamic> json, List<Option> options, Option correctAnswer) {
    return MultipleChoiceScreen(
      screenId: json['screen_id'],
      screenNumber: json['screen_number'],
      levelId: json['level_id'],
      options: options,
      correctAnswer: correctAnswer,
    );
  }
}
