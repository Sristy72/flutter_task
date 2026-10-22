import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';
import 'core/di/injection.dart';
import 'core/network/service/auth_storage_service.dart';
import 'core/notification/notification_service.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/presentation/home_bloc/home_bloc.dart';
import 'features/navigation_menu/navigation_bloc/navigation_menu_bloc.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('📩 [FCM Background Handler] Received message: ${message.messageId}');
  debugPrint('   Title: ${message.notification?.title ?? message.data['title']}');
  debugPrint('   Body: ${message.notification?.body ?? message.data['body']}');
  debugPrint('   Data: ${message.data}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await setupDependencies();

  final isLoggedIn = await getIt<AuthStorageService>().isLoggedIn();

  runApp(MyApp(initialRoute: isLoggedIn ? AppRoutes.navBar : AppRoutes.splash));
}

class MyApp extends StatefulWidget {
  final String initialRoute;

  const MyApp({super.key, this.initialRoute = AppRoutes.splash});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await NotificationService.instance.initialize();
      NotificationService.instance.handleNavigatorReady();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
        BlocProvider<NavigationMenuBloc>(create: (_) => NavigationMenuBloc()),
        BlocProvider<HomeBloc>(create: (_) => getIt<HomeBloc>()),
      ],
      child: MaterialApp(
        navigatorKey: AppRouter.navigatorKey,
        title: 'Flutter Task',
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        color: const Color(0xFF0C0E0D),
        debugShowCheckedModeBanner: false,
        initialRoute: widget.initialRoute,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
