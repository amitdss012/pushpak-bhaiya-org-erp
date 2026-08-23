import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/max_width_container.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 48 : 80),
      child: MaxWidthContainer(
        child: isMobile
            ? _buildMobileLayout(context, isDark)
            : _buildDesktopLayout(context, isDark),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Copy & CTAs
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBadge(isDark),
              AppSpacing.vLg,
              Text(
                AppConstants.heroTitle,
                style: AppTypography.displayLarge.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              AppSpacing.vMd,
              Text(
                AppConstants.heroDescription,
                style: AppTypography.bodyLarge.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  height: 1.6,
                ),
              ),
              AppSpacing.vXl,
              _buildCtas(context),
              AppSpacing.vXl,
              _buildTrustMetrics(isDark),
            ],
          ),
        ),
        AppSpacing.hXl,
        // Right Visual Mockup
        Expanded(flex: 6, child: _buildPlatformPreview(isDark)),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBadge(isDark),
        AppSpacing.vMd,
        Text(
          AppConstants.heroTitle,
          style: AppTypography.headlineLarge.copyWith(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vMd,
        Text(
          AppConstants.heroDescription,
          style: AppTypography.bodyMedium.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            height: 1.6,
          ),
        ),
        AppSpacing.vLg,
        _buildCtas(context),
        AppSpacing.vXl,
        _buildPlatformPreview(isDark),
        AppSpacing.vLg,
        _buildTrustMetrics(isDark),
      ],
    );
  }

  Widget _buildBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(isDark ? 40 : 20),
        borderRadius: AppRadius.full,
        border: Border.all(
          color: AppColors.primary.withAlpha(isDark ? 80 : 50),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          AppSpacing.hSm,
          Flexible(
            child: Text(
              'Multi-Branch Enterprise Cloud Platform',
              style: AppTypography.labelMedium.copyWith(
                color: isDark ? AppColors.primaryLight : AppColors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCtas(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: [
        AppButton(
          text: 'Get Started Free',
          height: 48,
          icon: Icons.arrow_forward_rounded,
          onPressed: () => context.goNamed(RouteNames.login),
        ),
        AppButton(
          text: 'Sign In to Panel',
          variant: AppButtonVariant.outline,
          height: 48,
          icon: Icons.login_rounded,
          onPressed: () => context.goNamed(RouteNames.login),
        ),
      ],
    );
  }

  Widget _buildTrustMetrics(bool isDark) {
    return Wrap(
      spacing: 24,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _MetricItem(title: '99.9%', subtitle: 'Uptime SLA', isDark: isDark),
        _MetricItem(
          title: 'Real-Time',
          subtitle: 'Branch Sync',
          isDark: isDark,
        ),
        _MetricItem(
          title: 'End-to-End',
          subtitle: 'Encrypted RBAC',
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildPlatformPreview(bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      enableHover: true,
      color: isDark ? const Color(0xFF131B2E) : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mock Window Bar
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
              ),
              AppSpacing.hXs,
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFFF59E0B),
                  shape: BoxShape.circle,
                ),
              ),
              AppSpacing.hXs,
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Container(
                  height: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : AppColors.backgroundLight,
                    borderRadius: AppRadius.sm,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'https://app.pushpak.io/organization/dashboard',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.vLg,

          // Organization Header in Preview
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apex International Group',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      'Organization Control Center • 8 Active Branches',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.hSm,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(30),
                  borderRadius: AppRadius.full,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 14,
                    ),
                    AppSpacing.hXs,
                    Text(
                      'All Systems Operational',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.success,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.vMd,

          // Mini Branch Cards in Mockup
          Row(
            children: [
              Expanded(
                child: _MockBranchCard(
                  name: 'Mumbai Central',
                  metric: '1,420 Students',
                  status: 'Active',
                  isDark: isDark,
                  color: AppColors.primary,
                ),
              ),
              AppSpacing.hSm,
              Expanded(
                child: _MockBranchCard(
                  name: 'Delhi North',
                  metric: '980 Students',
                  status: 'Active',
                  isDark: isDark,
                  color: AppColors.secondary,
                ),
              ),
              AppSpacing.hSm,
              Expanded(
                child: _MockBranchCard(
                  name: 'Bengaluru Tech',
                  metric: '2,150 Students',
                  status: 'Active',
                  isDark: isDark,
                  color: const Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
          AppSpacing.vMd,

          // Live Activity Log Preview
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withAlpha(5)
                  : AppColors.backgroundLight,
              borderRadius: AppRadius.sm,
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.sync_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
                AppSpacing.hSm,
                Expanded(
                  child: Text(
                    'Real-time automated sync across 8 branches completed 2 seconds ago.',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDark;

  const _MetricItem({
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          ),
        ),
      ],
    );
  }
}

class _MockBranchCard extends StatelessWidget {
  final String name;
  final String metric;
  final String status;
  final bool isDark;
  final Color color;

  const _MockBranchCard({
    required this.name,
    required this.metric,
    required this.status,
    required this.isDark,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              Text(
                status,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 10,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          AppSpacing.vXs,
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelMedium.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          Text(
            metric,
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
}
