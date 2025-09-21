import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_sdui_app/core/shared/services/preferences_service.dart';
import '../../../mocks/mock_shared_preferences.dart';

void main() {
  group('PreferencesService', () {
    late PreferencesService preferencesService;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      preferencesService = PreferencesService(mockSharedPreferences);
    });

    test('saves and retrieves locale correctly', () async {
      when(
        () => mockSharedPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);
      when(
        () => mockSharedPreferences.getString('app_locale'),
      ).thenReturn('ar');

      await preferencesService.saveLocale(const Locale('ar'));
      final result = preferencesService.getLocale();

      expect(result, equals(const Locale('ar')));
      verify(
        () => mockSharedPreferences.setString('app_locale', 'ar'),
      ).called(1);
    });

    test('returns null when no locale is saved', () {
      when(
        () => mockSharedPreferences.getString('app_locale'),
      ).thenReturn(null);

      final result = preferencesService.getLocale();
      expect(result, isNull);
    });

    test('saves and retrieves theme mode correctly', () async {
      when(
        () => mockSharedPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);
      when(
        () => mockSharedPreferences.getString('app_theme'),
      ).thenReturn('dark');

      await preferencesService.saveThemeMode('dark');
      final result = preferencesService.getThemeMode();

      expect(result, equals('dark'));
      verify(
        () => mockSharedPreferences.setString('app_theme', 'dark'),
      ).called(1);
    });
  });
}
