# Flutter SDUI App - Localization Guide

## Table of Contents

1. [Quick Start](#quick-start)
2. [Overview](#overview)
3. [File Structure](#file-structure)
4. [Development Workflow](#development-workflow)
5. [ARB File Structure](#arb-file-structure)
6. [Translation Platform Integration](#translation-platform-integration)
7. [Locale Hierarchy](#locale-hierarchy)
8. [Code Generation](#code-generation)
9. [Testing Localization](#testing-localization)
10. [Automation Scripts](#automation-scripts)
11. [Best Practices](#best-practices)
12. [Troubleshooting](#troubleshooting)
13. [Advanced Topics](#advanced-topics)
14. [Resources](#resources)

## Quick Start

### For New Developers

1. **Generate localizations**:
   ```bash
   cd flutter_sdui_app
   flutter gen-l10n
   ```

2. **Use in your code**:
   ```dart
   import 'package:flutter_gen/gen_l10n/app_localizations.dart';
   
   // In your widget
   Text(AppLocalizations.of(context)!.welcomeMessage)
   ```

3. **Add new translation key**:
   - Add to `lib/l10n/intl_en.arb`
   - Run `flutter gen-l10n`
   - Use `AppLocalizations.of(context)!.yourNewKey`

### For Translators

1. **Edit ARB files** in `lib/l10n/`
2. **Follow the metadata** (descriptions, character limits)
3. **Test your changes** by running the app
4. **Validate syntax** with provided scripts

## Overview

This Flutter SDUI Demo App uses a scalable localization system designed for:

- **Easy integration** with third-party translation platforms
- **Regional variant support** (e.g., US English vs UK English)
- **Hierarchical fallback** system
- **Developer-friendly** workflow with automation
- **Translator-friendly** metadata and context

### Current Language Support

- **English** (`en`) - Base language
- **US English** (`en_US`) - Regional variant
- **Arabic** (`ar`) - RTL support
- **Saudi Arabic** (`ar_SA`) - Regional variant

## File Structure

```
lib/l10n/
├── intl_en.arb           # Base English translations (template)
├── intl_en_US.arb        # US English regional overrides
├── intl_ar.arb           # Base Arabic translations
├── intl_ar_SA.arb        # Saudi Arabic regional overrides
└── l10n.yaml             # Configuration file

scripts/l10n/
├── generate_localizations.sh    # Automation script
└── validate_translations.sh     # Validation script (if exists)

Generated files (do not edit):
├── .dart_tool/flutter_gen/gen_l10n/
│   ├── app_localizations.dart
│   ├── app_localizations_en.dart
│   ├── app_localizations_ar.dart
│   └── ...
```

## Development Workflow

### Adding New Translation Keys

1. **Add to template file** (`lib/l10n/intl_en.arb`):
   ```json
   {
     "newFeatureTitle": "New Feature",
     "@newFeatureTitle": {
       "description": "Title for the new feature section",
       "context": "Displayed in the main navigation menu",
       "maxLength": 20
     }
   }
   ```

2. **Generate code**:
   ```bash
   flutter gen-l10n
   ```

3. **Use in code**:
   ```dart
   Text(AppLocalizations.of(context)!.newFeatureTitle)
   ```

4. **Add translations** to other language files

### Adding New Languages

1. **Create ARB file**: `lib/l10n/intl_<locale>.arb`
   ```json
   {
     "@@locale": "fr",
     "@@context": "Flutter SDUI Demo App - French translations",
     "welcomeMessage": "Bienvenue dans l'application SDUI",
     "@welcomeMessage": {
       "description": "Welcome message shown on the home screen"
     }
   }
   ```

2. **Update LanguageService** (`lib/core/services/language_service.dart`):
   ```dart
   static const List<LanguageModel> supportedLanguages = [
     LanguageModel(code: 'en', name: 'English', nativeName: 'English'),
     LanguageModel(code: 'ar', name: 'Arabic', nativeName: 'العربية'),
     LanguageModel(code: 'fr', name: 'French', nativeName: 'Français'), // Add this
   ];
   ```

3. **Test the new locale**:
   ```bash
   flutter gen-l10n
   flutter run
   ```

### Updating Existing Translations

1. **Edit ARB files** directly
2. **Regenerate** localizations: `flutter gen-l10n`
3. **Test changes** in the app
4. **Validate** with scripts (if available)

## ARB File Structure

### Enhanced Metadata Format

```json
{
  "@@locale": "en_US",
  "@@context": "Flutter SDUI Demo App - US English translations",
  
  "keyName": "Translation text with {placeholder}",
  "@keyName": {
    "description": "Detailed description for translators explaining the context and usage",
    "context": "Specific UI location where this text appears (e.g., 'Login screen title')",
    "maxLength": 30,
    "placeholders": {
      "placeholder": {
        "type": "String",
        "example": "John Doe",
        "description": "User's display name"
      }
    }
  }
}
```

### Metadata Fields Explained

| Field | Purpose | Example |
|-------|---------|---------|
| `@@locale` | BCP 47 locale identifier | `"en_US"`, `"ar_SA"` |
| `@@context` | File-level context | `"Mobile app - Settings screen"` |
| `description` | Translator guidance | `"Button text for saving user preferences"` |
| `context` | UI location | `"Settings screen, save button"` |
| `maxLength` | Character limit | `25` (prevents UI overflow) |
| `placeholders` | Dynamic parameters | User names, dates, counts |

### Placeholder Types

```json
{
  "welcomeUser": "Welcome back, {userName}!",
  "@welcomeUser": {
    "placeholders": {
      "userName": {
        "type": "String",
        "example": "Alice",
        "description": "The user's display name"
      }
    }
  },
  
  "itemCount": "You have {count} {count, plural, =0{items} =1{item} other{items}}",
  "@itemCount": {
    "placeholders": {
      "count": {
        "type": "int",
        "example": "5",
        "description": "Number of items in the list"
      }
    }
  }
}
```

## Translation Platform Integration

> **⚠️ Important**: The examples below are for reference purposes. Translation platform APIs and configurations change frequently. Always refer to the **official documentation** of each platform for the most up-to-date integration steps, API endpoints, and configuration options.

### Crowdin Integration

> 📚 **Official Documentation**: [Crowdin Flutter Integration Guide](https://support.crowdin.com/flutter-localization/)

1. **Setup** (`crowdin.yml`):
   ```yaml
   project_id: "your-project-id"
   api_token: "your-api-token"
   
   files:
     - source: /lib/l10n/intl_en.arb
       translation: /lib/l10n/intl_%two_letters_code%.arb
       update_option: update_as_unapproved
       preserve_hierarchy: true
   ```

2. **Upload source**:
   ```bash
   crowdin upload sources
   ```

3. **Download translations**:
   ```bash
   crowdin download
   flutter gen-l10n
   ```

### Lokalise Integration

> 📚 **Official Documentation**: [Lokalise Flutter Guide](https://docs.lokalise.com/en/articles/3088751-flutter-localization)

1. **Upload source file**:
   ```bash
   lokalise2 file upload \
     --project-id YOUR_PROJECT_ID \
     --file lib/l10n/intl_en.arb \
     --lang-iso en \
     --replace-modified
   ```

2. **Download translations**:
   ```bash
   lokalise2 file download \
     --project-id YOUR_PROJECT_ID \
     --format arb \
     --original-filenames=false \
     --directory-prefix lib/l10n/ \
     --placeholder-format=icu
   ```

### Phrase Integration

> 📚 **Official Documentation**: [Phrase Flutter Documentation](https://phrase.com/blog/posts/flutter-localization/)

1. **Configuration** (`.phrase.yml`):
   ```yaml
   phrase:
     access_token: YOUR_ACCESS_TOKEN
     project_id: YOUR_PROJECT_ID
     file_format: arb
     
   push:
     sources:
       - file: lib/l10n/intl_en.arb
         params:
           locale_id: en
           
   pull:
     targets:
       - file: lib/l10n/intl_<locale_code>.arb
         params:
           file_format: arb
   ```

2. **Sync commands**:
   ```bash
   phrase push
   phrase pull
   ```

## Locale Hierarchy

### Fallback Chain

The system uses a hierarchical fallback approach:

1. **Exact match**: `en_US` → `intl_en_US.arb`
2. **Language fallback**: `en_US` → `intl_en.arb` (if US variant missing)
3. **Default fallback**: Any unsupported locale → `intl_en.arb`

### Regional Variants Best Practices

Regional variants should only include keys that differ from the base language:

```json
// intl_en.arb (base English)
{
  "colorPreference": "Colour preference",
  "elevatorFloor": "Lift to floor {floor}",
  "dateFormat": "DD/MM/YYYY"
}

// intl_en_US.arb (US English overrides)
{
  "colorPreference": "Color preference",
  "elevatorFloor": "Elevator to floor {floor}",
  "dateFormat": "MM/DD/YYYY"
}
```

## Code Generation

### Configuration (`l10n.yaml`)

```yaml
arb-dir: lib/l10n
template-arb-file: intl_en.arb
output-localization-file: app_localizations.dart
nullable-getter: false
synthetic-package: false
preferred-supported-locales: ["en"]
header-file: lib/l10n/header.txt
header: |
  /// Generated localization file. Do not edit manually.
  /// 
  /// To add new translations:
  /// 1. Add keys to intl_en.arb
  /// 2. Run: flutter gen-l10n
  /// 3. Use: AppLocalizations.of(context)!.keyName
```

### Generated Files Structure

```dart
// app_localizations.dart - Base abstract class
abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) { ... }
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [ ... ];
  static const List<Locale> supportedLocales = [ ... ];
  
  String get welcomeMessage;
  String get appTitle;
  // ... other getters
}

// app_localizations_en.dart - English implementation
class AppLocalizationsEn extends AppLocalizations {
  @override
  String get welcomeMessage => 'Welcome to SDUI Demo';
  
  @override
  String get appTitle => 'SDUI Demo App';
}
```

### Usage in Code

```dart
// Basic usage
Text(AppLocalizations.of(context)!.welcomeMessage)

// With parameters
Text(AppLocalizations.of(context)!.welcomeUser('John'))

// Null-safe access
final l10n = AppLocalizations.of(context)!;
Text(l10n.welcomeMessage)

// In stateless widgets
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(l10n.appTitle);
  }
}
```

## Testing Localization

### Manual Testing

1. **Change device language**:
   - iOS Simulator: Settings → General → Language & Region
   - Android Emulator: Settings → System → Languages & input

2. **Test in app**:
   ```dart
   // Force specific locale for testing
   MaterialApp(
     locale: Locale('ar', 'SA'), // Test Saudi Arabic
     localizationsDelegates: AppLocalizations.localizationsDelegates,
     supportedLocales: AppLocalizations.supportedLocales,
     home: MyHomePage(),
   )
   ```

### Automated Testing

```dart
// test/localization_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  group('Localization Tests', () {
    testWidgets('English localization loads correctly', (tester) async {
      const locale = Locale('en');
      final localizations = await AppLocalizations.delegate.load(locale);
      
      expect(localizations.welcomeMessage, isNotEmpty);
      expect(localizations.appTitle, equals('SDUI Demo App'));
    });
    
    testWidgets('Arabic localization loads correctly', (tester) async {
      const locale = Locale('ar');
      final localizations = await AppLocalizations.delegate.load(locale);
      
      expect(localizations.welcomeMessage, isNotEmpty);
      expect(localizations.welcomeMessage, contains('مرحبا'));
    });
  });
}
```

### RTL Testing

```dart
// Test RTL layout
testWidgets('Arabic text displays RTL correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Text(AppLocalizations.of(context)!.welcomeMessage),
      ),
    ),
  );
  
  final textWidget = tester.widget<Text>(find.byType(Text));
  expect(textWidget.textDirection, TextDirection.rtl);
});
```

## Automation Scripts

### Generation Script

Create `scripts/l10n/generate_localizations.sh`:

```bash
#!/bin/bash

echo "🌍 Generating Flutter Localizations..."

# Navigate to project root
cd "$(dirname "$0")/../.."

# Clean previous generations
echo "🧹 Cleaning previous generations..."
rm -rf .dart_tool/flutter_gen/gen_l10n/

# Generate localizations
echo "⚡ Running flutter gen-l10n..."
flutter gen-l10n

if [ $? -eq 0 ]; then
    echo "✅ Localizations generated successfully!"
    echo "📁 Generated files are in .dart_tool/flutter_gen/gen_l10n/"
else
    echo "❌ Failed to generate localizations"
    exit 1
fi

# Optional: Run tests
echo "🧪 Running localization tests..."
flutter test test/localization_test.dart

echo "🎉 Localization generation complete!"
```

### Validation Script

Create `scripts/l10n/validate_translations.sh`:

```bash
#!/bin/bash

echo "🔍 Validating Translation Files..."

ARB_DIR="lib/l10n"
TEMPLATE_FILE="$ARB_DIR/intl_en.arb"

# Check if template exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "❌ Template file not found: $TEMPLATE_FILE"
    exit 1
fi

# Extract keys from template
TEMPLATE_KEYS=$(grep -o '"[^"@]*"[[:space:]]*:' "$TEMPLATE_FILE" | grep -v '"@' | sed 's/"//g' | sed 's/[[:space:]]*://' | sort)
TEMPLATE_COUNT=$(echo "$TEMPLATE_KEYS" | wc -l)

echo "📊 Template contains $TEMPLATE_COUNT translation keys"
echo ""

# Validate each ARB file
for arb_file in "$ARB_DIR"/intl_*.arb; do
    if [ "$arb_file" = "$TEMPLATE_FILE" ]; then
        continue
    fi
    
    filename=$(basename "$arb_file")
    echo "🔍 Validating: $filename"
    
    # Extract keys from current file
    FILE_KEYS=$(grep -o '"[^"@]*"[[:space:]]*:' "$arb_file" | grep -v '"@' | sed 's/"//g' | sed 's/[[:space:]]*://' | sort)
    FILE_COUNT=$(echo "$FILE_KEYS" | wc -l)
    
    # Find missing keys
    MISSING_KEYS=$(comm -23 <(echo "$TEMPLATE_KEYS") <(echo "$FILE_KEYS"))
    MISSING_COUNT=$(echo "$MISSING_KEYS" | grep -c .)
    
    # Find extra keys
    EXTRA_KEYS=$(comm -13 <(echo "$TEMPLATE_KEYS") <(echo "$FILE_KEYS"))
    EXTRA_COUNT=$(echo "$EXTRA_KEYS" | grep -c .)
    
    echo "  📊 Keys: $FILE_COUNT/$TEMPLATE_COUNT"
    
    if [ $MISSING_COUNT -gt 0 ]; then
        echo "  ⚠️  Missing keys ($MISSING_COUNT):"
        echo "$MISSING_KEYS" | sed 's/^/    - /'
    fi
    
    if [ $EXTRA_COUNT -gt 0 ]; then
        echo "  ℹ️  Extra keys ($EXTRA_COUNT):"
        echo "$EXTRA_KEYS" | sed 's/^/    + /'
    fi
    
    if [ $MISSING_COUNT -eq 0 ] && [ $EXTRA_COUNT -eq 0 ]; then
        echo "  ✅ All keys present"
    fi
    
    echo ""
done

echo "🎉 Validation complete!"
```

Make scripts executable:
```bash
chmod +x scripts/l10n/generate_localizations.sh
chmod +x scripts/l10n/validate_translations.sh
```

## Best Practices

### For Developers

1. **Use descriptive keys**:
   ```json
   // ❌ Bad
   "msg1": "Hello"
   
   // ✅ Good
   "welcomeMessage": "Welcome to our app"
   ```

2. **Group related keys**:
   ```json
   "loginTitle": "Login",
   "loginEmailLabel": "Email Address",
   "loginPasswordLabel": "Password",
   "loginSubmitButton": "Sign In"
   ```

3. **Avoid string concatenation**:
   ```dart
   // ❌ Bad
   Text(AppLocalizations.of(context)!.hello + " " + userName)
   
   // ✅ Good
   Text(AppLocalizations.of(context)!.welcomeUser(userName))
   ```

4. **Handle pluralization**:
   ```json
   "itemCount": "{count, plural, =0{No items} =1{One item} other{{count} items}}"
   ```

5. **Consider text expansion**:
   - German text can be 30% longer than English
   - Set appropriate `maxLength` values
   - Test with longer translations

### For Translators

1. **Read context carefully**:
   - Check `description` and `context` fields
   - Understand where text appears in UI
   - Consider user experience

2. **Respect character limits**:
   - Stay within `maxLength` constraints
   - Test on actual devices if possible
   - Consider text expansion in your language

3. **Maintain consistent tone**:
   - Keep the same voice throughout the app
   - Match the brand personality
   - Consider cultural appropriateness

4. **Test placeholders**:
   ```json
   // Ensure placeholders work in your language
   "welcomeUser": "مرحباً {userName}!" // Arabic
   "welcomeUser": "Bienvenue {userName}!" // French
   ```

5. **Consider RTL languages**:
   - Arabic and Hebrew read right-to-left
   - Numbers and English words remain left-to-right
   - Test actual layout in the app

### For Regional Variants

1. **Minimal overrides**:
   ```json
   // Only include keys that actually differ
   // intl_en_GB.arb
   {
     "colorPreference": "Colour preference",
     "elevatorButton": "Lift"
   }
   ```

2. **Cultural adaptation**:
   - Use local terminology
   - Consider cultural sensitivities
   - Adapt to local business practices

3. **Legal compliance**:
   - Follow local regulations
   - Consider data privacy laws
   - Adapt terms of service

## Troubleshooting

### Common Issues and Solutions

#### 1. Generation Errors

**Problem**: `flutter gen-l10n` fails
```
Error: The following LocalizationsDelegate was provided to MaterialApp but not supported
```

**Solutions**:
```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter gen-l10n

# Check l10n.yaml syntax
cat l10n.yaml

# Verify ARB file syntax
dart format --set-exit-if-changed lib/l10n/intl_en.arb
```

#### 2. Missing Translations

**Problem**: Text shows key instead of translation

**Solutions**:
```dart
// Check if locale is supported
print(AppLocalizations.supportedLocales);

// Verify delegate is added
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  // ...
)

// Check ARB file has the key
grep "yourKey" lib/l10n/intl_*.arb
```

#### 3. RTL Layout Issues

**Problem**: Arabic text not displaying correctly

**Solutions**:
```dart
// Ensure proper text direction
Text(
  AppLocalizations.of(context)!.arabicText,
  textDirection: TextDirection.rtl,
)

// Use Directionality widget
Directionality(
  textDirection: TextDirection.rtl,
  child: YourWidget(),
)

// Check locale configuration
Localizations.localeOf(context).languageCode == 'ar'
```

#### 4. Platform Integration Issues

**Problem**: Translation platform sync fails

**Solutions**:
```bash
# Check API credentials
echo $CROWDIN_API_TOKEN

# Verify file paths
ls -la lib/l10n/intl_*.arb

# Test API connection
curl -H "Authorization: Bearer $API_TOKEN" https://api.crowdin.com/api/v2/projects
```

### Debug Commands

```bash
# Check generated files
ls -la .dart_tool/flutter_gen/gen_l10n/

# Validate ARB syntax
python -m json.tool lib/l10n/intl_en.arb

# Check for duplicate keys
sort lib/l10n/intl_en.arb | uniq -d

# Find unused translation keys
grep -r "AppLocalizations.of(context)" lib/ | grep -o "\..*)" | sort | uniq

# Test specific locale
flutter run --locale=ar
```

## Advanced Topics

### Dynamic Locale Switching

```dart
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  
  Locale get locale => _locale;
  
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}

// In main.dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          locale: localeProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MyHomePage(),
        );
      },
    );
  }
}
```

### Custom Locale Resolution

```dart
class CustomLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  @override
  bool isSupported(Locale locale) {
    // Custom logic for locale support
    return ['en', 'ar', 'fr'].contains(locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) async {
    // Custom loading logic
    final String name = locale.countryCode?.isEmpty == true 
        ? locale.languageCode 
        : locale.toString();
    
    final String localeName = Intl.canonicalizedLocale(name);
    return SynchronousFuture<AppLocalizations>(
      lookupAppLocalizations(locale),
    );
  }
  
  @override
  bool shouldReload(CustomLocalizationDelegate old) => false;
}
```

### Performance Optimization

```dart
// Lazy loading for large translation files
class LazyAppLocalizations extends AppLocalizations {
  final Map<String, String> _cache = {};
  
  @override
  String get welcomeMessage {
    return _cache['welcomeMessage'] ??= _loadTranslation('welcomeMessage');
  }
  
  String _loadTranslation(String key) {
    // Load translation on demand
    return translations[key] ?? key;
  }
}
```

### CI/CD Integration

```yaml
# .github/workflows/localization.yml
name: Localization Check

on: [push, pull_request]

jobs:
  validate-translations:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        
      - name: Validate ARB files
        run: |
          ./scripts/l10n/validate_translations.sh
          
      - name: Generate localizations
        run: |
          flutter gen-l10n
          
      - name: Run localization tests
        run: |
          flutter test test/localization_test.dart
```

### Translation Memory Integration

```dart
// Custom translation loader with memory
class TranslationMemoryLoader {
  final Map<String, Map<String, String>> _memory = {};
  
  Future<void> loadFromMemory(String sourceText, String targetLocale) async {
    // Check translation memory first
    final cached = _memory[targetLocale]?[sourceText];
    if (cached != null) return cached;
    
    // Fallback to API or manual translation
    final translation = await translateViaAPI(sourceText, targetLocale);
    
    // Store in memory
    _memory[targetLocale] ??= {};
    _memory[targetLocale]![sourceText] = translation;
    
    return translation;
  }
}
```

## Resources

### Official Documentation
- [Flutter Internationalization Guide](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [ARB File Format Specification](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)
- [ICU Message Format](https://unicode-org.github.io/icu/userguide/format_parse/messages/)

### Language Standards
- [BCP 47 Language Tags](https://tools.ietf.org/html/bcp47)
- [ISO 639 Language Codes](https://www.iso.org/iso-639-language-codes.html)
- [Unicode CLDR](https://cldr.unicode.org/)

### Translation Platforms
- [Crowdin Flutter Integration](https://support.crowdin.com/flutter-localization/)
- [Lokalise Flutter Guide](https://docs.lokalise.com/en/articles/3088751-flutter-localization)
- [Phrase Flutter Documentation](https://phrase.com/blog/posts/flutter-localization/)

### Tools and Libraries
- [intl package](https://pub.dev/packages/intl)
- [flutter_localizations](https://docs.flutter.dev/development/accessibility-and-localization/internationalization#adding-support-for-a-new-language)
- [arb_utils](https://pub.dev/packages/arb_utils) - ARB file utilities

### Community Resources
- [Flutter Community Slack #i18n](https://fluttercommunity.slack.com/)
- [r/FlutterDev Localization Discussions](https://www.reddit.com/r/FlutterDev/)
- [Stack Overflow Flutter i18n Tag](https://stackoverflow.com/questions/tagged/flutter+internationalization)
