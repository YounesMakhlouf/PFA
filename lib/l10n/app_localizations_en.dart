import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn() : super('en');

  @override
  String get appTitle => 'Autism Learning App';

  // Home page
  @override
  String get learningGames => 'Learning Games';

  // Game categories
  @override
  String get logicalThinking => 'Logical Thinking';
  @override
  String get education => 'Education';
  @override
  String get relaxation => 'Relaxation';
  @override
  String get emotions => 'Emotions';
  @override
  String get numbers => 'Numbers';
  @override
  String get colorsAndShapes => 'Colors and Shapes';
  @override
  String get animals => 'Animals';
  @override
  String get fruitsAndVegetables => 'Fruits and Vegetables';

  // Game instructions
  @override
  String get chooseCorrectColor => 'Choose the correct color';

  // Colors
  @override
  String get red => 'Red';
  @override
  String get green => 'Green';
  @override
  String get blue => 'Blue';
  @override
  String get yellow => 'Yellow';
  @override
  String get purple => 'Purple';

  // Special conditions
  @override
  String get autism => 'Autism';
  @override
  String get adhd => 'ADHD';
  @override
  String get dyslexia => 'Dyslexia';
  @override
  String get dyscalculia => 'Dyscalculia';
  @override
  String get speakingDifficulties => 'Speaking Difficulties';

  // Error messages
  @override
  String get unknownScreenType => 'Unknown screen type';
  @override
  String get applicationError => 'Application Error';
  @override
  String get retry => 'Retry';

  // Game feedback
  @override
  String get correct => 'Correct! 👏';
  @override
  String get tryAgain => 'Try again! 🤔';

  // Game UI
  @override
  String get level => 'Level';
  @override
  String get screen => 'Screen';
  @override
  String get memoryGameUnderDevelopment => 'Memory game under development';
  @override
  String get goBack => 'Go Back';
  @override
  String get selectableOption => 'Selectable option';
  @override
  String get selected => 'Selected';
  @override
  String get selectCorrectOption => 'Select the correct option';
}
