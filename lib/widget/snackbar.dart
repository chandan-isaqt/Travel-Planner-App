import 'package:flutter/material.dart';

class TopSnackBar {
  static bool isVisible = false; 

  static void show(
    BuildContext context, {
    required String message,
    Color backgroundColor = Colors.green,
    IconData icon = Icons.check_circle_outline,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (isVisible) return;

    isVisible = true;

    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            padding: const EdgeInsets.all(16),
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            duration: duration,
          ),
        )
        .closed
        .then((_) {
          isVisible = false;
        });
  }
}
