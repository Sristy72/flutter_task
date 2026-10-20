import 'package:flutter/material.dart';

import 'app_colours.dart';
import 'app_dimentions.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static const Color darkBackground = AppColors.background;

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    splashFactory: NoSplash.splashFactory,

    scaffoldBackgroundColor: darkBackground,


    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      surface: darkBackground,
    ),

    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(Colors.black),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return Colors.transparent;
      }),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.heading,
      iconTheme: IconThemeData(color: Colors.white),
    ),


    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF151816),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppDimensions.radiusLarge,
        ),
        borderSide: const BorderSide(
          color: Color(0xFF252B28),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppDimensions.radiusLarge,
        ),
        borderSide: const BorderSide(
          color: Color(0xFF252B28),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppDimensions.radiusLarge,
        ),
        borderSide: const BorderSide(
          color: AppColors.primaryButton,
        ),
      ),
    ),
  );
}
