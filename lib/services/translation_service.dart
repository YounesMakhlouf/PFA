import 'dart:convert';

import '../constants/const.dart';

class TranslationService {
  final String Function() _languageCode;
  TranslationService(this._languageCode);

  String getLocalizedText(String jsonString, String currentLanguageCode) {
    try {
      final Map<String, dynamic> translations = jsonDecode(jsonString);

      return translations[currentLanguageCode] ??
          translations[defaultLanguageCode] ??
          translations.values.first;
    } catch (e) {
      return jsonString;
    }
  }

  String getLocalizedTextFromAppLocale(String jsonString) {
    return getLocalizedText(jsonString, _languageCode());
  }
}
