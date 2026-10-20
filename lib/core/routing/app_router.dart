import 'package:flutter/material.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/registration_successfull_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/navigation_menu/main_screen_view.dart';
import '../../features/splash/splash_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static const Color _routeBackgroundColor = Color(0xFF0C0E0D);

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _buildRoute(const DeenSplashScreen(), settings);

      case AppRoutes.login:
        return _buildRoute(const LoginScreen(), settings);

      case AppRoutes.signup:
        return _buildRoute(const SignUpScreen(), settings);

      case AppRoutes.verifyEmail:
        final email = settings.arguments as String?;
        return _buildRoute(VerifyEmailScreen(email: email), settings);

      case AppRoutes.registrationSuccess:
        return _buildRoute(const RegistrationSuccessfullScreen(), settings);

      case AppRoutes.home:
        return _buildRoute(const HomeScreen(), settings);

      case AppRoutes.navBar:
        return _buildRoute(const MainScreenView(), settings);

      default:
        return _buildRoute(
          const Scaffold(
            backgroundColor: _routeBackgroundColor,
            body: Center(
              child: Text(
                'Route not found',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
          settings,
        );
    }
  }

  /// Dark, seamless transition that completely prevents any white flash/light during navigation
  static PageRoute<dynamic> _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      opaque: true,
      barrierColor: _routeBackgroundColor,
      pageBuilder: (context, animation, secondaryAnimation) => Container(
        color: _routeBackgroundColor,
        child: page,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 180),
    );
  }
}
