import 'package:flutter/material.dart';

import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';
import '../../data/models/responses/prayer_dashboard_response_model.dart';

class PrayerTrackingCard extends StatelessWidget {
  final NextPrayer? nextPrayer;
  final DailyGoal? dailyGoal;

  const PrayerTrackingCard({super.key, this.nextPrayer, this.dailyGoal});

  @override
  Widget build(BuildContext context) {
    final prayerName = nextPrayer?.name ?? 'the next prayer';
    final completed = dailyGoal?.completed ?? 0;
    final target = dailyGoal?.target ?? 5;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.radiusLarge),
      decoration: BoxDecoration(
        color: AppColors.nextPrayerBackColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(
          color: AppColors.nextPrayerBorderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Have you prayed $prayerName?',
                  style: const TextStyle(
                    color: AppColors.deenColor,
                    fontSize: AppDimensions.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                    letterSpacing: AppDimensions.letterSpacing,
                  ),
                ),
                Text(
                  '$completed/$target prayers tracked today',
                  style: const TextStyle(
                    color: AppColors.dateColor,
                    fontSize: AppDimensions.heightMedium,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: AppDimensions.boldFontSize,
            height: AppDimensions.boldFontSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.questionBorderColor,
              ),
            ),
            child: const Icon(
              Icons.question_mark,
              color: AppColors.timeColor,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}