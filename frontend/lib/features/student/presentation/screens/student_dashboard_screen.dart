import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 40,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon Badge
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)],
                        ),
                        borderRadius: AppRadius.md,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    AppSpacing.vLg,

                    // Headline
                    Text(
                      'Welcome to Student Portal',
                      textAlign: TextAlign.center,
                      style: AppTypography.headlineMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    AppSpacing.vSm,

                    // Subtitle
                    Text(
                      'Access course materials, daily timetables, attendance history, exam schedules, and grade sheets.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    AppSpacing.vXl,

                    // Sign Out / Back Button
                    AppButton(
                      text: 'Sign Out to Login',
                      variant: AppButtonVariant.outline,
                      icon: Icons.logout_rounded,
                      onPressed: () => context.goNamed(RouteNames.login),
                      height: 44,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
