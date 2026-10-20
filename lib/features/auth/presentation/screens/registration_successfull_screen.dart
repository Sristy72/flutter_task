import 'package:flutter/material.dart';

import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';
import '../../../../core/theme/app_icons.dart';

class RegistrationSuccessfullScreen extends StatelessWidget {
  const RegistrationSuccessfullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppIcons.successIcon, width: 192, height: 192),
                  SizedBox(height: AppDimensions.heightBetweenButtonAndText),
                  Text(
                    'Registration Successful',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: AppDimensions.heightBetweenButtonAndText,
                      color: AppColors.deenColor,
                    ),
                  ),
                  SizedBox(height: AppDimensions.radiusMedium),
                  Text(
                    'Your account has been created successfully. Welcome to Deen.',
                    style: TextStyle(
                      fontSize: AppDimensions.fontSizeMedium,
                      fontWeight: FontWeight.w400,
                      color: AppColors.splashTextColour,
                    ),
                  ),
                  SizedBox(height: AppDimensions.largeTextGap),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: PrimaryButton(
                      text: 'Go to home',
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.home,
                          (route) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
