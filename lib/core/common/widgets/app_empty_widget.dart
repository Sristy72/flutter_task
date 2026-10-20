import 'package:flutter/material.dart';

class AppEmptyWidget extends StatelessWidget {
  final String message;

  const AppEmptyWidget({
    super.key,
    this.message = 'No data found',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}