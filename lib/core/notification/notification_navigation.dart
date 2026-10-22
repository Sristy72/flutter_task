import 'dart:convert';

import 'package:flutter/material.dart';

class NotificationNavigation {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static void openFromPayload(String? payload) {
    if (payload == null || payload.isEmpty) return;

    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final route = data['route'] as String?;

      if (route == null || route.isEmpty) return;

      // Validate routes before navigating.
      const allowedRoutes = {
        '/home',
        '/orders',
        '/notifications',
        '/order-details',
      };

      if (!allowedRoutes.contains(route)) return;

      navigatorKey.currentState?.pushNamed(
        route,
        arguments: data,
      );
    } on FormatException {
      // invalid payload — ignore
    } catch (_) {
      // navigation failed — ignore
    }
  }
}