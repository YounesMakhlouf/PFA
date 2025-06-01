import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pfa/constants/const.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/services/translation_service.dart';

import '../mocks/mock_services.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy<Locale>(const Locale('ar', 'SA'));
  });
  late MockRef mockRef;
  late TranslationService translationService;

  // Test data
  final validJsonData = {
    "en": "Hello English",
    "ar": "مرحبا عربي",
    "fr": "Bonjour Français"
  };
  final String validJsonString = jsonEncode(validJsonData);

  setUp(() {
    mockRef = MockRef();
    translationService = TranslationService(mockRef);
  });

  group('TranslationService - getLocalizedText', () {
    test(
        'should return translation for defaultLanguageCode (ar) if current is missing and default exists',
        () {
      // Verify our constant is indeed 'ar' for this test's context
      expect(defaultLanguageCode, 'ar');

      final jsonWithDefaultArabic = jsonEncode({
        "en": "Hello English",
        "ar": "مرحبا عربي الافتراضي", // Default language is present
        "fr": "Bonjour Français"
      });

      // Requesting 'de' (German), which is not in the JSON.
      // Default is 'ar', which IS in the JSON.
      final result =
          translationService.getLocalizedText(jsonWithDefaultArabic, 'de');
      expect(result, "مرحبا عربي الافتراضي"); // Should fall back to 'ar'
    });

    test(
        'should fall back to first available if current and default (ar) are missing',
        () {
      final jsonWithOnlyGerman = jsonEncode({"de": "Hallo Deutsch"});
      final result = translationService.getLocalizedText(
          jsonWithOnlyGerman, 'fr'); // current='fr', default='ar'
      expect(result, "Hallo Deutsch"); // Falls back to the only available one
    });

    test('should return translation for currentLanguageCode if present', () {
      final result = translationService.getLocalizedText(validJsonString, 'ar');
      expect(result, "مرحبا عربي");
    });

    test('should return original string if JSON is invalid', () {
      const invalidJsonString =
          '{"en": "Hello", ar: "مرحبا"}'; // Missing quotes around 'ar'
      final result =
          translationService.getLocalizedText(invalidJsonString, 'en');
      expect(result, invalidJsonString);
    });

    test(
        'should return original string if JSON map does not contain any requested keys',
        () {
      final jsonStringWithOtherKeys = jsonEncode({"de": "Hallo Deutsch"});
      final result =
          translationService.getLocalizedText(jsonStringWithOtherKeys, 'fr');
      // Fallback to first value if no 'fr' or 'en'
      expect(result, "Hallo Deutsch");

      final emptyMapJson = jsonEncode({});
      final resultEmpty =
          translationService.getLocalizedText(emptyMapJson, 'en');
      expect(resultEmpty, emptyMapJson); // Or some default like '' if preferred
    });

    test('should return original string for empty JSON string input', () {
      const emptyJsonString = "";
      final result = translationService.getLocalizedText(emptyJsonString, 'en');
      // The try-catch for jsonDecode will likely make it return the empty string itself.
      expect(result, emptyJsonString);
    });
  });

  group('TranslationService - getLocalizedTextFromAppLocale', () {
    test(
        'should use language code from localeProvider and return correct translation (ar)',
        () {
      when(mockRef.read(localeProvider)).thenReturn(const Locale('ar'));
      final result =
          translationService.getLocalizedTextFromAppLocale(validJsonString);
      expect(result, "مرحبا عربي");
      verify(mockRef.read(localeProvider)).called(1);
    });

    test(
        'should use fallback logic if localeProvider language (e.g., es) is missing, and default (ar) is present',
        () {
      final jsonWithDefaultArabic = jsonEncode({
        "en": "Hello English",
        "ar": "مرحبا عربي الافتراضي",
        "fr": "Bonjour Français"
      });
      when(mockRef.read(localeProvider))
          .thenReturn(const Locale('es')); // Spanish not in JSON
      final result = translationService
          .getLocalizedTextFromAppLocale(jsonWithDefaultArabic);
      expect(result, "مرحبا عربي الافتراضي"); // Falls back to 'ar'
    });

    test(
        'should use fallback to first available if localeProvider language AND default (ar) are missing',
        () {
      final jsonWithOnlyEnglishAndFrench =
          jsonEncode({"en": "Hello English", "fr": "Bonjour Français"});
      when(mockRef.read(localeProvider))
          .thenReturn(const Locale('de')); // German not in JSON
      final result = translationService
          .getLocalizedTextFromAppLocale(jsonWithOnlyEnglishAndFrench);
      // Expect either "Hello English" or "Bonjour Français" depending on map iteration order
      expect(result, isIn(["Hello English", "Bonjour Français"]));
    });
  });

  group('TranslationService - getLocalizedTextFromAppLocale', () {
    test(
        'should use language code from localeProvider and return correct translation',
        () {
      // Arrange: Mock the localeProvider to return a specific Locale
      when(mockRef.read(localeProvider)).thenReturn(const Locale('fr'));

      // Act
      final result =
          translationService.getLocalizedTextFromAppLocale(validJsonString);

      // Assert
      expect(result, "Bonjour Français");
      verify(mockRef.read(localeProvider))
          .called(1); // Verify provider was read
    });

    test(
        'should use fallback logic if localeProvider language is missing in JSON',
        () {
      // Arrange: localeProvider returns 'es', but 'es' is not in validJsonString
      when(mockRef.read(localeProvider)).thenReturn(const Locale('es'));

      // Act
      final result =
          translationService.getLocalizedTextFromAppLocale(validJsonString);

      // Assert: Should fall back to defaultLanguageCode ('ar')
      expect(result, "مرحبا عربي");
    });

    test(
        'should handle when localeProvider provides language code not in JSON at all',
        () {
      final jsonStringWithOnlyGerman = jsonEncode({"de": "Hallo Deutsch"});
      // Arrange: localeProvider returns 'es'
      when(mockRef.read(localeProvider)).thenReturn(const Locale('es'));

      // Act
      final result = translationService
          .getLocalizedTextFromAppLocale(jsonStringWithOnlyGerman);

      // Assert: Should fall back to the first available ('de')
      expect(result, "Hallo Deutsch");
    });
  });
}
