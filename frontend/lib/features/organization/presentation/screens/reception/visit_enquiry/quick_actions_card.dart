import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_radius.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_card.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  String _formatTodayDate() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  String _formatCheckInTime() {
    final now = TimeOfDay.now();
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          AppSpacing.vLg,

          // Today's Date Row
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.backgroundDark.withAlpha(120)
                  : AppColors.backgroundLight.withAlpha(200),
              borderRadius: AppRadius.sm,
              border: Border.all(
                color: isDark
                    ? AppColors.borderDark.withAlpha(80)
                    : AppColors.borderLight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    AppSpacing.hSm,
                    Text(
                      "Today's Date",
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceCardDark
                        : AppColors.surfaceLight,
                    borderRadius: AppRadius.full,
                    border: Border.all(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                  child: Text(
                    _formatTodayDate(),
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.vMd,

          // Check-in Time Row
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.backgroundDark.withAlpha(120)
                  : AppColors.backgroundLight.withAlpha(200),
              borderRadius: AppRadius.sm,
              border: Border.all(
                color: isDark
                    ? AppColors.borderDark.withAlpha(80)
                    : AppColors.borderLight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    AppSpacing.hSm,
                    Text(
                      'Check-in Time',
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceCardDark
                        : AppColors.surfaceLight,
                    borderRadius: AppRadius.full,
                    border: Border.all(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                  child: Text(
                    _formatCheckInTime(),
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
