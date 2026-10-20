import 'package:flutter/material.dart';

import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';
import '../../../../core/theme/app_icons.dart';

class SocialButtons extends StatelessWidget {
  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;

  const SocialButtons({
    super.key,
    this.onGoogleTap,
    this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google Button
        GestureDetector(
          onTap: onGoogleTap,
          child: Container(
            width: AppDimensions.socialButtonSize,
            height: AppDimensions.socialButtonSize,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusMedium,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(AppIcons.googleLogo, width: 18, height: 18,),
            ),
          ),
        ),

        const SizedBox(width: AppDimensions.paddingMedium),

        // Apple Button
        GestureDetector(
          onTap: onAppleTap,
          child: Container(
            width: AppDimensions.socialButtonSize,
            height: AppDimensions.socialButtonSize,
            decoration: BoxDecoration(
              color: AppColors.secondaryButtonColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium,),
              border: Border.all(
                color: AppColors.hintColor,
                width: 1,
              ),
            ),
            child: Center(
              child: Image.asset(AppIcons.appleLogo, width: 18, height: 18,),
            ),
          ),
        ),
      ],
    );
  }
}