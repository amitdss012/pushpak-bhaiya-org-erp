import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_card.dart';

class CourseDistributionItem {
  final String name;
  final double value;
  final Color color;

  const CourseDistributionItem({
    required this.name,
    required this.value,
    required this.color,
  });
}

class CourseDistributionCard extends StatefulWidget {
  const CourseDistributionCard({super.key});

  @override
  State<CourseDistributionCard> createState() => _CourseDistributionCardState();
}

class _CourseDistributionCardState extends State<CourseDistributionCard> {
  int _touchedIndex = -1;

  static const List<CourseDistributionItem> _courses = [
    CourseDistributionItem(
      name: 'Science',
      value: 35,
      color: Color(0xFF6366F1), // Indigo (Chart 1)
    ),
    CourseDistributionItem(
      name: 'Commerce',
      value: 25,
      color: Color(0xFF0EA5E9), // Sky (Chart 2)
    ),
    CourseDistributionItem(
      name: 'Arts',
      value: 20,
      color: Color(0xFFF59E0B), // Amber (Chart 3)
    ),
    CourseDistributionItem(
      name: 'Engineering',
      value: 15,
      color: Color(0xFF10B981), // Emerald (Chart 4)
    ),
    CourseDistributionItem(
      name: 'Medical',
      value: 5,
      color: Color(0xFFEC4899), // Pink (Chart 5)
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Row(
            children: [
              const Icon(
                Icons.menu_book_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              AppSpacing.hSm,
              Text(
                'Course Distribution',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          AppSpacing.vMd,

          // Donut Pie Chart
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex = pieTouchResponse
                          .touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 46,
                sections: List.generate(_courses.length, (i) {
                  final isTouched = i == _touchedIndex;
                  final fontSize = isTouched ? 14.0 : 11.0;
                  final radius = isTouched ? 36.0 : 30.0;
                  final item = _courses[i];

                  return PieChartSectionData(
                    color: item.color,
                    value: item.value,
                    title: '${item.value.toInt()}%',
                    radius: radius,
                    titleStyle: AppTypography.bodySmall.copyWith(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  );
                }),
              ),
            ),
          ),
          AppSpacing.vLg,

          // 2-Column Legend Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _courses.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 16,
              mainAxisExtent: 24,
            ),
            itemBuilder: (context, index) {
              final item = _courses[index];
              return Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: item.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  AppSpacing.hSm,
                  Expanded(
                    child: Text(
                      item.name,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${item.value.toInt()}%',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
