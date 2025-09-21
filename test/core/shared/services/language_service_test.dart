import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sdui_app/core/shared/services/language_service.dart';

void main() {
  group('LanguageService', () {
    test('has correct supported languages', () {
      expect(LanguageService.supportedLanguages.length, equals(2));
      expect(LanguageService.defaultLanguage.languageCode, equals('en'));
    });

    test('returns correct language for supported locales', () {
      final enLanguage = LanguageService.getLanguageByLocale(
        const Locale('en'),
      );
      final arLanguage = LanguageService.getLanguageByLocale(
        const Locale('ar'),
      );

      expect(enLanguage?.languageCode, equals('en'));
      expect(arLanguage?.languageCode, equals('ar'));
      expect(arLanguage?.isRTL, isTrue);
    });

    test('validates locale support correctly', () {
      expect(LanguageService.isLocaleSupported(const Locale('en')), isTrue);
      expect(LanguageService.isLocaleSupported(const Locale('ar')), isTrue);
      expect(LanguageService.isLocaleSupported(const Locale('fr')), isFalse);
    });

    test('returns correct RTL status', () {
      expect(LanguageService.isRTL(const Locale('en')), isFalse);
      expect(LanguageService.isRTL(const Locale('ar')), isTrue);
    });
  });
}
