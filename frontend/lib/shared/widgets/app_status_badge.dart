import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/extensions/context_extensions.dart';

enum AppBadgeStatus {
  active,
  completed,
  pending,
  danger,
  warning,
  info,
}

class AppStatusBadge extends StatelessWidget {
  final AppBadgeStatus status;
  final String? customLabel;

  const AppStatusBadge({
    super.key,
    required this.status,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    Color color;
    String defaultLabel;
    IconData icon;

    switch (status) {
      case AppBadgeStatus.active:
        color = AppColors.info;
        defaultLabel = 'Active';
        icon = Icons.fiber_manual_record_rounded;
        break;
      case AppBadgeStatus.completed:
        color = AppColors.success;
        defaultLabel = 'Completed';
        icon = Icons.check_circle_outline_rounded;
        break;
      case AppBadgeStatus.pending:
        color = AppColors.warning;
        defaultLabel = 'Pending';
        icon = Icons.schedule_rounded;
        break;
      case AppBadgeStatus.danger:
        color = AppColors.error;
        defaultLabel = 'Failed';
        icon = Icons.cancel_outlined;
        break;
      case AppBadgeStatus.warning:
        color = AppColors.warning;
        defaultLabel = 'Warning';
        icon = Icons.warning_amber_rounded;
        break;
      case AppBadgeStatus.info:
        color = AppColors.primary;
        defaultLabel = 'Info';
        icon = Icons.info_outline_rounded;
        break;
    }

    final label = customLabel ?? defaultLabel;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(isDark ? 40 : 25),
        borderRadius: AppRadius.full,
        border: Border.all(
          color: color.withAlpha(isDark ? 80 : 50),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          AppSpacing.hXs,
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
