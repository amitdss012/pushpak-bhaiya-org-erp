import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/max_width_container.dart';

class FeatureSection extends StatelessWidget {
  const FeatureSection({super.key});

  static const List<FeatureData> _features = [
    FeatureData(
      icon: Icons.hub_outlined,
      title: 'Multi-Branch Management',
      description: 'Spin up, monitor, and manage unlimited geographic or virtual branches with isolated data partitioning.',
      color: Color(0xFF6366F1),
    ),
    FeatureData(
      icon: Icons.admin_panel_settings_outlined,
      title: 'Centralized Organization Control',
      description: 'Unified administrative dashboard for organization-wide governance, subscription tiers, and global policies.',
      color: Color(0xFF0EA5E9),
    ),
    FeatureData(
      icon: Icons.storefront_outlined,
      title: 'Branch-Level Autonomy',
      description: 'Each branch gets a tailored operations panel for daily attendance, fee collections, and local staff tasks.',
      color: Color(0xFF10B981),
    ),
    FeatureData(
      icon: Icons.school_outlined,
      title: 'Student & Enrolment Management',
      description: 'Comprehensive student lifecycle tracking, admissions, automated roll generation, and progress records.',
      color: Color(0xFFF59E0B),
    ),
    FeatureData(
      icon: Icons.people_outline_rounded,
      title: 'Staff & Faculty Management',
      description: 'Role-based access, attendance tracking, shift allocation, and performance visibility across all locations.',
      color: Color(0xFF8B5CF6),
    ),
    FeatureData(
      icon: Icons.menu_book_outlined,
      title: 'Course & Batch Scheduling',
      description: 'Standardized curriculum templates shared globally or customized per branch with automated batch allocation.',
      color: Color(0xFFEC4899),
    ),
    FeatureData(
      icon: Icons.insights_outlined,
      title: 'Enterprise Analytics & Reports',
      description: 'Consolidated executive reports alongside granular branch audits, revenue tracking, and cohort KPIs.',
      color: Color(0xFF14B8A6),
    ),
    FeatureData(
      icon: Icons.lock_outline_rounded,
      title: 'Enterprise-Grade Security',
      description: 'Granular Role-Based Access Control (RBAC), multi-tenant data boundaries, and audit logging.',
      color: Color(0xFF3B82F6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;

    // Responsive columns
    final int crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 4);

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 48 : 80),
      child: MaxWidthContainer(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(isDark ? 40 : 20),
                borderRadius: AppRadius.full,
              ),
              child: Text(
                'ENTERPRISE CAPABILITIES',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            AppSpacing.vMd,
            Text(
              'Everything Required to Scale Your Operations',
              textAlign: TextAlign.center,
              style:
                  (isMobile
                          ? AppTypography.headlineMedium
                          : AppTypography.displayMedium)
                      .copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
            ),
            AppSpacing.vSm,
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Text(
                'Designed specifically for growing educational groups, institutions, and multi-location enterprises.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ),
            AppSpacing.vXxl,

            // Responsive Features Grid using LayoutBuilder
            LayoutBuilder(
              builder: (context, constraints) {
                final double itemWidth =
                    (constraints.maxWidth - (crossAxisCount - 1) * 20) /
                    crossAxisCount;
                return Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: _features.map((feature) {
                    return SizedBox(
                      width: itemWidth,
                      child: _FeatureCard(feature: feature, isDark: isDark),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const FeatureData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

class _FeatureCard extends StatelessWidget {
  final FeatureData feature;
  final bool isDark;

  const _FeatureCard({required this.feature, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      enableHover: true,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: feature.color.withAlpha(isDark ? 40 : 20),
              borderRadius: AppRadius.sm,
            ),
            child: Icon(feature.icon, color: feature.color, size: 24),
          ),
          AppSpacing.vLg,
          Text(
            feature.title,
            style: AppTypography.titleMedium.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.vSm,
          Text(
            feature.description,
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
