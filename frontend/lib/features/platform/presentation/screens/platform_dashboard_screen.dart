import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/auth/platform_auth_service.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

/// Luxury, production-grade Platform Super Admin Command Center & Analytics Cockpit.
/// Implements responsive & adaptive composition across Mobile, Tablet, Desktop & Ultrawide.
class PlatformDashboardScreen extends HookWidget {
  const PlatformDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final authService = PlatformAuthService.instance;
    final currentAdmin = authService.currentAdmin;
    final screenWidth = context.screenWidth;
    final isMobile = screenWidth < 700;

    // Time horizon filter: 0 = 30D, 1 = 90D, 2 = 1Y, 3 = All
    final selectedHorizon = useState<int>(0);
    // Donut slice touch tracking
    final touchedSliceIndex = useState<int>(-1);
    // Revenue chart metric toggle: 0 = ARR, 1 = Active Users
    final chartMetricIndex = useState<int>(0);

    return SelectionArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 28,
                vertical: isMobile ? 16 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Executive Top Hero Banner & Horizon Filter
                  _buildExecutiveHeader(
                    context,
                    isDark,
                    currentAdmin?.name ?? 'Super Admin',
                    selectedHorizon,
                  ),
                  AppSpacing.vLg,

                  // 2. High-Impact Adaptive KPI Cards
                  _buildKpiGrid(context, isDark),
                  AppSpacing.vLg,

                  // 3. Primary Visual Analytics: Revenue Line Spline + Plan Donut Chart
                  _buildPrimaryChartsRow(
                    context,
                    isDark,
                    chartMetricIndex,
                    touchedSliceIndex,
                  ),
                  AppSpacing.vLg,

                  // 4. Secondary Analytics: Onboarding Velocity Bar Chart + System Telemetry
                  _buildSecondaryChartsRow(context, isDark),
                  AppSpacing.vLg,

                  // 5. Quick Command Shortcuts
                  _buildQuickActionCommandCenter(context, isDark),
                  AppSpacing.vLg,

