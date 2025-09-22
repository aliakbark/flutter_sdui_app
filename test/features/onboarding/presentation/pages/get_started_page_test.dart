import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_sdui_app/core/shared/states/app/app_cubit.dart';
import 'package:flutter_sdui_app/features/onboarding/presentation/pages/get_started_page.dart';

import '../../../../mocks/mock_network_info.dart';
import '../../../../mocks/mock_preferences_service.dart';
import '../../../../pump_app.dart';

void main() {
  group('GetStartedPage', () {
    late AppCubit appCubit;
    late MockNetworkInfo mockNetworkInfo;
    late MockPreferencesService mockPreferencesService;
    late StreamController<bool> connectivityController;

    setUp(() {
      TestServiceLocator.setup();

      // Setup mocks
      mockNetworkInfo = MockNetworkInfo();
      mockPreferencesService = MockPreferencesService();
      connectivityController = StreamController<bool>.broadcast();

      // Setup mock behavior
      when(
        () => mockNetworkInfo.connectivityStream,
      ).thenAnswer((_) => connectivityController.stream);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockPreferencesService.getLocale()).thenReturn(null);

      // Create AppCubit with mocked dependencies
      appCubit = AppCubit(mockNetworkInfo, mockPreferencesService);
    });

    tearDown(() async {
      connectivityController.close();
      appCubit.close();
      await TestServiceLocator.reset();
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpApp(const GetStartedPage(), appCubit: appCubit);

      // Check for localized text (using the actual localization keys)
      expect(find.text('Flutter SDUI Demo App'), findsOneWidget);
      expect(
        find.text('Hey there!\nWelcome to Flutter SDUI Demo App'),
        findsOneWidget,
      );
      expect(find.text('Start SDUI Onboarding'), findsOneWidget);
      expect(find.text('Traditional Onboarding'), findsOneWidget);
    });
  });
}
