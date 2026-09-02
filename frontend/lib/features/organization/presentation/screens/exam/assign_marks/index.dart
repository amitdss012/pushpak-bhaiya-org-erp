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

class AssignMarksScreen extends StatefulWidget {
  const AssignMarksScreen({super.key});

  @override
  State<AssignMarksScreen> createState() => _AssignMarksScreenState();
}

class _AssignMarksScreenState extends State<AssignMarksScreen> {
  String _course = 'cs';
  String _batch = '2024-a';
  String _exam = 'mid-term';
  String _subject = 'math';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _studentsData = [
    {'id': '1', 'name': 'Alice Johnson', 'rollNo': 'CS2024001', 'maxMarks': 100, 'obtained': null},
    {'id': '2', 'name': 'Bob Smith', 'rollNo': 'CS2024002', 'maxMarks': 100, 'obtained': 85},
    {'id': '3', 'name': 'Charlie Brown', 'rollNo': 'CS2024003', 'maxMarks': 100, 'obtained': 72},
    {'id': '4', 'name': 'Diana Ross', 'rollNo': 'CS2024004', 'maxMarks': 100, 'obtained': null},
    {'id': '5', 'name': 'Edward Wilson', 'rollNo': 'CS2024005', 'maxMarks': 100, 'obtained': 91},
    {'id': '6', 'name': 'Fiona Green', 'rollNo': 'CS2024006', 'maxMarks': 100, 'obtained': null},
    {'id': '7', 'name': 'George Martin', 'rollNo': 'CS2024007', 'maxMarks': 100, 'obtained': 68},
    {'id': '8', 'name': 'Hannah White', 'rollNo': 'CS2024008', 'maxMarks': 100, 'obtained': 45},
  ];

  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (final s in _studentsData) {
      final id = s['id'] as String;
      final ob = s['obtained'];
      _controllers[id] = TextEditingController(text: ob != null ? ob.toString() : '');
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _handleSaveAllMarks() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All marks saved successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;

    final filteredStudents = _studentsData.where((s) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (s['name'] as String).toLowerCase();
      final roll = (s['rollNo'] as String).toLowerCase();
      return name.contains(q) || roll.contains(q);
    }).toList();

    final markedCount = _studentsData.where((s) => s['obtained'] != null).length;
    final pendingCount = _studentsData.length - markedCount;

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

