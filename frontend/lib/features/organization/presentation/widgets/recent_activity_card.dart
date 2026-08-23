import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_card.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

  static const List<_ActivityItem> _activities = [
    _ActivityItem(
      title: 'New Student Admission Form Submitted',
      description:
          'Aarav Sharma enrolled in Computer Science batch at Mumbai Central.',
      time: '4 mins ago',
      icon: Icons.how_to_reg_rounded,
      iconColor: AppColors.primary,
    ),
    _ActivityItem(
      title: 'Branch Wallet Recharged',
      description:
          '₹50,000 wallet top-up processed for Delhi North branch SMS gateway.',
      time: '18 mins ago',
      icon: Icons.account_balance_wallet_outlined,
      iconColor: AppColors.secondary,
    ),
    _ActivityItem(
      title: 'Term 1 Exam Schedule Published',
      description:
          'Mid-term schedule released across 8 branches by Exam Controller.',
      time: '1 hour ago',
      icon: Icons.calendar_month_outlined,
      iconColor: Color(0xFF8B5CF6),
    ),
    _ActivityItem(
      title: 'Monthly Fee Invoiced',
      description: 'Batch fee invoices generated for 1,420 students at Bengaluru branch.',
      time: '3 hours ago',
      icon: Icons.receipt_long_rounded,
      iconColor: AppColors.success,
    ),
  ];

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
                'Live Organization Activity',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          AppSpacing.vSm,
          Text(
            'Immutable audit events and cross-branch operational updates',
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          AppSpacing.vLg,
          const Divider(height: 1),
          AppSpacing.vMd,
          ..._activities.map((act) => _buildActivityRow(act, isDark)),
        ],
      ),
    );
  }

  Widget _buildActivityRow(_ActivityItem item, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item.iconColor.withAlpha(isDark ? 40 : 20),
              borderRadius: AppRadius.sm,
            ),
            child: Icon(item.icon, color: item.iconColor, size: 18),
          ),
          AppSpacing.hMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          fontSize: 13.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppSpacing.hSm,
                    Text(
                      item.time,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                      ),
                    ),
                  ],
                ),
                AppSpacing.vXs,
                Text(
                  item.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    height: 1.4,
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

class _ActivityItem {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color iconColor;

  const _ActivityItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.iconColor,
  });
}
