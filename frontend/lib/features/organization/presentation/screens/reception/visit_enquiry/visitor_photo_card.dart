import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/app_card.dart';

class VisitorPhotoCard extends StatelessWidget {
  final VoidCallback? onUploadPhoto;

  const VisitorPhotoCard({
    super.key,
    this.onUploadPhoto,
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
            'Visitor Photo',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          AppSpacing.vLg,
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circular photo avatar
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.backgroundDark.withAlpha(120)
                        : AppColors.backgroundLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.file_upload_outlined,
                      size: 36,
                      color: isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                    ),
                  ),
                ),
                AppSpacing.vLg,

                // Action button
                AppButton(
                  text: 'Capture / Upload Photo',
                  icon: Icons.upload_rounded,
                  variant: AppButtonVariant.outline,
                  onPressed: onUploadPhoto ?? () {},
                  height: 38,
                ),
                AppSpacing.vSm,

                // Subtitle
                Text(
                  'Take a photo using webcam or upload from device',
                  textAlign: TextAlign.center,
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
    );
  }
}
