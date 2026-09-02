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
import '../../../../../../shared/widgets/app_status_badge.dart';

class AssignCourseToBatchScreen extends StatefulWidget {
  const AssignCourseToBatchScreen({super.key});

  @override
  State<AssignCourseToBatchScreen> createState() => _AssignCourseToBatchScreenState();
}

class _AssignCourseToBatchScreenState extends State<AssignCourseToBatchScreen> {
  String _selectedBranch = 'main';
  String _selectedCourse = 'cs';
  String _selectedBatch = 'csa';

  final List<String> _subjectsList = [
    'Data Structures',
    'Algorithms',
    'Database Systems',
    'Web Development',
    'Operating Systems',
    'Computer Networks',
    'Software Engineering',
    'Machine Learning',
  ];

  final Set<String> _selectedSubjects = {'Data Structures', 'Algorithms', 'Database Systems', 'Web Development'};
  final _newSubjectController = TextEditingController();

  final List<Map<String, dynamic>> _assignmentsData = [
    {
      'id': '1',
      'course': 'Computer Science',
      'courseCode': 'CS101',
      'batch': 'CS-2024-A',
      'subjects': ['Data Structures', 'Algorithms', 'Database Systems', 'Web Development'],
      'instructors': ['Dr. Smith', 'Prof. Johnson'],
      'status': 'assigned',
    },
    {
      'id': '2',
      'course': 'Computer Science',
      'courseCode': 'CS101',
      'batch': 'CS-2024-B',
      'subjects': ['Data Structures', 'Algorithms', 'Database Systems', 'Web Development'],
      'instructors': ['Prof. Johnson', 'Dr. Patel'],
      'status': 'assigned',
    },
    {
      'id': '3',
      'course': 'Commerce',
      'courseCode': 'COM101',
      'batch': 'COM-2024-A',
      'subjects': ['Accounting', 'Economics', 'Business Studies', 'Statistics'],
      'instructors': ['Dr. Sharma', 'Prof. Gupta'],
      'status': 'assigned',
    },
    {
      'id': '4',
      'course': 'Engineering',
      'courseCode': 'ENG101',
      'batch': 'ENG-2024-A',
      'subjects': ['Mathematics', 'Physics', 'Chemistry', 'Engineering Drawing'],
      'instructors': ['Prof. Kumar'],
      'status': 'pending',
    },
  ];

  @override
  void dispose() {
    _newSubjectController.dispose();
    super.dispose();
  }

  void _addSubject() {
    final name = _newSubjectController.text.trim();
    if (name.isNotEmpty && !_subjectsList.contains(name)) {
      setState(() {
        _subjectsList.add(name);
        _selectedSubjects.add(name);
        _newSubjectController.clear();
      });
    }
  }

  void _handleAssignCourse() {
    setState(() {
      _assignmentsData.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'course': _selectedCourse == 'cs'
            ? 'Computer Science'
            : _selectedCourse == 'com'
                ? 'Commerce'
                : 'Engineering',
        'courseCode': _selectedCourse == 'cs'
            ? 'CS101'
            : _selectedCourse == 'com'
                ? 'COM101'
                : 'ENG101',
        'batch': _selectedBatch == 'csa'
            ? 'CS-2024-A'
            : _selectedBatch == 'csb'
                ? 'CS-2024-B'
                : _selectedBatch == 'coma'
                    ? 'COM-2024-A'
                    : 'ENG-2024-A',
        'subjects': _selectedSubjects.toList(),
        'instructors': ['Dr. Smith', 'Prof. Johnson'],
        'status': 'assigned',
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Course successfully assigned to batch!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isMobile = context.isMobile;

    final activeCount = _assignmentsData.where((a) => a['status'] == 'assigned').length;
    final pendingCount = _assignmentsData.where((a) => a['status'] == 'pending').length;

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

          // 2-Column Top Section
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildNewAssignmentCard(isDark)),
                AppSpacing.hLg,
                Expanded(flex: 1, child: _buildQuickStatsCard(activeCount, pendingCount, isDark)),
              ],
            )
          else
            Column(
              children: [
                _buildNewAssignmentCard(isDark),
                AppSpacing.vLg,
                _buildQuickStatsCard(activeCount, pendingCount, isDark),
              ],
            ),

          AppSpacing.vXl,

          // Current Assignments Table Card (Full Width)
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Current Assignments',
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
                          dataRowMinHeight: 60,
                          dataRowMaxHeight: 64,
                          horizontalMargin: 20,
                          columnSpacing: 24,
                          headingRowColor: WidgetStateProperty.all(
                            isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight.withAlpha(120),
                          ),
                          columns: [
                            _buildDataColumn('COURSE', isDark),
                            _buildDataColumn('BATCH', isDark),
                            _buildDataColumn('SUBJECTS', isDark),
                            _buildDataColumn('INSTRUCTORS', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: _assignmentsData.map((item) {
                            final course = item['course'] as String;
                            final courseCode = item['courseCode'] as String;
                            final batch = item['batch'] as String;
                            final subjects = (item['subjects'] as List).cast<String>();
                            final instructors = (item['instructors'] as List).cast<String>();
                            final status = item['status'] as String;
                            final isAssigned = status == 'assigned';

                            return DataRow(
                              cells: [
                                // Course Name + Code
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withAlpha(25),
                                          borderRadius: AppRadius.sm,
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.menu_book_rounded, size: 18, color: AppColors.primary),
                                        ),
                                      ),
                                      AppSpacing.hSm,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(course, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                          Text(
                                            courseCode,
                                            style: AppTypography.bodySmall.copyWith(
                                              fontSize: 11,
                                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Batch
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                      borderRadius: AppRadius.full,
                                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.groups_rounded, size: 14, color: AppColors.primary),
                                        AppSpacing.hXs,
                                        Text(
                                          batch,
                                          style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Subjects Chips
                                DataCell(
                                  Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: [
                                      ...subjects.take(2).map((sub) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withAlpha(15),
                                            borderRadius: AppRadius.sm,
                                          ),
                                          child: Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.primary)),
                                        );
                                      }),
                                      if (subjects.length > 2)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                            borderRadius: AppRadius.sm,
                                          ),
                                          child: Text('+${subjects.length - 2}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                        ),
                                    ],
                                  ),
                                ),

