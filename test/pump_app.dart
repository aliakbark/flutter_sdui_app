import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sdui_app/core/shared/services/language_service.dart';
import 'package:flutter_sdui_app/core/shared/states/app/app_cubit.dart';
import 'package:flutter_sdui_app/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

extension PumpApp on WidgetTester {
  /// Pumps a widget wrapped with necessary testing infrastructure.
  ///
  /// Parameters:
  /// - [widget]: The widget to be tested
  /// - [locale]: Optional locale for testing specific languages
  /// - [theme]: Optional theme data
  /// - [useScaffold]: Whether to wrap the widget with a Scaffold (default:true)
  /// - [appCubit]: Optional AppCubit for state management testing
  /// - [additionalProviders]: Additional BlocProviders for testing
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    ThemeData? theme,
    bool useScaffold = true,
    AppCubit? appCubit,
    List<BlocProvider>? additionalProviders,
  }) async {
    // Setup providers
    final providers = <BlocProvider>[
      if (appCubit != null) BlocProvider<AppCubit>.value(value: appCubit),
      ...?additionalProviders,
    ];

    // Wrap the widget with necessary providers and MaterialApp
    Widget wrappedWidget = providers.isNotEmpty
        ? MultiBlocProvider(
            providers: providers,
            child: _buildMaterialApp(widget, locale, theme, useScaffold),
          )
        : _buildMaterialApp(widget, locale, theme, useScaffold);

    // Pump the widget into the widget tree
    await pumpWidget(wrappedWidget);

    // Allow any pending animations or frames to complete
    await pumpAndSettle();
  }

  /// Builds MaterialApp with proper localization setup
  Widget _buildMaterialApp(
    Widget widget,
    Locale? locale,
    ThemeData? theme,
    bool useScaffold,
  ) {
    return MaterialApp(
      locale: locale ?? const Locale('en'),
      theme: theme ?? ThemeData.light(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LanguageService.supportedLocales,
      home: useScaffold ? Scaffold(body: widget) : widget,
    );
  }

  /// Pumps a widget with minimal setup (no localization)
  Future<void> pumpSimpleApp(
    Widget widget, {
    Locale? locale,
    ThemeData? theme,
  }) async {
    await pumpWidget(
      MaterialApp(
        locale: locale,
        theme: theme ?? ThemeData.light(),
        home: Scaffold(body: widget),
      ),
    );
    await pumpAndSettle();
  }
}

/// Helper for setting up and tearing down GetIt in tests
class TestServiceLocator {
  static final GetIt _getIt = GetIt.instance;

  /// Setup test dependencies
  static void setup() {
    if (_getIt.isRegistered<GlobalKey<NavigatorState>>()) return;
    
    _getIt.registerSingleton<GlobalKey<NavigatorState>>(
      GlobalKey<NavigatorState>(),
    );
  }

  /// Reset all dependencies
  static Future<void> reset() async {
    await _getIt.reset();
  }
}
