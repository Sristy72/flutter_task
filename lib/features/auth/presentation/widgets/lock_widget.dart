import 'package:flutter/material.dart';

import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_icons.dart';

class Lock extends StatelessWidget {
  const Lock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lockBack,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 0),
            blurRadius: 20,
            spreadRadius: 0,
          )
        ],
        border: Border.all(
          color: AppColors.textFieldBorderColor,
          width: 1,
        ),
      ),
      child: Center(
        child: Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.lockBack,
            border: Border.all(
              color: AppColors.textFieldBorderColor,
              width: 2,
            ),
          ),
          child: Center(
            child: Image.asset(
              AppIcons.lock,
              width: 36,
              height: 36,
            ),
          ),
        ),
      ),
    );
  }
}