import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/router/route_names.dart';
import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_radius.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/app_card.dart';
import '../../../widgets/org_stats_card.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  String _searchQuery = '';
  String _selectedTab = 'today'; // 'today', 'yesterday', 'custom'
  String _selectedDate = DateTime.now().toString().split(' ')[0];

  final List<Map<String, dynamic>> _attendanceRecords = [
    {
      'id': '1',
      'employeeId': 'EMP001',
      'employeeName': 'John Doe',
      'department': 'IT',
      'date': '2024-03-25',
      'punchInTime': '09:00 AM',
      'punchOutTime': '06:00 PM',
      'punchInPhoto': 'punch_in_1.jpg',
      'punchOutPhoto': 'punch_out_1.jpg',
      'status': 'present',
      'workingHours': 9.0,
    },
    {
      'id': '2',
      'employeeId': 'EMP002',
      'employeeName': 'Sarah Smith',
      'department': 'HR',
      'date': '2024-03-25',
      'punchInTime': '09:15 AM',
      'punchOutTime': '06:15 PM',
      'punchInPhoto': 'punch_in_2.jpg',
      'punchOutPhoto': 'punch_out_2.jpg',
      'status': 'present',
      'workingHours': 9.0,
    },
    {
      'id': '3',
      'employeeId': 'EMP003',
      'employeeName': 'Mike Johnson',
      'department': 'Sales',
      'date': '2024-03-25',
      'punchInTime': '09:30 AM',
      'punchOutTime': '',
      'punchInPhoto': 'punch_in_3.jpg',
      'punchOutPhoto': '',
      'status': 'half-day',
      'workingHours': 4.5,
    },
    {
      'id': '4',
      'employeeId': 'EMP004',
      'employeeName': 'Emily Davis',
      'department': 'IT',
      'date': '2024-03-25',
      'punchInTime': '',
      'punchOutTime': '',
      'punchInPhoto': '',
      'punchOutPhoto': '',
      'status': 'absent',
      'workingHours': 0.0,
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'present':
        return AppColors.success;
      case 'absent':
        return AppColors.error;
      case 'half-day':
        return AppColors.warning;
      case 'on-leave':
        return AppColors.info;
      default:
        return AppColors.info;
    }
  }

  void _openDetailsDialog(Map<String, dynamic> record, {String? specificPhoto}) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = ctx.isDarkMode;
        final status = record['status'] as String;
        final statusColor = _getStatusColor(status);

        return AlertDialog(
          title: Text(
            specificPhoto != null ? 'Attendance Photo Verification' : 'Attendance Record Details',
            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(record['employeeName'] as String, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
                          Text('ID: ${record['employeeId']} | ${record['department']}', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(20),
                          borderRadius: AppRadius.sm,
                          border: Border.all(color: statusColor.withAlpha(60)),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vLg,
                  const Divider(height: 1),
                  AppSpacing.vMd,

                  if (specificPhoto != null) ...[
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                        borderRadius: AppRadius.md,
                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.face_retouching_natural_rounded, size: 56, color: AppColors.primary),
                          AppSpacing.vSm,
                          Text('Photo Verified: $specificPhoto', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                          Text('Biometric match score: 98.4%', style: AppTypography.bodySmall.copyWith(color: AppColors.success, fontSize: 11)),
                        ],
                      ),
                    ),
                    AppSpacing.vMd,
                  ],

                  _buildDetailRow('Date:', record['date'] as String, isDark),
                  _buildDetailRow('Punch In Time:', record['punchInTime'].toString().isEmpty ? 'Not Marked' : record['punchInTime'] as String, isDark),
                  _buildDetailRow('Punch Out Time:', record['punchOutTime'].toString().isEmpty ? 'Not Marked' : record['punchOutTime'] as String, isDark),
                  _buildDetailRow('Total Working Hours:', '${record['workingHours']} hrs', isDark),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          Text(value, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;

    final filtered = _attendanceRecords.where((r) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = (r['employeeName'] as String).toLowerCase();
        final id = (r['employeeId'] as String).toLowerCase();
        final dept = (r['department'] as String).toLowerCase();
        return name.contains(q) || id.contains(q) || dept.contains(q);
      }
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 28,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          _buildHeader(isDark, isMobile),
          AppSpacing.vXl,

          // 4 Stats Cards
          _buildStatsCards(isMobile),
          AppSpacing.vXl,

          // Filters Card
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filter Attendance Records', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                AppSpacing.vMd,
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildTabButton('today', 'Today'),
                    _buildTabButton('yesterday', 'Yesterday'),
                    _buildTabButton('custom', 'Custom Date'),
                  ],
                ),
                if (_selectedTab == 'custom') ...[
                  AppSpacing.vMd,
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 38,
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(text: _selectedDate),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            suffixIcon: const Icon(Icons.calendar_today_rounded, size: 16),
                            border: OutlineInputBorder(borderRadius: AppRadius.sm),
                          ),
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() => _selectedDate = picked.toString().split(' ')[0]);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          AppSpacing.vXl,

          // Full-width Table Card
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Attendance Records',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                            borderRadius: AppRadius.sm,
                            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                          ),
                          child: TextField(
                            onChanged: (val) => setState(() => _searchQuery = val.trim()),
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search employee, ID, department...',
                              hintStyle: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                fontSize: 12,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                size: 16,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 8),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          headingRowHeight: 44,
                          dataRowMinHeight: 56,
                          dataRowMaxHeight: 64,
                          horizontalMargin: 20,
                          columnSpacing: 20,
                          headingRowColor: WidgetStateProperty.all(
                            isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight.withAlpha(120),
                          ),
                          columns: [
                            _buildDataColumn('EMPLOYEE ID', isDark),
                            _buildDataColumn('EMPLOYEE NAME', isDark),
                            _buildDataColumn('DEPARTMENT', isDark),
                            _buildDataColumn('PUNCH IN', isDark),
                            _buildDataColumn('PUNCH OUT', isDark),
                            _buildDataColumn('WORKING HOURS', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filtered.map((record) {
                            final id = record['employeeId'] as String;
                            final name = record['employeeName'] as String;
                            final dept = record['department'] as String;
                            final inTime = record['punchInTime'] as String;
                            final outTime = record['punchOutTime'] as String;
                            final hours = record['workingHours'];
                            final status = record['status'] as String;
                            final statusColor = _getStatusColor(status);

                            return DataRow(
                              cells: [
                                DataCell(Text(id, style: AppTypography.bodySmall.copyWith(fontFamily: 'monospace', fontWeight: FontWeight.w600))),
                                DataCell(Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700))),
                                DataCell(Text(dept, style: AppTypography.bodySmall)),
                                DataCell(
                                  inTime.isNotEmpty
                                      ? Row(
                                          children: [
                                            const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.success),
                                            const SizedBox(width: 6),
                                            Text(inTime, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                          ],
                                        )
                                      : Text('-', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                                ),
                                DataCell(
                                  outTime.isNotEmpty
                                      ? Row(
                                          children: [
                                            const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.primary),
                                            const SizedBox(width: 6),
                                            Text(outTime, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                          ],
                                        )
                                      : Text('-', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                                ),
                                DataCell(
                                  Text(
                                    hours > 0 ? '$hours hrs' : '-',
                                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: statusColor.withAlpha(20),
                                      borderRadius: AppRadius.sm,
                                      border: Border.all(color: statusColor.withAlpha(60)),
                                    ),
                                    child: Text(
                                      status.toUpperCase(),
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert_rounded, size: 18, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                    onSelected: (val) {
                                      if (val == 'details') {
                                        _openDetailsDialog(record);
                                      } else if (val == 'punch_in') {
                                        _openDetailsDialog(record, specificPhoto: 'Punch In (09:00 AM)');
                                      } else if (val == 'punch_out') {
                                        _openDetailsDialog(record, specificPhoto: 'Punch Out (06:00 PM)');
                                      }
                                    },
                                    itemBuilder: (ctx) => [
                                      const PopupMenuItem(
                                        value: 'details',
                                        child: Row(
                                          children: [
                                            Icon(Icons.visibility_outlined, size: 16),
                                            SizedBox(width: 8),
                                            Text('View Details'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'punch_in',
                                        child: Row(
                                          children: [
                                            Icon(Icons.photo_camera_front_outlined, size: 16),
                                            SizedBox(width: 8),
                                            Text('Punch In Photo'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'punch_out',
                                        child: Row(
                                          children: [
                                            Icon(Icons.photo_camera_back_outlined, size: 16),
                                            SizedBox(width: 8),
                                            Text('Punch Out Photo'),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String key, String label) {
    final isSelected = _selectedTab == key;
    return InkWell(
      onTap: () => setState(() => _selectedTab = key),
      borderRadius: AppRadius.sm,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: AppRadius.sm,
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : null,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(bool isMobile) {
    final totalEmployees = _attendanceRecords.length;
    final totalPresent = _attendanceRecords.where((r) => r['status'] == 'present').length;
    final totalAbsent = _attendanceRecords.where((r) => r['status'] == 'absent').length;
    final totalHalfDay = _attendanceRecords.where((r) => r['status'] == 'half-day').length;

    final cards = [
      OrgStatsCard(
        title: 'Total Employees',
        value: '$totalEmployees',
        subtitle: 'All staff',
        icon: Icons.people_outline_rounded,
        variant: OrgStatsCardVariant.primary,
      ),
      OrgStatsCard(
        title: 'Present Today',
        value: '$totalPresent',
        subtitle: 'Present employees',
        icon: Icons.check_circle_outline_rounded,
        variant: OrgStatsCardVariant.success,
      ),
      OrgStatsCard(
        title: 'Absent Today',
        value: '$totalAbsent',
        subtitle: 'Absent staff',
        icon: Icons.highlight_off_rounded,
        variant: OrgStatsCardVariant.defaultVariant,
      ),
      OrgStatsCard(
        title: 'Half Day',
        value: '$totalHalfDay',
        subtitle: 'Half-day shifts',
        icon: Icons.access_time_rounded,
        variant: OrgStatsCardVariant.warning,
      ),
    ];

    if (isMobile) {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList(),
      );
    }

    return Row(
      children: cards
          .map(
            (c) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: c,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildHeader(bool isDark, bool isMobile) {
    final headerTexts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => context.go(RouteNames.attendanceReportPath),
              child: Text(
                'Attendance',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                '/',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                ),
              ),
            ),
            Text(
              'Attendance Report',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Attendance Report',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'View and analyze employee attendance records',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionBtn = AppButton(
      text: 'Export Report',
      icon: Icons.download_rounded,
      variant: AppButtonVariant.outline,
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attendance report exported successfully!')),
        );
      },
      height: 38,
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerTexts,
          AppSpacing.vMd,
          actionBtn,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: headerTexts),
        actionBtn,
      ],
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
