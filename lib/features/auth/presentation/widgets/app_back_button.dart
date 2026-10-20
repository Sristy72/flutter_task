import 'package:flutter/material.dart';
import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.iconSize = AppDimensions.backButtonIconSize,
    this.backgroundColor = const Color(0xFF191D1B),
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).maybePop(),
      child: Container(
        width: AppDimensions.backButtonSize,
        height:AppDimensions.backButtonSize,
        decoration: BoxDecoration(
          color: AppColors.backButtonBackgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.backButtonBorderColor,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: iconColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}