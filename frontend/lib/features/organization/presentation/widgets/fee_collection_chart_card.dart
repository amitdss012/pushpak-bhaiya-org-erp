import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_card.dart';

class FeeCollectionChartCard extends StatelessWidget {
  const FeeCollectionChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Financial & Fee Inflow',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(isDark ? 40 : 20),
                  borderRadius: AppRadius.sm,
                ),
                child: Text(
                  'Aug 2026',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.vSm,
          Text(
            'Centralized collection across Razorpay, Stripe, and UPI channels',
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          AppSpacing.vLg,

          // Target bar overview
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹42,85,400',
                style: AppTypography.headlineLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              Text(
                'Target: ₹50,00,000',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.textMutedDark
                      : AppColors.textMutedLight,
                ),
              ),
            ],
          ),
          AppSpacing.vSm,
          ClipRRect(
            borderRadius: AppRadius.full,
            child: LinearProgressIndicator(
              value: 0.857,
              minHeight: 8,
              backgroundColor: isDark
                  ? Colors.white10
                  : AppColors.backgroundLight,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          AppSpacing.vLg,
          const Divider(height: 1),
          AppSpacing.vLg,

          // Channel Breakdown List
          _buildChannelRow(
            'Online Gateway (Razorpay/Stripe)',
            '₹26.56 L',
            0.62,
            const Color(0xFF6366F1),
            isDark,
          ),
          AppSpacing.vMd,
          _buildChannelRow(
            'Direct Bank Transfer (NEFT/RTGS)',
            '₹10.28 L',
            0.24,
            const Color(0xFF0EA5E9),
            isDark,
          ),
          AppSpacing.vMd,
          _buildChannelRow(
            'Branch POS / Cash Collection',
            '₹6.01 L',
            0.14,
            const Color(0xFF10B981),
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildChannelRow(
    String name,
    String amount,
    double ratio,
    Color color,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                AppSpacing.hSm,
                Text(
                  name,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Text(
              amount,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
        AppSpacing.vXs,
        ClipRRect(
          borderRadius: AppRadius.full,
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 4,
            backgroundColor: isDark ? Colors.white10 : AppColors.borderLight,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
