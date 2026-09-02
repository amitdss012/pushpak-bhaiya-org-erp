import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/app_card.dart';
import '../../../../navigation/configuration/sidebar_menu_config.dart';

class ModulePlaceholderScreen extends StatelessWidget {
  final String path;

  const ModulePlaceholderScreen({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final match = SidebarMenuConfig.findByPath(path);

    final parentTitle = match?.parent.title ?? 'Module';
    final pageTitle = match?.item.title ?? 'Page';
    final pageIcon = match?.item.icon ?? Icons.construction_rounded;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumbs
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                parentTitle,
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
                pageTitle,
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

          // Page Title
          Text(
            pageTitle,
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          AppSpacing.vXs,

          // Subtitle
          Text(
            'Manage and configure $pageTitle under the $parentTitle department.',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          AppSpacing.vXl,

          // Placeholder Content Card
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(isDark ? 40 : 25),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withAlpha(80),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          pageIcon,
                          size: 32,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    AppSpacing.vLg,
                    Text(
                      '$pageTitle Under Construction',
                      textAlign: TextAlign.center,
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    AppSpacing.vSm,
                    Text(
                      'This screen is configured in GoRouter and ready for UI implementation. The route path is `$path`.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    AppSpacing.vLg,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.backgroundDark
                            : AppColors.backgroundLight,
                        borderRadius: AppRadius.sm,
                        border: Border.all(
                          color: isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight,
                        ),
                      ),
                      child: Text(
                        'Route: $path',
                        style: AppTypography.bodySmall.copyWith(
                          fontFamily: 'monospace',
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight,
                        ),
                      ),
                    ),
                    AppSpacing.vXl,
                    AppButton(
                      text: 'Back to Dashboard',
                      icon: Icons.arrow_back_rounded,
                      variant: AppButtonVariant.outline,
                      onPressed: () => context.go(RouteNames.dashboardPath),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
