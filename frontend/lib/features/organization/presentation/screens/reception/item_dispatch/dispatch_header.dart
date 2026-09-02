import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_button.dart';

class DispatchHeader extends StatelessWidget {
  final VoidCallback? onExport;
  final VoidCallback onNewDispatch;

  const DispatchHeader({
    super.key,
    this.onExport,
    required this.onNewDispatch,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;

    final headerTexts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Breadcrumbs
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Reception',
              style: AppTypography.bodySmall.copyWith(
                color: isDark
                    ? AppColors.textMutedDark
                    : AppColors.textMutedLight,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                '/',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.textMutedDark
                      : AppColors.textMutedLight,
                ),
              ),
            ),
            Text(
              'Item Dispatch',
              style: AppTypography.bodySmall.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,

        // Title
        Text(
          'Item Dispatch',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,

        // Description
        Text(
          'Manage outgoing items and shipments',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButtons = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        AppButton(
          text: 'Export',
          icon: Icons.download_rounded,
          variant: AppButtonVariant.outline,
          onPressed: onExport ?? () {},
          height: 38,
        ),
        AppButton(
          text: 'New Dispatch',
          icon: Icons.add_rounded,
          onPressed: onNewDispatch,
          height: 38,
        ),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerTexts,
          AppSpacing.vMd,
          actionButtons,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: headerTexts),
        actionButtons,
      ],
    );
  }
}
