import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_radius.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_card.dart';
import '../../../../../../shared/widgets/app_status_badge.dart';

class VisitorsTableCard extends StatelessWidget {
  final List<Map<String, dynamic>> visitors;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<Map<String, dynamic>> onView;
  final ValueChanged<Map<String, dynamic>> onCheckout;
  final ValueChanged<Map<String, dynamic>> onPrint;
  final ValueChanged<Map<String, dynamic>> onDelete;

  const VisitorsTableCard({
    super.key,
    required this.visitors,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onView,
    required this.onCheckout,
    required this.onPrint,
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
          // Table Card Header & Search
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Visitors",
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
                        hintText: 'Search visitors by name, phone...',
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
                _buildDataColumn('VISITOR', isDark),
                _buildDataColumn('CONTACT', isDark),
                _buildDataColumn('PURPOSE', isDark),
                _buildDataColumn('LOCATION', isDark),
                _buildDataColumn('PERSON TO MEET', isDark),
                _buildDataColumn('CHECK-IN', isDark),
                _buildDataColumn('CHECK-OUT', isDark),
                _buildDataColumn('STATUS', isDark),
                _buildDataColumn('ACTIONS', isDark),
              ],
              rows: visitors.map((visitor) {
                final name = visitor['name'] as String? ?? '';
                final id = visitor['id'] as String? ?? '';
                final phone = visitor['phone'] as String? ?? '';
                final email = visitor['email'] as String? ?? '';
                final purpose = visitor['purpose'] as String? ?? '';
                final location = visitor['location'] as String? ?? '';
                final personToMeet = visitor['personToMeet'] as String? ?? '';
                final checkIn = visitor['checkIn'] as String? ?? '';
                final checkOut = visitor['checkOut'] as String?;
                final status = visitor['status'] as String? ?? 'active';

                final initials = name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join();

                AppBadgeStatus badgeStatus;
                switch (status) {
                  case 'completed':
                    badgeStatus = AppBadgeStatus.completed;
                    break;
                  case 'pending':
                    badgeStatus = AppBadgeStatus.pending;
                    break;
                  default:
                    badgeStatus = AppBadgeStatus.active;
                }

                return DataRow(
                  cells: [
                    // Visitor
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.primary.withAlpha(isDark ? 50 : 25),
                            child: Text(
                              initials,
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          AppSpacing.hSm,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                name,
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

                    // Contact
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            phone,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            email,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 10.5,
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Purpose
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
                          purpose,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ),

                    // Location
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: AppColors.primary),
                          AppSpacing.hXs,
                          Text(
                            location,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Person to Meet
                    DataCell(
                      Text(
                        personToMeet,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Check-in
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                          AppSpacing.hXs,
                          Text(
                            checkIn,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Check-out
                    DataCell(
                      checkOut != null
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.logout_rounded, size: 14, color: AppColors.textMutedLight),
                                AppSpacing.hXs,
                                Text(
                                  checkOut,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              '--',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
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
                          if (action == 'view') onView(visitor);
                          if (action == 'checkout') onCheckout(visitor);
                          if (action == 'print') onPrint(visitor);
                          if (action == 'delete') onDelete(visitor);
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
                          if (status == 'active')
                            const PopupMenuItem(
                              value: 'checkout',
                              child: Row(
                                children: [
                                  Icon(Icons.logout_rounded, size: 16),
                                  SizedBox(width: 8),
                                  Text('Check Out'),
                                ],
                              ),
                            ),
                          const PopupMenuItem(
                            value: 'print',
                            child: Row(
                              children: [
                                Icon(Icons.print_outlined, size: 16),
                                SizedBox(width: 8),
                                Text('Print Pass'),
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
