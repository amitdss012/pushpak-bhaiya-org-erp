import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../widgets/org_stats_card.dart';

class ReceiveStatsGrid extends StatelessWidget {
  final int totalReceived;
  final int goodCondition;
  final int damaged;
  final int pendingVerification;

  const ReceiveStatsGrid({
    super.key,
    required this.totalReceived,
    required this.goodCondition,
    required this.damaged,
    required this.pendingVerification,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isTablet = context.isTablet;

    final card1 = OrgStatsCard(
      title: 'Total Received',
      value: totalReceived.toString(),
      subtitle: 'This month',
      icon: Icons.all_inbox_rounded,
      variant: OrgStatsCardVariant.primary,
    );

    final card2 = OrgStatsCard(
      title: 'Good Condition',
      value: goodCondition.toString(),
      subtitle: 'No issues',
      icon: Icons.check_circle_outline_rounded,
      variant: OrgStatsCardVariant.success,
    );

    final card3 = OrgStatsCard(
      title: 'Damaged Items',
      value: damaged.toString(),
      subtitle: 'Needs attention',
      icon: Icons.warning_amber_rounded,
      variant: OrgStatsCardVariant.warning,
    );

    final card4 = OrgStatsCard(
      title: 'Pending Verification',
      value: pendingVerification.toString(),
      subtitle: 'To be processed',
      icon: Icons.schedule_rounded,
      variant: OrgStatsCardVariant.info,
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
