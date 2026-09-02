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
import '../../../../../../shared/widgets/app_text_field.dart';
import '../../../widgets/org_stats_card.dart';

class FeeAllocationScreen extends StatefulWidget {
  const FeeAllocationScreen({super.key});

  @override
  State<FeeAllocationScreen> createState() => _FeeAllocationScreenState();
}

class _FeeAllocationScreenState extends State<FeeAllocationScreen> {
  String _searchQuery = '';
  String? _selectedFeeGroup;
  String _filterCourse = 'all';
  String _filterBatch = 'all';
  final _dueDateController = TextEditingController(text: '2024-02-15');
  final Set<String> _selectedStudentIds = {};

  final List<Map<String, dynamic>> _allocationData = [
    {
      'id': '1',
      'studentId': 'STU001',
      'name': 'Rahul Sharma',
      'course': 'Computer Science',
      'batch': 'CS-2024-A',
      'feeGroup': 'Standard Fee Package',
      'totalFee': 59000,
      'allocated': true,
      'dueDate': '2024-02-15',
    },
    {
      'id': '2',
      'studentId': 'STU002',
      'name': 'Priya Patel',
      'course': 'Computer Science',
      'batch': 'CS-2024-A',
      'feeGroup': 'Science Stream Package',
      'totalFee': 62000,
      'allocated': true,
      'dueDate': '2024-02-15',
    },
    {
      'id': '3',
      'studentId': 'STU003',
      'name': 'Amit Kumar',
      'course': 'Commerce',
      'batch': 'COM-2024-A',
      'feeGroup': 'Standard Fee Package',
      'totalFee': 59000,
      'allocated': true,
      'dueDate': '2024-02-15',
    },
    {
      'id': '4',
      'studentId': 'STU004',
      'name': 'Sneha Gupta',
      'course': 'Engineering',
      'batch': 'ENG-2024-A',
      'feeGroup': '',
      'totalFee': 0,
      'allocated': false,
      'dueDate': '-',
    },
    {
      'id': '5',
      'studentId': 'STU005',
      'name': 'Vikram Singh',
      'course': 'Arts',
      'batch': 'ART-2024-A',
      'feeGroup': '',
      'totalFee': 0,
      'allocated': false,
      'dueDate': '-',
    },
    {
      'id': '6',
      'studentId': 'STU006',
      'name': 'Anita Reddy',
      'course': 'Science',
      'batch': 'SCI-2024-A',
      'feeGroup': 'Science Stream Package',
      'totalFee': 62000,
      'allocated': true,
      'dueDate': '2024-02-15',
    },
  ];

  final List<Map<String, dynamic>> _feeGroups = [
    {'id': 'standard', 'name': 'Standard Fee Package', 'amount': 59000},
    {'id': 'science', 'name': 'Science Stream Package', 'amount': 62000},
    {'id': 'hostel', 'name': 'Hostel Student Package', 'amount': 119000},
    {'id': 'transport', 'name': 'Day Scholar with Transport', 'amount': 71000},
    {'id': 'merit', 'name': 'Merit Scholarship Package', 'amount': 29000},
  ];

  @override
  void dispose() {
    _dueDateController.dispose();
    super.dispose();
  }

  void _handleBulkAllocate() {
    if (_selectedFeeGroup == null) return;
    if (_selectedStudentIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one student from the list.'), backgroundColor: AppColors.warning),
      );
      return;
    }

    final groupObj = _feeGroups.firstWhere((g) => g['id'] == _selectedFeeGroup);
    final groupName = groupObj['name'] as String;
    final groupAmount = groupObj['amount'] as int;

