import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/core/theme/app_colours.dart';
import 'package:flutter_task/core/theme/app_dimentions.dart';
import 'package:flutter_task/core/theme/app_icons.dart';

import 'navigation_bloc/navigation_menu_bloc.dart';
import 'navigation_bloc/navigation_menu_event.dart';
import 'navigation_bloc/navigation_menu_state.dart';


class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      // margin: const EdgeInsets.symmetric(
      //   horizontal: 8,
      //   vertical: 8,
      // ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 9.5),
        decoration: BoxDecoration(
          color: AppColors.navBarBackColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: Border.all(
            color: AppColors.navBarBorderColor,
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              offset: Offset(0, -4),
              blurRadius: 10,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x0A000000),
              offset: Offset(0, -1),
              blurRadius: 3,
              spreadRadius: 0,
            ),
          ],
        ),
      child: BlocBuilder<NavigationMenuBloc, NavigationMenuState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavigationItem(
                index: 0,
                selectedIndex: state.selectedIndex,
                selectedIcon: AppIcons.home,
                label: 'Home',
              ),

              _NavigationItem(
                index: 1,
                selectedIndex: state.selectedIndex,
                selectedIcon: AppIcons.communityIcon,
                label: 'Community',
              ),

              _NavigationItem(
                index: 2,
                selectedIndex: state.selectedIndex,
                selectedIcon: AppIcons.reflect,
                label: 'Reflect',
              ),

              _NavigationItem(
                index: 3,
                selectedIndex: state.selectedIndex,
                selectedIcon: AppIcons.prayer,
                label: 'Prayer',
              ),
              _NavigationItem(
                index: 4,
                selectedIndex: state.selectedIndex,
                selectedIcon: AppIcons.profile,
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final String selectedIcon;
  final String label;

  const _NavigationItem({
    required this.index,
    required this.selectedIndex,
    required this.selectedIcon,
    required this.label,
  });

  bool get isSelected => index == selectedIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<NavigationMenuBloc>().add(
          NavigationItemSelected(index),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        height: 64,
        width: 64,
        // padding: EdgeInsets.symmetric(
        //   horizontal: isSelected ? 16 : 10,
        // ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.cardBackColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11.63),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(selectedIcon, color: isSelected
                    ? AppColors.primaryButton
                    : AppColors.eyeColor, width: 20,height: 20,),

                // Icon(
                //   isSelected ? selectedIcon : icon,
                //   size: 23,
                //   color: isSelected
                //       ? AppColors.primaryButton
                //   : AppColors.eyeColor,
                // ),
                //

                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSelected ? AppColors.primaryButton : AppColors.eyeColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}