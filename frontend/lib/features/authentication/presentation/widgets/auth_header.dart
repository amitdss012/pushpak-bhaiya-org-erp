import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    this.title = 'Welcome back',
    this.subtitle = 'Sign in to access your organization dashboard',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand logo icon badge
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(isDark ? 50 : 25),
            borderRadius: AppRadius.md,
            border: Border.all(
              color: AppColors.primary.withAlpha(isDark ? 80 : 50),
              width: 1.5,
            ),
          ),
          child: const Center(
            child: Icon(Icons.hub_rounded, color: AppColors.primary, size: 26),
          ),
        ),
        AppSpacing.vLg,
        Text(
          title,
          style: AppTypography.headlineLarge.copyWith(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          subtitle,
          style: AppTypography.bodyMedium.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
