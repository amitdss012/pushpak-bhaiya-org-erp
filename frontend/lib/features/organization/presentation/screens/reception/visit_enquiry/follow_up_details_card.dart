import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_card.dart';
import '../../../../../../shared/widgets/app_text_field.dart';

class FollowUpDetailsCard extends StatelessWidget {
  final TextEditingController followUpDateController;
  final TextEditingController followUpTimeController;
  final TextEditingController followUpNotesController;

  const FollowUpDetailsCard({
    super.key,
    required this.followUpDateController,
    required this.followUpTimeController,
    required this.followUpNotesController,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      followUpDateController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
    );
    if (picked != null) {
      followUpTimeController.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isDesktop = context.isDesktop || context.isUltraWide || context.isTablet;

    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.phone_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              AppSpacing.hSm,
              Text(
                'Follow-up Details',
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

          // Row 1: Follow-up Call Date & Preferred Time
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(context),
                    child: IgnorePointer(
                      child: AppTextField(
                        controller: followUpDateController,
                        label: 'Follow-up Call Date',
                        hint: 'YYYY-MM-DD',
                        suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                      ),
                    ),
                  ),
                ),
                AppSpacing.hMd,
                Expanded(
                  child: InkWell(
                    onTap: () => _pickTime(context),
                    child: IgnorePointer(
                      child: AppTextField(
                        controller: followUpTimeController,
                        label: 'Preferred Time',
                        hint: 'HH:MM',
                        suffixIcon: const Icon(Icons.schedule_rounded, size: 18),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else ...[
            InkWell(
              onTap: () => _pickDate(context),
              child: IgnorePointer(
                child: AppTextField(
                  controller: followUpDateController,
                  label: 'Follow-up Call Date',
                  hint: 'YYYY-MM-DD',
                  suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                ),
              ),
            ),
            AppSpacing.vMd,
            InkWell(
              onTap: () => _pickTime(context),
              child: IgnorePointer(
                child: AppTextField(
                  controller: followUpTimeController,
                  label: 'Preferred Time',
                  hint: 'HH:MM',
                  suffixIcon: const Icon(Icons.schedule_rounded, size: 18),
                ),
              ),
            ),
          ],
          AppSpacing.vMd,

          // Row 2: Follow-up Notes
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Follow-up Notes',
                style: AppTypography.labelMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.vXs,
              TextFormField(
                controller: followUpNotesController,
                maxLines: 2,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
                decoration: const InputDecoration(
                  hintText: 'Any notes for the follow-up call...',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
