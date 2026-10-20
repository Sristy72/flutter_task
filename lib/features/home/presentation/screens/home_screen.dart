import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/service/auth_storage_service.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _displayName = 'Believer';
  String _displayEmail = '';
  bool _isGuest = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final storage = getIt<AuthStorageService>();
    final isGuest = await storage.isGuest();
    final name = await storage.getUserName();
    final email = await storage.getUserEmail();

    if (mounted) {
      setState(() {
        _isGuest = isGuest;
        if (name != null && name.isNotEmpty) {
          _displayName = name;
        } else if (isGuest) {
          _displayName = 'Guest User';
        }
        if (email != null && email.isNotEmpty) {
          _displayEmail = email;
        }
      });
    }
  }

  void _handleLogout() {
    context.read<AuthBloc>().add(Logout());
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.splash,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.splash,
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0C0E0D),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0C0E0D),
          elevation: 0,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppIcons.moonImageWithBackground,
                width: 28,
                height: 28,
              ),
              const SizedBox(width: 8),
              const Text(
                'DEEN-STEP',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deenColor,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: AppColors.splashTextColour),
              tooltip: 'Logout',
              onPressed: _handleLogout,
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Welcome Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151816),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                    border: Border.all(
                      color: const Color(0xFF252B28),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: _isGuest
                                ? const Color(0xFF252B28)
                                : AppColors.primaryButton,
                            child: Icon(
                              _isGuest ? Icons.person_outline : Icons.person,
                              color: _isGuest
                                  ? AppColors.splashTextColour
                                  : AppColors.primaryButtonTextColor,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        _displayName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.deenColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _isGuest
                                            ? const Color(0xFF2A2D2B)
                                            : AppColors.primaryButton,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _isGuest ? 'Guest' : 'Member',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: _isGuest
                                              ? AppColors.splashTextColour
                                              : AppColors.primaryButtonTextColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_displayEmail.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    _displayEmail,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.splashTextColour,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isGuest
                            ? 'You are currently browsing as a guest. Register or sign in anytime to sync your progress.'
                            : 'Welcome back to your spiritual journey. May today be filled with barakah.',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.splashTextColour,
                          height: 1.4,
                        ),
                      ),
                      if (_isGuest) ...[
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 42,
                          child: PrimaryButton(
                            text: 'Create Full Account',
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.signup);
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 2. Section Title
                const Text(
                  'Daily Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deenColor,
                  ),
                ),

                const SizedBox(height: 14),

                // 3. Quick Habit Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        icon: Icons.mosque_outlined,
                        title: 'Prayers',
                        value: '5 Daily',
                        subtitle: 'Track your Salah',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        icon: Icons.auto_stories_outlined,
                        title: 'Quran',
                        value: 'Surah Al-Mulk',
                        subtitle: 'Daily recitation',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        icon: Icons.favorite_border_rounded,
                        title: 'Dhikr',
                        value: 'Morning',
                        subtitle: 'Remembrance of Allah',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        icon: Icons.local_fire_department_outlined,
                        title: 'Streak',
                        value: 'Day 1',
                        subtitle: 'Consistency is key',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // 4. Logout / Switch Button
                SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeight,
                  child: SecondaryButton(
                    text: 'Log Out',
                    onPressed: _handleLogout,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151816),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(
          color: const Color(0xFF252B28),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryButton, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.splashTextColour,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.deenColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.hintColor,
            ),
          ),
        ],
      ),
    );
  }
}
