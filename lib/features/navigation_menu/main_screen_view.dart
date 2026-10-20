import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/core/theme/app_colours.dart';

import '../home/presentation/screens/home_screen.dart';
import 'navigation_bloc/navigation_menu_bloc.dart';
import 'navigation_bloc/navigation_menu_state.dart';
import 'navigation_menu.dart';

class MainScreenView extends StatelessWidget {
  const MainScreenView({super.key});
  static const Color background = Color(0xFF0D1611);

  static const List<Widget> _pages = [
    HomeScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationMenuBloc, NavigationMenuState>(
      listenWhen: (previous, current) =>
          previous.selectedIndex != current.selectedIndex,
      listener: (context, state) {
        // When navigating TO the Orders tab (index 1), refresh both cart and orders
        if (state.selectedIndex == 1) {
          //context.read<HomeBloc>().add(FetchCartEvent());
        }
      },
      child: BlocBuilder<NavigationMenuBloc, NavigationMenuState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: IndexedStack(
              index: state.selectedIndex,
              children: _pages,
            ),
            bottomNavigationBar: const AppBottomNavigation(),
          );
        },
      ),
    );
  }
}
