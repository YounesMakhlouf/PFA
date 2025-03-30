class Screen {
  final int screenNumber;
  
  Screen({
    required this.screenNumber,
  });

  bool isCorrectAnswer() {
    return false; // Base implementation
  }

  Future<void> fetchNextScreen() async {
    // Implementation to fetch the next screen
  }
}

class Option {
  final String label;
  final String picture;

  Option({
    required this.label,
    required this.picture,
  });
}

class MemoryScreen extends Screen {
  final List<Option> options;
  final List<Option> correctAnswers;

  MemoryScreen({
    required super.screenNumber,
    required this.options,
    required this.correctAnswers,
  });

  @override
  bool isCorrectAnswer() {
    // Implementation for memory game
    return true;
  }
}

class MultipleChoiceScreen extends Screen {
  final List<Option> options;
  final Option correctAnswer;

  MultipleChoiceScreen({
    required super.screenNumber,
    required this.options,
    required this.correctAnswer,
  });

  @override
  bool isCorrectAnswer() {
    // Implementation for multiple choice game
    return true;
  }
}