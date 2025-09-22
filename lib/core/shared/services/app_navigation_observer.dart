import 'package:flutter/material.dart';
import 'package:flutter_sdui_app/core/di/injector.dart';
import 'package:flutter_sdui_app/core/shared/services/telemetry_service.dart';

class AppNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _logNavigation('PUSH', route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _logNavigation('POP', route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logNavigation('REPLACE', newRoute, oldRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    _logNavigation('REMOVE', route, previousRoute);
  }

  void _logNavigation(String action, Route? route, Route? previousRoute) {
    final String current = route?.settings.name ?? route.toString();
    final String previous =
        previousRoute?.settings.name ?? previousRoute.toString();

    sl<AnalyticsService>().logEvent('navigation_$action', {
      'from': previous,
      'to': current,
    });
  }
}
