import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/core/di/injection.dart';
import 'package:flutter_task/core/theme/app_icons.dart';
import 'package:flutter_task/features/home/presentation/home_bloc/home_bloc.dart';
import 'package:flutter_task/features/home/presentation/home_bloc/home_event.dart';
import 'package:flutter_task/features/home/presentation/home_bloc/home_state.dart';
import 'package:flutter_task/features/home/presentation/widgets/goal_cards.dart';
import 'package:flutter_task/features/home/presentation/widgets/prayer_header.dart';
import 'package:flutter_task/features/home/presentation/widgets/reflection_card.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';
import '../widgets/prayer_tracking_card.dart';
import '../widgets/short_cut_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeBloc>()..add(FetchDashboard()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.cardBackColor,
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    final data = state.data;

    // ── Loading / Saving Location ─────────────────────────────────────────────
    if ((state.status == HomeStatus.loading ||
            state.status == HomeStatus.savingLocation) &&
        data == null) {
      final isSaving = state.status == HomeStatus.savingLocation;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.primaryButton),
            const SizedBox(height: 16),
            Text(
              isSaving ? 'Getting your location…' : 'Loading prayer times…',
              style: const TextStyle(
                color: AppColors.hintColor,
                fontSize: AppDimensions.fontSizeMedium,
              ),
            ),
          ],
        ),
      );
    }

    // ── Location Permission Denied ────────────────────────────────────────────
    if (state.status == HomeStatus.locationPermissionDenied) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_off,
                  color: AppColors.primaryButton, size: 56),
              const SizedBox(height: 16),
              Text(
                state.errorMsg ?? 'Location permission denied.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.hintColor,
                  fontSize: AppDimensions.fontSizeMedium,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryButton,
                ),
                onPressed: () async {
                  await Geolocator.openAppSettings();
                },
                icon: const Icon(Icons.settings, size: 18),
                label: const Text('Open Settings'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () =>
                    context.read<HomeBloc>().add(FetchDashboard()),
                child: const Text(
                  'Retry',
                  style: TextStyle(color: AppColors.primaryButton),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ── Generic Error (no cached data) ────────────────────────────────────────
    if (state.status == HomeStatus.failure && data == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, color: AppColors.hintColor, size: 48),
              const SizedBox(height: 16),
              Text(
                state.errorMsg ?? 'Something went wrong',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.hintColor,
                  fontSize: AppDimensions.fontSizeMedium,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryButton,
                ),
                onPressed: () =>
                    context.read<HomeBloc>().add(FetchDashboard()),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // ── Loaded (with pull-to-refresh) ─────────────────────────────────────────
    return RefreshIndicator(
      color: AppColors.primaryButton,
      onRefresh: () async => context.read<HomeBloc>().add(FetchDashboard()),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          children: [
            PrayerHeader(data: data),
            const SizedBox(height: AppDimensions.radiusLarge),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  PrayerTrackingCard(
                    nextPrayer: data?.nextPrayer,
                    dailyGoal: data?.dailyGoal,
                  ),
                  const SizedBox(height: AppDimensions.heightMedium1),
                  GoalCards(
                    dailyGoal: data?.dailyGoal,
                    streak: data?.streak,
                  ),
                  const SizedBox(height: AppDimensions.heightMedium1),
                  ReflectionCard(aiReflection: data?.aiReflection),
                  const SizedBox(height: AppDimensions.heightMedium1),
                  _abundanceVerseCard(data?.abundanceVerse),
                  const SizedBox(height: AppDimensions.heightMedium1),
                  const ShortcutCards(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _abundanceVerseCard(dynamic abundanceVerse) {
    final reference =
        abundanceVerse?.reference as String? ?? 'Sahih al-Bukhari, 6412';
    final translation = abundanceVerse?.translation as String? ??
        'Start your daily verse by input them in reflections.';

    return Container(
      width: double.infinity,
      //height: 156,
      decoration: BoxDecoration(
        color: const Color(0xFF14211C),
        borderRadius:
            BorderRadius.circular(AppDimensions.heightBetweenButtonAndText),
        border: Border.all(color: AppColors.nextPrayerBorderColor, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -54,
            child: Transform.rotate(
              angle: -0.785398,
              child: Container(
                width: 210,
                height: 210,
                decoration:
                    BoxDecoration(color: AppColors.rotateBackColor),
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
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.menu_book,
                        color: AppColors.primaryButton, size: 22),
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
                        reference,
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
                const SizedBox(
                    height: AppDimensions.heightBetweenButtonAndText),
                Text(
                  translation,
                  maxLines: 2,
                  //overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.hintColor,
                    fontSize: AppDimensions.fontSizeMedium,
                    fontWeight: FontWeight.w500,
                    letterSpacing: AppDimensions.letterSpacing,
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
