import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sdui_app/core/shared/data/models/app_language.dart';

void main() {
  group('AppLanguage', () {
    test('creates language with correct properties', () {
      const language = AppLanguage(
        languageCode: 'en',
        displayName: 'English',
        nativeName: 'English',
        isRTL: false,
      );

      expect(language.languageCode, equals('en'));
      expect(language.displayName, equals('English'));
      expect(language.isRTL, isFalse);
    });

    test('returns correct locale', () {
      const language = AppLanguage(
        languageCode: 'ar',
        displayName: 'Arabic',
        nativeName: 'العربية',
        isRTL: true,
      );

      expect(language.locale, equals(const Locale('ar')));
      expect(language.isRTL, isTrue);
    });

    test('matches locale correctly', () {
      const language = AppLanguage(
        languageCode: 'en',
        displayName: 'English',
        nativeName: 'English',
        isRTL: false,
      );

      expect(language.matchesLocale(const Locale('en')), isTrue);
      expect(language.matchesLocale(const Locale('fr')), isFalse);
    });

    test('equality works correctly', () {
      const language1 = AppLanguage(
        languageCode: 'en',
        displayName: 'English',
        nativeName: 'English',
        isRTL: false,
      );

      const language2 = AppLanguage(
        languageCode: 'en',
        displayName: 'English',
        nativeName: 'English',
        isRTL: false,
      );

      expect(language1, equals(language2));
    });
  });
}
