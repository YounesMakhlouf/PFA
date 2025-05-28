// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Application d\'Apprentissage pour l\'Autisme';

  @override
  String get learningGames => 'Jeux d\'Apprentissage';

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
  String get hintsUsed => 'Indices utilisés';

  @override
  String get all => 'Tout';

  @override
  String get periodThisWeek => 'Cette Semaine';

  @override
  String get statsError => 'Aucune statistique disponible, réessayez plus tard';

  @override
  String get viewStats => 'Consulter les statistiques';

  @override
  String get chooseCorrectColor => 'Choisissez la bonne couleur';

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

  @override
  String get unknownCategory => 'Autre';

  @override
  String get unknownScreenType => 'Type d\'écran inconnu';

  @override
  String get applicationError => 'Erreur d\'Application';

  @override
  String errorLoadingGamesDetails(Object error) {
    return 'Erreur lors du chargement des jeux : $error';
  }

  @override
  String errorLoadingCategoryGamesDetails(String categoryName, Object error) {
    return 'Erreur lors du chargement des jeux pour $categoryName : $error';
  }

  @override
  String errorLoadingProfileDetails(Object error) {
    return 'Erreur lors du chargement des données du profil : $error';
  }

  @override
  String errorCheckingAuthDetails(Object error) {
    return 'Erreur lors de la vérification de l\'authentification : $error';
  }

  @override
  String get noGameCategoriesAvailable => 'Aucune catégorie de jeu disponible.';

  @override
  String noGamesInCategoryAvailable(String categoryName) {
    return 'Aucun jeu disponible dans la catégorie $categoryName pour le moment.';
  }

  @override
  String get authenticating => 'Authentification en cours...';

  @override
  String appFailedToInitialize(String error) {
    return 'L\'application n\'a pas pu s\'initialiser: $error';
  }

  @override
  String get featureNotImplemented =>
      'Cette fonctionnalité n\'est pas encore implémentée.';

  @override
  String get errorCategoryMissing => 'Erreur : Catégorie manquante.';

  @override
  String get errorGameCategoryOrIdMissing =>
      'Erreur : Catégorie de jeu ou identifiant manquant.';

  @override
  String get errorChildIdMissing =>
      'Erreur : Identifiant de l\'enfant manquant';

  @override
  String get correct => 'Correct !';

  @override
  String get tryAgain => 'Essayez encore !';

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
  String get sendPasswordReset =>
      'Envoyer l\'e-mail de réinitialisation du mot de passe';

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
  String profileCreatedSuccess(String firstName) {
    return 'Profil créé pour $firstName !';
  }

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
  String get addChildProfileButton => 'Ajouter un profil enfant';

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
  String get onboardingDesc1 =>
      'Cette application est spécialement conçue pour les enfants ayant des besoins spécifiques. Jouons et apprenons ensemble de manière ludique et sûre.';

  @override
  String get onboardingDesc2 =>
      'Suivez les progrès de vos enfants et découvrez des activités qui développent leurs compétences de manière intelligente et simple.';

  @override
  String get onboardingSkipButton => 'Passer';

  @override
  String get onboardingGetStartedButton => 'Commencer';

  @override
  String get loadingProfilesMessage => 'Chargement des profils...';

  @override
  String get noProfilesFoundMessage => 'Aucun profil trouvé...';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get ttsEnabledSetting => 'Activer la synthèse vocale';

  @override
  String get soundEffectsEnabledSetting => 'Activer les effets sonores';

  @override
  String get loadingSetting => 'Chargement du paramètre...';

  @override
  String get errorLoadingSetting => 'Erreur de chargement du paramètre';

  @override
  String get languageSetting => 'Langue';

  @override
  String get selectLanguageDialogTitle => 'Choisir la langue';

  @override
  String get ttsSpeechRateSetting => 'Vitesse de la parole';

  @override
  String get ttsRateSlow => 'Lent';

  @override
  String get ttsRateNormal => 'Normal';

  @override
  String get ttsRateFast => 'Rapide';

  @override
  String get hapticsEnabledSetting => 'Activer le retour haptique';

  @override
  String get settingsSectionAudio => 'Audio et Retours';

  @override
  String get settingsSectionGeneral => 'Général';

  @override
  String get oopsSomethingWentWrong => 'Oups ! Quelque chose s\'est mal passé.';

  @override
  String get retryButton => 'Réessayer';

  @override
  String get closeAppButton => 'Fermer l\'application';

  @override
  String get errorScreenContactSupport =>
      'Si le problème persiste, veuillez contacter le support ou réessayer plus tard.';

  @override
  String get imageOption => 'Option Image';

  @override
  String get loadingUserData => 'Chargement des données utilisateur...';

  @override
  String get noGameCategoriesAvailableMessage =>
      'Aucune catégorie de jeu disponible pour le moment.';

  @override
  String loadingGamesFor(String categoryName) {
    return 'Chargement des jeux pour $categoryName...';
  }

  @override
  String get allCategoriesFilter => 'Toutes les catégories';

  @override
  String get overallStatsTitle => 'Performance globale';

  @override
  String get categoryAccuracyChartTitle =>
      'Précision par catégorie (Tout temps)';

  @override
  String get noChartDataAvailable =>
      'Pas assez de données pour afficher le graphique.';

  @override
  String get noStatsFound =>
      'Aucune statistique trouvée pour les filtres sélectionnés.';
}
