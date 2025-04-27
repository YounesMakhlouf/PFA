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
  @override
  String get applicationError => 'Erreur d\'Application';
  @override
  String get retry => 'Réessayer';

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
  String get memoryGameUnderDevelopment =>
      'Jeu de mémoire en cours de développement';
  @override
  String get goBack => 'Retour';
  @override
  String get selectableOption => 'Option sélectionnable';
  @override
  String get selected => 'Sélectionné';
  @override
  String get selectCorrectOption => 'Sélectionnez la bonne option';

// Authenticatio
  @override
  String get signIn => 'Se connecter';
  @override
  String get signUp => 'S\'inscrire';
  @override
  String get enterEmail => 'Entrez votre e-mail';
  @override
  String get validEmailError => 'Veuillez entrer une adresse e-mail valide';
  @override
  String get enterPassword => 'Entrez votre mot de passe';
  @override
  String get passwordLengthError =>
      'Veuillez entrer un mot de passe d\'au moins 6 caractères';
  @override
  String get forgotPassword => 'Mot de passe oublié ?';
  @override
  String get dontHaveAccount => 'Pas de compte ? S\'inscrire';
  @override
  String get haveAccount => 'Déjà un compte ? Se connecter';
  @override
  String get sendPasswordReset => 'Envoyer l\'e-mail de réinitialisation';
  @override
  String get passwordResetSent =>
      'L\'e-mail de réinitialisation du mot de passe a été envoyé';
  @override
  String get backToSignIn => 'Retour à la connexion';
  @override
  String get unexpectedError => 'Une erreur inattendue s\'est produite';
  @override
  String get requiredFieldError => 'Ce champ est requis';
  @override
  String get confirmPasswordError => 'Les mots de passe ne correspondent pas';
  @override
  String get confirmPassword => 'Confirmer le mot de passe';
  @override
  String get createChildProfileTitle => 'Créer le profil de l\'enfant';
  @override
  String get selectAvatarPrompt => 'Choisissez un avatar';
  @override
  String get firstNameLabel => 'Prénom';
  @override
  String get enterFirstNameHint => 'Entrez le prénom';
  @override
  String get errorFirstNameRequired => 'Veuillez entrer un prénom';
  @override
  String get lastNameLabelOptional => 'Nom de famille (Facultatif)';
  @override
  String get enterLastNameHintOptional =>
      'Entrez le nom de famille (facultatif)';
  @override
  String get birthdateLabelOptional => 'Date de naissance (Facultatif)';
  @override
  String get selectDateButton => 'Sélectionner une date';
  @override
  String get specialConditionsLabelOptional =>
      'Conditions spécifiques (Facultatif)';
  @override
  String get createProfileButton => 'Créer le profil';
  @override
  String profileCreatedSuccess(String firstName) =>
      'Profil créé pour $firstName !';
  @override
  String get errorCreatingProfile =>
      'Impossible de créer le profil. Veuillez réessayer.';
}
