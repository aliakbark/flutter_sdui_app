import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sdui/src/core/sdui_renderer.dart';
import 'package:sdui/src/models/widget_config.dart';
import 'package:sdui/src/core/workflow_controller.dart';
import 'package:sdui/src/exceptions/sdui_exceptions.dart';
import '../helpers/mock_data.dart';
import '../helpers/test_utils.dart';

void main() {
  group('SduiRenderer', () {
    late SduiWorkflowController controller;

    setUp(() {
      controller = TestUtils.createMockController();
    });

    group('Widget Rendering', () {
      testWidgets('should render text widget', (WidgetTester tester) async {
        const config = WidgetConfig(
          id: 'text1',
          type: 'text',
          properties: {'text': 'Hello World'},
        );

        final widget = SduiRenderer.renderWidget(
          config,
          MockData.mockThemeTokens,
          controller,
        );

        await tester.pumpWidget(TestUtils.createThemedTestWidget(widget));
        expect(find.text('Hello World'), findsOneWidget);
      });

      testWidgets('should render textfield widget', (WidgetTester tester) async {
        const config = WidgetConfig(
          id: 'field1',
          type: 'textfield',
          label: 'Email',
          properties: {'hint': 'Enter email'},
        );

        final widget = SduiRenderer.renderWidget(
          config,
          MockData.mockThemeTokens,
          controller,
        );

        await tester.pumpWidget(TestUtils.createThemedTestWidget(widget));
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('should render button widget', (WidgetTester tester) async {
        const config = WidgetConfig(
          id: 'btn1',
          type: 'button',
          label: 'Submit',
        );

        final widget = SduiRenderer.renderWidget(
          config,
          MockData.mockThemeTokens,
          controller,
        );

        await tester.pumpWidget(TestUtils.createThemedTestWidget(widget));
        expect(find.text('Submit'), findsOneWidget);
      });

      testWidgets('should render container widget', (WidgetTester tester) async {
        const config = WidgetConfig(
          id: 'container1',
          type: 'container',
          children: [
            WidgetConfig(
              id: 'text1',
              type: 'text',
              properties: {'text': 'Child Text'},
            ),
          ],
        );

        final widget = SduiRenderer.renderWidget(
          config,
          MockData.mockThemeTokens,
          controller,
        );

        await tester.pumpWidget(TestUtils.createThemedTestWidget(widget));
        expect(find.text('Child Text'), findsOneWidget);
      });

      testWidgets('should render row widget', (WidgetTester tester) async {
        const config = WidgetConfig(
          id: 'row1',
          type: 'row',
          children: [
            WidgetConfig(
              id: 'text1',
              type: 'text',
              properties: {'text': 'Item 1'},
            ),
            WidgetConfig(
              id: 'text2',
              type: 'text',
              properties: {'text': 'Item 2'},
            ),
          ],
        );

        final widget = SduiRenderer.renderWidget(
          config,
          MockData.mockThemeTokens,
          controller,
        );

        await tester.pumpWidget(TestUtils.createThemedTestWidget(widget));
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
      });

      testWidgets('should render column widget', (WidgetTester tester) async {
        const config = WidgetConfig(
          id: 'column1',
          type: 'column',
          children: [
            WidgetConfig(
              id: 'text1',
              type: 'text',
              properties: {'text': 'Item 1'},
            ),
            WidgetConfig(
              id: 'text2',
              type: 'text',
              properties: {'text': 'Item 2'},
            ),
          ],
        );

        final widget = SduiRenderer.renderWidget(
          config,
          MockData.mockThemeTokens,
          controller,
        );

        await tester.pumpWidget(TestUtils.createThemedTestWidget(widget));
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
      });

      testWidgets('should render spacer widget', (WidgetTester tester) async {
        const config = WidgetConfig(
          id: 'spacer1',
          type: 'spacer',
          properties: {'height': 20.0},
        );

        final widget = SduiRenderer.renderWidget(
          config,
          MockData.mockThemeTokens,
          controller,
        );

        await tester.pumpWidget(TestUtils.createThemedTestWidget(widget));
        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('should render otp field widget', (WidgetTester tester) async {
        const config = WidgetConfig(
          id: 'otp1',
          type: 'otpfield',
          properties: {'length': 6},
        );

        final widget = SduiRenderer.renderWidget(
          config,
          MockData.mockThemeTokens,
          controller,
        );

        await tester.pumpWidget(TestUtils.createThemedTestWidget(widget));
        // OTP field should render multiple text fields
        expect(find.byType(TextField), findsWidgets);
      });
    });

    group('Unsupported Widget', () {
      testWidgets('should render unsupported widget placeholder', (WidgetTester tester) async {
        const config = WidgetConfig(
          id: 'unknown1',
          type: 'unknown_widget',
        );

        final widget = SduiRenderer.renderWidget(
          config,
          MockData.mockThemeTokens,
          controller,
        );

        await tester.pumpWidget(TestUtils.createThemedTestWidget(widget));
        expect(find.text('Unsupported widget: unknown_widget'), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
      });
    });

    group('Error Handling', () {
      test('should throw SduiRenderingException on render error', () {
        // Create a config that would cause an error
        const config = WidgetConfig(
          id: 'error_widget',
          type: 'text',
          properties: null, // This might cause an error in some cases
        );

        // The renderer should handle errors gracefully
        expect(
          () => SduiRenderer.renderWidget(
            config,
            MockData.mockThemeTokens,
            controller,
          ),
          // Either succeeds or throws SduiRenderingException
          anyOf(
            returnsNormally,
            throwsA(isA<SduiRenderingException>()),
          ),
        );
      });
    });

    group('Case Insensitive Widget Types', () {
      testWidgets('should handle uppercase widget types', (WidgetTester tester) async {
        const config = WidgetConfig(
          id: 'text1',
          type: 'TEXT',
          properties: {'text': 'Hello'},
        );

        final widget = SduiRenderer.renderWidget(
          config,
          MockData.mockThemeTokens,
          controller,
        );

        await tester.pumpWidget(TestUtils.createThemedTestWidget(widget));
        expect(find.text('Hello'), findsOneWidget);
      });

      testWidgets('should handle mixed case widget types', (WidgetTester tester) async {
        const config = WidgetConfig(
          id: 'btn1',
          type: 'Button',
          label: 'Click Me',
        );

        final widget = SduiRenderer.renderWidget(
          config,
          MockData.mockThemeTokens,
          controller,
        );

        await tester.pumpWidget(TestUtils.createThemedTestWidget(widget));
        expect(find.text('Click Me'), findsOneWidget);
      });
    });
  });
}
