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
import '../../../widgets/org_stats_card.dart';

class ExamScheduleScreen extends StatefulWidget {
  const ExamScheduleScreen({super.key});

  @override
  State<ExamScheduleScreen> createState() => _ExamScheduleScreenState();
}

class _ExamScheduleScreenState extends State<ExamScheduleScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _examsData = [
    {
      'id': '1',
      'examName': 'Mid-Term Examination',
      'course': 'Computer Science',
      'batch': '2024-A',
      'date': '2024-01-25',
      'duration': '3 hours',
      'totalMarks': 100,
      'studentsAppeared': 45,
      'status': 'completed',
    },
    {
      'id': '2',
      'examName': 'Practical Test',
      'course': 'Science',
      'batch': '2024-B',
      'date': '2024-01-28',
      'duration': '2 hours',
      'totalMarks': 50,
      'studentsAppeared': 38,
      'status': 'completed',
    },
    {
      'id': '3',
      'examName': 'Unit Test 1',
      'course': 'Commerce',
      'batch': '2024-A',
      'date': '2024-02-05',
      'duration': '1 hour',
      'totalMarks': 25,
      'studentsAppeared': 0,
      'status': 'pending',
    },
    {
      'id': '4',
      'examName': 'Final Examination',
      'course': 'Arts',
      'batch': '2024-C',
      'date': '2024-02-15',
      'duration': '3 hours',
      'totalMarks': 100,
      'studentsAppeared': 0,
      'status': 'pending',
    },
    {
      'id': '5',
      'examName': 'Lab Practical',
      'course': 'Engineering',
      'batch': '2024-A',
      'date': '2024-01-30',
      'duration': '4 hours',
      'totalMarks': 50,
      'studentsAppeared': 52,
      'status': 'active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isTablet = context.isTablet;

    final filteredExams = _examsData.where((e) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (e['examName'] as String).toLowerCase();
      final course = (e['course'] as String).toLowerCase();
      final batch = (e['batch'] as String).toLowerCase();
      return name.contains(q) || course.contains(q) || batch.contains(q);
    }).toList();

    final completedCount = _examsData.where((e) => e['status'] == 'completed').length;
    final pendingCount = _examsData.where((e) => e['status'] == 'pending').length;

    // Stats Cards
    final card1 = OrgStatsCard(
      title: 'Total Exams',
      value: '12',
      subtitle: 'This semester',
      icon: Icons.assignment_outlined,
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = OrgStatsCard(
      title: 'Completed',
      value: completedCount.toString(),
      subtitle: 'Successfully conducted',
      icon: Icons.check_circle_outline_rounded,
      variant: OrgStatsCardVariant.success,
    );
    final card3 = OrgStatsCard(
      title: 'Upcoming',
      value: pendingCount.toString(),
      subtitle: 'Scheduled',
      icon: Icons.calendar_today_rounded,
      variant: OrgStatsCardVariant.info,
    );
    final card4 = OrgStatsCard(
      title: 'Results Pending',
      value: '3',
      subtitle: 'Awaiting marks entry',
      icon: Icons.description_outlined,
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
          _buildHeader(isDark, isMobile),
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

          // Examination Schedule Table Card (Full Width)
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
                        'Examination Schedule',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                            borderRadius: AppRadius.sm,
                            border: Border.all(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                          ),
                          child: TextField(
                            onChanged: (val) => setState(() => _searchQuery = val.trim()),
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search exams...',
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
                          dataRowMinHeight: 60,
                          dataRowMaxHeight: 64,
                          horizontalMargin: 20,
                          columnSpacing: 24,
                          headingRowColor: WidgetStateProperty.all(
                            isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight.withAlpha(120),
                          ),
                          columns: [
                            _buildDataColumn('EXAM', isDark),
                            _buildDataColumn('BATCH', isDark),
                            _buildDataColumn('DATE', isDark),
                            _buildDataColumn('DURATION', isDark),
                            _buildDataColumn('TOTAL MARKS', isDark),
                            _buildDataColumn('APPEARED', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredExams.map((exam) {
                            final name = exam['examName'] as String;
                            final course = exam['course'] as String;
                            final batch = exam['batch'] as String;
                            final date = exam['date'] as String;
                            final duration = exam['duration'] as String;
                            final totalMarks = exam['totalMarks'] as int;
                            final appeared = exam['studentsAppeared'] as int;
                            final status = exam['status'] as String;

                            AppBadgeStatus badgeStatus;
                            switch (status) {
                              case 'completed':
                                badgeStatus = AppBadgeStatus.completed;
                                break;
                              case 'active':
                                badgeStatus = AppBadgeStatus.active;
                                break;
                              default:
                                badgeStatus = AppBadgeStatus.pending;
                            }

                            return DataRow(
                              cells: [
                                // Exam
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                      Text(
                                        course,
                                        style: AppTypography.bodySmall.copyWith(
                                          fontSize: 11,
                                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                        ),
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
                                    child: Text(batch, style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500)),
                                  ),
                                ),

                                // Date
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.calendar_today_rounded, size: 14, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                      AppSpacing.hXs,
                                      Text(date, style: AppTypography.bodySmall),
                                    ],
                                  ),
                                ),

                                // Duration
                                DataCell(Text(duration, style: AppTypography.bodySmall)),

                                // Total Marks
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                      borderRadius: AppRadius.sm,
                                    ),
                                    child: Text(
                                      '$totalMarks marks',
                                      style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),

                                // Appeared
                                DataCell(
                                  Text(
                                    appeared > 0 ? '$appeared students' : '-',
                                    style: AppTypography.bodySmall,
                                  ),
                                ),

                                // Status
                                DataCell(AppStatusBadge(status: badgeStatus, customLabel: status)),

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
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Viewing $name details...')));
                                      }
                                      if (action == 'marks') {
                                        context.go(RouteNames.examAssignMarksPath);
                                      }
                                      if (action == 'hallTicket') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Generating hall tickets for $name...')),
                                        );
                                      }
                                      if (action == 'edit') {
                                        context.go(RouteNames.examCreatePath);
                                      }
                                      if (action == 'delete') {
                                        setState(() => _examsData.remove(exam));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Deleted $name.'), backgroundColor: AppColors.error),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'view',
                                        child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text('View Details')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'marks',
                                        child: Row(children: [Icon(Icons.edit_note_rounded, size: 16), SizedBox(width: 8), Text('Assign Marks')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'hallTicket',
                                        child: Row(children: [Icon(Icons.badge_outlined, size: 16), SizedBox(width: 8), Text('Print Hall Ticket')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Row(children: [Icon(Icons.edit_outlined, size: 16), SizedBox(width: 8), Text('Edit')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Row(children: [Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error), SizedBox(width: 8), Text('Delete', style: TextStyle(color: AppColors.error))]),
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
              'Exam Schedule',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Exam Schedule',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'View and manage examination schedules',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'Schedule Exam',
      icon: Icons.add_rounded,
      onPressed: () => context.go(RouteNames.examCreatePath),
      height: 38,
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerTexts,
          AppSpacing.vMd,
          actionButton,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: headerTexts),
        actionButton,
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
