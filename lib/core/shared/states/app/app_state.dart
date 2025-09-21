part of 'app_cubit.dart';

/// Global app state
class AppState extends Equatable {
  final Locale locale;
  final ThemeMode themeMode;
  final bool isNetworkConnected;

  const AppState({
    required this.locale,
    required this.themeMode,
    required this.isNetworkConnected,
  });

  /// Initial state with default values
  factory AppState.initial() => const AppState(
    locale: Locale('en'),
    themeMode: ThemeMode.system,
    isNetworkConnected: true,
  );

  /// Create a copy with updated values
  AppState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    bool? isNetworkConnected,
  }) {
    return AppState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      isNetworkConnected: isNetworkConnected ?? this.isNetworkConnected,
    );
  }

  @override
  List<Object> get props => [locale, themeMode, isNetworkConnected];

  @override
  String toString() {
    return 'AppState(locale: $locale, themeMode: $themeMode, isNetworkConnected: $isNetworkConnected)';
  }
}
