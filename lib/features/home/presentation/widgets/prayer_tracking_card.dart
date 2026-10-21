import 'package:flutter/material.dart';

import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';

class PrayerTrackingCard extends StatelessWidget {
  const PrayerTrackingCard({super.key});

  @override
  Widget build(BuildContext context) {
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Have you prayed Dhuhr?',
                  style: TextStyle(
                    color: AppColors.deenColor,
                    fontSize: AppDimensions.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                    letterSpacing: AppDimensions.letterSpacing,
                  ),
                ),
                Text(
                  '2/5 prayers tracked today',
                  style: TextStyle(
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