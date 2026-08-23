import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/max_width_container.dart';

class OrgStructureSection extends StatelessWidget {
  const OrgStructureSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 48 : 80),
      color: isDark
          ? AppColors.surfaceDark.withAlpha(80)
          : AppColors.primaryLight.withAlpha(60),
      child: MaxWidthContainer(
        child: Column(
          children: [
            // Section Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(isDark ? 40 : 20),
                borderRadius: AppRadius.full,
              ),
              child: Text(
                'CENTRALIZED ARCHITECTURE',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            AppSpacing.vMd,
            Text(
              'How the Multi-Branch Platform Works',
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
                'Head organizations maintain global governance, billing, and macro-analytics while delegating operational autonomy to individual branch panels.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ),
            AppSpacing.vXxl,

            // Interactive Architecture Visualization
            _buildHierarchyDiagram(context, isDark, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildHierarchyDiagram(
    BuildContext context,
    bool isDark,
    bool isMobile,
  ) {
    return Column(
      children: [
        // Top Node: Central Organization
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          color: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF),
          borderSide: BorderSide(
            color: AppColors.primary.withAlpha(120),
            width: 1.5,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.corporate_fare_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                AppSpacing.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Central Organization Control Panel',
                        style: AppTypography.titleMedium.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Global Billing • RBAC Policies • Macro Analytics • Cross-Branch Governance',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Vertical connecting stem
        Container(
          width: 2,
          height: 32,
          color: AppColors.primary.withAlpha(100),
        ),

        // 3 Branch Columns (or stacked on mobile)
        if (isMobile)
          Column(
            children: [
              _buildBranchNode(name: 'Branch 1 (West Campus)', isDark: isDark),
              AppSpacing.vMd,
              _buildBranchNode(name: 'Branch 2 (East Campus)', isDark: isDark),
              AppSpacing.vMd,
              _buildBranchNode(
                name: 'Branch 3 (Digital Campus)',
                isDark: isDark,
              ),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildBranchNode(
                  name: 'Branch 1 (West Campus)',
                  isDark: isDark,
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: _buildBranchNode(
                  name: 'Branch 2 (East Campus)',
                  isDark: isDark,
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: _buildBranchNode(
                  name: 'Branch 3 (Digital Campus)',
                  isDark: isDark,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildBranchNode({required String name, required bool isDark}) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      enableHover: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withAlpha(isDark ? 40 : 20),
                  borderRadius: AppRadius.sm,
                ),
                child: const Icon(
                  Icons.account_tree_rounded,
                  color: AppColors.secondary,
                  size: 20,
                ),
              ),
              AppSpacing.hSm,
              Expanded(
                child: Text(
                  name,
                  style: AppTypography.titleMedium.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          const Divider(height: 1),
          AppSpacing.vMd,

          // Sub-modules inside branch
          _ModuleItem(
            icon: Icons.school_outlined,
            label: 'Student Management',
            isDark: isDark,
          ),
          AppSpacing.vSm,
          _ModuleItem(
            icon: Icons.badge_outlined,
            label: 'Staff & Faculty Operations',
            isDark: isDark,
          ),
          AppSpacing.vSm,
          _ModuleItem(
            icon: Icons.menu_book_outlined,
            label: 'Courses & Curriculum',
            isDark: isDark,
          ),
          AppSpacing.vSm,
          _ModuleItem(
            icon: Icons.settings_suggest_outlined,
            label: 'Branch Management & Fees',
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _ModuleItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _ModuleItem({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        AppSpacing.hSm,
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
