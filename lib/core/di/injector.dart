import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sdui_app/core/network/api_client.dart';
import 'package:flutter_sdui_app/core/shared/services/network_info.dart';
import 'package:flutter_sdui_app/core/shared/services/preferences_service.dart';
import 'package:flutter_sdui_app/core/shared/states/app/app_cubit.dart';
import 'package:flutter_sdui_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_sdui_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_sdui_app/features/auth/presentation/states/authentication_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global service locator
final sl = GetIt.instance;

/// Initialize dependencies
Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Global navigator key
  sl.registerSingleton<GlobalKey<NavigatorState>>(GlobalKey<NavigatorState>());

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(Connectivity()));
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Shared services
  sl.registerLazySingleton<PreferencesService>(() => PreferencesService(sl()));

  // App-level state management
  sl.registerSingleton<AppCubit>(AppCubit(sl(), sl()));

  // Authentication
  sl.registerSingleton<AuthenticationCubit>(
    AuthenticationCubit(AuthRepositoryImpl(AuthLocalDataSource(sl()))),
  );
}
