import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = locale;

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizationsAr();
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
    Locale('fr'),
  ];

  // App title
  String get appTitle;

  // Home page
  String get learningGames;

  // Game categories
  String get logicalThinking;
  String get education;
  String get relaxation;
  String get emotions;
  String get numbers;
  String get colorsAndShapes;
  String get animals;
  String get fruitsAndVegetables;

  // Stats
  String get statsTitle;
  String get globalStatsTitle;
  String get categoryStatsTitle;
  String get accuracy;
  String get averageTime;
  String get hintsUsed;
  String get all;
  String get periodThisWeek;
  String get statsError;
  String get viewStats;

  // Game instructions
  String get chooseCorrectColor;

  // Colors
  String get red;
  String get green;
  String get blue;
  String get yellow;
  String get purple;

  // Special conditions
  String get autism;
  String get adhd;
  String get dyslexia;
  String get dyscalculia;
  String get speakingDifficulties;

  // Error messages
  String get oopsSomethingWentWrong;
  String get retryButton;
  String get closeAppButton;
  String get errorScreenContactSupport;
  String get errorScreenRestartInstruction;
  String get unknownScreenType;
  String get applicationError;
  String errorLoadingGamesDetails(Object error);
  String errorLoadingCategoryGamesDetails(String categoryName, Object error);
  String errorLoadingProfileDetails(Object error);
  String errorCheckingAuthDetails(Object error);
  String get noGameCategoriesAvailable;
  String noGamesInCategoryAvailable(String categoryName);

  // Game feedback
  String get correct;
  String get tryAgain;

  // Game UI
  String get level;
  String get screen;
  String get memoryGameUnderDevelopment;
  String get goBack;
  String get selectableOption;
  String get selected;
  String get selectCorrectOption;

  // Authentication
  String get signIn;
  String get signUp;
  String get enterEmail;
  String get validEmailError;
  String get enterPassword;
  String get passwordLengthError;
  String get forgotPassword;
  String get dontHaveAccount;
  String get haveAccount;
  String get sendPasswordReset;
  String get passwordResetSent;
  String get backToSignIn;
  String get unexpectedError;
  String get requiredFieldError;
  String get confirmPasswordError;
  String get confirmPassword;

  // Create Child Profile Screen
  String get createChildProfileTitle;
  String get selectAvatarPrompt;
  String get firstNameLabel;
  String get enterFirstNameHint;
  String get errorFirstNameRequired;
  String get lastNameLabelOptional;
  String get enterLastNameHintOptional;
  String get birthdateLabelOptional;
  String get selectDateButton;
  String get specialConditionsLabelOptional;
  String get createProfileButton;
  String profileCreatedSuccess(String firstName);
  String get errorCreatingProfile;
  String get selectChildProfileTitle;
  String get whoIsPlayingPrompt;
  String get addChildProfileButton;
  String get manageProfilesTooltip;
  String get switchChildProfileButton;
  String get onlyOneProfileExists;
  String get logout;

  // Profile messages
  String get loadingProfilesMessage;
  String get noProfilesFoundMessage;

  String get loading;
  String get gameOver;
  String get congratulationsAllLevelsComplete;
  String get playAgain;
  String get backToGames;
  String get exitGameTooltip;
  String get exitGameConfirmationTitle;
  String get exitGameConfirmationMessage;
  String get cancelButton;
  String get exitButton;
  String get unknownCategory;
  String get repeatInstructionTooltip;

  String get onboardingDesc1;
  String get onboardingDesc2;
  String get onboardingSkipButton;
  String get onboardingGetStartedButton;

  String get settingsTitle;
  String get ttsEnabledSetting;
  String get soundEffectsEnabledSetting;
  String get loadingSetting;
  String get errorLoadingSetting;
  String get languageSetting;
  String get selectLanguageDialogTitle;
  String get ttsSpeechRateSetting;
  String get ttsRateSlow;
  String get ttsRateNormal;
  String get ttsRateFast;
  String get hapticsEnabledSetting;
  String get settingsSectionAudio;
  String get settingsSectionGeneral;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(_lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.contains(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations _lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ar':
      return AppLocalizationsAr();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale"');
}
