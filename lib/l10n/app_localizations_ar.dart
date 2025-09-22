// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تطبيق Flutter SDUI التجريبي';

  @override
  String get welcomeMessage =>
      'مرحباً بك!\nأهلاً بك في تطبيق Flutter SDUI التجريبي';

  @override
  String get startSduiOnboarding => 'بدء عملية الإعداد SDUI';

  @override
  String get normalOnboarding => 'عملية الإعداد العادية';

  @override
  String get onboardingCompleted => 'تم إكمال عملية الإعداد بنجاح!';

  @override
  String errorMessage(String error) {
    return 'خطأ: $error';
  }

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';
}
