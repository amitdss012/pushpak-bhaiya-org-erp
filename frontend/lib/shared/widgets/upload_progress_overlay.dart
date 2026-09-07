import 'dart:ui';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/extensions/context_extensions.dart';

/// Reusable full-screen overlay for displaying image upload and compression progress.
/// Can wrap any screen or widget tree to provide a clean, modern, non-blocking UX.
class UploadProgressOverlay extends StatelessWidget {
  /// Whether the overlay is currently visible.
  final bool isVisible;

  /// Progress value between 0.0 and 1.0 (use null or <= 0 for indeterminate animation).
  final double? progress;

  /// Header title for the overlay dialog (e.g., "Uploading Image", "Processing Logo").
  final String title;

  /// Optional subtitle or detail message (e.g., "Compressing under 100 KB... 65%").
  final String? status;

  /// The underlying screen or widget to be overlaid.
  final Widget child;

  const UploadProgressOverlay({
    super.key,
    required this.isVisible,
    required this.child,
    this.progress,
    this.title = 'Uploading Image',
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Stack(
      children: [
        // Base Content
        child,

        // Fullscreen Progress Overlay
        if (isVisible)
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 200),
                builder: (context, opacity, _) {
                  return Opacity(
                    opacity: opacity,
                    child: Stack(
                      children: [
                        // Frosted Glass Blur Backdrop
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container(
                            color: Colors.black.withAlpha(isDark ? 140 : 100),
                          ),
                        ),

                        // Centered Modal Card
                        Center(
                          child: RepaintBoundary(
                            child: Container(
                              width: 340,
                              margin: const EdgeInsets.symmetric(horizontal: 24),
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.surfaceCardDark
                                    : AppColors.surfaceCardLight,
                                borderRadius: AppRadius.lg,
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.borderDark
                                      : AppColors.borderLight,
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(isDark ? 90 : 40),
                                    blurRadius: 30,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Animated Cloud Upload Icon with Glow
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary.withAlpha(isDark ? 40 : 25),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.cloud_upload_rounded,
                                        color: AppColors.primary,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                  AppSpacing.vMd,

                                  // Overlay Title
                                  Text(
                                    title,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.titleMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  AppSpacing.vXs,

                                  // Status Description
                                  Text(
                                    status ?? 'Processing image...',
                                    textAlign: TextAlign.center,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                  AppSpacing.vLg,

                                  // Progress Bar
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                      value: (progress != null && progress! > 0.0)
                                          ? progress!.clamp(0.0, 1.0)
                                          : null,
                                      minHeight: 8,
                                      backgroundColor: isDark
                                          ? AppColors.borderDark
                                          : AppColors.borderLight,
                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  AppSpacing.vSm,

                                  // Percentage Label
                                  if (progress != null && progress! > 0.0)
                                    Text(
                                      '${(progress! * 100).toInt()}%',
                                      style: AppTypography.labelMedium.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
