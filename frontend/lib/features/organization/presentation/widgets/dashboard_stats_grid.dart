import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import 'org_stats_card.dart';

class DashboardStatsGrid extends StatelessWidget {
  const DashboardStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isTablet = context.isTablet;

    const cards = [
      OrgStatsCard(
        title: 'Total Students',
        value: '2,847',
        subtitle: 'Active enrollments',
        icon: Icons.school_rounded,
        trend: OrgStatsCardTrend(value: 12, isPositive: true),
        variant: OrgStatsCardVariant.primary,
      ),
      OrgStatsCard(
        title: 'Total Courses',
        value: '48',
        subtitle: 'Across all batches',
        icon: Icons.menu_book_rounded,
        trend: OrgStatsCardTrend(value: 8, isPositive: true),
        variant: OrgStatsCardVariant.info,
      ),
      OrgStatsCard(
        title: 'Fee Collection',
        value: '₹9.8L',
        subtitle: 'This month',
        icon: Icons.credit_card_rounded,
        trend: OrgStatsCardTrend(value: 5, isPositive: true),
        variant: OrgStatsCardVariant.success,
      ),
      OrgStatsCard(
        title: 'Due Payments',
        value: '₹1.2L',
        subtitle: '15 students pending',
        icon: Icons.warning_amber_rounded,
        trend: OrgStatsCardTrend(value: 3, isPositive: false),
        variant: OrgStatsCardVariant.warning,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: [
          Expanded(child: cards[0]),
          AppSpacing.hLg,
          Expanded(child: cards[1]),
          AppSpacing.hLg,
          Expanded(child: cards[2]),
          AppSpacing.hLg,
          Expanded(child: cards[3]),
        ],
      );
    }

    if (isTablet) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: cards[0]),
              AppSpacing.hMd,
              Expanded(child: cards[1]),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(child: cards[2]),
              AppSpacing.hMd,
              Expanded(child: cards[3]),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        cards[0],
        AppSpacing.vMd,
        cards[1],
        AppSpacing.vMd,
        cards[2],
        AppSpacing.vMd,
        cards[3],
      ],
    );
  }
}
