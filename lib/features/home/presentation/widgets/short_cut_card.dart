import 'package:flutter/material.dart';
import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';

class ShortcutCards extends StatelessWidget {
  const ShortcutCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _shortcut(
            icon: Icons.explore,
            title: 'Qibla',
            color: AppColors.timeColor,
          ),
        ),
        const SizedBox(width: AppDimensions.radiusMedium),
        Expanded(
          child: _shortcut(
            icon: Icons.nightlight_round,
            title: 'Hijri',
            color: AppColors.hijriColor,
          ),
        ),
        const SizedBox(width: AppDimensions.radiusMedium),
        Expanded(
          child: _shortcut(
            icon: Icons.attach_money,
            title: 'Zakat',
            color: AppColors.zakatColor,
          ),
        ),
        const SizedBox(width: AppDimensions.radiusMedium),
        Expanded(
          child: _shortcut(
            icon: Icons.calendar_month,
            title: 'Times',
            color: AppColors.timesColor,
          ),
        ),
      ],
    );
  }
  Widget _shortcut({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      //constraints: const BoxConstraints(minHeight: 125),
      padding: const EdgeInsets.all(AppDimensions.radiusMedium),
      decoration: BoxDecoration(
        color: AppColors.shortCutBackColor,
        borderRadius: BorderRadius.circular(AppDimensions.paddingMedium),
        border: Border.all(color: AppColors.nextPrayerBorderColor, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 31,
            decoration: BoxDecoration(
              color: AppColors.shortCutColor,
              borderRadius: BorderRadius.circular(AppDimensions.lockBorderRadius),
            ),
            child: Icon(icon, color: color, size: AppDimensions.radiusLarge),
          ),
          const SizedBox(height: 13),
          Text(
            title,
            style: const TextStyle(color: AppColors.splashTextColour, fontSize: AppDimensions.timeFontSize, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}