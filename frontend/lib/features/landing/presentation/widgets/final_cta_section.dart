import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/max_width_container.dart';

class FinalCtaSection extends StatelessWidget {
  const FinalCtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 48 : 80),
      child: MaxWidthContainer(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 48,
            vertical: isMobile ? 40 : 64,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)],
            ),
            borderRadius: AppRadius.xl,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(50),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Ready to Modernize Your Entire Organization?',
                textAlign: TextAlign.center,
                style:
                    (isMobile
                            ? AppTypography.headlineMedium
                            : AppTypography.displayMedium)
                        .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
              ),
              AppSpacing.vMd,
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Text(
                  'Join forward-thinking institutions that manage branches, staff, students, and operations seamlessly with Pushpak SaaS.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyLarge.copyWith(
                    color: Colors.white.withAlpha(220),
                  ),
                ),
              ),
              AppSpacing.vXxl,
              Wrap(
                spacing: 16,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  AppButton(
                    text: 'Get Started Now',
                    height: 50,
                    icon: Icons.rocket_launch_rounded,
                    onPressed: () => context.goNamed(RouteNames.login),
                  ),
                  AppButton(
                    text: 'Sign In to Account',
                    variant: AppButtonVariant.outline,
                    height: 50,
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => context.goNamed(RouteNames.login),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
