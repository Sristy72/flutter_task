import 'package:flutter/material.dart';

import '../../../../core/theme/app_colours.dart';

class TextWidget extends StatelessWidget {
  final String text;

  const TextWidget({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.hintColor,
        ),
      ),
    );
  }
}