import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_card.dart';

class DashboardMetricsGrid extends StatelessWidget {
  const DashboardMetricsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;
    final int crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 4);

    final metrics = [
      const _MetricData(
        title: 'Total Branches',
        value: '8 Active',
        changeText: '+2 new this quarter',
        isPositive: true,
        icon: Icons.domain_rounded,
        color: Color(0xFF6366F1),
      ),
      const _MetricData(
        title: 'Total Enrolled Students',
        value: '6,420',
        changeText: '+12.4% vs last month',
        isPositive: true,
        icon: Icons.school_rounded,
        color: Color(0xFF0EA5E9),
      ),
      const _MetricData(
        title: 'Faculty & Staff Members',
        value: '348',
        changeText: '98.2% present today',
        isPositive: true,
        icon: Icons.people_alt_rounded,
        color: Color(0xFF8B5CF6),
      ),
      const _MetricData(
        title: 'Fee Collection (Aug 2026)',
        value: '₹42.85 L',
        changeText: '84.6% collected of target',
        isPositive: true,
        icon: Icons.payments_rounded,
        color: Color(0xFF10B981),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth =
            (constraints.maxWidth - (crossAxisCount - 1) * 16) / crossAxisCount;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: metrics.map((metric) {
            return SizedBox(
              width: itemWidth,
              child: _MetricCard(metric: metric),
            );
          }).toList(),
        );
      },
    );
  }
}

class _MetricData {
  final String title;
  final String value;
  final String changeText;
  final bool isPositive;
  final IconData icon;
  final Color color;

  const _MetricData({
    required this.title,
    required this.value,
    required this.changeText,
    required this.isPositive,
    required this.icon,
    required this.color,
  });
}

class _MetricCard extends StatelessWidget {
  final _MetricData metric;

  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return AppCard(
      padding: const EdgeInsets.all(20),
      enableHover: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                metric.title,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: metric.color.withAlpha(isDark ? 40 : 20),
                  borderRadius: AppRadius.sm,
                ),
                child: Icon(metric.icon, color: metric.color, size: 18),
              ),
            ],
          ),
          AppSpacing.vSm,
          Text(
            metric.value,
            style: AppTypography.headlineMedium.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.vSm,
          Row(
            children: [
              Icon(
                metric.isPositive
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                size: 16,
                color: metric.isPositive ? AppColors.success : AppColors.error,
              ),
              AppSpacing.hXs,
              Expanded(
                child: Text(
                  metric.changeText,
                  style: AppTypography.bodySmall.copyWith(
                    color: metric.isPositive
                        ? AppColors.success
                        : AppColors.error,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
