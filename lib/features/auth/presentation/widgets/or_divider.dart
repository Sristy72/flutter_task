import 'package:flutter/material.dart';

import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.dividerColor,
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.radiusMedium,
          ),
          child: Text(
            'OR',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMedium,
              fontWeight: FontWeight.w400,
              color: AppColors.hintColor,
              letterSpacing: AppDimensions.letterSpacing,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.dividerColor,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}