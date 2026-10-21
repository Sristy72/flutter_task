import 'package:flutter/material.dart';
import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';
import '../../data/models/responses/prayer_dashboard_response_model.dart';

class GoalCards extends StatelessWidget {
  final DailyGoal? dailyGoal;
  final PrayerStreak? streak;

  const GoalCards({super.key, this.dailyGoal, this.streak});

  @override
  Widget build(BuildContext context) {
    final completed = dailyGoal?.completed ?? 0;
    final target = dailyGoal?.target ?? 5;
    final currentStreak = streak?.current ?? 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _goalCard(
            title: 'Daily Goal',
            icon: Icons.access_time,
            iconColor: AppColors.timerColor,
            number: '$completed',
            suffix: '/$target',
            message: completed == 0
                ? 'Track a prayer to unlock goals'
                : '$completed of $target prayers done',
            messageColor: AppColors.primaryButton,
          ),
        ),
        const SizedBox(width: AppDimensions.paddingSmall),
        Expanded(
          child: _goalCard(
            title: 'Current Streak',
            icon: Icons.local_fire_department,
            iconColor: const Color(0xFFF5D47A),
            number: '$currentStreak',
            suffix: ' days',
            message: currentStreak == 0
                ? 'Log today to begin streak'
                : 'Keep it up! 🔥',
            messageColor: AppColors.streakTextColor,
          ),
        ),
      ],
    );
  }

  Widget _goalCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String number,
    required String suffix,
    required String message,
    required Color messageColor,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 180),
      padding: const EdgeInsets.all(AppDimensions.backButtonIconSize),
      decoration: BoxDecoration(
        color: AppColors.cardBackColor,
        borderRadius: BorderRadius.circular(
          AppDimensions.heightBetweenButtonAndText,
        ),
        border: Border.all(color: AppColors.textFieldBorderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.hintColor,
                    fontSize: AppDimensions.heightMedium,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(icon, color: iconColor, size: 19),
            ],
          ),
          const SizedBox(height: AppDimensions.radiusLarge),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  number,
                  style: const TextStyle(
                    color: AppColors.deenColor,
                    fontSize: AppDimensions.boldFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  suffix,
                  style: const TextStyle(
                    color: AppColors.hintColor,
                    fontSize: AppDimensions.radiusLarge,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: TextStyle(
              color: messageColor,
              fontSize: AppDimensions.heightMedium,
              fontWeight: FontWeight.w700,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}