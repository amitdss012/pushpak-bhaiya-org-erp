import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/extensions/context_extensions.dart';

enum AppButtonVariant { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AppButtonVariant.primary
                    ? Colors.white
                    : AppColors.primary,
              ),
            ),
          ),
          AppSpacing.hSm,
        ] else if (icon != null) ...[
          Icon(icon, size: 18),
          AppSpacing.hSm,
        ],
        Text(
          text,
          style: AppTypography.labelLarge.copyWith(
            color: _getTextColor(isDark),
          ),
        ),
      ],
    );

    final buttonStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(width ?? 0, height)),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.md),
      ),
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return isDark ? Colors.white10 : Colors.black12;
        }
        return _getBackgroundColor(isDark);
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (variant == AppButtonVariant.outline) {
          return BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          );
        }
        return BorderSide.none;
      }),
    );

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: isLoading ? null : onPressed,
        child: content,
      ),
    );
  }

  Color _getBackgroundColor(bool isDark) {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.primary;
      case AppButtonVariant.secondary:
        return isDark ? AppColors.surfaceCardDark : AppColors.primaryLight;
      case AppButtonVariant.outline:
      case AppButtonVariant.text:
        return Colors.transparent;
    }
  }

  Color _getTextColor(bool isDark) {
    switch (variant) {
      case AppButtonVariant.primary:
        return Colors.white;
      case AppButtonVariant.secondary:
        return isDark ? AppColors.textPrimaryDark : AppColors.primary;
      case AppButtonVariant.outline:
        return isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
      case AppButtonVariant.text:
        return isDark ? AppColors.textPrimaryDark : AppColors.primary;
    }
  }
}
