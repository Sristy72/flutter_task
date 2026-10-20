import 'package:flutter/material.dart';
import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final bool readOnly;

  const InputTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      textInputAction: textInputAction,
      readOnly: readOnly,
      style: const TextStyle(
        color: AppColors.deenColor,
        fontSize: AppDimensions.fontSizeMedium,
      ),
      cursorColor: AppColors.deenColor,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.hintColor,
          fontSize: AppDimensions.fontSizeMedium,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: AppColors.backButtonBackgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimensions.radiusMedium,
          ),
          borderSide: const BorderSide(
            color: AppColors.textFieldBorderColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimensions.radiusMedium,
          ),
          borderSide: const BorderSide(
            color: AppColors.textFieldBorderColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimensions.radiusMedium,
          ),
          borderSide: const BorderSide(
            color: AppColors.textFieldBorderColor,
            width: 1,
          ),
        ),
      ),
    );
  }
}
