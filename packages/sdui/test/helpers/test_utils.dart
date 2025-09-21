import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sdui/src/core/workflow_controller.dart';
import 'package:sdui/src/models/theme_tokens.dart';
import 'package:sdui/src/models/workflow.dart';

import 'mock_data.dart';

class TestUtils {
  /// Create a test widget wrapper with MaterialApp
  static Widget createTestWidget(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  /// Create a test widget with theme
  static Widget createThemedTestWidget(
    Widget child, {
    ThemeTokens? themeTokens,
  }) {
    final tokens = themeTokens ?? MockData.mockThemeTokens;
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: tokens.fontFamily,
      ),
      home: Scaffold(body: child),
    );
  }

  /// Create a mock workflow controller
  static SduiWorkflowController createMockController({
    Workflow? workflow,
    String? currentScreenId,
  }) {
    final mockWorkflow = workflow ?? MockData.mockWorkflow;
    final controller = SduiWorkflowController(workflow: mockWorkflow);

    return controller;
  }

  /// Pump and settle with default duration
  static Future<void> pumpAndSettle(WidgetTester tester) async {
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
  }

  /// Enter text in a text field
  static Future<void> enterText(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await pumpAndSettle(tester);
  }
}
