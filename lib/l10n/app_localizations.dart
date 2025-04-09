import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
  String get unknownScreenType;

  // Game feedback
  String get correct;
  String get tryAgain;

  // Game UI
  String get level;
  String get screen;
  String get memoryGameUnderDevelopment;
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
  // Lookup logic when a locale is passed.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ar':
      return AppLocalizationsAr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale"');
}
