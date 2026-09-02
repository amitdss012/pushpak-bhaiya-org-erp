import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_card.dart';

class UpcomingEventModel {
  final int id;
  final String title;
  final String date;
  final String type;

  const UpcomingEventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
  });
}

class UpcomingEventsCard extends StatelessWidget {
  const UpcomingEventsCard({super.key});

  static const List<UpcomingEventModel> _events = [
    UpcomingEventModel(
      id: 1,
      title: 'Mid-term Exams',
      date: 'Jan 25, 2024',
      type: 'exam',
    ),
    UpcomingEventModel(
      id: 2,
      title: 'Parent-Teacher Meeting',
      date: 'Jan 28, 2024',
      type: 'meeting',
    ),
    UpcomingEventModel(
      id: 3,
      title: 'Annual Sports Day',
      date: 'Feb 5, 2024',
      type: 'event',
    ),
    UpcomingEventModel(
      id: 4,
      title: 'Fee Submission Deadline',
      date: 'Feb 10, 2024',
      type: 'deadline',
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
                Icons.calendar_today_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              AppSpacing.hSm,
              Text(
                'Upcoming Events',
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

          // Events List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _events.length,
            separatorBuilder: (context, index) => AppSpacing.vSm,
            itemBuilder: (context, index) {
              final event = _events[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.backgroundDark.withAlpha(120)
                      : AppColors.backgroundLight.withAlpha(200),
                  borderRadius: AppRadius.sm,
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark.withAlpha(80)
                        : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: const Icon(
                        Icons.calendar_month_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    AppSpacing.hMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            event.date,
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceCardDark
                            : AppColors.surfaceLight,
                        borderRadius: AppRadius.full,
                        border: Border.all(
                          color: isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight,
                        ),
                      ),
                      child: Text(
                        event.type,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
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
