import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/extensions/context_extensions.dart';
import 'app_button.dart';
import 'app_card.dart';

/// A production-grade, reusable empty/error/restricted state template.
///
/// Use this template when:
/// 1. Backend returns an empty list or no matching records.
/// 2. Access is denied / unauthorized (403 Forbidden).
/// 3. Server or connection errors occur (500, timeout, offline).
class NoDataFoundTemplate extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionText;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final String? secondaryActionText;
  final IconData? secondaryActionIcon;
  final VoidCallback? onSecondaryAction;
  final bool isError;
  final bool isAccessDenied;
  final bool isCompact;
  final bool cardWrapper;

  const NoDataFoundTemplate({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.title = 'No Data Found',
    this.message,
    this.actionText,
    this.actionIcon,
    this.onAction,
    this.secondaryActionText,
    this.secondaryActionIcon,
    this.onSecondaryAction,
    this.isError = false,
    this.isAccessDenied = false,
    this.isCompact = false,
    this.cardWrapper = true,
  });

  /// Factory preset for Access Denied / 403 Forbidden states
  factory NoDataFoundTemplate.accessDenied({
    Key? key,
    String title = 'Access Denied',
    String message =
        'You do not have the required permissions to view or manage this data. Please contact your organization administrator.',
    String? actionText,
    IconData? actionIcon,
    VoidCallback? onAction,
    bool isCompact = false,
    bool cardWrapper = true,
  }) {
    return NoDataFoundTemplate(
      key: key,
      icon: Icons.lock_person_outlined,
      title: title,
      message: message,
      actionText: actionText,
      actionIcon: actionIcon,
      onAction: onAction,
      isAccessDenied: true,
      isCompact: isCompact,
      cardWrapper: cardWrapper,
    );
  }

  /// Factory preset for Server / Network error states
  factory NoDataFoundTemplate.error({
    Key? key,
    String title = 'Unable to Load Data',
    String message =
        'A server communication or connectivity issue occurred while retrieving records. Please check your connection and try again.',
    String actionText = 'Retry',
    IconData actionIcon = Icons.refresh_rounded,
    VoidCallback? onRetry,
    bool isCompact = false,
    bool cardWrapper = true,
  }) {
    return NoDataFoundTemplate(
      key: key,
      icon: Icons.cloud_off_rounded,
      title: title,
      message: message,
      actionText: actionText,
      actionIcon: actionIcon,
      onAction: onRetry,
      isError: true,
      isCompact: isCompact,
      cardWrapper: cardWrapper,
    );
  }

  Color _getThemeColor() {
    if (isAccessDenied) return AppColors.warning;
    if (isError) return AppColors.error;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final themeColor = _getThemeColor();

    final content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? AppSpacing.md : AppSpacing.xl,
        vertical: isCompact ? AppSpacing.lg : AppSpacing.xxl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Styled Icon Bubble
              Container(
                width: isCompact ? 56 : 72,
                height: isCompact ? 56 : 72,
                decoration: BoxDecoration(
                  color: themeColor.withAlpha(isDark ? 35 : 18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: themeColor.withAlpha(isDark ? 70 : 40),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: isCompact ? 28 : 36,
                    color: themeColor,
                  ),
                ),
              ),
              SizedBox(height: isCompact ? AppSpacing.sm : AppSpacing.md),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: (isCompact
                        ? AppTypography.titleMedium
                        : AppTypography.titleLarge)
                    .copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),

              // Message Description
              if (message != null && message!.isNotEmpty) ...[
                AppSpacing.vXs,
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                    height: 1.5,
                  ),
                ),
              ],

              // Actions Row
              if (onAction != null || onSecondaryAction != null) ...[
                SizedBox(height: isCompact ? AppSpacing.md : AppSpacing.lg),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (onSecondaryAction != null &&
                        secondaryActionText != null)
                      OutlinedButton.icon(
                        onPressed: onSecondaryAction,
                        icon: Icon(
                          secondaryActionIcon ?? Icons.clear_rounded,
                          size: 16,
                        ),
                        label: Text(secondaryActionText!),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.sm,
                          ),
                        ),
                      ),
                    if (onAction != null && actionText != null)
                      AppButton(
                        text: actionText!,
                        icon: actionIcon,
                        onPressed: onAction,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (!cardWrapper) {
      return content;
    }

    return AppCard(
      padding: EdgeInsets.zero,
      child: content,
    );
  }
}
