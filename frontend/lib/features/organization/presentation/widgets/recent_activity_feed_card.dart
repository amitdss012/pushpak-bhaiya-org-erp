import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_card.dart';

class RecentActivityItemModel {
  final int id;
  final String action;
  final String student;
  final String time;
  final String type;

  const RecentActivityItemModel({
    required this.id,
    required this.action,
    required this.student,
    required this.time,
    required this.type,
  });
}

class RecentActivityFeedCard extends StatelessWidget {
  const RecentActivityFeedCard({super.key});

  static const List<RecentActivityItemModel> _activities = [
    RecentActivityItemModel(
      id: 1,
      action: 'New student admitted',
      student: 'John Doe',
      time: '2 hours ago',
      type: 'admission',
    ),
    RecentActivityItemModel(
      id: 2,
      action: 'Fee payment received',
      student: 'Sarah Smith',
      time: '3 hours ago',
      type: 'payment',
    ),
    RecentActivityItemModel(
      id: 3,
      action: 'Exam scheduled',
      student: 'Physics Final',
      time: '5 hours ago',
      type: 'exam',
    ),
    RecentActivityItemModel(
      id: 4,
      action: 'Certificate issued',
      student: 'Mike Johnson',
      time: '6 hours ago',
      type: 'certificate',
    ),
    RecentActivityItemModel(
      id: 5,
      action: 'Due fee reminder sent',
      student: 'Emily Brown',
      time: '8 hours ago',
      type: 'reminder',
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
          // Header
          Row(
            children: [
              const Icon(
                Icons.people_alt_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              AppSpacing.hSm,
              Text(
                'Recent Activity',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          AppSpacing.vLg,

          // List of Activities
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _activities.length,
            separatorBuilder: (context, index) => AppSpacing.vSm,
            itemBuilder: (context, index) {
              final activity = _activities[index];
              final isPayment = activity.type == 'payment';
              final isReminder = activity.type == 'reminder';

              Color badgeBg;
              Color badgeTextColor;

              if (isPayment) {
                badgeBg = AppColors.success.withAlpha(isDark ? 40 : 25);
                badgeTextColor = isDark ? AppColors.successLight : AppColors.success;
              } else if (isReminder) {
                badgeBg = AppColors.warning.withAlpha(isDark ? 40 : 25);
                badgeTextColor = isDark ? AppColors.warningLight : AppColors.warning;
              } else {
                badgeBg = isDark
                    ? AppColors.surfaceCardDark
                    : AppColors.backgroundLight;
                badgeTextColor = isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight;
              }

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.backgroundDark.withAlpha(80)
                      : AppColors.backgroundLight.withAlpha(120),
                  borderRadius: AppRadius.sm,
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark.withAlpha(60)
                        : AppColors.borderLight.withAlpha(80),
                  ),
                ),
                child: Row(
                  children: [
                    // Avatar with initial
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(isDark ? 40 : 20),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          activity.student.isNotEmpty
                              ? activity.student[0].toUpperCase()
                              : '?',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    AppSpacing.hMd,

                    // Action and Student details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.action,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            activity.student,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.textMutedDark
                                  : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.hSm,

                    // Badge and timestamp
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: AppRadius.full,
                            border: Border.all(
                              color: badgeTextColor.withAlpha(80),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isPayment) ...[
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 12,
                                  color: badgeTextColor,
                                ),
                                AppSpacing.hXs,
                              ],
                              Text(
                                activity.type,
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: badgeTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.vXs,
                        Text(
                          activity.time,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.textMutedLight,
                          ),
                        ),
                      ],
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