    setState(() {
      for (final student in _allocationData) {
        if (_selectedStudentIds.contains(student['id'])) {
          student['feeGroup'] = groupName;
          student['totalFee'] = groupAmount;
          student['allocated'] = true;
          student['dueDate'] = _dueDateController.text.trim();
        }
      }
      _selectedStudentIds.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Allocated "$groupName" to selected students.'), backgroundColor: AppColors.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isTablet = context.isTablet;

    final filteredData = _allocationData.where((s) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = (s['name'] as String).toLowerCase();
        final sid = (s['studentId'] as String).toLowerCase();
        final course = (s['course'] as String).toLowerCase();
        if (!name.contains(q) && !sid.contains(q) && !course.contains(q)) return false;
      }
      if (_filterCourse != 'all') {
        if ((s['course'] as String).toLowerCase() != _filterCourse.toLowerCase()) return false;
      }
      return true;
    }).toList();

    final allocatedCount = _allocationData.where((s) => s['allocated'] == true).length;
    final pendingCount = _allocationData.where((s) => s['allocated'] == false).length;
    final totalAllocated = _allocationData.where((s) => s['allocated'] == true).fold<int>(0, (sum, s) => sum + (s['totalFee'] as int));

    // Stats Cards
    final card1 = OrgStatsCard(
      title: 'Total Students',
      value: _allocationData.length.toString(),
      subtitle: 'Enrolled students',
      icon: Icons.groups_outlined,
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = OrgStatsCard(
      title: 'Fee Allocated',
      value: allocatedCount.toString(),
      subtitle: 'Packages assigned',
      icon: Icons.check_circle_outline_rounded,
      variant: OrgStatsCardVariant.success,
    );
    final card3 = OrgStatsCard(
      title: 'Pending Allocation',
      value: pendingCount.toString(),
      subtitle: 'Unassigned students',
      icon: Icons.error_outline_rounded,
      variant: OrgStatsCardVariant.defaultVariant,
    );
    final card4 = OrgStatsCard(
      title: 'Total Allocated',
      value: '₹${(totalAllocated / 100000).toStringAsFixed(1)}L',
      subtitle: 'Current total ledger',
      icon: Icons.currency_rupee_rounded,
      variant: OrgStatsCardVariant.warning,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 28,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          _buildHeader(isDark),
          AppSpacing.vXl,

          // Stats Grid
          if (isDesktop)
            Row(
              children: [
                Expanded(child: card1),
                AppSpacing.hLg,
                Expanded(child: card2),
                AppSpacing.hLg,
                Expanded(child: card3),
                AppSpacing.hLg,
                Expanded(child: card4),
              ],
            )
          else if (isTablet)
            Column(
              children: [
                Row(children: [Expanded(child: card1), AppSpacing.hMd, Expanded(child: card2)]),
                AppSpacing.vMd,
                Row(children: [Expanded(child: card3), AppSpacing.hMd, Expanded(child: card4)]),
              ],
            )
          else
            Column(
              children: [
                card1,
                AppSpacing.vMd,
                card2,
                AppSpacing.vMd,
                card3,
                AppSpacing.vMd,
                card4,
              ],
            ),

          AppSpacing.vXl,

          // Allocation Form & Student List Section
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 320,
                  child: _buildQuickAllocationCard(isDark),
                ),
                AppSpacing.hLg,
                Expanded(
                  child: _buildStudentListTableCard(filteredData, isDark),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildQuickAllocationCard(isDark),
                AppSpacing.vXl,
                _buildStudentListTableCard(filteredData, isDark),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildQuickAllocationCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.link_rounded, size: 20, color: AppColors.primary),
              AppSpacing.hSm,
              Text('Quick Allocation', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          AppSpacing.vXs,
          Text(
            'Assign fee group to multiple students',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          AppSpacing.vLg,

          // Fee Group Dropdown
          _buildFieldLabel('Fee Group', isDark),
          AppSpacing.vXs,
          DropdownButtonFormField<String>(
            initialValue: _selectedFeeGroup,
            isExpanded: true,
            hint: const Text('Select fee group'),
            decoration: const InputDecoration(),
            items: _feeGroups.map((group) {
              final id = group['id'] as String;
              final name = group['name'] as String;
              final amount = group['amount'] as int;
              return DropdownMenuItem(
                value: id,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                    Text(
                      '₹${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (v) => setState(() => _selectedFeeGroup = v),
          ),
          AppSpacing.vMd,

          // Filter by Course
          _buildFieldLabel('Filter by Course', isDark),
          AppSpacing.vXs,
          DropdownButtonFormField<String>(
            initialValue: _filterCourse,
            isExpanded: true,
            decoration: const InputDecoration(),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All Courses')),
              DropdownMenuItem(value: 'Computer Science', child: Text('Computer Science')),
              DropdownMenuItem(value: 'Commerce', child: Text('Commerce')),
              DropdownMenuItem(value: 'Engineering', child: Text('Engineering')),
              DropdownMenuItem(value: 'Arts', child: Text('Arts')),
              DropdownMenuItem(value: 'Science', child: Text('Science')),
            ],
            onChanged: (v) => setState(() => _filterCourse = v!),
          ),
          AppSpacing.vMd,

          // Filter by Batch
          _buildFieldLabel('Filter by Batch', isDark),
          AppSpacing.vXs,
          DropdownButtonFormField<String>(
            initialValue: _filterBatch,
            isExpanded: true,
            decoration: const InputDecoration(),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All Batches')),
              DropdownMenuItem(value: 'CS-2024-A', child: Text('CS-2024-A')),
              DropdownMenuItem(value: 'COM-2024-A', child: Text('COM-2024-A')),
              DropdownMenuItem(value: 'ENG-2024-A', child: Text('ENG-2024-A')),
            ],
            onChanged: (v) => setState(() => _filterBatch = v!),
          ),
          AppSpacing.vMd,

          // Due Date
          AppTextField(
            controller: _dueDateController,
            label: 'Due Date',
            hint: 'YYYY-MM-DD',
            suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
          ),
          AppSpacing.vLg,

          // Button
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: 'Allocate to Selected (${_selectedStudentIds.length})',
              icon: Icons.check_circle_outline_rounded,
              onPressed: _selectedFeeGroup != null ? _handleBulkAllocate : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentListTableCard(List<Map<String, dynamic>> students, bool isDark) {
    final allSelected = students.isNotEmpty && _selectedStudentIds.length == students.length;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Student List', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                    Text(
                      'Select students to allocate fee groups',
                      style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    ),
                  ],
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 240),
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                      borderRadius: AppRadius.sm,
                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val.trim()),
                      style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                      decoration: InputDecoration(
                        hintText: 'Search students...',
                        hintStyle: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight, fontSize: 12),
                        prefixIcon: Icon(Icons.search_rounded, size: 16, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
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
                    dataRowMaxHeight: 60,
                    horizontalMargin: 16,
                    columnSpacing: 20,
                    headingRowColor: WidgetStateProperty.all(
                      isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight.withAlpha(120),
                    ),
                    columns: [
                      DataColumn(
                        label: Checkbox(
                          value: allSelected,
                          onChanged: (v) {
                            setState(() {
                              if (v == true) {
                                _selectedStudentIds.addAll(students.map((s) => s['id'] as String));
                              } else {
                                _selectedStudentIds.clear();
                              }
                            });
                          },
                          activeColor: AppColors.primary,
                        ),
                      ),
                      _buildDataColumn('STUDENT', isDark),
                      _buildDataColumn('COURSE', isDark),
                      _buildDataColumn('FEE GROUP', isDark),
                      _buildDataColumn('TOTAL FEE', isDark),
                      _buildDataColumn('DUE DATE', isDark),
                      _buildDataColumn('STATUS', isDark),
                      _buildDataColumn('ACTIONS', isDark),
                    ],
                    rows: students.map((student) {
                      final id = student['id'] as String;
                      final name = student['name'] as String;
                      final studentId = student['studentId'] as String;
                      final course = student['course'] as String;
                      final batch = student['batch'] as String;
                      final feeGroup = student['feeGroup'] as String;
                      final totalFee = student['totalFee'] as int;
                      final dueDate = student['dueDate'] as String;
                      final allocated = student['allocated'] as bool;
                      final isSelected = _selectedStudentIds.contains(id);

                      return DataRow(
                        selected: isSelected,
                        cells: [
                          DataCell(
                            Checkbox(
                              value: isSelected,
                              onChanged: (v) {
                                setState(() {
                                  if (v == true) {
                                    _selectedStudentIds.add(id);
                                  } else {
                                    _selectedStudentIds.remove(id);
                                  }
                                });
                              },
                              activeColor: AppColors.primary,
                            ),
                          ),

                          // Student (Name + ID)
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                Text(studentId, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                              ],
                            ),
                          ),

                          // Course (Badge + Batch)
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                    borderRadius: AppRadius.sm,
                                  ),
                                  child: Text(course, style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500)),
                                ),
                                Text(batch, style: AppTypography.bodySmall.copyWith(fontSize: 10.5, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                              ],
                            ),
                          ),

                          // Fee Group
                          DataCell(
                            feeGroup.isNotEmpty
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                      borderRadius: AppRadius.sm,
                                    ),
                                    child: Text(feeGroup, style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500)),
                                  )
                                : Text('Not assigned', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                          ),

                          // Total Fee
                          DataCell(
                            totalFee > 0
                                ? Text(
                                    '₹${totalFee.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700),
                                  )
                                : const Text('-'),
                          ),

                          // Due Date
                          DataCell(Text(dueDate, style: AppTypography.bodySmall)),

                          // Status (Allocated / Pending)
                          DataCell(
                            allocated
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withAlpha(20),
                                      borderRadius: AppRadius.full,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.check_circle_rounded, size: 12, color: AppColors.success),
                                        AppSpacing.hXs,
                                        Text('Allocated', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.error.withAlpha(20),
                                      borderRadius: AppRadius.full,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.error_outline_rounded, size: 12, color: AppColors.error),
                                        AppSpacing.hXs,
                                        Text('Pending', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.error, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                          ),

                          // Actions
                          DataCell(
                            PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_horiz_rounded,
                                size: 18,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                              onSelected: (action) {
                                if (action == 'view') {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Viewing allocation for $name...')));
                                }
                                if (action == 'change') {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Change fee group for $name...')));
                                }
                                if (action == 'discount') {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Adding scholarship/discount for $name...')));
                                }
                                if (action == 'remove') {
                                  setState(() {
                                    student['feeGroup'] = '';
                                    student['totalFee'] = 0;
                                    student['allocated'] = false;
                                    student['dueDate'] = '-';
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Removed allocation for $name.'), backgroundColor: AppColors.error),
                                  );
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'view',
                                  child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text('View Details')]),
                                ),
                                PopupMenuItem(
                                  value: 'change',
                                  child: Row(children: [Icon(Icons.edit_outlined, size: 16), SizedBox(width: 8), Text('Change Fee Group')]),
                                ),
                                PopupMenuItem(
                                  value: 'discount',
                                  child: Row(children: [Icon(Icons.discount_outlined, size: 16), SizedBox(width: 8), Text('Add Discount')]),
                                ),
                                PopupMenuItem(
                                  value: 'remove',
                                  child: Row(children: [Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error), SizedBox(width: 8), Text('Remove Allocation', style: TextStyle(color: AppColors.error))]),
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

  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => context.go(RouteNames.feeCollectionPath),
              child: Text(
                'Fee Management',
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
              'Fee Allocation',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Fee Allocation',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Assign fee groups to students',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label, bool isDark) {
    return Text(
      label,
      style: AppTypography.labelMedium.copyWith(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        fontWeight: FontWeight.w600,
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
