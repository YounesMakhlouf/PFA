import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/providers/global_providers.dart';

import '../constants/const.dart';

class TranslationService {
  final Ref _ref;
  TranslationService(this._ref);

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
    final currentLanguageCode = _ref.read(localeProvider).languageCode;
    return getLocalizedText(jsonString, currentLanguageCode);
  }
}
