import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../widgets/org_stats_card.dart';

class DispatchStatsGrid extends StatelessWidget {
  final int totalDispatched;
  final int inTransit;
  final int delivered;
  final int pendingPickup;

  const DispatchStatsGrid({
    super.key,
    required this.totalDispatched,
    required this.inTransit,
    required this.delivered,
    required this.pendingPickup,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isTablet = context.isTablet;

    final card1 = OrgStatsCard(
      title: 'Total Dispatched',
      value: totalDispatched.toString(),
      subtitle: 'This month',
      icon: Icons.inventory_2_rounded,
      variant: OrgStatsCardVariant.primary,
    );

    final card2 = OrgStatsCard(
      title: 'In Transit',
      value: inTransit.toString(),
      subtitle: 'On the way',
      icon: Icons.local_shipping_rounded,
      variant: OrgStatsCardVariant.info,
    );

    final card3 = OrgStatsCard(
      title: 'Delivered',
      value: delivered.toString(),
      subtitle: 'Successfully received',
      icon: Icons.mark_email_read_rounded,
      variant: OrgStatsCardVariant.success,
    );

    final card4 = OrgStatsCard(
      title: 'Pending Pickup',
      value: pendingPickup.toString(),
      subtitle: 'Awaiting courier',
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
