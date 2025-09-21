import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sdui_app/core/di/injector.dart';
import 'package:flutter_sdui_app/core/shared/presentation/widgets/network_banner_wrapper.dart';
import 'package:flutter_sdui_app/core/shared/services/language_service.dart';
import 'package:flutter_sdui_app/core/shared/states/app/app_cubit.dart';
import 'package:flutter_sdui_app/features/auth/presentation/states/authentication_cubit.dart';
import 'package:flutter_sdui_app/features/auth/presentation/widget/auth_wrapper.dart';
import 'package:flutter_sdui_app/l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>.value(value: sl<AppCubit>()),
        BlocProvider<AuthenticationCubit>(
          create: (context) => sl<AuthenticationCubit>()..checkAuthStatus(),
        ),
      ],
      child: BlocBuilder<AppCubit, AppState>(
        builder: (BuildContext context, AppState appState) {
          return MaterialApp(
            title: 'Flutter SDUI Demo App',
            debugShowCheckedModeBanner: false,
            navigatorKey: sl<GlobalKey<NavigatorState>>(),

            // Localization configuration
            locale: appState.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageService.supportedLocales,
            localeResolutionCallback: LanguageService.resolveLocale,

            // Theme configuration
            themeMode: appState.themeMode,
            theme: ThemeData(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),

            // Wrap with network banner
            home: const NetworkBannerWrapper(child: AuthWrapper()),
          );
        },
      ),
    );
  }
}
