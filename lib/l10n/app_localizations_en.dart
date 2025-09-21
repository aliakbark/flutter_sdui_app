// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter SDUI Demo App';

  @override
  String get welcomeMessage => 'Hey there!\nWelcome to Flutter SDUI Demo App';

  @override
  String get startSduiOnboarding => 'Start SDUI Onboarding';

  @override
  String get traditionalOnboarding => 'Traditional Onboarding';

  @override
  String get onboardingCompleted => 'Onboarding completed successfully!';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';
}
