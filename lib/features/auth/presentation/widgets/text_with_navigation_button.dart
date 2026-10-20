
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';

class AuthNavigationText extends StatelessWidget {
  final String message;
  final String actionText;
  final VoidCallback onTap;
  final Color? actionColor;

  const AuthNavigationText({
    super.key,
    required this.message,
    required this.actionText,
    required this.onTap,
    this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          style: const TextStyle(
            fontSize: AppDimensions.fontSizeMedium,
            color: AppColors.dontHaveAccountColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMedium,
              fontWeight: FontWeight.w600,
              color: actionColor ?? AppColors.primaryButton,
            ),
          ),
        ),
      ],
    );
  }
}
