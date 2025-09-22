import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdui_app/core/di/injector.dart';
import 'package:flutter_sdui_app/features/auth/presentation/states/authentication_cubit.dart';
import 'package:flutter_sdui_app/core/shared/presentation/pages/splash_screen.dart';
import 'package:flutter_sdui_app/features/home/presentation/pages/home_page.dart';
import 'package:flutter_sdui_app/features/onboarding/presentation/pages/get_started_page.dart';

import 'dart:developer' as dev;

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (BuildContext context, AuthenticationState state) {
          if (state is Authenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).popUntil((route) => route.isFirst);
              final NavigatorState? navigatorState =
                  sl<GlobalKey<NavigatorState>>().currentState;
              if (navigatorState != null) {
                navigatorState.popUntil((route) => route.isFirst);
              }
            });
          } else if (state is Unauthenticated) {
            _showAuthError(context, state);
          }
        },
        builder: (BuildContext context, AuthenticationState state) {
          if (state is AuthenticationLoading) {
            return const SplashScreen();
          } else if (state is Authenticated) {
            return const HomePage();
          } else {
            // Unauthenticated or any other state
            return const GetStartedPage();
          }
        },
      );

  void _showAuthError(BuildContext context, Unauthenticated state) {
    if (state.message?.trim().isEmpty ?? true) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if the widget is still mounted and context is valid
      if (!context.mounted) {
        dev.log(
          'Skipping error snackbar - widget no longer mounted',
          name: 'AuthWrapper',
        );
        return;
      }

      try {
        // Additional check to ensure we have a valid Scaffold ancestor
        final ScaffoldMessengerState? scaffoldMessenger =
            ScaffoldMessenger.maybeOf(context);
        if (scaffoldMessenger == null) {
          dev.log(
            'No ScaffoldMessenger found in widget tree',
            name: 'AuthWrapper',
          );
          return;
        }

        scaffoldMessenger.clearSnackBars();

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              state.message!,
              style: TextStyle(color: Theme.of(context).colorScheme.onError),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Theme.of(context).colorScheme.onError,
              onPressed: () {
                if (context.mounted) {
                  ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
                }
              },
            ),
          ),
        );
      } catch (e) {
        dev.log(
          'Error showing auth error snackbar: $e',
          name: 'AuthWrapper',
          error: e,
        );
      }
    });
  }
}
