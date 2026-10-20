import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  bool get isTablet => screenWidth >= 600;

  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
}