import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_sdui_app/core/shared/services/language_service.dart';
import 'package:flutter_sdui_app/core/shared/states/app/app_cubit.dart';
import '../../../../mocks/mock_network_info.dart';
import '../../../../mocks/mock_preferences_service.dart';

void main() {
  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(const Locale('en'));
  });

  group('AppCubit', () {
    late AppCubit appCubit;
    late MockNetworkInfo mockNetworkInfo;
    late MockPreferencesService mockPreferencesService;
    late StreamController<bool> connectivityController;

    setUp(() {
      mockNetworkInfo = MockNetworkInfo();
      mockPreferencesService = MockPreferencesService();
      connectivityController = StreamController<bool>.broadcast();

      when(
        () => mockNetworkInfo.connectivityStream,
      ).thenAnswer((_) => connectivityController.stream);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockPreferencesService.getLocale()).thenReturn(null);

      appCubit = AppCubit(mockNetworkInfo, mockPreferencesService);
    });

    tearDown(() {
      connectivityController.close();
      appCubit.close();
    });

    test('initial state is correct', () {
      expect(appCubit.state, equals(AppState.initial()));
    });

    blocTest<AppCubit, AppState>(
      'initialize sets default locale and network status',
      build: () => appCubit,
      act: (cubit) => cubit.initialize(),
      expect: () => [
        AppState.initial().copyWith(
          locale: LanguageService.defaultLanguage.locale,
          isNetworkConnected: true,
        ),
      ],
    );

    blocTest<AppCubit, AppState>(
      'changeLocale updates locale',
      build: () {
        when(
          () => mockPreferencesService.saveLocale(any()),
        ).thenAnswer((_) async {});
        return appCubit;
      },
      act: (cubit) => cubit.changeLocale(const Locale('ar')),
      expect: () => [AppState.initial().copyWith(locale: const Locale('ar'))],
    );

    blocTest<AppCubit, AppState>(
      'connectivity stream updates network status',
      build: () => appCubit,
      act: (cubit) async {
        await cubit.initialize();
        connectivityController.add(false);
      },
      expect: () => [
        AppState.initial().copyWith(
          locale: LanguageService.defaultLanguage.locale,
          isNetworkConnected: true,
        ),
        AppState.initial().copyWith(
          locale: LanguageService.defaultLanguage.locale,
          isNetworkConnected: false,
        ),
      ],
    );
  });
}
