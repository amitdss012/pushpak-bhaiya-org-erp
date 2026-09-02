import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';

enum OrgStatsCardVariant {
  defaultVariant,
  primary,
  info,
  success,
  warning,
}

class OrgStatsCardTrend {
  final num value;
  final bool isPositive;

  const OrgStatsCardTrend({
    required this.value,
    required this.isPositive,
  });
}

class OrgStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final OrgStatsCardTrend? trend;
  final OrgStatsCardVariant variant;

  const OrgStatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.trend,
    this.variant = OrgStatsCardVariant.defaultVariant,
  });

  Color _getAccentColor() {
    switch (variant) {
      case OrgStatsCardVariant.primary:
        return AppColors.primary;
      case OrgStatsCardVariant.info:
        return AppColors.info;
      case OrgStatsCardVariant.success:
        return AppColors.success;
      case OrgStatsCardVariant.warning:
        return AppColors.warning;
      case OrgStatsCardVariant.defaultVariant:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final accentColor = _getAccentColor();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? accentColor.withAlpha(20)
            : accentColor.withAlpha(12),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark
              ? accentColor.withAlpha(50)
              : accentColor.withAlpha(35),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                AppSpacing.vXs,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: AppTypography.headlineMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    if (trend != null) ...[
                      AppSpacing.hSm,
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            trend!.isPositive
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            size: 12,
                            color: trend!.isPositive
                                ? AppColors.success
                                : AppColors.error,
                          ),
                          Text(
                            '${trend!.isPositive ? '+' : ''}${trend!.value}%',
                            style: AppTypography.bodySmall.copyWith(
                              color: trend!.isPositive
                                  ? AppColors.success
                                  : AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                if (subtitle != null) ...[
                  AppSpacing.vXs,
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withAlpha(isDark ? 50 : 25),
              borderRadius: AppRadius.sm,
            ),
            child: Icon(
              icon,
              size: 22,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
