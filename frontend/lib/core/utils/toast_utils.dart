import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../app/router/app_router.dart';
import '../errors/api_exception.dart';
import '../errors/failures.dart';

/// Global key to access [ScaffoldMessengerState] from anywhere in the app.
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Unified Toast/SnackBar utility with clean styling and auto-dismiss.
class AppToast {
  AppToast._();

  /// Display a success toast message.
  static void showSuccess(String message) {
    if (message.trim().isEmpty) return;
    _showToast(
      message: message.trim(),
      backgroundColor: const Color(0xFF10B981), // Emerald 500
      icon: Icons.check_circle_rounded,
    );
  }

  /// Display an error toast message with auto unwrapping of backend error message.
  static void showError(
    dynamic error, {
    String fallback = 'An unexpected error occurred',
  }) {
    String message = fallback;
    if (error != null) {
      if (error is ApiException) {
        message = error.message;
      } else if (error is Failure) {
        message = error.message;
      } else if (error is DioException) {
        final data = error.response?.data;
        if (data is Map &&
            data['message'] is String &&
            (data['message'] as String).trim().isNotEmpty) {
          message = data['message'] as String;
        } else if (error.error is ApiException) {
          message = (error.error as ApiException).message;
        } else if (error.message != null && error.message!.trim().isNotEmpty) {
          message = error.message!;
        }
      } else {
        try {
          final dynamic dyn = error;
          if (dyn.message is String && (dyn.message as String).trim().isNotEmpty) {
            message = dyn.message as String;
          } else if (dyn.response?.data is Map &&
              dyn.response.data['message'] is String &&
              (dyn.response.data['message'] as String).trim().isNotEmpty) {
            message = dyn.response.data['message'] as String;
          } else {
            message = error.toString().replaceAll('Exception: ', '').trim();
          }
        } catch (_) {
          message = error.toString().replaceAll('Exception: ', '').trim();
        }
      }
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
    if (message.trim().isEmpty) return;
    _showToast(
      message: message.trim(),
      backgroundColor: const Color(0xFF3B82F6), // Blue 500
      icon: Icons.info_rounded,
    );
  }

  static void _showToast({
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    var state = rootScaffoldMessengerKey.currentState;
    if (state == null) {
      final navContext = AppRouter.rootNavigatorKey.currentContext;
      if (navContext != null && navContext.mounted) {
        state = ScaffoldMessenger.maybeOf(navContext);
      }
    }

    if (state == null) {
      debugPrint('[AppToast] ScaffoldMessenger is not ready: $message');
      return;
    }

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
