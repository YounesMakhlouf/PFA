import 'app_localizations.dart';

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr() : super('fr');

  @override
  String get appTitle => 'Application d\'Apprentissage pour l\'Autisme';

  // Home page
  @override
  String get learningGames => 'Jeux d\'Apprentissage';

  // Game categories
  @override
  String get logicalThinking => 'Pensée Logique';
  @override
  String get education => 'Éducation';
  @override
  String get relaxation => 'Relaxation';
  @override
  String get emotions => 'Émotions';
  @override
  String get numbers => 'Nombres';
  @override
  String get colorsAndShapes => 'Couleurs et Formes';
  @override
  String get animals => 'Animaux';
  @override
  String get fruitsAndVegetables => 'Fruits et Légumes';

  // Game instructions
  @override
  String get chooseCorrectColor => 'Choisissez la bonne couleur';

  // Colors
  @override
  String get red => 'Rouge';
  @override
  String get green => 'Vert';
  @override
  String get blue => 'Bleu';
  @override
  String get yellow => 'Jaune';
  @override
  String get purple => 'Violet';

  // Special conditions
  @override
  String get autism => 'Autisme';
  @override
  String get adhd => 'TDAH';
  @override
  String get dyslexia => 'Dyslexie';
  @override
  String get dyscalculia => 'Dyscalculie';
  @override
  String get speakingDifficulties => 'Difficultés d\'Élocution';

  // Error messages
  @override
  String get unknownScreenType => 'Type d\'écran inconnu';

  // Game feedback
  @override
  String get correct => 'Correct ! 👏';
  @override
  String get tryAgain => 'Essayez encore ! 🤔';

  // Game UI
  @override
  String get level => 'Niveau';
  @override
  String get screen => 'Écran';
  @override
  String get memoryGameUnderDevelopment => 'Jeu de mémoire en cours de développement';
}