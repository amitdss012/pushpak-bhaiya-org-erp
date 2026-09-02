import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_card.dart';

class MonthlyFeeItem {
  final String month;
  final double collected;
  final double pending;

  const MonthlyFeeItem({
    required this.month,
    required this.collected,
    required this.pending,
  });
}

class FeeCollectionOverviewCard extends StatelessWidget {
  const FeeCollectionOverviewCard({super.key});

  static const _collectedColor = Color(0xFF0EA5E9); // Sky / Chart-2
  static const _pendingColor = Color(0xFFF59E0B); // Amber / Chart-3

  static const List<MonthlyFeeItem> _data = [
    MonthlyFeeItem(month: 'Jan', collected: 125, pending: 25),
    MonthlyFeeItem(month: 'Feb', collected: 145, pending: 35),
    MonthlyFeeItem(month: 'Mar', collected: 180, pending: 20),
    MonthlyFeeItem(month: 'Apr', collected: 155, pending: 45),
    MonthlyFeeItem(month: 'May', collected: 200, pending: 30),
    MonthlyFeeItem(month: 'Jun', collected: 175, pending: 25),
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
                Icons.credit_card_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              AppSpacing.hSm,
              Text(
                'Fee Collection Overview',
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

          // Grouped Bar Chart
          SizedBox(
            height: 260,
            child: BarChart(
              BarChartData(
                maxY: 220,
                minY: 0,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => isDark
                        ? AppColors.surfaceCardDark
                        : AppColors.surfaceLight,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final item = _data[group.x.toInt()];
                      final isCollected = rodIndex == 0;
                      final type = isCollected ? 'Collected' : 'Pending';
                      final val = isCollected ? item.collected : item.pending;
                      return BarTooltipItem(
                        '$type: ₹${val.toInt()}K',
                        AppTypography.bodySmall.copyWith(
                          color: isCollected ? _collectedColor : _pendingColor,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    },
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
                      interval: 50,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '₹${value.toInt()}K',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.textMutedLight,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < _data.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _data[index].month,
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
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark
                        ? AppColors.borderDark.withAlpha(80)
                        : AppColors.borderLight,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(_data.length, (i) {
                  final item = _data[i];
                  return BarChartGroupData(
                    x: i,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: item.collected,
                        color: _collectedColor,
                        width: 12,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                      BarChartRodData(
                        toY: item.pending,
                        color: _pendingColor,
                        width: 12,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          AppSpacing.vMd,

          // Bottom Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: _collectedColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  AppSpacing.hSm,
                  Text(
                    'Collected',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              AppSpacing.hXl,
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: _pendingColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  AppSpacing.hSm,
                  Text(
                    'Pending',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
