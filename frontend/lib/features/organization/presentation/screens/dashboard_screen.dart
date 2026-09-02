import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../widgets/admission_trends_card.dart';
import '../widgets/course_distribution_card.dart';
import '../widgets/dashboard_page_header.dart';
import '../widgets/dashboard_stats_grid.dart';
import '../widgets/fee_collection_overview_card.dart';
import '../widgets/recent_activity_feed_card.dart';
import '../widgets/upcoming_events_card.dart';

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
          // 1. Page Header
          const DashboardPageHeader(),
          AppSpacing.vLg,

          // 2. 4 Metric Stats Cards (Students, Courses, Fee Collection, Due Payments)
          const DashboardStatsGrid(),
          AppSpacing.vXl,

          // 3. Section 1: Admission Trends (2 cols) & Course Distribution (1 col)
          if (isDesktop)
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: AdmissionTrendsCard(),
                ),
                AppSpacing.hXl,
                Expanded(
                  flex: 1,
                  child: CourseDistributionCard(),
                ),
              ],
            )
          else
            const Column(
              children: [
                AdmissionTrendsCard(),
                AppSpacing.vLg,
                CourseDistributionCard(),
              ],
            ),
          AppSpacing.vXl,

          // 4. Section 2: Fee Collection Overview (2 cols) & Upcoming Events (1 col)
          if (isDesktop)
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: FeeCollectionOverviewCard(),
                ),
                AppSpacing.hXl,
                Expanded(
                  flex: 1,
                  child: UpcomingEventsCard(),
                ),
              ],
            )
          else
            const Column(
              children: [
                FeeCollectionOverviewCard(),
                AppSpacing.vLg,
                UpcomingEventsCard(),
              ],
            ),
          AppSpacing.vXl,

          // 5. Section 3: Recent Activity (Full width)
          const RecentActivityFeedCard(),
          AppSpacing.vXl,
        ],
      ),
    );
  }
}
