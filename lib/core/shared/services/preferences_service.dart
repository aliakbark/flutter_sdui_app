import 'dart:ui';
import 'package:flutter_sdui_app/core/shared/services/language_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app preferences
class PreferencesService {
  final SharedPreferences _prefs;
  
  static const String _localeKey = 'app_locale';
  static const String _themeKey = 'app_theme';

  PreferencesService(this._prefs);

  /// Save the selected locale using language identifier
  Future<void> saveLocale(Locale locale) async {
    final language = LanguageService.getLanguageByLocale(locale);
    if (language != null) {
      await _prefs.setString(_localeKey, language.identifier);
    }
  }

  /// Get the saved locale with validation
  Locale? getLocale() {
    final identifier = _prefs.getString(_localeKey);
    if (identifier != null) {
      final language = LanguageService.getLanguageByIdentifier(identifier);
      return language?.locale;
    }
    return null;
  }

  /// Save the selected theme mode
  Future<void> saveThemeMode(String themeMode) async {
    await _prefs.setString(_themeKey, themeMode);
  }

  /// Get the saved theme mode
  String? getThemeMode() {
    return _prefs.getString(_themeKey);
  }

  /// Clear all preferences
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
