import 'package:uuid/uuid.dart';

class Screen {
  final String screenId;
  final int screenNumber;

  Screen({
    String? screenId,
    required this.screenNumber,
  }) : screenId = screenId ?? const Uuid().v4();

  List<Option> getOptions() {
    return []; // Base implementation, to be overridden
  }

  bool checkAnswer(List<Option> selectedOptions) {
    return false; // Base implementation, to be overridden
  }
}

class Option {
  final String optionId;
  final String? labelText;
  final String? pictureUrl;
  final String? pairId; // Used for Memory games to identify matching pairs

  Option({
    String? optionId,
    this.labelText,
    this.pictureUrl,
    this.pairId,
  }) : optionId = optionId ?? const Uuid().v4();
}

class MemoryScreen extends Screen {
  final List<Option> options;

  MemoryScreen({
    super.screenId,
    required super.screenNumber,
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
}

class MultipleChoiceScreen extends Screen {
  final List<Option> options;
  final Option correctAnswer;

  MultipleChoiceScreen({
    super.screenId,
    required super.screenNumber,
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
}
