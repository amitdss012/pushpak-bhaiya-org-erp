import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../configuration/sidebar_menu_config.dart';
import 'sidebar_accordion_item.dart';

class AppSidebar extends StatefulWidget {
  final String currentPath;
  final VoidCallback? onCloseDrawer;

  const AppSidebar({super.key, required this.currentPath, this.onCloseDrawer});

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleNavigate(String path) {
    widget.onCloseDrawer?.call();
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isDashboardActive =
        widget.currentPath == RouteNames.dashboardPath ||
        widget.currentPath == '/dashboard';

    // Filter menu items by search query
    final filteredItems = SidebarMenuConfig.menuItems.where((item) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      final matchesParent = item.title.toLowerCase().contains(query);
      final matchesChild = item.subItems.any(
        (sub) => sub.title.toLowerCase().contains(query),
      );
      return matchesParent || matchesChild;
    }).toList();

    return Container(
      width: 270,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Brand & Organization Selector Header
            _buildBrandHeader(isDark),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Container(
                height: 36,
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
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search modules...',
                    hintStyle: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                      fontSize: 12,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 16,
                      color: isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 14),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),

            const Divider(height: 1),

            // Scrollable Menu Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top-level Dashboard Item
                    Material(
                      color: isDashboardActive
                          ? (isDark
                                ? AppColors.primary.withAlpha(45)
                                : AppColors.primary.withAlpha(20))
                          : Colors.transparent,
                      borderRadius: AppRadius.sm,
                      child: InkWell(
                        onTap: () => _handleNavigate(RouteNames.dashboardPath),
                        borderRadius: AppRadius.sm,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.dashboard_rounded,
                                size: 18,
                                color: isDashboardActive
                                    ? AppColors.primary
                                    : (isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight),
                              ),
                              AppSpacing.hSm,
                              Text(
                                'Dashboard',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: isDashboardActive
                                      ? AppColors.primary
                                      : (isDark
                                            ? AppColors.textPrimaryDark
                                            : AppColors.textPrimaryLight),
                                  fontWeight: isDashboardActive
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  fontSize: 13.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AppSpacing.vXs,

                    // Category Section Label
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        top: 12,
                        bottom: 6,
                      ),
                      child: Text(
                        'ORGANIZATION MODULES',
                        style: AppTypography.labelMedium.copyWith(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight,
                        ),
                      ),
                    ),

                    // Accordion List of All 17 Categories
                    ...filteredItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.5),
                        child: SidebarAccordionItem(
                          item: item,
                          currentPath: widget.currentPath,
                          onNavigate: _handleNavigate,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            // Bottom Profile / Session Footer
            _buildUserFooter(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              child: Icon(Icons.hub_rounded, color: Colors.white, size: 20),
            ),
          ),
          AppSpacing.hSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppConstants.appName,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  'Apex Group • Head Org',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserFooter(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary.withAlpha(isDark ? 50 : 30),
            child: Text(
              'SA',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
          AppSpacing.hSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Super Admin',
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'admin@apexgroup.org',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 10.5,
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              size: 18,
              color: isDark
                  ? AppColors.textMutedDark
                  : AppColors.textMutedLight,
            ),
            tooltip: 'Sign Out',
            onPressed: () => context.goNamed(RouteNames.login),
          ),
        ],
      ),
    );
  }
}
