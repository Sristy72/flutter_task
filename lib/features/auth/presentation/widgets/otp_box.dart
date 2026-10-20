import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';

class OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final FocusNode? prevFocusNode;
  final VoidCallback onCodeChanged;
  final bool hasError;

  const OtpBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onCodeChanged,
    this.nextFocusNode,
    this.prevFocusNode,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    focusNode.onKeyEvent = (node, event) {
      if (event is KeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.backspace &&
          controller.text.isEmpty &&
          prevFocusNode != null) {
        prevFocusNode!.requestFocus();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };

    return Expanded(
      child: ListenableBuilder(
        listenable: focusNode,
        builder: (context, _) {
          final isFocused = focusNode.hasFocus;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 72,
              decoration: BoxDecoration(
                color: AppColors.pinBoxBackgroundColor,
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusLarge,
                ),
                border: Border.all(
                  color: hasError
                      ? AppColors.error
                      : (isFocused
                          ? AppColors.pinBoxBnableBorderColor
                          : AppColors.pinBoxBorderColor),
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                maxLength: 1,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                cursorColor: AppColors.primaryButton,
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  filled: false,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    if (nextFocusNode != null) {
                      nextFocusNode!.requestFocus();
                    } else {
                      focusNode.unfocus();
                    }
                  }
                  onCodeChanged();
                },
              ),
            );
          },
      ),
    );
  }
}