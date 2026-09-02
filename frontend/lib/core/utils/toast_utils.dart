import 'package:flutter/material.dart';

/// Global key to access [ScaffoldMessengerState] from anywhere in the app.
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Unified Toast/SnackBar utility with clean styling and auto-dismiss.
class AppToast {
  AppToast._();

  /// Display a success toast message.
  static void showSuccess(String message) {
    _showToast(
      message: message,
      backgroundColor: const Color(0xFF10B981), // Emerald 500
      icon: Icons.check_circle_rounded,
    );
  }

  /// Display an error toast message with auto unwrapping of Exception strings.
  static void showError(
    dynamic error, {
    String fallback = 'An unexpected error occurred',
  }) {
    String message = fallback;
    if (error != null) {
      message = error.toString().replaceAll('Exception: ', '').trim();
      if (message.isEmpty) message = fallback;
    }

    _showToast(
      message: message,
      backgroundColor: const Color(0xFFEF4444), // Red 500
      icon: Icons.error_rounded,
    );
  }

  /// Display an informative toast message.
  static void showInfo(String message) {
    _showToast(
      message: message,
      backgroundColor: const Color(0xFF3B82F6), // Blue 500
      icon: Icons.info_rounded,
    );
  }

  static void _showToast({
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    final state = rootScaffoldMessengerKey.currentState;
    if (state == null) return;

    state.removeCurrentSnackBar();
    state.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
