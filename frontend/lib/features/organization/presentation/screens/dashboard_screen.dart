import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../widgets/branch_overview_table.dart';
import '../widgets/dashboard_metrics_grid.dart';
import '../widgets/dashboard_welcome_header.dart';
import '../widgets/fee_collection_chart_card.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/recent_activity_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isMobile = context.isMobile;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 28,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Greeting
          const DashboardWelcomeHeader(),
          AppSpacing.vLg,

          // 4 Metric Stats
          const DashboardMetricsGrid(),
          AppSpacing.vXl,

          // Quick Action Shortcuts
          const QuickActionsGrid(),
          AppSpacing.vXl,

          // Main Multi-Column Section
          if (isDesktop)
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Branch Table & Financial Inflow (flex: 7)
                Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      BranchOverviewTable(),
                      AppSpacing.vXl,
                      FeeCollectionChartCard(),
                    ],
                  ),
                ),
                AppSpacing.hXl,
                // Right Column: Live Audit Activity Feed (flex: 5)
                Expanded(
                  flex: 5,
                  child: Column(children: [RecentActivityCard()]),
                ),
              ],
            )
          else
            const Column(
              children: [
                BranchOverviewTable(),
                AppSpacing.vLg,
                FeeCollectionChartCard(),
                AppSpacing.vLg,
                RecentActivityCard(),
              ],
            ),
          AppSpacing.vXl,
        ],
      ),
    );
  }
}
