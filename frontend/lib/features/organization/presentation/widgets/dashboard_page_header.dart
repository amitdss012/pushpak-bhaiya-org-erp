import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';

class DashboardPageHeader extends StatelessWidget {
  final String title;
  final String description;

  const DashboardPageHeader({
    super.key,
    this.title = 'Dashboard',
    this.description =
        "Welcome back! Here's an overview of your school's performance.",
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          description,
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
