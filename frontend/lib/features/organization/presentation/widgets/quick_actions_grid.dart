import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_card.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;

    final int crossAxisCount = isMobile ? 2 : (isTablet ? 3 : 6);

    final actions = [
      _ActionData(
        title: 'Create Branch',
        icon: Icons.add_business_rounded,
        color: const Color(0xFF6366F1),
      ),
      _ActionData(
        title: 'New Admission',
        icon: Icons.how_to_reg_rounded,
        color: const Color(0xFF0EA5E9),
      ),
      _ActionData(
        title: 'Collect Fee',
        icon: Icons.point_of_sale_rounded,
        color: const Color(0xFF10B981),
      ),
      _ActionData(
        title: 'Notice Board',
        icon: Icons.campaign_outlined,
        color: const Color(0xFFF59E0B),
      ),
      _ActionData(
        title: 'Generate Admit',
        icon: Icons.print_outlined,
        color: const Color(0xFF8B5CF6),
      ),
      _ActionData(
        title: 'Live Class Setup',
        icon: Icons.video_call_rounded,
        color: const Color(0xFFEC4899),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Operations',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vSm,
        LayoutBuilder(
          builder: (context, constraints) {
            final double itemWidth =
                (constraints.maxWidth - (crossAxisCount - 1) * 12) /
                crossAxisCount;

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: actions.map((act) {
                return SizedBox(
                  width: itemWidth,
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    enableHover: true,
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: act.color.withAlpha(isDark ? 40 : 20),
                            borderRadius: AppRadius.sm,
                          ),
                          child: Icon(act.icon, color: act.color, size: 20),
                        ),
                        AppSpacing.vSm,
                        Text(
                          act.title,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ActionData {
  final String title;
  final IconData icon;
  final Color color;

  const _ActionData({
    required this.title,
    required this.icon,
    required this.color,
  });
}
