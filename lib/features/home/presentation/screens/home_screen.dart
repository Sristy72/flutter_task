import 'package:flutter/material.dart';
import 'package:flutter_task/core/theme/app_icons.dart';
import 'package:flutter_task/features/home/presentation/widgets/goal_cards.dart';
import 'package:flutter_task/features/home/presentation/widgets/prayer_header.dart';
import 'package:flutter_task/features/home/presentation/widgets/reflection_card.dart';
import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';
import '../widgets/prayer_tracking_card.dart';
import '../widgets/short_cut_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          children: [
            PrayerHeader(),
            const SizedBox(height: AppDimensions.radiusLarge),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  PrayerTrackingCard(),
                  const SizedBox(height: AppDimensions.heightMedium1),
                  GoalCards(),
                  const SizedBox(height: AppDimensions.heightMedium1),
                  ReflectionCard(),
                  const SizedBox(height: AppDimensions.heightMedium1),
                  _abundanceVerseCard(),
                  const SizedBox(height: AppDimensions.heightMedium1),
                  ShortcutCards(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Abundance verse
  Widget _abundanceVerseCard() {
    return Container(
      width: double.infinity,
      height: 156,
      decoration: BoxDecoration(
        color: const Color(0xFF14211C),
        borderRadius: BorderRadius.circular(AppDimensions.heightBetweenButtonAndText),
        border: Border.all(
          color: AppColors.nextPrayerBorderColor,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background image on the right

          // Dark gradient overlay
          // Diagonal background shape (-45 degrees)
          // Diagonal background shape (-45 degrees)
          Positioned(
            top: -40,
            right: -54,
            child: Transform.rotate(
              angle: -0.785398, // -45 degrees in radians
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  color: AppColors.rotateBackColor,
                ),
              ),
            ),
          ),

          Positioned(
            top: 0,
            right: 0,
            bottom: 24,
            width: 135,
            child: Image.asset(
              AppIcons.book,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          // Card content
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.menu_book,
                      color: AppColors.primaryButton,
                      size: 22,
                    ),
                    const SizedBox(width: AppDimensions.radiusSmall),

                    const Expanded(
                      child: Text(
                        'ABUNDANCE VERSE',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.deenColor,
                          fontSize: AppDimensions.heightMedium,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Flexible(
                      child: Text(
                        'Sahih al-Bukhari, 6412',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: AppColors.dontHaveAccountColor,
                          fontSize: AppDimensions.heightMedium,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.heightBetweenButtonAndText),

                const Text(
                  'Start your daily verse by input them in reflections.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.hintColor,
                    fontSize: AppDimensions.fontSizeMedium,
                    fontWeight: FontWeight.w500,
                    letterSpacing: AppDimensions.letterSpacing
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
