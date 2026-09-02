import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_radius.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/app_status_badge.dart';

class VisitorDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> visitor;
  final VoidCallback? onPrintPass;

  const VisitorDetailsDialog({
    super.key,
    required this.visitor,
    this.onPrintPass,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    final name = visitor['name'] as String? ?? '';
    final id = visitor['id'] as String? ?? '';
    final phone = visitor['phone'] as String? ?? '';
    final email = visitor['email'] as String? ?? '';
    final purpose = visitor['purpose'] as String? ?? '';
    final personToMeet = visitor['personToMeet'] as String? ?? '';
    final department = visitor['department'] as String? ?? '';
    final checkIn = visitor['checkIn'] as String? ?? '';
    final checkOut = visitor['checkOut'] as String?;
    final status = visitor['status'] as String? ?? 'active';
    final idType = visitor['idType'] as String? ?? '';
    final idNumber = visitor['idNumber'] as String? ?? '';
    final enquiryReason = visitor['enquiryReason'] as String? ?? '';
    final location = visitor['location'] as String? ?? '';
    final followUpDate = visitor['followUpDate'] as String?;

    final initials = name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join();

    AppBadgeStatus badgeStatus;
    switch (status) {
      case 'completed':
        badgeStatus = AppBadgeStatus.completed;
        break;
      case 'pending':
        badgeStatus = AppBadgeStatus.pending;
        break;
      default:
        badgeStatus = AppBadgeStatus.active;
    }

    return Dialog(
      backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Visitor Details',
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
                padding: const EdgeInsets.all(16),
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
                      radius: 26,
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
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            phone,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                          Text(
                            email,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.textMutedDark
                                  : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppStatusBadge(status: badgeStatus),
                  ],
                ),
              ),
              AppSpacing.vLg,

              // 2-Column Details Grid
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildDetailItem('Visitor ID', id, isDark)),
                          AppSpacing.hMd,
                          Expanded(child: _buildDetailItem('Purpose', purpose, isDark)),
                        ],
                      ),
                      AppSpacing.vMd,
                      _buildDetailItem('Enquiry Reason', enquiryReason, isDark),
                      AppSpacing.vMd,
                      Row(
                        children: [
                          Expanded(child: _buildDetailItem('Location', location, isDark, icon: Icons.location_on_outlined)),
                          AppSpacing.hMd,
                          Expanded(
                            child: _buildDetailItem(
                              'Follow-up Date',
                              followUpDate ?? 'Not scheduled',
                              isDark,
                              icon: followUpDate != null ? Icons.phone_rounded : null,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.vMd,
                      Row(
                        children: [
                          Expanded(child: _buildDetailItem('Person to Meet', personToMeet, isDark)),
                          AppSpacing.hMd,
                          Expanded(child: _buildDetailItem('Department', department, isDark)),
                        ],
                      ),
                      AppSpacing.vMd,
                      Row(
                        children: [
                          Expanded(child: _buildDetailItem('ID Type', idType, isDark)),
                          AppSpacing.hMd,
                          Expanded(child: _buildDetailItem('ID Number', idNumber, isDark)),
                        ],
                      ),
                      AppSpacing.vMd,
                      Row(
                        children: [
                          Expanded(child: _buildDetailItem('Check-in', checkIn, isDark)),
                          AppSpacing.hMd,
                          Expanded(child: _buildDetailItem('Check-out', checkOut ?? 'Not checked out', isDark)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.vLg,

              // Dialog Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    text: 'Print Pass',
                    icon: Icons.print_rounded,
                    variant: AppButtonVariant.outline,
                    onPressed: onPrintPass ?? () {},
                  ),
                  AppSpacing.hSm,
                  AppButton(
                    text: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, bool isDark, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelMedium.copyWith(
            fontSize: 10,
            letterSpacing: 0.5,
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            fontWeight: FontWeight.w700,
          ),
        ),
        AppSpacing.vXs,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: AppColors.primary),
              AppSpacing.hXs,
            ],
            Flexible(
              child: Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
