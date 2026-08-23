import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/login_portal_type.dart';

class LoginPortalSelector extends StatelessWidget {
  final LoginPortalType selectedPortal;
  final ValueChanged<LoginPortalType> onPortalChanged;

  const LoginPortalSelector({
    super.key,
    required this.selectedPortal,
    required this.onPortalChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: LoginPortalType.values.map((portal) {
          final isSelected = portal == selectedPortal;

          return Expanded(
            child: InkWell(
              onTap: () => onPortalChanged(portal),
              borderRadius: AppRadius.sm,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 4,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? AppColors.primary : AppColors.primary)
                      : Colors.transparent,
                  borderRadius: AppRadius.sm,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(
                              isDark ? 80 : 60,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      portal.icon,
                      size: 18,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight),
                    ),
                    AppSpacing.vXs,
                    Text(
                      portal.title,
                      style: AppTypography.labelMedium.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
