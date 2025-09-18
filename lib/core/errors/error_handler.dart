import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

/// A service that handles application errors centrally
class ErrorHandler {
  /// Initialize error handlers for both framework and platform errors
  static void initialize() {
    // Handle framework errors
    FlutterError.onError = _handleFlutterError;

    // Handle uncaught asynchronous errors from the platform
    PlatformDispatcher.instance.onError = _handlePlatformError;
  }

  /// Handle Flutter framework errors
  static void _handleFlutterError(FlutterErrorDetails details) {
    FlutterError.presentError(details);

    if (kDebugMode) {
      dev.log(
        'Flutter framework error: ${details.exception}',
        stackTrace: details.stack,
        name: 'ErrorHandler',
      );
    } else {
      // Add production error reporting here
    }
  }

  /// Handle platform errors
  static bool _handlePlatformError(Object error, StackTrace stack) {
    if (kDebugMode) {
      dev.log(
        'Unhandled async error: $error',
        stackTrace: stack,
        name: 'ErrorHandler',
      );
    } else {
      // Add production error reporting here
    }

    return true; // error is handled
  }
}
