import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdui_app/features/auth/presentation/states/authentication_cubit.dart';
import 'package:flutter_sdui_app/core/di/injector.dart';
import 'package:flutter_sdui_app/features/auth/presentation/widget/auth_wrapper.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationCubit>(
      create: (context) => sl<AuthenticationCubit>()..checkAuthStatus(),
      child: MaterialApp(
        title: 'Flutter SDUI Demo App',
        debugShowCheckedModeBanner: false,
        navigatorKey: sl<GlobalKey<NavigatorState>>(),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
