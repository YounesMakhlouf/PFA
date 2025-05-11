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

  //Stats
  @override
  String get statsTitle => 'Statistiques';
  @override
  String get globalStatsTitle => 'Statistiques globales';
  @override
  String get categoryStatsTitle => 'Statistiques par catégorie';
  @override
  String get accuracy => 'Précision';
  @override
  String get averageTime => 'Temps Moyen';
  @override
  String get hintsUsed => 'Indice utilisés';
  @override
  String get all => 'Tout';
  @override
  String get periodThisWeek => 'Cette Semaine';
  @override
  String get statsError => 'Aucune statistique disponible, réessayez plus tard';

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
  String get unknownCategory => 'Autre';
  @override
  String get unknownScreenType => 'Type d\'écran inconnu';
  @override
  String get applicationError => 'Erreur d\'Application';
  @override
  String get retry => 'Réessayer';
  @override
  String errorLoadingGamesDetails(Object error) =>
      'Erreur lors du chargement des jeux : $error';
  @override
  String errorLoadingCategoryGamesDetails(String categoryName, Object error) =>
      'Erreur lors du chargement des jeux pour $categoryName : $error';
  @override
  String errorLoadingProfileDetails(Object error) =>
      'Erreur lors du chargement des données du profil : $error';
  @override
  String errorCheckingAuthDetails(Object error) =>
      "Erreur lors de la vérification de l'authentification : $error";
  @override
  String get noGameCategoriesAvailable => 'Aucune catégorie de jeu disponible.';
  @override
  String noGamesInCategoryAvailable(String categoryName) =>
      'Aucun jeu disponible dans la catégorie $categoryName pour le moment.';

  // Game feedback
  @override
  String get correct => 'Correct !';
  @override
  String get tryAgain => 'Essayez encore !';

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

  @override
  String get logout => 'Déconnexion';
  @override
  String get errorScreenRestartInstruction =>
      'Veuillez fermer et rouvrir l\'application.';
  @override
  String get selectChildProfileTitle => 'Sélectionner un profil';
  @override
  String get whoIsPlayingPrompt => 'Qui joue ?';
  @override
  String get addChildProfileButton => 'Ajouter un autre profil';
  @override
  String get manageProfilesTooltip => 'Gérer les profils';
  @override
  String get switchChildProfileButton => 'Changer de profil';
  @override
  String get onlyOneProfileExists => 'Un seul profil existe.';

  @override
  String get loading => 'Chargement...';

  @override
  String get gameOver => 'Partie terminée !';
  @override
  String get congratulationsAllLevelsComplete =>
      'Félicitations ! Vous avez terminé tous les niveaux !';
  @override
  String get playAgain => 'Rejouer';
  @override
  String get backToGames => 'Retour aux jeux';
  @override
  String get exitGameTooltip => 'Quitter le jeu';
  @override
  String get exitGameConfirmationTitle => 'Quitter le jeu ?';
  @override
  String get exitGameConfirmationMessage =>
      'Êtes-vous sûr de vouloir quitter ? Votre progression actuelle dans ce niveau pourrait être perdue.';
  @override
  String get cancelButton => 'Annuler';
  @override
  String get exitButton => 'Quitter';
  @override
  String get repeatInstructionTooltip => 'Répéter l\'instruction';
  @override
  String get onboardingDesc1 => 'Cette application est spécialement conçue pour les enfants ayant des besoins spécifiques. Jouons et apprenons ensemble de manière ludique et sûre.';
  @override
  String get onboardingDesc2 => 'Suivez les progrès de vos enfants et découvrez des activités qui développent leurs compétences de manière intelligente et simple.';
  @override
  String get onboardingSkipButton => 'Passer';
  @override
  String get onboardingGetStartedButton => 'Commencer';
}
