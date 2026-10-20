import 'package:flutter/material.dart';

class AppDialog {
  AppDialog._();

  static Future<void> showConfirmation(
      BuildContext context, {
        required String title,
        required String message,
        required VoidCallback onConfirm,
      }) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}