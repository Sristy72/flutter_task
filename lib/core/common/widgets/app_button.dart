import 'package:flutter/material.dart';

import '../../theme/app_colours.dart';
import '../../theme/app_dimentions.dart';


class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final double? borderRadius;
  final double elevation;
  final FontWeight fontWeight;
  final Widget? icon;
  final bool isExpanded;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
    this.borderRadius,
    this.elevation = 0,
    this.fontWeight = FontWeight.w700,
    this.icon,
    this.isExpanded = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 10),
            blurRadius: 15,
            spreadRadius: -3,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryButton,
          disabledBackgroundColor:
              (backgroundColor ?? AppColors.primaryButton).withValues(alpha: 0.7),
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppDimensions.radiusLarge,
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor ?? AppColors.primaryButtonTextColor,
                  ),
                ),
              )
            : (icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon!,
                      const SizedBox(width: 8),
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: fontSize ?? AppDimensions.paddingMedium,
                          fontWeight: fontWeight,
                          color:
                              foregroundColor ?? AppColors.primaryButtonTextColor,
                        ),
                      ),
                    ],
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize ?? AppDimensions.paddingMedium,
                      fontWeight: fontWeight,
                      color:
                          foregroundColor ?? AppColors.primaryButtonTextColor,
                    ),
                  )),
      ),
    );

    return isExpanded
        ? SizedBox(
            width: double.infinity,
            child: button,
          )
        : button;
  }
}


class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight fontWeight;
  final double? borderRadius;
  final double? letterSpacing;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight = FontWeight.w500,
    this.borderRadius,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 10),
            blurRadius: 15,
            spreadRadius: -3,
          ),
        ]
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor:
          backgroundColor ?? AppColors.secondaryButtonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppDimensions.radiusLarge,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize ?? AppDimensions.radiusLarge,
            fontWeight: fontWeight,
            letterSpacing:
            letterSpacing ?? AppDimensions.letterSpacing,
            color: textColor ?? AppColors.deenColor,
          ),
        ),
      ),
    );
  }
}