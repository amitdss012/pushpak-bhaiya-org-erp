import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_button.dart';

class VisitEnquiryActions extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const VisitEnquiryActions({
    super.key,
    required this.isSubmitting,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppButton(
            text: 'Cancel',
            variant: AppButtonVariant.outline,
            icon: Icons.close_rounded,
            onPressed: isSubmitting ? null : onCancel,
            height: 44,
          ),
          AppSpacing.hMd,
          AppButton(
            text: isSubmitting ? 'Registering...' : 'Register Visitor',
            icon: Icons.save_rounded,
            isLoading: isSubmitting,
            onPressed: onSubmit,
            height: 44,
          ),
        ],
      ),
    );
  }
}
