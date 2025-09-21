import 'dart:async';
import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdui_app/core/shared/services/language_service.dart';
import 'package:flutter_sdui_app/core/shared/services/network_info.dart';
import 'package:flutter_sdui_app/core/shared/services/preferences_service.dart';

part 'app_state.dart';

/// Cubit for managing global app state
class AppCubit extends Cubit<AppState> {
  final NetworkInfo _networkInfo;
  final PreferencesService _preferencesService;
  StreamSubscription<bool>? _connectivitySubscription;

  AppCubit(this._networkInfo, this._preferencesService)
    : super(AppState.initial());

  /// Initialize the app cubit
  Future<void> initialize() async {
    try {
      // Load saved preferences with fallback to device locale
      final savedLocale = _preferencesService.getLocale();
      final initialLocale = savedLocale ?? LanguageService.getDeviceLocale();

      // Ensure the locale is supported
      if (LanguageService.isLocaleSupported(initialLocale)) {
        emit(state.copyWith(locale: initialLocale));
      } else {
        // Fallback to default language
        emit(state.copyWith(locale: LanguageService.defaultLanguage.locale));
      }

      // Check initial connectivity
      final isConnected = await _networkInfo.isConnected;
      emit(state.copyWith(isNetworkConnected: isConnected));

      // Start listening to network changes
      _connectivitySubscription = _networkInfo.connectivityStream.listen(
        (isConnected) {
          emit(state.copyWith(isNetworkConnected: isConnected));
        },
        onError: (error) {
          // Handle connectivity stream errors gracefully
          emit(state.copyWith(isNetworkConnected: false));
        },
      );
    } catch (e) {
      // Handle initialization errors gracefully
      emit(state.copyWith(isNetworkConnected: false));
    }
  }

  /// Change the app locale
  Future<void> changeLocale(Locale locale) async {
    try {
      emit(state.copyWith(locale: locale));
      await _preferencesService.saveLocale(locale);
    } catch (e) {
      // Handle save error - revert to previous state if needed
      // For now, we'll keep the UI updated even if save fails
    }
  }

  /// Change the app theme mode (for future use)
  Future<void> changeThemeMode(ThemeMode themeMode) async {
    try {
      emit(state.copyWith(themeMode: themeMode));
      await _preferencesService.saveThemeMode(themeMode.name);
    } catch (e) {
      // Handle save error gracefully
    }
  }

  /// Manually update network status (for testing or manual refresh)
  Future<void> refreshNetworkStatus() async {
    try {
      final isConnected = await _networkInfo.isConnected;
      emit(state.copyWith(isNetworkConnected: isConnected));
    } catch (e) {
      emit(state.copyWith(isNetworkConnected: false));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
