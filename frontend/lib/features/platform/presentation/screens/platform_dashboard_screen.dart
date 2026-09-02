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

/// Professional, state-of-the-art Platform Owner / Super Admin Dashboard.
/// Fully responsive across Mobile, Tablet, Desktop, and Ultra-wide resolutions.
class PlatformDashboardScreen extends HookWidget {
  const PlatformDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final authService = PlatformAuthService.instance;
    final currentAdmin = authService.currentAdmin;
    final isMobile = context.screenWidth < 768;

    return SelectionArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header Banner
              _buildTopHeader(context, isDark, currentAdmin?.name ?? 'Super Admin'),
              AppSpacing.vLg,

              // 2. 4 High-Impact KPI Stat Cards
              _buildKpiGrid(context, isDark),
              AppSpacing.vLg,

              // 3. Analytics & Distribution Section
              _buildAnalyticsSection(context, isDark),
              AppSpacing.vLg,

              // 4. Quick Action Shortcuts
              _buildQuickActions(context, isDark),
              AppSpacing.vLg,

              // 5. Recent Organizations Table
              _buildRecentOrganizationsTable(context, isDark),
              AppSpacing.vXl,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context, bool isDark, String adminName) {
    final isSmall = context.screenWidth < 640;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 16 : 24,
        vertical: isSmall ? 16 : 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E1B4B), const Color(0xFF0F172A)]
              : [const Color(0xFFEEF2FF), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? const Color(0xFF312E81) : const Color(0xFFE0E7FF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Platform Control Center',
                        style: (isSmall
                                ? AppTypography.titleLarge
                                : AppTypography.headlineMedium)
                            .copyWith(
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                    AppSpacing.hSm,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withAlpha(isDark ? 40 : 20),
                        borderRadius: AppRadius.full,
                        border: Border.all(
                          color: AppColors.success.withAlpha(isDark ? 100 : 60),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Live',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.vXs,
          Text(
            'Welcome back, $adminName. Multi-tenant infrastructure is running normally across all regions.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiGrid(BuildContext context, bool isDark) {
    final width = context.screenWidth;
    final int columns;
    if (width < 600) {
      columns = 1;
    } else if (width < 1100) {
      columns = 2;
    } else {
      columns = 4;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
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
                title: 'Total Revenue (ARR)',
                value: '₹48.6 L',
                badgeText: '+24.8% MoM',
                badgeColor: AppColors.success,
                subtitle: '₹4.05L projected this month',
                icon: Icons.account_balance_wallet_rounded,
                iconColor: const Color(0xFF6366F1),
                isDark: isDark,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildKpiCard(
                title: 'Active Organizations',
                value: '42',
                badgeText: '+8 new',
                badgeColor: const Color(0xFF0EA5E9),
                subtitle: '38 paid, 4 trialing',
                icon: Icons.corporate_fare_rounded,
                iconColor: const Color(0xFF0EA5E9),
                isDark: isDark,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildKpiCard(
                title: 'Global Branches',
                value: '156',
                badgeText: 'Across 18 cities',
                badgeColor: const Color(0xFF8B5CF6),
                subtitle: 'Avg 3.7 branches / org',
                icon: Icons.domain_rounded,
                iconColor: const Color(0xFF8B5CF6),
                isDark: isDark,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildKpiCard(
                title: 'System Health',
                value: '99.98%',
                badgeText: 'Optimal',
                badgeColor: AppColors.success,
                subtitle: 'All API nodes operational',
                icon: Icons.cloud_done_rounded,
                iconColor: AppColors.success,
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
    required String badgeText,
    required Color badgeColor,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool isDark,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(18),
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
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(isDark ? 40 : 20),
                  borderRadius: AppRadius.sm,
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ],
          ),
          AppSpacing.vSm,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: AppTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.w900,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              AppSpacing.hSm,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor.withAlpha(isDark ? 35 : 20),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  badgeText,
                  style: AppTypography.labelSmall.copyWith(
                    color: badgeColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
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
              color: isDark
                  ? AppColors.textMutedDark
                  : AppColors.textMutedLight,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection(BuildContext context, bool isDark) {
    final isWide = context.screenWidth >= 960;

    final planDistributionCard = AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subscription Tiers Breakdown',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              TextButton(
                onPressed: () => context.go(RouteNames.platformPlansPath),
                child: const Text('View Plans'),
              ),
            ],
          ),
          AppSpacing.vMd,
          _buildTierProgressRow(
            title: 'Enterprise Tier (₹9,999/mo)',
            count: '14 Orgs',
            percent: 0.35,
            color: const Color(0xFF8B5CF6),
            isDark: isDark,
          ),
          AppSpacing.vMd,
          _buildTierProgressRow(
            title: 'Growth Tier (₹4,999/mo)',
            count: '20 Orgs',
            percent: 0.48,
            color: const Color(0xFF6366F1),
            isDark: isDark,
          ),
          AppSpacing.vMd,
          _buildTierProgressRow(
            title: 'Starter Tier (₹1,999/mo)',
            count: '8 Orgs',
            percent: 0.17,
            color: const Color(0xFF0EA5E9),
            isDark: isDark,
          ),
        ],
      ),
    );

    final telemetryCard = AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Infrastructure Telemetry',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          AppSpacing.vSm,
          _buildTelemetryRow('Database Read Latency', '4.2 ms', AppColors.success, isDark),
          const Divider(height: 16),
          _buildTelemetryRow('API Response Average', '38 ms', AppColors.success, isDark),
          const Divider(height: 16),
          _buildTelemetryRow('Tenant Isolation Security', 'Active', AppColors.primary, isDark),
          const Divider(height: 16),
          _buildTelemetryRow('Automated DB Backups', 'Every 6 Hours', const Color(0xFF0EA5E9), isDark),
        ],
      ),
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: planDistributionCard),
          AppSpacing.hLg,
          Expanded(flex: 4, child: telemetryCard),
        ],
      );
    }

    return Column(
      children: [
        planDistributionCard,
        AppSpacing.vLg,
        telemetryCard,
      ],
    );
  }

  Widget _buildTierProgressRow({
    required String title,
    required String count,
    required double percent,
    required Color color,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            Text(
              count,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        AppSpacing.vXs,
        ClipRRect(
          borderRadius: AppRadius.full,
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: isDark
                ? const Color(0xFF334155)
                : const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildTelemetryRow(
    String title,
    String value,
    Color statusColor,
    bool isDark,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.bodySmall.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w700,
            color: statusColor,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(20),
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
                      'Super Admin Fast Navigation',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      'Instantly inspect subscription tiers or provision new tenant organizations.',
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
          AppSpacing.vMd,
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              AppButton(
                text: 'Subscription Plans',
                icon: Icons.loyalty_rounded,
                variant: AppButtonVariant.outline,
                onPressed: () => context.go(RouteNames.platformPlansPath),
                height: 40,
              ),
              AppButton(
                text: 'Organizations Directory',
                icon: Icons.corporate_fare_rounded,
                onPressed: () =>
                    context.go(RouteNames.platformOrganizationsPath),
                height: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrganizationsTable(BuildContext context, bool isDark) {
    final staticTenants = [
      {
        'name': 'Apex International Academy',
        'slug': 'apex-academy',
        'plan': 'Enterprise Tier',
        'branches': '8 Branches',
        'owner': 'Dr. Rajesh Sharma',
        'email': 'director@apexacademy.edu',
        'status': 'ACTIVE',
      },
      {
        'name': 'Bright Future Coaching Institutes',
        'slug': 'bright-future',
        'plan': 'Growth Tier',
        'branches': '4 Branches',
        'owner': 'Pooja Verma',
        'email': 'admin@brightfuture.com',
        'status': 'ACTIVE',
      },
      {
        'name': 'St. Xavier Global School',
        'slug': 'st-xavier-global',
        'plan': 'Enterprise Tier',
        'branches': '12 Branches',
        'owner': 'Fr. Thomas Mathew',
        'email': 'principal@stxavierglobal.org',
        'status': 'ACTIVE',
      },
      {
        'name': 'Pioneer Science Academy',
        'slug': 'pioneer-science',
        'plan': 'Starter Tier',
        'branches': '1 Branch',
        'owner': 'Amit Joshi',
        'email': 'amit@pioneerscience.in',
        'status': 'ACTIVE',
      },
    ];

    return AppCard(
      padding: const EdgeInsets.all(20),
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
                      'Recent SaaS Tenant Organizations',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      'Active institutions running on Pushpak Multi-Tenant ERP',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('Manage All'),
                onPressed: () =>
                    context.go(RouteNames.platformOrganizationsPath),
              ),
            ],
          ),
          AppSpacing.vMd,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: staticTenants.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final tenant = staticTenants[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          AppColors.primary.withAlpha(isDark ? 40 : 20),
                      child: Text(
                        tenant['name']![0],
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AppSpacing.hSm,
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tenant['name']!,
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
                            'Owner: ${tenant['owner']}',
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
                    if (context.screenWidth >= 640)
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tenant['plan']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              tenant['branches']!,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.textMutedDark
                                    : AppColors.textMutedLight,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withAlpha(isDark ? 40 : 20),
                        borderRadius: AppRadius.full,
                      ),
                      child: Text(
                        tenant['status']!,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
