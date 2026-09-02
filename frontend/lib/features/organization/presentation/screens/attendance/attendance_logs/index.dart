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

class AttendanceLogsScreen extends StatefulWidget {
  const AttendanceLogsScreen({super.key});

  @override
  State<AttendanceLogsScreen> createState() => _AttendanceLogsScreenState();
}

class _AttendanceLogsScreenState extends State<AttendanceLogsScreen> {
  String _searchQuery = '';
  String _selectedDepartment = 'all';
  String _fromDate = DateTime.now().subtract(const Duration(days: 7)).toString().split(' ')[0];
  String _toDate = DateTime.now().toString().split(' ')[0];

  final List<Map<String, dynamic>> _sampleLogs = [
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
      'lateArrival': false,
      'earlyDeparture': false,
      'overtime': 0.0,
      'remarks': 'On time',
    },
    {
      'id': '2',
      'employeeId': 'EMP002',
      'employeeName': 'Sarah Smith',
      'department': 'HR',
      'date': '2024-03-25',
      'punchInTime': '09:45 AM',
      'punchOutTime': '06:30 PM',
      'punchInPhoto': 'punch_in_2.jpg',
      'punchOutPhoto': 'punch_out_2.jpg',
      'lateArrival': true,
      'earlyDeparture': false,
      'overtime': 0.5,
      'remarks': 'Late arrival by 45 minutes',
    },
    {
      'id': '3',
      'employeeId': 'EMP003',
      'employeeName': 'Mike Johnson',
      'department': 'Sales',
      'date': '2024-03-24',
      'punchInTime': '08:30 AM',
      'punchOutTime': '08:00 PM',
      'punchInPhoto': 'punch_in_3.jpg',
      'punchOutPhoto': 'punch_out_3.jpg',
      'lateArrival': false,
      'earlyDeparture': false,
      'overtime': 2.0,
      'remarks': 'Overtime work approved',
    },
    {
      'id': '4',
      'employeeId': 'EMP004',
      'employeeName': 'Emily Davis',
      'department': 'IT',
      'date': '2024-03-24',
      'punchInTime': '09:00 AM',
      'punchOutTime': '05:00 PM',
      'punchInPhoto': 'punch_in_4.jpg',
      'punchOutPhoto': 'punch_out_4.jpg',
      'lateArrival': false,
      'earlyDeparture': true,
      'overtime': 0.0,
      'remarks': 'Early departure approved',
    },
  ];

  void _openDetailsDialog(Map<String, dynamic> log, {String? specificPhoto}) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = ctx.isDarkMode;

        return AlertDialog(
          title: Text(
            specificPhoto != null ? 'Attendance Photo Verification' : 'Attendance Log Details',
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
                          Text(log['employeeName'] as String, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
                          Text('ID: ${log['employeeId']} | ${log['department']}', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                        ],
                      ),
                      Text(log['date'] as String, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
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
                          Icon(Icons.camera_front_rounded, size: 56, color: AppColors.primary),
                          AppSpacing.vSm,
                          Text('Biometric Capture: $specificPhoto', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                          Text('Location Verified: Head Office Gate 1', style: AppTypography.bodySmall.copyWith(color: AppColors.success, fontSize: 11)),
                        ],
                      ),
                    ),
                    AppSpacing.vMd,
                  ],

                  _buildDetailRow('Punch In Time:', log['punchInTime'] as String, isDark),
                  _buildDetailRow('Punch Out Time:', log['punchOutTime'] as String, isDark),
                  _buildDetailRow('Late Arrival:', (log['lateArrival'] as bool) ? 'Yes (Late)' : 'No', isDark),
                  _buildDetailRow('Early Departure:', (log['earlyDeparture'] as bool) ? 'Yes (Early)' : 'No', isDark),
                  _buildDetailRow('Overtime:', log['overtime'] > 0 ? '+${log['overtime']} hrs' : 'None', isDark),
                  AppSpacing.vMd,
                  const Divider(height: 1),
                  AppSpacing.vMd,
                  Text('REMARKS', style: AppTypography.labelMedium.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  AppSpacing.vXs,
                  Text(log['remarks'] ?? 'No remarks provided.', style: AppTypography.bodySmall),
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

    final filtered = _sampleLogs.where((l) {
      final name = (l['employeeName'] as String).toLowerCase();
      final id = (l['employeeId'] as String).toLowerCase();
      final dept = (l['department'] as String).toLowerCase();
      final q = _searchQuery.toLowerCase();

      final matchesQuery = _searchQuery.isEmpty || name.contains(q) || id.contains(q);
      final matchesDept = _selectedDepartment == 'all' || dept == _selectedDepartment.toLowerCase();

      return matchesQuery && matchesDept;
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

          // Filter Card
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.filter_list_rounded, size: 18, color: AppColors.primary),
                    AppSpacing.hSm,
                    Text('Filter Attendance Logs', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
                AppSpacing.vMd,
                if (isMobile) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Search Employee', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                      AppSpacing.vXs,
                      TextField(
                        onChanged: (v) => setState(() => _searchQuery = v.trim()),
                        decoration: InputDecoration(
                          hintText: 'Search by name or ID...',
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          prefixIcon: const Icon(Icons.search_rounded, size: 16),
                          border: OutlineInputBorder(borderRadius: AppRadius.sm),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vMd,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Department', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: _selectedDepartment,
                        isExpanded: true,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All Departments')),
                          DropdownMenuItem(value: 'IT', child: Text('IT')),
                          DropdownMenuItem(value: 'HR', child: Text('HR')),
                          DropdownMenuItem(value: 'Sales', child: Text('Sales')),
                          DropdownMenuItem(value: 'Finance', child: Text('Finance')),
                        ],
                        onChanged: (v) => setState(() => _selectedDepartment = v!),
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Search Employee', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                            AppSpacing.vXs,
                            TextField(
                              onChanged: (v) => setState(() => _searchQuery = v.trim()),
                              decoration: InputDecoration(
                                hintText: 'Search by name or ID...',
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                prefixIcon: const Icon(Icons.search_rounded, size: 16),
                                border: OutlineInputBorder(borderRadius: AppRadius.sm),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Department', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                            AppSpacing.vXs,
                            DropdownButtonFormField<String>(
                              initialValue: _selectedDepartment,
                              isExpanded: true,
                              decoration: const InputDecoration(),
                              items: const [
                                DropdownMenuItem(value: 'all', child: Text('All Departments')),
                                DropdownMenuItem(value: 'IT', child: Text('IT')),
                                DropdownMenuItem(value: 'HR', child: Text('HR')),
                                DropdownMenuItem(value: 'Sales', child: Text('Sales')),
                                DropdownMenuItem(value: 'Finance', child: Text('Finance')),
                              ],
                              onChanged: (v) => setState(() => _selectedDepartment = v!),
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('From Date', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                            AppSpacing.vXs,
                            TextField(
                              readOnly: true,
                              controller: TextEditingController(text: _fromDate),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                suffixIcon: const Icon(Icons.calendar_today_rounded, size: 16),
                                border: OutlineInputBorder(borderRadius: AppRadius.sm),
                              ),
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now().subtract(const Duration(days: 7)),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() => _fromDate = picked.toString().split(' ')[0]);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('To Date', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                            AppSpacing.vXs,
                            TextField(
                              readOnly: true,
                              controller: TextEditingController(text: _toDate),
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
                                  setState(() => _toDate = picked.toString().split(' ')[0]);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                AppSpacing.vMd,
                const Divider(height: 1),
                AppSpacing.vSm,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Showing ${filtered.length} of ${_sampleLogs.length} records',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _selectedDepartment = 'all';
                        });
                      },
                      icon: const Icon(Icons.clear_rounded, size: 16),
                      label: const Text('Clear Filters', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
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
                  child: Text(
                    'Detailed Attendance Logs',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
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
                            _buildDataColumn('DATE', isDark),
                            _buildDataColumn('PUNCH IN', isDark),
                            _buildDataColumn('PUNCH OUT', isDark),
                            _buildDataColumn('OVERTIME', isDark),
                            _buildDataColumn('REMARKS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filtered.map((log) {
                            final id = log['employeeId'] as String;
                            final name = log['employeeName'] as String;
                            final dept = log['department'] as String;
                            final date = log['date'] as String;
                            final inTime = log['punchInTime'] as String;
                            final outTime = log['punchOutTime'] as String;
                            final isLate = log['lateArrival'] as bool;
                            final isEarly = log['earlyDeparture'] as bool;
                            final ot = log['overtime'] as double;
                            final remarks = log['remarks'] as String;

                            return DataRow(
                              cells: [
                                DataCell(Text(id, style: AppTypography.bodySmall.copyWith(fontFamily: 'monospace', fontWeight: FontWeight.w600))),
                                DataCell(Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700))),
                                DataCell(Text(dept, style: AppTypography.bodySmall)),
                                DataCell(Text(date, style: AppTypography.bodySmall)),
                                DataCell(
                                  Row(
                                    children: [
                                      Icon(Icons.access_time_rounded, size: 14, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                      const SizedBox(width: 4),
                                      Text(inTime, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                      if (isLate) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.error.withAlpha(20),
                                            borderRadius: AppRadius.sm,
                                          ),
                                          child: Text('Late', style: AppTypography.bodySmall.copyWith(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.error)),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      Icon(Icons.access_time_rounded, size: 14, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                      const SizedBox(width: 4),
                                      Text(outTime, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                      if (isEarly) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.warning.withAlpha(20),
                                            borderRadius: AppRadius.sm,
                                          ),
                                          child: Text('Early', style: AppTypography.bodySmall.copyWith(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.warning)),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    ot > 0 ? '+$ot hrs' : '-',
                                    style: AppTypography.bodySmall.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: ot > 0 ? AppColors.success : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 160),
                                    child: Text(
                                      remarks,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert_rounded, size: 18, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                    onSelected: (val) {
                                      if (val == 'details') {
                                        _openDetailsDialog(log);
                                      } else if (val == 'punch_in') {
                                        _openDetailsDialog(log, specificPhoto: 'Punch In Photo (09:00 AM)');
                                      } else if (val == 'punch_out') {
                                        _openDetailsDialog(log, specificPhoto: 'Punch Out Photo (06:00 PM)');
                                      }
                                    },
                                    itemBuilder: (ctx) => [
                                      const PopupMenuItem(
                                        value: 'details',
                                        child: Row(
                                          children: [
                                            Icon(Icons.visibility_outlined, size: 16),
                                            SizedBox(width: 8),
                                            Text('View Full Log Details'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'punch_in',
                                        child: Row(
                                          children: [
                                            Icon(Icons.photo_camera_front_outlined, size: 16),
                                            SizedBox(width: 8),
                                            Text('View Punch In Photo'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'punch_out',
                                        child: Row(
                                          children: [
                                            Icon(Icons.photo_camera_back_outlined, size: 16),
                                            SizedBox(width: 8),
                                            Text('View Punch Out Photo'),
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

  Widget _buildHeader(bool isDark, bool isMobile) {
    final headerTexts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => context.go(RouteNames.attendanceLogsPath),
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
              'Attendance Logs',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Attendance Logs',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'View detailed attendance logs and history',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionBtn = AppButton(
      text: 'Export Logs',
      icon: Icons.download_rounded,
      variant: AppButtonVariant.outline,
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attendance logs exported successfully!')),
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