                                // Instructors
                                DataCell(Text(instructors.join(', '), style: AppTypography.bodySmall)),

                                // Status
                                DataCell(
                                  AppStatusBadge(
                                    status: isAssigned ? AppBadgeStatus.completed : AppBadgeStatus.pending,
                                    customLabel: isAssigned ? 'Assigned' : 'Pending',
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
                                      if (action == 'remove') {
                                        setState(() => _assignmentsData.remove(item));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Assignment for "$batch" removed.'),
                                            backgroundColor: AppColors.error,
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Viewing assignment details for $batch...')),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'view',
                                        child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text('View Details')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Row(children: [Icon(Icons.edit_outlined, size: 16), SizedBox(width: 8), Text('Edit Assignment')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'remove',
                                        child: Row(children: [Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error), SizedBox(width: 8), Text('Remove Assignment', style: TextStyle(color: AppColors.error))]),
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

  Widget _buildNewAssignmentCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.link_rounded, size: 20, color: AppColors.primary),
              AppSpacing.hSm,
              Text(
                'New Assignment',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          AppSpacing.vXs,
          Text(
            'Assign a course to a batch with selected subjects',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          AppSpacing.vLg,

          // Branch, Course, Batch Dropdowns
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Branch *',
                      style: AppTypography.labelMedium.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _selectedBranch,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'main', child: Text('Main Branch')),
                        DropdownMenuItem(value: 'north', child: Text('North Campus')),
                        DropdownMenuItem(value: 'south', child: Text('South Campus')),
                        DropdownMenuItem(value: 'east', child: Text('East Campus')),
                      ],
                      onChanged: (v) => setState(() => _selectedBranch = v!),
                    ),
                  ],
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Course *',
                      style: AppTypography.labelMedium.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCourse,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'cs', child: Text('Computer Science (CS101)')),
                        DropdownMenuItem(value: 'com', child: Text('Commerce (COM101)')),
                        DropdownMenuItem(value: 'eng', child: Text('Engineering (ENG101)')),
                        DropdownMenuItem(value: 'arts', child: Text('Arts (ART101)')),
                        DropdownMenuItem(value: 'sci', child: Text('Science (SCI101)')),
                      ],
                      onChanged: (v) => setState(() => _selectedCourse = v!),
                    ),
                  ],
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Batch *',
                      style: AppTypography.labelMedium.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _selectedBatch,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'csa', child: Text('CS-2024-A')),
                        DropdownMenuItem(value: 'csb', child: Text('CS-2024-B')),
                        DropdownMenuItem(value: 'coma', child: Text('COM-2024-A')),
                        DropdownMenuItem(value: 'enga', child: Text('ENG-2024-A')),
                      ],
                      onChanged: (v) => setState(() => _selectedBatch = v!),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.vLg,

          // Subjects Selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Subjects',
                style: AppTypography.labelMedium.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 180),
                    child: SizedBox(
                      height: 32,
                      child: TextField(
                        controller: _newSubjectController,
                        style: const TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
                          hintText: 'New subject...',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.hXs,
                  AppButton(
                    text: 'Add',
                    variant: AppButtonVariant.outline,
                    onPressed: _addSubject,
                    height: 32,
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.vSm,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight,
              borderRadius: AppRadius.sm,
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: _subjectsList.map((subject) {
                final isChecked = _selectedSubjects.contains(subject);
                return FilterChip(
                  selected: isChecked,
                  label: Text(subject, style: const TextStyle(fontSize: 12)),
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedSubjects.add(subject);
                      } else {
                        _selectedSubjects.remove(subject);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          AppSpacing.vMd,

          // Selected Badges Preview
          if (_selectedSubjects.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Selected: ',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: _selectedSubjects.map((sub) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(20),
                          borderRadius: AppRadius.full,
                        ),
                        child: Text(
                          sub,
                          style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          AppSpacing.vLg,

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                text: 'Cancel',
                variant: AppButtonVariant.outline,
                onPressed: () {
                  setState(() => _selectedSubjects.clear());
                },
              ),
              AppSpacing.hMd,
              AppButton(
                text: 'Assign Course',
                icon: Icons.link_rounded,
                onPressed: _handleAssignCourse,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsCard(int activeCount, int pendingCount, bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Stats',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          AppSpacing.vLg,
          _buildQuickStatRow('Total Assignments', _assignmentsData.length.toString(), isDark),
          AppSpacing.vMd,
          _buildQuickStatRow('Active Assignments', activeCount.toString(), isDark, valueColor: AppColors.success),
          AppSpacing.vMd,
          _buildQuickStatRow('Pending Assignments', pendingCount.toString(), isDark, valueColor: AppColors.warning),
          AppSpacing.vMd,
          _buildQuickStatRow('Total Batches', '4', isDark),
        ],
      ),
    );
  }

  Widget _buildQuickStatRow(String title, String value, bool isDark, {Color? valueColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight,
        borderRadius: AppRadius.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            ),
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
              onTap: () => context.go(RouteNames.courseViewPath),
              child: Text(
                'Course Management',
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
              'Assign Course to Batch',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Assign Course to Batch',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Link courses with batches and assign subjects',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
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
