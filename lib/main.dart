import 'package:flutter/material.dart';
import 'package:flutter_sdui_app/app.dart';
import 'package:flutter_sdui_app/core/errors/error_handler.dart';
import 'package:flutter_sdui_app/core/di/injector.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorHandler.initialize();

  // Initialize dependencies
  await di.init();

  runApp(const App());
}
