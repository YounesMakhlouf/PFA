// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Autism Learning App';

  @override
  String get learningGames => 'Learning Games';

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

  @override
  String get statsTitle => 'Stats';

  @override
  String get globalStatsTitle => 'Global Statistics';

  @override
  String get categoryStatsTitle => 'Category Statistics';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get averageTime => 'Avg time';

  @override
  String get hintsUsed => 'Hints Used';

  @override
  String get all => 'All';

  @override
  String get periodThisWeek => 'This week';

  @override
  String get statsError => 'No stats available, try again later';

  @override
  String get viewStats => 'View Stats';

  @override
  String get chooseCorrectColor => 'Choose the correct color';

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

  @override
  String get unknownCategory => 'Other';

  @override
  String get unknownScreenType => 'Unknown screen type';

  @override
  String get applicationError => 'Application Error';

  @override
  String errorLoadingGamesDetails(Object error) {
    return 'Error loading games: $error';
  }

  @override
  String errorLoadingCategoryGamesDetails(String categoryName, Object error) {
    return 'Error loading games for $categoryName: $error';
  }

  @override
  String errorLoadingProfileDetails(Object error) {
    return 'Error loading profile data: $error';
  }

  @override
  String errorCheckingAuthDetails(Object error) {
    return 'Error checking authentication: $error';
  }

  @override
  String get noGameCategoriesAvailable => 'No game categories available.';

  @override
  String noGamesInCategoryAvailable(String categoryName) {
    return 'No games available in the $categoryName category yet.';
  }

  @override
  String get authenticating => 'Authenticating...';

  @override
  String appFailedToInitialize(String error) {
    return 'App failed to initialize: $error';
  }

  @override
  String get featureNotImplemented => 'This feature is not implemented yet.';

  @override
  String get errorCategoryMissing => 'Error: Category is missing.';

  @override
  String get errorGameCategoryOrIdMissing =>
      'Error: Game category or ID is missing.';

  @override
  String get errorChildIdMissing => 'Error: Child identifier is missing';

  @override
  String get correct => 'Correct!';

  @override
  String get tryAgain => 'Try again!';

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

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get validEmailError => 'Please enter a valid email address';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get passwordLengthError =>
      'Please enter a password that is at least 6 characters long';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Sign up';

  @override
  String get haveAccount => 'Already have an account? Sign in';

  @override
  String get sendPasswordReset => 'Send password reset email';

  @override
  String get passwordResetSent => 'Password reset email has been sent';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get unexpectedError => 'An unexpected error occurred';

  @override
  String get requiredFieldError => 'This field is required';

  @override
  String get confirmPasswordError => 'Passwords do not match';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get createChildProfileTitle => 'Create Child Profile';

  @override
  String get selectAvatarPrompt => 'Choose an Avatar';

  @override
  String get firstNameLabel => 'First Name';

  @override
  String get enterFirstNameHint => 'Enter first name';

  @override
  String get errorFirstNameRequired => 'Please enter a first name';

  @override
  String get lastNameLabelOptional => 'Last Name (Optional)';

  @override
  String get enterLastNameHintOptional => 'Enter last name (optional)';

  @override
  String get birthdateLabelOptional => 'Birthdate (Optional)';

  @override
  String get selectDateButton => 'Select Date';

  @override
  String get specialConditionsLabelOptional => 'Special Conditions (Optional)';

  @override
  String get createProfileButton => 'Create Profile';

  @override
  String profileCreatedSuccess(String firstName) {
    return 'Profile created for $firstName!';
  }

  @override
  String get errorCreatingProfile =>
      'Could not create profile. Please try again.';

  @override
  String get logout => 'Logout';

  @override
  String get errorScreenRestartInstruction =>
      'Please close and reopen the application.';

  @override
  String get selectChildProfileTitle => 'Select Profile';

  @override
  String get whoIsPlayingPrompt => 'Who is playing?';

  @override
  String get addChildProfileButton => 'Add Another Profile';

  @override
  String get manageProfilesTooltip => 'Manage Profiles';

  @override
  String get switchChildProfileButton => 'Switch Profile';

  @override
  String get onlyOneProfileExists => 'Only one profile exists.';

  @override
  String get loading => 'Loading...';

  @override
  String get gameOver => 'Game Over!';

  @override
  String get congratulationsAllLevelsComplete =>
      'Congratulations! You\'ve completed all levels!';

  @override
  String get playAgain => 'Play Again';

  @override
  String get backToGames => 'Back to Games';

  @override
  String get exitGameTooltip => 'Exit Game';

  @override
  String get exitGameConfirmationTitle => 'Exit Game?';

  @override
  String get exitGameConfirmationMessage =>
      'Are you sure you want to quit? Your current progress in this level might be lost.';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get exitButton => 'Exit';

  @override
  String get repeatInstructionTooltip => 'Repeat Instruction';

  @override
  String get onboardingDesc1 =>
      'This app is specially designed for children with special needs. Let\'s play and learn together in a fun and safe way.';

  @override
  String get onboardingDesc2 =>
      'Track your children\'s progress and discover activities that develop their skills in smart and simple ways.';

  @override
  String get onboardingSkipButton => 'Skip';

  @override
  String get onboardingGetStartedButton => 'Get Started';

  @override
  String get loadingProfilesMessage => 'Loading profiles...';

  @override
  String get noProfilesFoundMessage => 'No profiles found...';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get ttsEnabledSetting => 'Enable Text-to-Speech';

  @override
  String get soundEffectsEnabledSetting => 'Enable Sound Effects';

  @override
  String get loadingSetting => 'Loading setting...';

  @override
  String get errorLoadingSetting => 'Error loading setting';

  @override
  String get languageSetting => 'Language';

  @override
  String get selectLanguageDialogTitle => 'Select Language';

  @override
  String get ttsSpeechRateSetting => 'Speech Rate';

  @override
  String get ttsRateSlow => 'Slow';

  @override
  String get ttsRateNormal => 'Normal';

  @override
  String get ttsRateFast => 'Fast';

  @override
  String get hapticsEnabledSetting => 'Enable Haptic Feedback';

  @override
  String get settingsSectionAudio => 'Audio & Feedback';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get oopsSomethingWentWrong => 'Oops! Something went wrong.';

  @override
  String get retryButton => 'Try Again';

  @override
  String get closeAppButton => 'Close App';

  @override
  String get errorScreenContactSupport =>
      'If the problem persists, please contact support or try again later.';

  @override
  String get imageOption => 'Image Option';

  @override
  String get loadingUserData => 'Loading user data...';

  @override
  String get noGameCategoriesAvailableMessage =>
      'No game categories available at the moment.';

  @override
  String loadingGamesFor(String categoryName) {
    return 'Loading games for $categoryName...';
  }

  @override
  String get allCategoriesFilter => 'All Categories';

  @override
  String get overallStatsTitle => 'Overall Performance';

  @override
  String get categoryAccuracyChartTitle => 'Accuracy by Category (All Time)';

  @override
  String get noChartDataAvailable => 'Not enough data to display chart.';

  @override
  String get noStatsFound => 'No statistics found for the selected filters.';

  @override
  String get matchFound => 'Match Found!';

  @override
  String get noMatchTryAgain => 'No Match. Try Again!';

  @override
  String get matched => 'Matched';
}
