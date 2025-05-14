import 'package:flutter/material.dart';

enum AppLanguage { english, arabic, french }

extension AppLanguageExtension on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.arabic:
        return 'ar';
      case AppLanguage.french:
        return 'fr';
    }
  }

  String displayName(BuildContext context) {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.arabic:
        return 'العربية (Arabic)';
      case AppLanguage.french:
        return 'Français (French)';
    }
  }

  static AppLanguage fromCode(String? languageCode) {
    switch (languageCode) {
      case 'en':
        return AppLanguage.english;
      case 'ar':
        return AppLanguage.arabic;
      case 'fr':
        return AppLanguage.french;
      default:
        return AppLanguage.arabic;
    }
  }
}
