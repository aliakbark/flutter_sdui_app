import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  /// Pumps a widget wrapped with necessary testing infrastructure.
  ///
  /// Parameters:
  /// - [widget]: The widget to be tested
  /// - [locale]: Optional locale for testing specific languages
  /// - [theme]: Optional theme data
  /// - [useScaffold]: Whether to wrap the widget with a Scaffold (default:true)
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    ThemeData? theme,
    bool useScaffold = true,
  }) async {
    // Wrap the widget with MaterialApp for theming and localization support
    Widget wrappedWidget = MaterialApp(
      locale: locale,
      theme: theme ?? ThemeData.light(),
      home: useScaffold ? Scaffold(body: widget) : widget,
    );

    // Pump the widget into the widget tree
    await pumpWidget(wrappedWidget);

    // Allow any pending animations or frames to complete
    await pumpAndSettle();
  }
}
