import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/splash/widgets/background_dot.dart';
import '../../core/common/widgets/app_button.dart';
import '../../core/routing/app_routes.dart';

import '../../core/theme/app_colours.dart';
import '../../core/theme/app_dimentions.dart';
import '../../core/theme/app_icons.dart';
import '../auth/presentation/bloc/auth_bloc.dart';
import '../auth/presentation/bloc/auth_event.dart';
import '../auth/presentation/bloc/auth_state.dart';

class DeenSplashScreen extends StatefulWidget {
  const DeenSplashScreen({super.key});

  @override
  State<DeenSplashScreen> createState() => _DeenSplashScreenState();
}

class _DeenSplashScreenState extends State<DeenSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> mosqueSlideAnimation;
  late Animation<double> mosqueFadeAnimation;
  late Animation<double> buttonFadeAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Mosque slides smoothly up from the below
    mosqueSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.15, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    mosqueFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
      ),
    );

    // Buttons fade in once mosque has largely risen into position
    buttonFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.65, 1.0, curve: Curves.easeIn),
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          final message = state.successMsg ??
              (state.isGuest ? 'Welcome, Guest!' : 'Welcome back!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
                style: const TextStyle(color: AppColors.secondaryButtonColor),
              ),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          );
        } else if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMsg ?? 'Guest login failed'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

        return Scaffold(
          backgroundColor: const Color(0xFF0C0E0D),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // 1. Solid dark background
                  Container(color: const Color(0xFF0C0E0D)),

                  // 2. Figma background starry dots
                  Positioned.fill(
                    child: CustomPaint(
                      painter: const DotBackgroundPainter(),
                    ),
                  ),

                  // 3. Mosque image animated from below
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SlideTransition(
                      position: mosqueSlideAnimation,
                      child: FadeTransition(
                        opacity: mosqueFadeAnimation,
                        child: Image.asset(
                          AppIcons.mosqueImage,
                          fit: BoxFit.cover,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                  // 4. Logo and app title
                  Positioned(
                    top: constraints.maxHeight * 0.32,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Container(
                          width: AppDimensions.moonHeight,
                          height: AppDimensions.moonHeight,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppDimensions.moonRadius),
                          ),
                          child: Image.asset(AppIcons.moonImageWithBackground),
                        ),
                        const SizedBox(height: AppDimensions.heightMedium),
                        const Text(
                          'DEEN-STEP',
                          style: TextStyle(
                            fontSize: AppDimensions.boldFontSize,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deenColor,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.heightMedium1),
                        const Text(
                          'Every step counts. Track your habit, build\n'
                          'consistency, elevate your spiritual journey.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppDimensions.fontSizeMedium,
                            letterSpacing: AppDimensions.letterSpacing,
                            color: AppColors.splashTextColour,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 5. Welcome buttons (appear after mosque slide)
                  Positioned(
                    bottom: constraints.maxHeight * 0.037,
                    left: 18,
                    right: 18,
                    child: FadeTransition(
                      opacity: buttonFadeAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: AppDimensions.buttonHeight,
                            child: PrimaryButton(
                              text: 'Create Account',
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      Navigator.pushNamed(context, AppRoutes.signup);
                                    },
                            ),
                          ),

                          const SizedBox(height: AppDimensions.paddingMedium),

                          SizedBox(
                            width: double.infinity,
                            height: AppDimensions.buttonHeight,
                            child: SecondaryButton(
                              text: 'Already registered? Log In',
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      Navigator.pushNamed(context, AppRoutes.login);
                                    },
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    context.read<AuthBloc>().add(GuestLogin());
                                  },
                            child: isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryButton,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Continue as Guest',
                                    style: TextStyle(
                                      fontSize: AppDimensions.fontSizeMedium,
                                      color: AppColors.splashTextColour,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}