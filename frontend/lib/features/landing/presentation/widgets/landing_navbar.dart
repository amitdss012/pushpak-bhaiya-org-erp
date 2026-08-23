import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/max_width_container.dart';

class LandingNavbar extends StatelessWidget {
  final VoidCallback? onFeaturesClick;
  final VoidCallback? onStructureClick;
  final VoidCallback? onPlatformClick;

  const LandingNavbar({
    super.key,
    this.onFeaturesClick,
    this.onStructureClick,
    this.onPlatformClick,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: (isDark ? AppColors.backgroundDark : AppColors.surfaceLight)
            .withAlpha(240),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: MaxWidthContainer(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Brand Logo
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => context.goNamed(RouteNames.landing),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                        borderRadius: AppRadius.sm,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.hub_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    AppSpacing.hSm,
                    Text(
                      AppConstants.appName,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Navigation Links (Desktop only)
            if (context.isDesktop || context.isUltraWide) ...[
              Row(
                children: [
                  _NavLink(title: 'Features', onTap: onFeaturesClick),
                  AppSpacing.hLg,
                  _NavLink(title: 'Architecture', onTap: onStructureClick),
                  AppSpacing.hLg,
                  _NavLink(title: 'Platform', onTap: onPlatformClick),
                ],
              ),
            ],

            // Action Buttons
            Row(
              children: [
                TextButton(
                  onPressed: () => context.goNamed(RouteNames.login),
                  child: Text(
                    'Sign In',
                    style: AppTypography.labelLarge.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                ),
                AppSpacing.hSm,
                AppButton(
                  text: 'Get Started',
                  height: 40,
                  onPressed: () => context.goNamed(RouteNames.login),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _NavLink({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: AppTypography.bodyMedium.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
