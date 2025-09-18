import 'package:flutter_sdui_app/features/onboarding/core/onboarding_widget_keys.dart';
import 'package:flutter_sdui_app/features/onboarding/presentation/pages/get_started_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../pump_app.dart';

void main() {
  group('GetStartedPage', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpApp(const GetStartedPage());

      expect(
        find.text('Hey there!\nWelcome to Flutter SDUI Demo App'),
        findsOneWidget,
      );
      expect(find.byKey(OnboardingWidgetKeys.getStartedButton), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
    });
  });
}
