import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class PlatformDashboardScreen extends StatelessWidget {
  const PlatformDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 40,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon Badge
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: AppRadius.md,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withAlpha(100),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.admin_panel_settings_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                    AppSpacing.vLg,

                    // Headline
                    Text(
                      'Welcome to Platform Panel',
                      textAlign: TextAlign.center,
                      style: AppTypography.headlineMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    AppSpacing.vSm,

                    // Subtitle
                    Text(
                      'Global administration for multi-tenant organizations, subscription plans, branch management, and platform analytics.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    AppSpacing.vXl,

                    // Stats Quick Summary Row
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.backgroundDark.withAlpha(120)
                            : AppColors.primaryLight.withAlpha(140),
                        borderRadius: AppRadius.md,
                        border: Border.all(
                          color: isDark
                              ? AppColors.borderDark
                              : AppColors.primary.withAlpha(40),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            context: context,
                            title: 'Organizations',
                            value: '24',
                            icon: Icons.corporate_fare_rounded,
                            isDark: isDark,
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                          ),
                          _buildStatItem(
                            context: context,
                            title: 'Active Branches',
                            value: '108',
                            icon: Icons.domain_rounded,
                            isDark: isDark,
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                          ),
                          _buildStatItem(
                            context: context,
                            title: 'System Health',
                            value: '99.9%',
                            icon: Icons.cloud_done_rounded,
                            isDark: isDark,
                            valueColor: AppColors.success,
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.vXl,

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: 'Back to Login',
                            variant: AppButtonVariant.outline,
                            icon: Icons.arrow_back_rounded,
                            onPressed: () => context.goNamed(RouteNames.login),
                            height: 44,
                          ),
                        ),
                        AppSpacing.hMd,
                        Expanded(
                          child: AppButton(
                            text: 'Sign Out',
                            icon: Icons.logout_rounded,
                            onPressed: () => context.goNamed(RouteNames.platformLogin),
                            height: 44,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required bool isDark,
    Color? valueColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        AppSpacing.vXs,
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: valueColor ??
                (isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight),
          ),
        ),
        Text(
          title,
          style: AppTypography.bodySmall.copyWith(
            color: isDark
                ? AppColors.textMutedDark
                : AppColors.textMutedLight,
          ),
        ),
      ],
    );
  }
}
