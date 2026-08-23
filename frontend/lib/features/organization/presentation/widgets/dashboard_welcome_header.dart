import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_button.dart';

class DashboardWelcomeHeader extends StatelessWidget {
  const DashboardWelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Welcome, Super Admin',
                    style:
                        (isMobile
                                ? AppTypography.titleLarge
                                : AppTypography.headlineMedium)
                            .copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              fontWeight: FontWeight.w700,
                            ),
                  ),
                  AppSpacing.hSm,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withAlpha(isDark ? 40 : 25),
                      borderRadius: AppRadius.full,
                      border: Border.all(
                        color: AppColors.success.withAlpha(80),
                      ),
                    ),
                    child: Text(
                      'Live Org Sync',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.success,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.vXs,
              Text(
                'Apex International Group • Multi-branch centralized operations and financial overview',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        if (!isMobile) ...[
          AppSpacing.hMd,
          Row(
            children: [
              AppButton(
                text: 'Add Branch',
                height: 40,
                icon: Icons.add_business_rounded,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ],
    );
  }
}
