
import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../routing/app_router.dart';
import '../routing/app_routes.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  final StreamController<RemoteMessage> _messageController =
  StreamController<RemoteMessage>.broadcast();

  Stream<RemoteMessage> get messages => _messageController.stream;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_alerts',
    'Important Notifications',
    description: 'Important application updates and prayer alerts',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  bool _initialized = false;
  bool _permissionGranted = false;
  String? _fcmToken;
  Map<String, dynamic>? _pendingPayload;

  bool get permissionGranted => _permissionGranted;

  String? get fcmToken => _fcmToken;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    await _initializeLocalNotifications();

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Request notification permissions (Android 13+ and iOS)
    await requestPermission();

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _messageController.add(message);
      _openNotification(message.data);
    });

    final initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      _messageController.add(initialMessage);
      _queueOrOpenNotification(initialMessage.data);
    }

    await refreshToken();

    _messaging.onTokenRefresh.listen((token) {
      _fcmToken = token;

      if (kDebugMode) {
        debugPrint('FCM token refreshed: $token');
      }

      // Later, send the refreshed token to your backend.
    });

    // Handle a local notification that launched the app.
    final launchDetails =
    await _localNotifications.getNotificationAppLaunchDetails();

    final response = launchDetails?.notificationResponse;

    if (launchDetails?.didNotificationLaunchApp == true &&
        response?.payload != null) {
      _handleLocalNotificationTap(response!.payload);
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        _handleLocalNotificationTap(response.payload);
      },
    );
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    _messageController.add(message);

    final title = message.notification?.title ?? message.data['title'] ?? 'Notification';
    final body = message.notification?.body ?? message.data['body'] ?? '';

    if (kDebugMode) {
      debugPrint('📩 [NotificationService] Foreground message received:');
      debugPrint('   Message ID: ${message.messageId}');
      debugPrint('   Title: $title');
      debugPrint('   Body: $body');
      debugPrint('   Data: ${message.data}');
    }

    try {
      final int notificationId = (message.messageId?.hashCode ??
              DateTime.now().millisecondsSinceEpoch)
          .abs() %
          2147483647;

      await _localNotifications.show(
        id: notificationId,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            enableVibration: true,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
      if (kDebugMode) {
        debugPrint('✅ [NotificationService] Foreground notification displayed.');
      }
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('❌ [NotificationService] Failed to show notification: $e\n$stack');
      }
    }
  }

  /// Displays an immediate system notification on the device without requiring a backend server.
  Future<void> showNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final int notificationId =
        DateTime.now().millisecondsSinceEpoch.abs() % 2147483647;

    await _localNotifications.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: data != null ? jsonEncode(data) : null,
    );
  }

  void _handleLocalNotificationTap(String? payload) {
    if (payload == null || payload.isEmpty) return;

    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      _queueOrOpenNotification(data);
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Invalid local notification payload: $error');
      }
    }
  }

  void _queueOrOpenNotification(Map<String, dynamic> data) {
    final navigator = AppRouter.navigatorKey.currentState;

    if (navigator == null) {
      _pendingPayload = data;
      return;
    }

    _openNotification(data);
  }

  void handleNavigatorReady() {
    final payload = _pendingPayload;

    if (payload == null) return;

    _pendingPayload = null;
    _openNotification(payload);
  }

  /// Requests notification permission on Android 13+ and iOS.
  /// Handles user denial gracefully and returns whether permission was granted.
  Future<bool> requestPermission() async {
    // 1. Android 13+ runtime POST_NOTIFICATIONS permission
    final androidImplementation = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final androidGranted =
        await androidImplementation?.requestNotificationsPermission();

    // 2. Firebase Messaging permission (iOS & cross-platform)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    _permissionGranted = (androidGranted ?? true) &&
        (settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional);

    if (kDebugMode) {
      if (_permissionGranted) {
        debugPrint('✅ [NotificationService] Notification permission GRANTED.');
      } else {
        debugPrint(
          '⚠️ [NotificationService] Notification permission DENIED by user. '
          'Push notifications will not display until granted in settings.',
        );
      }
    }

    return _permissionGranted;
  }

  void _openNotification(Map<String, dynamic> data) {
    // Look for 'route', 'screen', or 'path' in notification payload data
    final routeRaw = (data['route'] ?? data['screen'] ?? data['path']) as String?;

    if (routeRaw == null || routeRaw.isEmpty) {
      if (kDebugMode) {
        debugPrint(
          'ℹ️ [NotificationService] Notification tapped, but no route key was found in payload: $data',
        );
      }
      return;
    }

    // Normalize route (e.g. 'home' -> '/home', 'navBar' -> '/nav-bar')
    String route = routeRaw.startsWith('/') ? routeRaw : '/$routeRaw';
    if (route == '/navBar' || route == '/navbar') {
      route = AppRoutes.navBar;
    }

    const allowedRoutes = <String>{
      AppRoutes.splash,
      AppRoutes.login,
      AppRoutes.signup,
      AppRoutes.verifyEmail,
      AppRoutes.registrationSuccess,
      AppRoutes.home,
      AppRoutes.navBar,
    };

    if (!allowedRoutes.contains(route)) {
      if (kDebugMode) {
        debugPrint(
          '⚠️ [NotificationService] Unsupported notification route: "$route". '
          'Allowed routes: $allowedRoutes',
        );
      }
      return;
    }

    final navigator = AppRouter.navigatorKey.currentState;

    if (navigator == null) {
      _pendingPayload = data;
      return;
    }

    navigator.pushNamed(route, arguments: data);
  }

  /// Gets the current FCM token, or fetches a new one if not yet initialized.
  Future<String?> getFcmToken() async {
    if (_fcmToken != null) return _fcmToken;
    return await refreshToken();
  }

  /// Stream of refreshed FCM tokens to notify backend when tokens change.
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  Future<String?> refreshToken() async {
    try {
      _fcmToken = await _messaging.getToken();

      if (kDebugMode) {
        debugPrint('🔥 [NotificationService] FCM Token: $_fcmToken');
      }

      return _fcmToken;
    } catch (error) {
      if (kDebugMode) {
        debugPrint('❌ [NotificationService] Unable to retrieve FCM token: $error');
      }

      return null;
    }
  }
}
