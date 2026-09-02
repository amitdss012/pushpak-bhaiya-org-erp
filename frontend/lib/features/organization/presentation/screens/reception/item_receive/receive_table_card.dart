import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_radius.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_card.dart';
import '../../../../../../shared/widgets/app_status_badge.dart';

class ReceiveTableCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<Map<String, dynamic>> onView;
  final ValueChanged<Map<String, dynamic>> onPrint;
  final ValueChanged<Map<String, dynamic>> onForward;
  final ValueChanged<Map<String, dynamic>> onDelete;

  const ReceiveTableCard({
    super.key,
    required this.items,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onView,
    required this.onPrint,
    required this.onForward,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header & Search
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Received Items',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Container(
                    height: 38,
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
                    child: TextField(
                      onChanged: onSearchChanged,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search item, sender, tracking...',
                        hintStyle: AppTypography.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight,
                          fontSize: 12,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 16,
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Responsive Data Table
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    headingRowHeight: 44,
                    dataRowMinHeight: 60,
                    dataRowMaxHeight: 64,
                    horizontalMargin: 20,
                    columnSpacing: 24,
              headingRowColor: WidgetStateProperty.all(
                isDark
                    ? AppColors.backgroundDark.withAlpha(80)
                    : AppColors.backgroundLight.withAlpha(120),
              ),
              columns: [
                _buildDataColumn('ITEM', isDark),
                _buildDataColumn('QTY', isDark),
                _buildDataColumn('SENDER', isDark),
                _buildDataColumn('COURIER', isDark),
                _buildDataColumn('RECEIVED', isDark),
                _buildDataColumn('DEPARTMENT', isDark),
                _buildDataColumn('CONDITION', isDark),
                _buildDataColumn('STATUS', isDark),
                _buildDataColumn('ACTIONS', isDark),
              ],
              rows: items.map((item) {
                final itemName = item['itemName'] as String? ?? '';
                final id = item['id'] as String? ?? '';
                final quantity = item['quantity']?.toString() ?? '1';
                final senderName = item['senderName'] as String? ?? '';
                final senderPhone = item['senderPhone'] as String? ?? '';
                final courierService = item['courierService'] as String? ?? '';
                final trackingNumber = item['trackingNumber'] as String? ?? '';
                final receivedDate = item['receivedDate'] as String? ?? '';
                final department = item['department'] as String? ?? '';
                final condition = item['condition'] as String? ?? 'good';
                final status = item['status'] as String? ?? 'completed';

                Color conditionColor;
                String conditionLabel;
                IconData conditionIcon;

                switch (condition) {
                  case 'damaged':
                    conditionColor = AppColors.error;
                    conditionLabel = 'Damaged';
                    conditionIcon = Icons.warning_amber_rounded;
                    break;
                  case 'partial':
                    conditionColor = AppColors.warning;
                    conditionLabel = 'Partial';
                    conditionIcon = Icons.info_outline_rounded;
                    break;
                  default:
                    conditionColor = AppColors.success;
                    conditionLabel = 'Good';
                    conditionIcon = Icons.check_circle_outline_rounded;
                }

                AppBadgeStatus badgeStatus;
                switch (status) {
                  case 'active':
                    badgeStatus = AppBadgeStatus.active;
                    break;
                  case 'pending':
                    badgeStatus = AppBadgeStatus.pending;
                    break;
                  default:
                    badgeStatus = AppBadgeStatus.completed;
                }

                return DataRow(
                  cells: [
                    // Item
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(isDark ? 40 : 20),
                              borderRadius: AppRadius.sm,
                            ),
                            child: const Center(
                              child: Icon(Icons.all_inbox_rounded, color: AppColors.primary, size: 18),
                            ),
                          ),
                          AppSpacing.hSm,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                itemName,
                                style: AppTypography.bodySmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                              Text(
                                id,
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 10.5,
                                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Quantity
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                          borderRadius: AppRadius.full,
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                        child: Text(
                          quantity,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ),

                    // Sender
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            senderName,
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            senderPhone,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 10.5,
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Courier & Tracking
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            courierService,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            trackingNumber,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 10.5,
                              fontFamily: 'monospace',
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Received Date
                    DataCell(
                      Text(
                        receivedDate,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),

                    // Department
                    DataCell(
                      Text(
                        department,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Condition Badge
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: conditionColor.withAlpha(25),
                          borderRadius: AppRadius.full,
                          border: Border.all(color: conditionColor.withAlpha(60)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(conditionIcon, size: 12, color: conditionColor),
                            AppSpacing.hXs,
                            Text(
                              conditionLabel,
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: conditionColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Status
                    DataCell(AppStatusBadge(status: badgeStatus)),

                    // Actions Menu
                    DataCell(
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_horiz_rounded,
                          size: 18,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                        onSelected: (action) {
                          if (action == 'view') onView(item);
                          if (action == 'print') onPrint(item);
                          if (action == 'forward') onForward(item);
                          if (action == 'delete') onDelete(item);
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'view',
                            child: Row(
                              children: [
                                Icon(Icons.visibility_outlined, size: 16),
                                SizedBox(width: 8),
                                Text('View Details'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'print',
                            child: Row(
                              children: [
                                Icon(Icons.print_outlined, size: 16),
                                SizedBox(width: 8),
                                Text('Print Acknowledgment'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'forward',
                            child: Row(
                              children: [
                                Icon(Icons.forward_to_inbox_rounded, size: 16),
                                SizedBox(width: 8),
                                Text('Forward to Dept'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                                SizedBox(width: 8),
                                Text('Delete', style: TextStyle(color: AppColors.error)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  DataColumn _buildDataColumn(String title, bool isDark) {
    return DataColumn(
      label: Text(
        title,
        style: AppTypography.labelMedium.copyWith(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
        ),
      ),
    );
  }
}
