import 'package:flutter/material.dart';
import 'package:flutter_sdui_app/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Localization Tests', () {
    testWidgets('English localizations loads correctly', (tester) async {
      const locale = Locale('en');
      final localizations = await AppLocalizations.delegate.load(locale);

      expect(localizations.welcomeMessage, isNotEmpty);
      expect(localizations.appTitle, equals('Flutter SDUI Demo App'));
    });

    testWidgets('Arabic localizations loads correctly', (tester) async {
      const locale = Locale('ar');
      final localizations = await AppLocalizations.delegate.load(locale);

      expect(localizations.welcomeMessage, isNotEmpty);
      expect(localizations.welcomeMessage, contains('مرحباً'));
      expect(localizations.appTitle, equals('تطبيق Flutter SDUI التجريبي'));
    });

    testWidgets('English US localizations loads correctly', (tester) async {
      const locale = Locale('en', 'US');
      final localizations = await AppLocalizations.delegate.load(locale);

      expect(localizations.welcomeMessage, isNotEmpty);
      expect(localizations.appTitle, equals('Flutter SDUI Demo App'));
    });

    testWidgets('Arabic SA localizations loads correctly', (tester) async {
      const locale = Locale('ar', 'SA');
      final localizations = await AppLocalizations.delegate.load(locale);

      expect(localizations.welcomeMessage, isNotEmpty);
      expect(localizations.welcomeMessage, contains('مرحباً'));
      expect(localizations.appTitle, equals('تطبيق Flutter SDUI التجريبي'));
    });

    testWidgets('Error message with placeholder works correctly', (
      tester,
    ) async {
      const locale = Locale('en');
      final localizations = await AppLocalizations.delegate.load(locale);

      const testError = 'Network connection failed';
      final errorMessage = localizations.errorMessage(testError);

      expect(errorMessage, equals('Error: $testError'));
      expect(errorMessage, contains(testError));
    });

    testWidgets('Arabic error message with placeholder works correctly', (
      tester,
    ) async {
      const locale = Locale('ar');
      final localizations = await AppLocalizations.delegate.load(locale);

      const testError = 'فشل في الاتصال بالشبكة';
      final errorMessage = localizations.errorMessage(testError);

      expect(errorMessage, equals('خطأ: $testError'));
      expect(errorMessage, contains(testError));
    });

    test('AppLocalizations delegate supports correct locales', () {
      const delegate = AppLocalizations.delegate;

      // Test supported locales
      expect(delegate.isSupported(const Locale('en')), isTrue);
      expect(delegate.isSupported(const Locale('ar')), isTrue);
      expect(delegate.isSupported(const Locale('en', 'US')), isTrue);
      expect(delegate.isSupported(const Locale('ar', 'SA')), isTrue);

      // Test unsupported locales
      expect(delegate.isSupported(const Locale('fr')), isFalse);
      expect(delegate.isSupported(const Locale('es')), isFalse);
      expect(delegate.isSupported(const Locale('de')), isFalse);
    });
  });
}
