import 'package:flutter/material.dart';
import 'package:flutter_sdui_app/app.dart';
import 'package:flutter_sdui_app/core/errors/error_handler.dart';
import 'package:flutter_sdui_app/core/di/injector.dart' as di;

import 'features/sdui/core/sdui_workflow_registry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorHandler.initialize();

  // Initialize dependencies
  await di.init();

  // Initialize SDUI
  await _initializeSdui();

  runApp(const App());
}

/// Initialize SDUI service and capabilities
Future<void> _initializeSdui() async {
  // Initialize SDUI with asset configuration and register all workflow capabilities
  await SDUIWorkflowRegistry.initialize(
    assetPath: 'assets/json/dynamic_ui_config.json',
  );
}
