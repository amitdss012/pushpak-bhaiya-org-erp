import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../widgets/org_stats_card.dart';

class VisitorsStatsGrid extends StatelessWidget {
  final int totalToday;
  final int activeVisitors;
  final int completedToday;
  final String avgDuration;

  const VisitorsStatsGrid({
    super.key,
    required this.totalToday,
    required this.activeVisitors,
    required this.completedToday,
    this.avgDuration = '45 min',
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isTablet = context.isTablet;

    final card1 = OrgStatsCard(
      title: 'Total Visitors Today',
      value: totalToday.toString(),
      subtitle: 'All registered visits',
      icon: Icons.people_rounded,
      variant: OrgStatsCardVariant.primary,
    );

    final card2 = OrgStatsCard(
      title: 'Currently Inside',
      value: activeVisitors.toString(),
      subtitle: 'Active visitors',
      icon: Icons.person_add_rounded,
      variant: OrgStatsCardVariant.info,
    );

    final card3 = OrgStatsCard(
      title: 'Checked Out',
      value: completedToday.toString(),
      subtitle: 'Completed visits',
      icon: Icons.logout_rounded,
      variant: OrgStatsCardVariant.success,
    );

    final card4 = OrgStatsCard(
      title: 'Avg. Visit Duration',
      value: avgDuration,
      subtitle: "Today's average",
      icon: Icons.schedule_rounded,
      variant: OrgStatsCardVariant.warning,
    );

    if (isDesktop) {
      return Row(
        children: [
          Expanded(child: card1),
          AppSpacing.hLg,
          Expanded(child: card2),
          AppSpacing.hLg,
          Expanded(child: card3),
          AppSpacing.hLg,
          Expanded(child: card4),
        ],
      );
    }

    if (isTablet) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: card1),
              AppSpacing.hMd,
              Expanded(child: card2),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(child: card3),
              AppSpacing.hMd,
              Expanded(child: card4),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        card1,
        AppSpacing.vMd,
        card2,
        AppSpacing.vMd,
        card3,
        AppSpacing.vMd,
        card4,
      ],
    );
  }
}
