import 'dart:convert'; 
import 'package:flutter/widgets.dart'; 

class TranslationService {
  String getTranslatedText(BuildContext context, String jsonString) {
    try {
      final locale = Localizations.localeOf(context).languageCode;

      final Map<String, dynamic> translations = jsonDecode(jsonString);

      return translations[locale] ??
          translations['ar'] ??
          translations.values.first;
    } catch (e) {
      return jsonString;
    }
  }
}
