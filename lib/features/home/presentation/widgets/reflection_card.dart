import 'package:flutter/material.dart';

import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';
import '../../../../core/theme/app_icons.dart';

class ReflectionCard extends StatelessWidget {
  const ReflectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.backButtonIconSize),
      decoration: BoxDecoration(
        color: AppColors.nextPrayerBackColor,
        borderRadius: BorderRadius.circular(
          AppDimensions.heightBetweenButtonAndText,
        ),
        border: Border.all(color: AppColors.nextPrayerBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                AppIcons.aiReflection,
                height: 14,
                width: 14,
              ),
              const SizedBox(width: AppDimensions.radiusSmall),
              const Expanded(
                child: Text(
                  'AI REFLECTION',
                  style: TextStyle(
                    color: AppColors.primaryButton,
                    fontSize: AppDimensions.radiusMedium,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                width: AppDimensions.paddingSmall,
                height: AppDimensions.paddingSmall,
                decoration: const BoxDecoration(
                  color: AppColors.timeColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.radiusMedium),
          const Text(
            'Assalamu alaikum! Welcome to your space for spiritual growth. Every big journey begins with a small step. Log your first prayer today to start building a beautiful, consistent habit',
            style: TextStyle(
              color: AppColors.hintColor,
              fontSize: AppDimensions.fontSizeMedium,
              fontWeight: FontWeight.w500,
              letterSpacing: AppDimensions.letterSpacing,
            ),
          ),
        ],
      ),
    );
  }
}