import 'package:flutter/material.dart';

import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';
import '../../../../core/theme/app_icons.dart';
import '../../data/models/responses/prayer_dashboard_response_model.dart';

class ReflectionCard extends StatelessWidget {
  final AiReflection? aiReflection;

  const ReflectionCard({super.key, this.aiReflection});

  @override
  Widget build(BuildContext context) {
    final text = aiReflection?.text ??
        'Assalamu alaikum! Welcome to your space for spiritual growth. '
            'Every big journey begins with a small step. Log your first prayer '
            'today to start building a beautiful, consistent habit';

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
          Text(
            text,
            style: const TextStyle(
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