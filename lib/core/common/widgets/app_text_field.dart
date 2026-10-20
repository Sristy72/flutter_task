import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Color color;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final Color borderColor;
  final double borderRadius;


  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.color = Colors.white,
    this.suffixIcon,
    this.borderColor = Colors.blue,
    required this.borderRadius, this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey
        ),
        fillColor: Colors.white,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor,
            width: 1.5
          )
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor,
              width: 1.5
          )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor,
              width: 1.5
          )
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
              width: 1.5
          )
        ),
      ),
    );
  }
}