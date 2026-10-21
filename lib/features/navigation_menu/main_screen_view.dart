import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/core/routing/app_routes.dart';
import 'package:flutter_task/core/theme/app_colours.dart';
import 'package:flutter_task/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_task/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_task/features/auth/presentation/bloc/auth_state.dart';

import '../home/presentation/screens/home_screen.dart';
import 'navigation_bloc/navigation_menu_bloc.dart';
import 'navigation_bloc/navigation_menu_state.dart';
import 'navigation_menu.dart';

class MainScreenView extends StatelessWidget {
  const MainScreenView({super.key});

  static const Color background = Color(0xFF0D1611);

  static const List<Widget> _pages = [
    HomeScreen(),
    Center(
      child: Text(
        'Community',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ),
    Center(
      child: Text(
        'Reflect',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ),
    Center(
      child: Text(
        'Prayer',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ),
    _LogoutTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status == AuthStatus.unauthenticated,
          listener: (context, state) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          },
        ),
        BlocListener<NavigationMenuBloc, NavigationMenuState>(
          listenWhen: (previous, current) =>
              previous.selectedIndex != current.selectedIndex,
          listener: (context, state) {
            if (state.selectedIndex == 1) {
              // tab switch logic
            }
          },
        ),
      ],
      child: BlocBuilder<NavigationMenuBloc, NavigationMenuState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: IndexedStack(index: state.selectedIndex, children: _pages),
            bottomNavigationBar: const AppBottomNavigation(),
          );
        },
      ),
    );
  }
}

class _LogoutTab extends StatelessWidget {
  const _LogoutTab();

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF14211C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.nextPrayerBorderColor),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: AppColors.hintColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.hintColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButton,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<AuthBloc>().add(Logout());
              },
              child: const Text(
                'Log Out',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            iconSize: 48,
            color: AppColors.primaryButton,
            onPressed: () => _showLogoutConfirmation(context),
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(height: 8),
          const Text(
            'Log Out',
            style: TextStyle(
              color: AppColors.hintColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
