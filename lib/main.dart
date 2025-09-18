import 'package:flutter/material.dart';
import 'package:flutter_sdui_app/app.dart';
import 'package:flutter_sdui_app/core/errors/error_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorHandler.initialize();

  runApp(const App());
}