          // Select Exam Card
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Exam', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                AppSpacing.vLg,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Course', isDark),
                          AppSpacing.vXs,
                          DropdownButtonFormField<String>(
                            initialValue: _course,
                            isExpanded: true,
                            decoration: const InputDecoration(),
                            items: const [
                              DropdownMenuItem(value: 'cs', child: Text('Computer Science')),
                              DropdownMenuItem(value: 'science', child: Text('Science')),
                              DropdownMenuItem(value: 'commerce', child: Text('Commerce')),
                            ],
                            onChanged: (v) => setState(() => _course = v!),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.hMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Batch', isDark),
                          AppSpacing.vXs,
                          DropdownButtonFormField<String>(
                            initialValue: _batch,
                            isExpanded: true,
                            decoration: const InputDecoration(),
                            items: const [
                              DropdownMenuItem(value: '2024-a', child: Text('2024-A')),
                              DropdownMenuItem(value: '2024-b', child: Text('2024-B')),
                            ],
                            onChanged: (v) => setState(() => _batch = v!),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.hMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Exam', isDark),
                          AppSpacing.vXs,
                          DropdownButtonFormField<String>(
                            initialValue: _exam,
                            isExpanded: true,
                            decoration: const InputDecoration(),
                            items: const [
                              DropdownMenuItem(value: 'mid-term', child: Text('Mid-Term Examination')),
                              DropdownMenuItem(value: 'unit-1', child: Text('Unit Test 1')),
                              DropdownMenuItem(value: 'practical', child: Text('Practical Test')),
                            ],
                            onChanged: (v) => setState(() => _exam = v!),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.hMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Subject', isDark),
                          AppSpacing.vXs,
                          DropdownButtonFormField<String>(
                            initialValue: _subject,
                            isExpanded: true,
                            decoration: const InputDecoration(),
                            items: const [
                              DropdownMenuItem(value: 'math', child: Text('Mathematics')),
                              DropdownMenuItem(value: 'physics', child: Text('Physics')),
                              DropdownMenuItem(value: 'chemistry', child: Text('Chemistry')),
                            ],
                            onChanged: (v) => setState(() => _subject = v!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.vLg,

          // Student Marks Entry Card
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Student Marks Entry', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                          Text(
                            'Mid-Term Examination - Mathematics (Max: 100)',
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
                              hintText: 'Search student...',
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
                          horizontalMargin: 20,
                          columnSpacing: 24,
                          headingRowColor: WidgetStateProperty.all(
                            isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight.withAlpha(120),
                          ),
                          columns: [
                            _buildDataColumn('#', isDark),
                            _buildDataColumn('STUDENT', isDark),
                            _buildDataColumn('ROLL NO', isDark),
                            _buildDataColumn('MAX MARKS', isDark),
                            _buildDataColumn('OBTAINED MARKS', isDark),
                            _buildDataColumn('STATUS', isDark),
                          ],
                          rows: filteredStudents.asMap().entries.map((entry) {
                            final index = entry.key;
                            final student = entry.value;
                            final id = student['id'] as String;
                            final name = student['name'] as String;
                            final rollNo = student['rollNo'] as String;
                            final maxMarks = student['maxMarks'] as int;
                            final obtained = student['obtained'] as int?;
                            final ctrl = _controllers[id]!;

                            return DataRow(
                              cells: [
                                DataCell(Text((index + 1).toString(), style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600))),

                                // Student Avatar + Name
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColors.primary.withAlpha(25),
                                        child: Text(
                                          name.substring(0, 1),
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12),
                                        ),
                                      ),
                                      AppSpacing.hSm,
                                      Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),

                                DataCell(Text(rollNo, style: AppTypography.bodySmall)),
                                DataCell(Text(maxMarks.toString(), style: AppTypography.bodySmall)),

                                // Obtained Marks (Editable)
                                DataCell(
                                  SizedBox(
                                    width: 100,
                                    height: 36,
                                    child: TextField(
                                      controller: ctrl,
                                      keyboardType: TextInputType.number,
                                      style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                      decoration: InputDecoration(
                                        hintText: 'Enter marks',
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        border: OutlineInputBorder(
                                          borderRadius: AppRadius.sm,
                                          borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                        ),
                                      ),
                                      onChanged: (v) {
                                        final val = int.tryParse(v.trim());
                                        setState(() {
                                          student['obtained'] = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),

                                // Status Badge
                                DataCell(
                                  obtained != null
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: obtained >= 35 ? AppColors.success.withAlpha(20) : AppColors.error.withAlpha(20),
                                            borderRadius: AppRadius.full,
                                          ),
                                          child: Text(
                                            obtained >= 35 ? 'Pass' : 'Fail',
                                            style: AppTypography.bodySmall.copyWith(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: obtained >= 35 ? AppColors.success : AppColors.error,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                            borderRadius: AppRadius.full,
                                          ),
                                          child: Text(
                                            'Pending',
                                            style: AppTypography.bodySmall.copyWith(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                            ),
                                          ),
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
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Showing ${_studentsData.length} students • $markedCount marked, $pendingCount pending',
                        style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                      ),
                      AppButton(
                        text: 'Save All Marks',
                        icon: Icons.save_rounded,
                        onPressed: _handleSaveAllMarks,
                      ),
                    ],
                  ),
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
              onTap: () => context.go(RouteNames.examSchedulePath),
              child: Text(
                'Exam & Marks',
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
              'Assign Marks',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Assign Marks',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Enter marks for students',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButtons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton(
          text: 'Import CSV',
          icon: Icons.upload_file_rounded,
          variant: AppButtonVariant.outline,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Importing marks CSV...')));
          },
          height: 38,
        ),
        AppSpacing.hSm,
        AppButton(
          text: 'Export',
          icon: Icons.download_rounded,
          variant: AppButtonVariant.outline,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exporting marks list...')));
          },
          height: 38,
        ),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerTexts,
          AppSpacing.vMd,
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: actionButtons),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: headerTexts),
        actionButtons,
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
