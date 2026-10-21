import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_task/core/theme/app_colours.dart';
import 'package:flutter_task/core/theme/app_dimentions.dart';
import 'package:flutter_task/core/theme/app_icons.dart';
import 'package:flutter_task/features/home/data/models/responses/prayer_dashboard_response_model.dart';

import 'dottet_border.dart';

class PrayerHeader extends StatefulWidget {
  final PrayerResponseModel? data;

  const PrayerHeader({super.key, this.data});

  @override
  State<PrayerHeader> createState() => _PrayerHeaderState();
}

class _PrayerHeaderState extends State<PrayerHeader> {
  late DateTime _currentTime;
  Timer? _timer;
  int _secondsUntil = 0;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _secondsUntil = widget.data?.nextPrayer.secondsUntil ?? 0;
    _startTimer();
  }

  @override
  void didUpdateWidget(PrayerHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _secondsUntil = widget.data?.nextPrayer.secondsUntil ?? 0;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
          if (_secondsUntil > 0) {
            _secondsUntil--;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final timings = data?.timings;
    final nextPrayer = data?.nextPrayer;
    final location = data?.location;
    final hijri = data?.date.hijri;
    final gregorian = data?.date.gregorian;

    // Parse seconds until next prayer into h/m/s
    final secondsUntil = _secondsUntil;
    final h = secondsUntil ~/ 3600;
    final m = (secondsUntil % 3600) ~/ 60;
    final s = secondsUntil % 60;

    final locationText =
        location != null ? '${location.city}, ${location.countryCode}' : '—';

    final hijriText = hijri != null
        ? '${hijri.day} ${hijri.monthEn}, ${hijri.year} H'
        : '— Hijri';

    final gregorianText = _formatGregorianDate(gregorian, _currentTime);

    final hourStr = _currentTime.hour.toString().padLeft(2, '0');
    final minuteStr = ':${_currentTime.minute.toString().padLeft(2, '0')}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(AppDimensions.boldFontSize)),
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
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.backButtonIconSize),
            decoration: BoxDecoration(
              color: AppColors.locationBackColor,
              borderRadius: BorderRadius.circular(
                AppDimensions.lockBorderRadius,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.primaryButton,
                  size: 18,
                ),
                const SizedBox(width: AppDimensions.paddingSmall),
                Text(
                  locationText,
                  style: const TextStyle(
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
            child: Text(
              hijriText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: AppDimensions.radiusLarge,
                fontWeight: FontWeight.w500,
                letterSpacing: AppDimensions.letterSpacing,
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.radiusMedium),

          // Current time & Gregorian date
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        hourStr,
                        style: const TextStyle(
                          fontSize: AppDimensions.largeFont,
                          fontWeight: FontWeight.w700,
                          color: AppColors.timeColor,
                        ),
                      ),
                      Text(
                        minuteStr,
                        style: const TextStyle(
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 26),
                  child: Text(
                    gregorianText,
                    style: const TextStyle(
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
          if (nextPrayer != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.namazBackColor,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.lockBorderRadius),
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
                      TextSpan(text: ' ${nextPrayer.name} in '),
                      _countdownSpan('$h'),
                      const TextSpan(text: 'h '),
                      _countdownSpan('$m'),
                      const TextSpan(text: 'm '),
                      _countdownSpan('$s'),
                      const TextSpan(text: 's left'),
                    ],
                  ),
                ),
              ),
            ),

          const SizedBox(height: AppDimensions.paddingLarge),

          // Prayer timeline
          if (timings != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _prayerItem(
                  time: timings.fajr,
                  icon: AppIcons.fajr,
                  name: 'Fajr',
                  isFajr: true,
                ),
                _prayerItem(
                  time: timings.dhuhr,
                  icon: AppIcons.dhuhr,
                  name: 'Dhuhr',
                  isActive: nextPrayer?.name.toLowerCase() == 'dhuhr',
                ),
                _prayerItem(
                  time: timings.asr,
                  icon: AppIcons.asr,
                  name: 'Asr',
                  isActive: nextPrayer?.name.toLowerCase() == 'asr',
                ),
                _prayerItem(
                  time: timings.maghrib,
                  icon: AppIcons.maghrib,
                  name: 'Maghrib',
                  isActive: nextPrayer?.name.toLowerCase() == 'maghrib',
                ),
                _prayerItem(
                  time: timings.isha,
                  icon: AppIcons.fajr,
                  name: 'Isha',
                  isActive: nextPrayer?.name.toLowerCase() == 'isha',
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _prayerItem(time: '—', icon: AppIcons.fajr, name: 'Fajr', isFajr: true),
                _prayerItem(time: '—', icon: AppIcons.dhuhr, name: 'Dhuhr'),
                _prayerItem(time: '—', icon: AppIcons.asr, name: 'Asr'),
                _prayerItem(time: '—', icon: AppIcons.maghrib, name: 'Maghrib'),
                _prayerItem(time: '—', icon: AppIcons.fajr, name: 'Isha'),
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

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static const _weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];

  String _formatGregorianDate(GregorianDate? gregorian, DateTime now) {
    if (gregorian != null && gregorian.date.isNotEmpty) {
      final parts = gregorian.date.split('-');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final monthIdx = int.tryParse(parts[1]);
        final month = (monthIdx != null && monthIdx >= 1 && monthIdx <= 12)
            ? _months[monthIdx - 1]
            : parts[1];
        final year = parts[2];
        final dayName = gregorian.weekdayEn.length >= 3
            ? gregorian.weekdayEn.substring(0, 3)
            : gregorian.weekdayEn;
        return '$dayName, $day $month $year';
      }
    }

    final dayName = _weekdays[now.weekday - 1];
    final day = now.day.toString().padLeft(2, '0');
    final month = _months[now.month - 1];
    final year = now.year.toString();
    return '$dayName, $day $month $year';
  }
}
