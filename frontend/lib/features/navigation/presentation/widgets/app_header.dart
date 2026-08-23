import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../configuration/sidebar_menu_config.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String currentPath;
  final VoidCallback? onOpenDrawer;

  const AppHeader({super.key, required this.currentPath, this.onOpenDrawer});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  String _getPageTitle() {
    if (currentPath == '/dashboard' || currentPath == '/') {
      return 'Overview Dashboard';
    }
    final match = SidebarMenuConfig.findByPath(currentPath);
    if (match != null) {
      return '${match.parent.title} / ${match.item.title}';
    }
    return 'Management';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop || context.isUltraWide;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Hamburger button on mobile / tablet
            if (!isDesktop) ...[
              IconButton(
                icon: const Icon(Icons.menu_rounded, size: 22),
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                onPressed: onOpenDrawer,
                tooltip: 'Open Menu',
              ),
              AppSpacing.hXs,
            ],

            // Breadcrumb / Title
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      _getPageTitle(),
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: isMobile ? 14 : 16,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Branch Selector Dropdown (Desktop & Tablet)
            if (!isMobile) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceCardDark
                      : AppColors.backgroundLight,
                  borderRadius: AppRadius.sm,
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.domain_rounded,
                      size: 15,
                      color: AppColors.primary,
                    ),
                    AppSpacing.hSm,
                    Text(
                      'All Branches (8)',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    AppSpacing.hXs,
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 18,
                      color: isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                    ),
                  ],
                ),
              ),
              AppSpacing.hMd,
            ],

            // Notifications Bell
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, size: 20),
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  onPressed: () {},
                  tooltip: 'Notifications',
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