                  // 6. Recent Tenant Directory (Adaptive Table / Cards)
                  _buildRecentOrganizationsSection(context, isDark),
                  AppSpacing.vXl,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 1. Executive Top Hero Banner & Horizon Filter
  // ===========================================================================
  Widget _buildExecutiveHeader(
    BuildContext context,
    bool isDark,
    String adminName,
    ValueNotifier<int> selectedHorizon,
  ) {
    final screenWidth = context.screenWidth;
    final isSmall = screenWidth < 780;

    final horizonLabels = ['30 Days', '90 Days', '1 Year', 'All Time'];

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Platform Command Center',
              style: (isSmall
                      ? AppTypography.titleLarge
                      : AppTypography.headlineMedium)
                  .copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            // Live Status Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha(isDark ? 35 : 20),
                borderRadius: AppRadius.full,
                border: Border.all(
                  color: AppColors.success.withAlpha(isDark ? 100 : 50),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Operational',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        AppSpacing.vXs,
        Text(
          'Welcome back, $adminName. Monitoring 42 tenant institutions across 156 campuses in real-time.',
          style: AppTypography.bodySmall.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionsBlock = Wrap(
      spacing: 10,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Horizon Filter Segment
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
            borderRadius: AppRadius.full,
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(horizonLabels.length, (idx) {
              final isSelected = selectedHorizon.value == idx;
              return GestureDetector(
                onTap: () => selectedHorizon.value = idx,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? AppColors.primary : Colors.white)
                        : Colors.transparent,
                    borderRadius: AppRadius.full,
                    boxShadow: isSelected && !isDark
                        ? [
                            BoxShadow(
                              color: Colors.black.withAlpha(15),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            )
                          ]
                        : null,
                  ),
                  child: Text(
                    horizonLabels[idx],
                    style: AppTypography.labelSmall.copyWith(
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? AppColors.textMutedDark
                              : AppColors.textSecondaryLight),
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        AppButton(
          text: 'Onboard Org',
          icon: Icons.add_business_rounded,
          height: 38,
          onPressed: () => context.go(RouteNames.platformOrganizationsPath),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.all(isSmall ? 16 : 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF1E1B4B).withAlpha(220),
                  const Color(0xFF0F172A).withAlpha(240),
                ]
              : [
                  const Color(0xFFEEF2FF),
                  Colors.white,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? const Color(0xFF312E81) : const Color(0xFFE0E7FF),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withAlpha(60)
                : AppColors.primary.withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isSmall
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                titleBlock,
                AppSpacing.vMd,
                actionsBlock,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: titleBlock),
                AppSpacing.hMd,
                actionsBlock,
              ],
            ),
    );
  }

  // ===========================================================================
  // 2. High-Impact KPI Stat Cards (Adaptive 1 / 2 / 4 Columns)
  // ===========================================================================
  Widget _buildKpiGrid(BuildContext context, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final int columns;
        if (width < 600) {
          columns = 1;
        } else if (width < 1024) {
          columns = 2;
        } else {
          columns = 4;
        }

        final spacing = 16.0;
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            SizedBox(
              width: itemWidth,
              child: _buildKpiCard(
                title: 'Annual Recurring Revenue',
                value: '₹48.6 L',
                trendText: '+24.8%',
                trendPositive: true,
                subtitle: '₹4.05L projected MRR this month',
                icon: Icons.payments_rounded,
                accentColor: const Color(0xFF6366F1),
                isDark: isDark,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildKpiCard(
                title: 'Active Institutions',
                value: '42',
                trendText: '+8 new',
                trendPositive: true,
                subtitle: '38 paid active, 4 trialing',
                icon: Icons.corporate_fare_rounded,
                accentColor: const Color(0xFF0EA5E9),
                isDark: isDark,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildKpiCard(
                title: 'Total Managed Students',
                value: '28,450',
                trendText: '+18.2%',
                trendPositive: true,
                subtitle: 'Across 156 affiliated campuses',
                icon: Icons.school_rounded,
                accentColor: const Color(0xFF8B5CF6),
                isDark: isDark,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildKpiCard(
                title: 'Infrastructure Uptime',
                value: '99.98%',
                trendText: '24ms',
                trendPositive: true,
                subtitle: 'Multi-region Postgres & Edge cluster',
                icon: Icons.verified_rounded,
                accentColor: AppColors.success,
                isDark: isDark,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String trendText,
    required bool trendPositive,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required bool isDark,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(isDark ? 40 : 20),
                  borderRadius: AppRadius.md,
                ),
                child: Icon(icon, color: accentColor, size: 18),
              ),
            ],
          ),
          AppSpacing.vSm,
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: AppTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              AppSpacing.hSm,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (trendPositive ? AppColors.success : AppColors.error)
                      .withAlpha(isDark ? 35 : 20),
                  borderRadius: AppRadius.full,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendPositive
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 11,
                      color:
                          trendPositive ? AppColors.success : AppColors.error,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      trendText,
                      style: AppTypography.labelSmall.copyWith(
                        color:
                            trendPositive ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.vXs,
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 3. Primary Visual Analytics: Revenue Line Chart + Plan Distribution Donut
  // ===========================================================================
  Widget _buildPrimaryChartsRow(
    BuildContext context,
    bool isDark,
    ValueNotifier<int> chartMetricIndex,
    ValueNotifier<int> touchedSliceIndex,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isStacked = width < 1000;

        final lineChartWidget = _buildRevenueLineChartCard(
          context,
          isDark,
          chartMetricIndex,
        );
        final donutChartWidget = _buildPlanDistributionDonutCard(
          context,
          isDark,
          touchedSliceIndex,
        );

        if (isStacked) {
          return Column(
            children: [
              lineChartWidget,
              AppSpacing.vLg,
              donutChartWidget,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 62, child: lineChartWidget),
            AppSpacing.hLg,
            Expanded(flex: 38, child: donutChartWidget),
          ],
        );
      },
    );
  }

  /// Interactive Spline Area Chart for Revenue Trajectory
  Widget _buildRevenueLineChartCard(
    BuildContext context,
    bool isDark,
    ValueNotifier<int> metricIndex,
  ) {
    final months = ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final revenueSpots = const [
      FlSpot(0, 1.8),
      FlSpot(1, 2.3),
      FlSpot(2, 2.7),
      FlSpot(3, 3.2),
      FlSpot(4, 3.8),
      FlSpot(5, 4.8),
    ];
    final userSpots = const [
      FlSpot(0, 11.2),
      FlSpot(1, 14.5),
      FlSpot(2, 17.8),
      FlSpot(3, 21.0),
      FlSpot(4, 24.6),
      FlSpot(5, 28.4),
    ];

    final isRevenue = metricIndex.value == 0;
    final activeSpots = isRevenue ? revenueSpots : userSpots;
    final maxY = isRevenue ? 6.0 : 35.0;
    final yUnit = isRevenue ? '₹' : '';
    final ySuffix = isRevenue ? 'L' : 'K';
    final primaryColor = isRevenue
        ? const Color(0xFF6366F1)
        : const Color(0xFF0EA5E9);

    return AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Metric Toggle
          Wrap(
            spacing: 8,
            runSpacing: 6,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRevenue
                        ? 'Revenue Growth Trajectory'
                        : 'Total Student Adoption Curve',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    isRevenue
                        ? 'Monthly ARR scaling and contract expansion'
                        : 'Active student seats provisioned across tenants',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),

              // Metric Switcher Pills
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF1F5F9),
                  borderRadius: AppRadius.full,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildChartMetricToggle(
                      label: 'ARR',
                      isSelected: isRevenue,
                      isDark: isDark,
                      onTap: () => metricIndex.value = 0,
                    ),
                    _buildChartMetricToggle(
                      label: 'Students',
                      isSelected: !isRevenue,
                      isDark: isDark,
                      onTap: () => metricIndex.value = 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.vLg,

          // Line Chart Viewport
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: isRevenue ? 1.5 : 8.0,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= months.length) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            months[index],
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.textMutedDark
                                  : AppColors.textMutedLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      interval: isRevenue ? 1.5 : 10.0,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            '$yUnit${value.toInt()}$ySuffix',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark
                                  ? AppColors.textMutedDark
                                  : AppColors.textMutedLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (months.length - 1).toDouble(),
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: activeSpots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: primaryColor,
                    barWidth: 3.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: primaryColor,
                        strokeWidth: 2.5,
                        strokeColor:
                            isDark ? const Color(0xFF0F172A) : Colors.white,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withAlpha(isDark ? 90 : 55),
                          primaryColor.withAlpha(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => isDark
                        ? const Color(0xFF1E293B)
                        : Colors.white,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final valText = isRevenue
                            ? '₹${spot.y.toStringAsFixed(1)} Lakhs'
                            : '${spot.y.toStringAsFixed(1)}K Students';
                        return LineTooltipItem(
                          '$valText\n',
                          TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text: months[spot.x.toInt()],
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textMutedDark
                                    : AppColors.textMutedLight,
                                fontWeight: FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartMetricToggle({
    required String label,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.primary : Colors.white)
              : Colors.transparent,
          borderRadius: AppRadius.full,
          boxShadow: isSelected && !isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark
                    ? AppColors.textMutedDark
                    : AppColors.textSecondaryLight),
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  /// Interactive Donut Pie Chart for Subscription Tiers
  Widget _buildPlanDistributionDonutCard(
    BuildContext context,
    bool isDark,
    ValueNotifier<int> touchedIndex,
  ) {
    final tiers = [
      {
        'name': 'Starter Tier',
        'count': 18,
        'percent': '43%',
        'color': const Color(0xFF6366F1),
      },
      {
        'name': 'Growth Tier',
        'count': 16,
        'percent': '38%',
        'color': const Color(0xFF0EA5E9),
      },
      {
        'name': 'Enterprise Tier',
        'count': 8,
        'percent': '19%',
        'color': const Color(0xFF8B5CF6),
      },
    ];

    return AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Plan Distribution',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              TextButton(
                onPressed: () => context.go(RouteNames.platformPlansPath),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text('Plans →'),
              ),
            ],
          ),
          AppSpacing.vXs,
          Text(
            'Tenant share across active tier catalogs.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          AppSpacing.vMd,

          // Donut Chart with Center Label
          SizedBox(
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, pieTouchResponse) {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex.value = -1;
                          return;
                        }
                        touchedIndex.value = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 3,
                    centerSpaceRadius: 46,
                    sections: List.generate(tiers.length, (i) {
                      final isTouched = i == touchedIndex.value;
                      final tier = tiers[i];
                      final radius = isTouched ? 34.0 : 28.0;

                      return PieChartSectionData(
                        color: tier['color'] as Color,
                        value: (tier['count'] as int).toDouble(),
                        title: '',
                        radius: radius,
                      );
                    }),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '42',
                      style: AppTypography.headlineMedium.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      'Total Orgs',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.vMd,

          // Legend List
          Column(
            children: tiers.map((tier) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: tier['color'] as Color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    AppSpacing.hSm,
                    Expanded(
                      child: Text(
                        tier['name'] as String,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                    Text(
                      '${tier['count']} orgs (${tier['percent']})',
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 4. Secondary Analytics: Velocity Bar Chart + System Telemetry
  // ===========================================================================
  Widget _buildSecondaryChartsRow(BuildContext context, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isStacked = width < 1000;

        final velocityBarChart = _buildOnboardingVelocityCard(context, isDark);
        final telemetryPanel = _buildTelemetryCard(context, isDark);

        if (isStacked) {
          return Column(
            children: [
              velocityBarChart,
              AppSpacing.vLg,
              telemetryPanel,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 50, child: velocityBarChart),
            AppSpacing.hLg,
            Expanded(flex: 50, child: telemetryPanel),
          ],
        );
      },
    );
  }

  /// Tenant Onboarding Velocity Monthly Bar Chart
  Widget _buildOnboardingVelocityCard(BuildContext context, bool isDark) {
    final months = ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final counts = [3, 5, 7, 8, 10, 9];

    return AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Tenant Onboarding Velocity',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      'Monthly institution acquisition across India',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(isDark ? 35 : 18),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  '+42 Tot.',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.vLg,

          // Bar Chart Viewport
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: 12,
                minY: 0,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => isDark
                        ? const Color(0xFF1E293B)
                        : Colors.white,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()} New Schools\n',
                        const TextStyle(
                          color: Color(0xFF0EA5E9),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: months[group.x.toInt()],
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textMutedDark
                                  : AppColors.textMutedLight,
                              fontWeight: FontWeight.normal,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= months.length) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            months[index],
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.textMutedDark
                                  : AppColors.textMutedLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 3,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            '${value.toInt()}',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark
                                  ? AppColors.textMutedDark
                                  : AppColors.textMutedLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 3,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(counts.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: counts[i].toDouble(),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF0EA5E9),
                            Color(0xFF6366F1),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 16,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// System Telemetry & Resource Utilization
  Widget _buildTelemetryCard(BuildContext context, bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Infrastructure Telemetry',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(isDark ? 30 : 20),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  'ALL SYSTEMS NORMAL',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w800,
                    fontSize: 9,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.vXs,
          Text(
            'Health monitoring and cluster services telemetry across regions.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          AppSpacing.vLg,

          _buildTelemetryMetricRow(
            serviceName: 'PostgreSQL Connection Pool',
            status: 'Healthy',
            details: '12 of 50 active pool connections (24%)',
            latency: '4ms ping',
            progress: 0.24,
            accentColor: AppColors.success,
            isDark: isDark,
          ),
          const Divider(height: 24),
          _buildTelemetryMetricRow(
            serviceName: 'Core REST API Gateway (ap-south-1)',
            status: 'Optimal',
            details: 'Cluster Node in Mumbai • 99.98% uptime',
            latency: '24ms avg',
            progress: 0.18,
            accentColor: const Color(0xFF0EA5E9),
            isDark: isDark,
          ),
          const Divider(height: 24),
          _buildTelemetryMetricRow(
            serviceName: 'Document & Media Storage',
            status: 'Healthy',
            details: '48.2 GB of 250 GB provisioned bucket',
            latency: '19.2% used',
            progress: 0.192,
            accentColor: const Color(0xFF8B5CF6),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryMetricRow({
    required String serviceName,
    required String status,
    required String details,
    required String latency,
    required double progress,
    required Color accentColor,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                serviceName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: accentColor.withAlpha(isDark ? 35 : 20),
                borderRadius: AppRadius.full,
              ),
              child: Text(
                status,
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.vXs,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              details,
              style: AppTypography.bodySmall.copyWith(
                color:
                    isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                fontSize: 11,
              ),
            ),
            Text(
              latency,
              style: AppTypography.labelSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                fontSize: 10,
              ),
            ),
          ],
        ),
        AppSpacing.vXs,
        ClipRRect(
          borderRadius: AppRadius.full,
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor:
                isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 5. Quick Action Command Center
  // ===========================================================================
  Widget _buildQuickActionCommandCenter(BuildContext context, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final int columns = width < 600 ? 2 : 4;
        final spacing = 14.0;
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            SizedBox(
              width: itemWidth,
              child: _buildActionTile(
                title: 'Onboard Tenant',
                subtitle: 'Register new school',
                icon: Icons.add_business_rounded,
                accentColor: AppColors.primary,
                isDark: isDark,
                onTap: () =>
                    context.go(RouteNames.platformOrganizationsPath),
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildActionTile(
                title: 'Manage Plans',
                subtitle: 'Pricing & quota tiers',
                icon: Icons.loyalty_rounded,
                accentColor: const Color(0xFF0EA5E9),
                isDark: isDark,
                onTap: () => context.go(RouteNames.platformPlansPath),
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildActionTile(
                title: 'Tenant Directory',
                subtitle: 'All 42 active schools',
                icon: Icons.domain_rounded,
                accentColor: const Color(0xFF8B5CF6),
                isDark: isDark,
                onTap: () =>
                    context.go(RouteNames.platformOrganizationsPath),
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildActionTile(
                title: 'System Audit',
                subtitle: 'Platform security logs',
                icon: Icons.receipt_long_rounded,
                accentColor: AppColors.success,
                isDark: isDark,
                onTap: () {},
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.md,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withAlpha(isDark ? 40 : 20),
                borderRadius: AppRadius.md,
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            AppSpacing.hSm,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 6. Recent Organizations Overview (Adaptive Table / Cards)
  // ===========================================================================
  Widget _buildRecentOrganizationsSection(BuildContext context, bool isDark) {
    final screenWidth = context.screenWidth;
    final isDesktop = screenWidth >= 880;

    return AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Recent Tenant Onboardings',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              TextButton(
                onPressed: () =>
                    context.go(RouteNames.platformOrganizationsPath),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text('View All Organizations →'),
              ),
            ],
          ),
          AppSpacing.vXs,
          Text(
            'Latest multi-tenant educational institutions onboarded on Pushpak SaaS.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          AppSpacing.vLg,

          if (isDesktop)
            LayoutBuilder(
              builder: (context, constraints) {
                final tableWidth = constraints.maxWidth > 850
                    ? constraints.maxWidth
                    : 850.0;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: tableWidth,
                    child: _buildDesktopTable(context, isDark),
                  ),
                );
              },
            )
          else
            _buildMobileRecentCards(context, isDark),
        ],
      ),
    );
  }

  Widget _buildDesktopTable(BuildContext context, bool isDark) {
    final sampleOrgs = [
      {
        'name': 'Delhi Public School Group',
        'slug': 'dps-north',
        'owner': 'principal@dps.edu.in',
        'plan': 'Enterprise Tier',
        'branches': '6',
        'status': 'ACTIVE',
        'joined': 'Today',
      },
      {
        'name': 'St. Xavier High School',
        'slug': 'st-xavier-campus',
        'owner': 'admin@stxavier.org',
        'plan': 'Growth Tier',
        'branches': '3',
        'status': 'ACTIVE',
        'joined': 'Yesterday',
      },
      {
        'name': 'Heritage Global Academy',
        'slug': 'heritage-acad',
        'owner': 'director@heritage.com',
        'plan': 'Starter Tier',
        'branches': '1',
        'status': 'TRIALING',
        'joined': '3 days ago',
      },
    ];

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.6),
        1: FlexColumnWidth(2.0),
        2: FlexColumnWidth(1.6),
        3: FixedColumnWidth(125),
        4: FixedColumnWidth(110),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        // Table Header
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0),
              ),
            ),
          ),
          children: [
            _buildTableHeaderCell('ORGANIZATION', isDark),
            _buildTableHeaderCell('OWNER EMAIL', isDark),
            _buildTableHeaderCell('ACTIVE PLAN', isDark),
            _buildTableHeaderCell('BRANCHES', isDark),
            _buildTableHeaderCell('STATUS', isDark),
          ],
        ),

        // Table Rows
        ...sampleOrgs.map((org) {
          final isTrial = org['status'] == 'TRIALING';
          return TableRow(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                ),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          AppColors.primary.withAlpha(isDark ? 45 : 20),
                      child: Text(
                        org['name']![0],
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    AppSpacing.hSm,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            org['name']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            org['slug']!,
                            style: AppTypography.labelSmall.copyWith(
                              fontFamily: 'monospace',
                              color: isDark
                                  ? AppColors.textMutedDark
                                  : AppColors.textMutedLight,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  org['owner']!,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    fontSize: 12,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  org['plan']!,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    fontSize: 12,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  '${org['branches']!} campuses',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    fontSize: 12,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (isTrial ? AppColors.warning : AppColors.success)
                          .withAlpha(isDark ? 35 : 20),
                      borderRadius: AppRadius.full,
                      border: Border.all(
                        color: (isTrial ? AppColors.warning : AppColors.success)
                            .withAlpha(isDark ? 90 : 60),
                      ),
                    ),
                    child: Text(
                      org['status']!,
                      style: AppTypography.labelSmall.copyWith(
                        color: isTrial ? AppColors.warning : AppColors.success,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildTableHeaderCell(String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildMobileRecentCards(BuildContext context, bool isDark) {
    final sampleOrgs = [
      {
        'name': 'Delhi Public School Group',
        'slug': 'dps-north',
        'owner': 'principal@dps.edu.in',
        'plan': 'Enterprise Tier',
        'status': 'ACTIVE',
      },
      {
        'name': 'St. Xavier High School',
        'slug': 'st-xavier-campus',
        'owner': 'admin@stxavier.org',
        'plan': 'Growth Tier',
        'status': 'ACTIVE',
      },
      {
        'name': 'Heritage Global Academy',
        'slug': 'heritage-acad',
        'owner': 'director@heritage.com',
        'plan': 'Starter Tier',
        'status': 'TRIALING',
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sampleOrgs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final org = sampleOrgs[i];
        final isTrial = org['status'] == 'TRIALING';

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B).withAlpha(120)
                : const Color(0xFFF8FAFC),
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      org['name']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: (isTrial ? AppColors.warning : AppColors.success)
                          .withAlpha(isDark ? 35 : 20),
                      borderRadius: AppRadius.full,
                    ),
                    child: Text(
                      org['status']!,
                      style: AppTypography.labelSmall.copyWith(
                        color: isTrial ? AppColors.warning : AppColors.success,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.vXs,
              Text(
                'Plan: ${org['plan']!} • ${org['owner']!}',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
