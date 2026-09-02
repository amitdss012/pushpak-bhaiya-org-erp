import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_radius.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_card.dart';

class IdDocumentCard extends StatelessWidget {
  final VoidCallback? onUploadDocument;

  const IdDocumentCard({
    super.key,
    this.onUploadDocument,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ID Document',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          AppSpacing.vLg,
          InkWell(
            onTap: onUploadDocument ?? () {},
            borderRadius: AppRadius.md,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.backgroundDark.withAlpha(80)
                    : AppColors.backgroundLight.withAlpha(120),
                borderRadius: AppRadius.md,
                border: Border.all(
                  color: isDark
                      ? AppColors.borderDark
                      : AppColors.borderLight,
                  style: BorderStyle.solid,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 32,
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                  ),
                  AppSpacing.vSm,
                  Text(
                    'Upload ID proof',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  AppSpacing.vXs,
                  Text(
                    'JPG, PNG up to 5MB',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
