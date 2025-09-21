import 'dart:ui';

/// Model representing a supported language in the app
class AppLanguage {
  final String languageCode;      // 'en', 'ar', 'zh'
  final String? countryCode;      // 'US', 'SA', 'CN', 'TW'
  final String? scriptCode;       // 'Hans', 'Hant' for Chinese variants
  final String displayName;       // 'English (US)', 'العربية', '中文 (简体)'
  final String nativeName;        // Native language name
  final bool isRTL;
  final String? icon;             // Language icon (not country flag)
  
  const AppLanguage({
    required this.languageCode,
    this.countryCode,
    this.scriptCode,
    required this.displayName,
    required this.nativeName,
    required this.isRTL,
    this.icon,
  });

  /// Generate Flutter Locale from language configuration
  Locale get locale {
    if (scriptCode != null && countryCode != null) {
      return Locale.fromSubtags(
        languageCode: languageCode,
        scriptCode: scriptCode,
        countryCode: countryCode,
      );
    } else if (countryCode != null) {
      return Locale(languageCode, countryCode);
    }
    return Locale(languageCode);
  }

  /// Unique identifier for the language variant
  String get identifier {
    final parts = [languageCode];
    if (scriptCode != null) parts.add(scriptCode!);
    if (countryCode != null) parts.add(countryCode!);
    return parts.join('_');
  }

  /// Check if this language matches a given locale
  bool matchesLocale(Locale locale) {
    return this.locale.languageCode == locale.languageCode &&
           (this.locale.countryCode == locale.countryCode || 
            this.locale.countryCode == null) &&
           (this.locale.scriptCode == locale.scriptCode || 
            this.locale.scriptCode == null);
  }

  @override
  String toString() => identifier;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppLanguage && other.identifier == identifier;
  }

  @override
  int get hashCode => identifier.hashCode;
}
