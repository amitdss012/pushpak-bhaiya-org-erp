import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/max_width_container.dart';

class ValuePropSection extends StatelessWidget {
  const ValuePropSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 48 : 80),
      color: isDark
          ? AppColors.surfaceDark.withAlpha(50)
          : AppColors.surfaceLight,
      child: MaxWidthContainer(
        child: Column(
          children: [
            // Title
            Text(
              'One Organization. Multiple Branches. One Platform.',
              textAlign: TextAlign.center,
              style:
                  (isMobile
                          ? AppTypography.headlineMedium
                          : AppTypography.displayMedium)
                      .copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w800,
                      ),
            ),
            AppSpacing.vMd,
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Text(
                'Eliminate disconnected spreadsheets, fragmented databases, and redundant software subscriptions. Pushpak brings your entire institution under one unified digital ecosystem.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ),
            AppSpacing.vXxl,

            // Two-pillar comparison card
            if (isMobile)
              Column(
                children: [
                  _buildPillarCard(
                    title: 'For Organization Executives',
                    badge: 'GLOBAL GOVERNANCE',
                    icon: Icons.corporate_fare_rounded,
                    points: const [
                      'Cross-branch executive dashboards and consolidated revenue reports.',
                      'Global subscription & tier management with customizable limits.',
                      'Centralized security, audit logs, and organization-level RBAC.',
                      'Instant branch onboarding in seconds without technical setup.',
                    ],
                    isDark: isDark,
                  ),
                  AppSpacing.vLg,
                  _buildPillarCard(
                    title: 'For Branch Principals & Staff',
                    badge: 'LOCAL AUTONOMY',
                    icon: Icons.domain_rounded,
                    points: const [
                      'Dedicated branch login panel isolated from other branches.',
                      'End-to-end student admissions, records, and attendance tracking.',
                      'Teacher, faculty, and staff management with local permissions.',
                      'Automated fee collection, invoices, and localized branch schedules.',
                    ],
                    isDark: isDark,
                  ),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildPillarCard(
                      title: 'For Organization Executives',
                      badge: 'GLOBAL GOVERNANCE',
                      icon: Icons.corporate_fare_rounded,
                      points: const [
                        'Cross-branch executive dashboards and consolidated revenue reports.',
                        'Global subscription & tier management with customizable limits.',
                        'Centralized security, audit logs, and organization-level RBAC.',
                        'Instant branch onboarding in seconds without technical setup.',
                      ],
                      isDark: isDark,
                    ),
                  ),
                  AppSpacing.hXl,
                  Expanded(
                    child: _buildPillarCard(
                      title: 'For Branch Principals & Staff',
                      badge: 'LOCAL AUTONOMY',
                      icon: Icons.domain_rounded,
                      points: const [
                        'Dedicated branch login panel isolated from other branches.',
                        'End-to-end student admissions, records, and attendance tracking.',
                        'Teacher, faculty, and staff management with local permissions.',
                        'Automated fee collection, invoices, and localized branch schedules.',
                      ],
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillarCard({
    required String title,
    required String badge,
    required IconData icon,
    required List<String> points,
    required bool isDark,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(32),
      enableHover: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(isDark ? 40 : 20),
                  borderRadius: AppRadius.sm,
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      badge,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      title,
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.vLg,
          const Divider(height: 1),
          AppSpacing.vLg,
          ...points.map(
            (pt) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 18,
                  ),
                  AppSpacing.hSm,
                  Expanded(
                    child: Text(
                      pt,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
