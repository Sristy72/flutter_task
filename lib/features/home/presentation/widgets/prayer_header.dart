import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_task/core/theme/app_colours.dart';
import 'package:flutter_task/core/theme/app_dimentions.dart';
import 'package:flutter_task/core/theme/app_icons.dart';

import 'dottet_border.dart';

class PrayerHeader extends StatelessWidget {
  const PrayerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppDimensions.boldFontSize)),
        image: DecorationImage(
          image: AssetImage(AppIcons.homeBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: AppDimensions.largeFont),
          const SizedBox(height: AppDimensions.heightMedium),

          // Location
          Container(
              height: AppDimensions.paddingLarge,
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.backButtonIconSize),
              decoration: BoxDecoration(
                color: AppColors.locationBackColor,
                borderRadius: BorderRadius.circular(
                  AppDimensions.lockBorderRadius,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.primaryButton,
                    size: 18,
                  ),
                  SizedBox(width: AppDimensions.paddingSmall),
                  Text(
                    'Gulshan, Dhaka',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppDimensions.fontSizeMedium,
                      fontWeight: FontWeight.w500,
                      letterSpacing: AppDimensions.letterSpacing,
                    ),
                  ),
                ],
              ),
            ),


          const SizedBox(height: AppDimensions.heightMedium),

          // Hijri date
          Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              '3 Jumada Al-Awwal, 1447 H',
              style: TextStyle(
                color: Colors.white,
                fontSize: AppDimensions.radiusLarge,
                fontWeight: FontWeight.w500,
                letterSpacing: AppDimensions.letterSpacing,
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.radiusMedium),

          // Current time and Gregorian date
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        '18',
                        style: TextStyle(
                          fontSize: AppDimensions.largeFont,
                          fontWeight: FontWeight.w700,
                          color: AppColors.timeColor,
                        ),
                      ),
                      Text(
                        ':55',
                        style: TextStyle(
                          fontSize: AppDimensions.largeFont,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.radiusSmall),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 26),
                  child: Text(
                    'Sat, 25 Oct 2025',
                    style: TextStyle(
                      color: AppColors.dateColor,
                      fontWeight: FontWeight.w400,
                      fontSize: AppDimensions.heightMedium,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.radiusMedium),

          // Next prayer countdown
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.namazBackColor,
                borderRadius: BorderRadius.circular(AppDimensions.lockBorderRadius),
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: AppColors.namazColor,
                    fontSize: AppDimensions.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.access_time,
                        color: AppColors.namazColor,
                        size: 14,
                      ),
                    ),
                    const TextSpan(text: ' Maghrib in '),
                    _countdownSpan('0'),
                    const TextSpan(text: 'h '),
                    _countdownSpan('29'),
                    const TextSpan(text: 'm '),
                    _countdownSpan('3'),
                    const TextSpan(text: 's left'),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.paddingLarge),

          // Prayer timeline
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _prayerItem(
                time: '04:03',
                icon: AppIcons.fajr,
                name: 'Fajr',
                isFajr: true,
                isCompleted: true,
              ),
              _prayerItem(
                time: '11:37',
                icon: AppIcons.dhuhr,
                name: 'Dhuhr',
                isActive: true,
              ),
              _prayerItem(time: '15:00', icon: AppIcons.asr, name: 'Asr'),
              _prayerItem(
                time: '17:48',
                icon: AppIcons.maghrib,
                name: 'Maghrib',
              ),
              _prayerItem(time: '19:02', icon: AppIcons.fajr, name: 'Isha'),
            ],
          ),
        ],
      ),
    );
  }

  static TextSpan _countdownSpan(String value) {
    return TextSpan(
      text: value,
      style: TextStyle(
        color: AppColors.namazTextColor,
        fontSize: AppDimensions.fontSizeMedium,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _prayerItem({
    required String time,
    required String icon,
    required String name,
    bool isActive = false,
    bool isCompleted = false,
    bool isFajr = false,
  }) {
    final bool hasPrimaryBackground = !isFajr && (isActive || isCompleted);

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Active prayer time moves upward.
          Transform.translate(
            offset: Offset(0, isActive ? -5 : 0),
            child: Text(
              time,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isActive
                    ? AppColors.primaryButton
                    : AppColors.splashTextColour,
                fontSize: isActive
                    ? AppDimensions.timeFontSize + 1
                    : AppDimensions.timeFontSize,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Prayer icon and circular border.
          Container(
            width: isActive ? 56 : 42,
            height: isActive ? 56 : 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hasPrimaryBackground
                  ? AppColors.primaryButton
                  : const Color(0xFF101419),
              border: !isFajr && !hasPrimaryBackground
                  ? Border.all(color: AppColors.textFieldBorderColor, width: 1)
                  : null,
            ),
            child: CustomPaint(
              foregroundPainter: isFajr
                  ? DottedCirclePainter(color: AppColors.primaryButton)
                  : null,
              child: Padding(
                padding: EdgeInsets.all(isActive ? 17 : 8),
                child: Image.asset(
                  icon,
                  fit: BoxFit.contain,
                  color: hasPrimaryBackground
                      ? Colors.black
                      : const Color(0xFF78808E),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.paddingSmall),

          // Prayer name.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isActive
                    ? AppColors.primaryButton
                    : isCompleted && !isFajr
                    ? AppColors.primaryButton
                    : AppColors.splashTextColour,
                fontSize: isActive
                    ? AppDimensions.fontSizeMedium
                    : AppDimensions.radiusMedium,
                fontWeight: isActive || isCompleted
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
