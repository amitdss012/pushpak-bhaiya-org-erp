import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_card.dart';

class BranchOverviewTable extends StatelessWidget {
  const BranchOverviewTable({super.key});

  static const List<_BranchRowData> _branches = [
    _BranchRowData(
      name: 'Mumbai Central Campus',
      code: 'BR-MUM-01',
      city: 'Mumbai, MH',
      students: '1,420',
      staff: '64',
      collectionProgress: 0.92,
      collectionText: '₹12.4 L / ₹13.5 L',
      status: 'Active',
      statusColor: AppColors.success,
    ),
    _BranchRowData(
      name: 'Delhi North Campus',
      code: 'BR-DEL-02',
      city: 'New Delhi, DL',
      students: '980',
      staff: '48',
      collectionProgress: 0.88,
      collectionText: '₹8.6 L / ₹9.8 L',
      status: 'Active',
      statusColor: AppColors.success,
    ),
    _BranchRowData(
      name: 'Bengaluru Tech Branch',
      code: 'BR-BLR-03',
      city: 'Bengaluru, KA',
      students: '2,150',
      staff: '92',
      collectionProgress: 0.95,
      collectionText: '₹15.2 L / ₹16.0 L',
      status: 'Active',
      statusColor: AppColors.success,
    ),
    _BranchRowData(
      name: 'Pune IT Campus',
      code: 'BR-PUN-04',
      city: 'Pune, MH',
      students: '740',
      staff: '38',
      collectionProgress: 0.74,
      collectionText: '₹4.8 L / ₹6.5 L',
      status: 'Review',
      statusColor: AppColors.warning,
    ),
    _BranchRowData(
      name: 'Hyderabad Cyber Hub',
      code: 'BR-HYD-05',
      city: 'Hyderabad, TS',
      students: '1,130',
      staff: '52',
      collectionProgress: 0.86,
      collectionText: '₹7.9 L / ₹9.2 L',
      status: 'Active',
      statusColor: AppColors.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;

    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Branch Performance Overview',
                    style: AppTypography.titleLarge.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacing.vXs,
                  Text(
                    'Real-time student enrolments, faculty allocations, and fee progress per branch',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              if (!isMobile)
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: const Text('View All (8)'),
                ),
            ],
          ),
          AppSpacing.vLg,
          const Divider(height: 1),
          AppSpacing.vMd,

          // Table / Responsive Rows
          if (isMobile)
            Column(
              children: _branches
                  .map((b) => _buildMobileBranchCard(b, isDark))
                  .toList(),
            )
          else
            Column(
              children: [
                // Table Column Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text('BRANCH NAME', style: _headerStyle(isDark)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('STUDENTS', style: _headerStyle(isDark)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('STAFF', style: _headerStyle(isDark)),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'FEE COLLECTION',
                          style: _headerStyle(isDark),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('STATUS', style: _headerStyle(isDark)),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ..._branches.map((b) => _buildDesktopBranchRow(b, isDark)),
              ],
            ),
        ],
      ),
    );
  }

  TextStyle _headerStyle(bool isDark) {
    return AppTypography.labelMedium.copyWith(
      fontSize: 11,
      letterSpacing: 0.8,
      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
    );
  }

  Widget _buildDesktopBranchRow(_BranchRowData branch, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          // Name & Code
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  branch.name,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  '${branch.code} • ${branch.city}',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          // Students
          Expanded(
            flex: 2,
            child: Text(
              branch.students,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
          // Staff
          Expanded(
            flex: 2,
            child: Text(
              branch.staff,
              style: AppTypography.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ),
          // Fee Progress Bar
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  branch.collectionText,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                AppSpacing.vXs,
                ClipRRect(
                  borderRadius: AppRadius.full,
                  child: LinearProgressIndicator(
                    value: branch.collectionProgress,
                    minHeight: 5,
                    backgroundColor: isDark
                        ? Colors.white10
                        : AppColors.backgroundLight,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      branch.collectionProgress > 0.85
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Status Pill
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: branch.statusColor.withAlpha(isDark ? 40 : 20),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  branch.status,
                  style: AppTypography.labelMedium.copyWith(
                    color: branch.statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBranchCard(_BranchRowData branch, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  branch.name,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: branch.statusColor.withAlpha(isDark ? 40 : 20),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  branch.status,
                  style: AppTypography.labelMedium.copyWith(
                    color: branch.statusColor,
                    fontSize: 10.5,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.vXs,
          Text(
            '${branch.code} • ${branch.city}',
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textMutedDark
                  : AppColors.textMutedLight,
              fontSize: 11,
            ),
          ),
          AppSpacing.vMd,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Students: ${branch.students}',
                style: AppTypography.bodySmall,
              ),
              Text('Staff: ${branch.staff}', style: AppTypography.bodySmall),
            ],
          ),
          AppSpacing.vSm,
          ClipRRect(
            borderRadius: AppRadius.full,
            child: LinearProgressIndicator(
              value: branch.collectionProgress,
              minHeight: 5,
              backgroundColor: isDark ? Colors.white10 : AppColors.borderLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                branch.collectionProgress > 0.85
                    ? AppColors.success
                    : AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BranchRowData {
  final String name;
  final String code;
  final String city;
  final String students;
  final String staff;
  final double collectionProgress;
  final String collectionText;
  final String status;
  final Color statusColor;

  const _BranchRowData({
    required this.name,
    required this.code,
    required this.city,
    required this.students,
    required this.staff,
    required this.collectionProgress,
    required this.collectionText,
    required this.status,
    required this.statusColor,
  });
}
