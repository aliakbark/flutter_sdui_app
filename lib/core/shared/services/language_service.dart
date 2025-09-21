import 'dart:ui';
import 'package:flutter_sdui_app/core/shared/data/models/app_language.dart';

/// Service for managing app language configurations and operations
class LanguageService {
  /// List of all supported languages in the app
  static const List<AppLanguage> supportedLanguages = [
    // English (default)
    AppLanguage(
      languageCode: 'en',
      displayName: 'English',
      nativeName: 'English',
      isRTL: false,
    ),

    // Arabic (generic - covers all Arabic-speaking regions)
    AppLanguage(
      languageCode: 'ar',
      displayName: 'Arabic',
      nativeName: 'العربية',
      isRTL: true,
    ),

    // Example for Chinese with variants:
    // AppLanguage(
    //   languageCode: 'zh',
    //   scriptCode: 'Hans',
    //   countryCode: 'CN',
    //   displayName: 'Chinese (Simplified)',
    //   nativeName: '中文 (简体)',
    //   isRTL: false,
    // ),
    // AppLanguage(
    //   languageCode: 'zh',
    //   scriptCode: 'Hant',
    //   countryCode: 'TW',
    //   displayName: 'Chinese (Traditional)',
    //   nativeName: '中文 (繁體)',
    //   isRTL: false,
    // ),
  ];

  /// Get all supported Flutter Locales
  static List<Locale> get supportedLocales =>
      supportedLanguages.map((lang) => lang.locale).toList();

  /// Get the default language (first in the list)
  static AppLanguage get defaultLanguage => supportedLanguages.first;

  /// Find language by locale with fallback logic
  static AppLanguage? getLanguageByLocale(Locale locale) {
    // Try exact match first
    AppLanguage? exactMatch;
    try {
      exactMatch = supportedLanguages.firstWhere(
        (lang) => lang.matchesLocale(locale),
      );
    } catch (e) {
      exactMatch = null;
    }

    if (exactMatch != null) return exactMatch;

    // Try language code match as fallback
    try {
      return supportedLanguages.firstWhere(
        (lang) => lang.languageCode == locale.languageCode,
      );
    } catch (e) {
      return null;
    }
  }

  /// Find language by identifier string
  static AppLanguage? getLanguageByIdentifier(String identifier) {
    try {
      return supportedLanguages.firstWhere(
        (lang) => lang.identifier == identifier,
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if a locale is supported
  static bool isLocaleSupported(Locale locale) {
    return getLanguageByLocale(locale) != null;
  }

  /// Check if a language code is supported
  static bool isLanguageCodeSupported(String languageCode) {
    return supportedLanguages.any((lang) => lang.languageCode == languageCode);
  }

  /// Get device locale with intelligent fallback
  static Locale getDeviceLocale() {
    final deviceLocale = PlatformDispatcher.instance.locale;

    // Try to find a supported language that matches the device locale
    final matchedLanguage = getLanguageByLocale(deviceLocale);

    if (matchedLanguage != null) {
      return matchedLanguage.locale;
    }

    // Fallback to default language
    return defaultLanguage.locale;
  }

  /// Custom locale resolution for MaterialApp
  static Locale? resolveLocale(
    Locale? locale,
    Iterable<Locale> supportedLocales,
  ) {
    if (locale != null) {
      final matchedLanguage = getLanguageByLocale(locale);
      if (matchedLanguage != null) {
        return matchedLanguage.locale;
      }
    }

    // Fallback to device locale or default
    return getDeviceLocale();
  }

  /// Get language display information for UI
  static String getLanguageDisplayName(Locale locale) {
    final language = getLanguageByLocale(locale);
    return language?.displayName ?? locale.languageCode.toUpperCase();
  }

  /// Get language native name for UI
  static String getLanguageNativeName(Locale locale) {
    final language = getLanguageByLocale(locale);
    return language?.nativeName ?? locale.languageCode.toUpperCase();
  }

  /// Check if a locale uses RTL layout
  static bool isRTL(Locale locale) {
    final language = getLanguageByLocale(locale);
    return language?.isRTL ?? false;
  }

  /// Get language icon
  static String? getLanguageIcon(Locale locale) {
    final language = getLanguageByLocale(locale);
    return language?.icon;
  }

  /// Validate and sanitize a locale string
  static Locale? parseLocaleString(String localeString) {
    try {
      final parts = localeString.split('_');
      if (parts.isEmpty) return null;

      final languageCode = parts[0];
      final countryCode = parts.length > 1 ? parts[1] : null;
      final scriptCode = parts.length > 2 ? parts[2] : null;

      Locale locale;
      if (scriptCode != null && countryCode != null) {
        locale = Locale.fromSubtags(
          languageCode: languageCode,
          scriptCode: scriptCode,
          countryCode: countryCode,
        );
      } else if (countryCode != null) {
        locale = Locale(languageCode, countryCode);
      } else {
        locale = Locale(languageCode);
      }

      return isLocaleSupported(locale) ? locale : null;
    } catch (e) {
      return null;
    }
  }
}
