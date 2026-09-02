import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_radius.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_button.dart';

class VisitorCheckoutDialog extends StatelessWidget {
  final Map<String, dynamic> visitor;
  final VoidCallback onConfirm;

  const VisitorCheckoutDialog({
    super.key,
    required this.visitor,
    required this.onConfirm,
  });

  String _formatTime() {
    final now = TimeOfDay.now();
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final name = visitor['name'] as String? ?? '';
    final id = visitor['id'] as String? ?? '';
    final purpose = visitor['purpose'] as String? ?? '';
    final checkIn = visitor['checkIn'] as String? ?? '';
    final initials = name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join();

    return Dialog(
      backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Visitor Check-out',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              AppSpacing.vMd,

              // Visitor Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.backgroundDark.withAlpha(120)
                      : AppColors.backgroundLight,
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark.withAlpha(80)
                        : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primary.withAlpha(isDark ? 50 : 25),
                      child: Text(
                        initials,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    AppSpacing.hMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            '$id • $purpose',
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.textMutedDark
                                  : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.vMd,

              // Check-in vs Check-out times
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Check-in Time',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.textMutedLight,
                          ),
                        ),
                        AppSpacing.vXs,
                        Text(
                          checkIn,
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Check-out Time',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.textMutedLight,
                          ),
                        ),
                        AppSpacing.vXs,
                        Text(
                          _formatTime(),
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppSpacing.vMd,

              // Remarks
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Remarks (Optional)',
                    style: AppTypography.labelMedium.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.vXs,
                  TextFormField(
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Any notes about the visit...',
                    ),
                  ),
                ],
              ),
              AppSpacing.vLg,

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    text: 'Cancel',
                    variant: AppButtonVariant.outline,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  AppSpacing.hSm,
                  AppButton(
                    text: 'Confirm Check-out',
                    icon: Icons.logout_rounded,
                    onPressed: onConfirm,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
