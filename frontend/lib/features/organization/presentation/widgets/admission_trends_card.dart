import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_card.dart';

class AdmissionTrendsCard extends StatelessWidget {
  const AdmissionTrendsCard({super.key});

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
  static const _studentCounts = [45.0, 52.0, 78.0, 65.0, 90.0, 85.0];

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
                Icons.trending_up_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              AppSpacing.hSm,
              Text(
                'Admission Trends',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          AppSpacing.vLg,

          // Area Line Chart
          SizedBox(
            height: 260,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 100,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 25,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark
                        ? AppColors.borderDark.withAlpha(80)
                        : AppColors.borderLight,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: isDark
                        ? AppColors.borderDark.withAlpha(80)
                        : AppColors.borderLight,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 25,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.textMutedLight,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < _months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _months[index],
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.textMutedDark
                                    : AppColors.textMutedLight,
                                fontSize: 11,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => isDark
                        ? AppColors.surfaceCardDark
                        : AppColors.surfaceLight,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.x.toInt();
                        final month = _months[index];
                        return LineTooltipItem(
                          '$month: ${spot.y.toInt()} students',
                          AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      _studentCounts.length,
                      (i) => FlSpot(i.toDouble(), _studentCounts[i]),
                    ),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppColors.primary,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withAlpha(isDark ? 80 : 50),
                          AppColors.primary.withAlpha(isDark ? 10 : 5),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
