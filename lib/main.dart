import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'core/di/injection.dart';
import 'core/network/service/auth_storage_service.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/navigation_menu/navigation_bloc/navigation_menu_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize dependencies
  await setupDependencies();

  // Check login status
  final isLoggedIn = await getIt<AuthStorageService>().isLoggedIn();

  runApp(
    MyApp(
      initialRoute: isLoggedIn ? AppRoutes.navBar : AppRoutes.splash,
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({
    super.key,
    this.initialRoute = AppRoutes.splash,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>(),
        ),
        BlocProvider<NavigationMenuBloc>(
          create: (_) => NavigationMenuBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Task',
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        color: const Color(0xFF0C0E0D),
        debugShowCheckedModeBanner: false,
        initialRoute: initialRoute,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}