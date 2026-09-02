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

class MarksListScreen extends StatefulWidget {
  const MarksListScreen({super.key});

  @override
  State<MarksListScreen> createState() => _MarksListScreenState();
}

class _MarksListScreenState extends State<MarksListScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _marksData = [
    {'id': '1', 'studentName': 'Alice Johnson', 'rollNo': 'CS2024001', 'examName': 'Mid-Term', 'subject': 'Mathematics', 'maxMarks': 100, 'obtainedMarks': 92, 'percentage': 92, 'grade': 'A+', 'status': 'completed'},
    {'id': '2', 'studentName': 'Bob Smith', 'rollNo': 'CS2024002', 'examName': 'Mid-Term', 'subject': 'Mathematics', 'maxMarks': 100, 'obtainedMarks': 78, 'percentage': 78, 'grade': 'B+', 'status': 'completed'},
    {'id': '3', 'studentName': 'Charlie Brown', 'rollNo': 'CS2024003', 'examName': 'Mid-Term', 'subject': 'Mathematics', 'maxMarks': 100, 'obtainedMarks': 65, 'percentage': 65, 'grade': 'B', 'status': 'completed'},
    {'id': '4', 'studentName': 'Diana Ross', 'rollNo': 'CS2024004', 'examName': 'Mid-Term', 'subject': 'Mathematics', 'maxMarks': 100, 'obtainedMarks': 0, 'percentage': 0, 'grade': '-', 'status': 'absent'},
    {'id': '5', 'studentName': 'Edward Wilson', 'rollNo': 'CS2024005', 'examName': 'Mid-Term', 'subject': 'Mathematics', 'maxMarks': 100, 'obtainedMarks': 88, 'percentage': 88, 'grade': 'A', 'status': 'completed'},
    {'id': '6', 'studentName': 'Fiona Green', 'rollNo': 'CS2024006', 'examName': 'Mid-Term', 'subject': 'Mathematics', 'maxMarks': 100, 'obtainedMarks': 45, 'percentage': 45, 'grade': 'C', 'status': 'completed'},
    {'id': '7', 'studentName': 'George Martin', 'rollNo': 'CS2024007', 'examName': 'Mid-Term', 'subject': 'Mathematics', 'maxMarks': 100, 'obtainedMarks': 32, 'percentage': 32, 'grade': 'F', 'status': 'completed'},
  ];

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return AppColors.success;
      case 'B+':
      case 'B':
        return AppColors.info;
      case 'C+':
      case 'C':
        return AppColors.warning;
      case 'F':
        return AppColors.error;
      default:
        return AppColors.textSecondaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isTablet = context.isTablet;

    final filteredData = _marksData.where((m) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (m['studentName'] as String).toLowerCase();
      final roll = (m['rollNo'] as String).toLowerCase();
      final sub = (m['subject'] as String).toLowerCase();
      return name.contains(q) || roll.contains(q) || sub.contains(q);
    }).toList();

    // Stats Cards
    final card1 = const OrgStatsCard(
      title: 'Total Students',
      value: '45',
      subtitle: 'In this batch',
      icon: Icons.groups_outlined,
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = const OrgStatsCard(
      title: 'Average Score',
      value: '72%',
      subtitle: '+5% from last exam',
      icon: Icons.trending_up_rounded,
      trend: OrgStatsCardTrend(value: 5, isPositive: true),
      variant: OrgStatsCardVariant.success,
    );
    final card3 = const OrgStatsCard(
      title: 'Top Scorers',
      value: '8',
      subtitle: 'Above 85%',
      icon: Icons.military_tech_outlined,
      variant: OrgStatsCardVariant.info,
    );
    final card4 = const OrgStatsCard(
      title: 'Below Passing',
      value: '3',
      subtitle: 'Need attention',
      icon: Icons.warning_amber_rounded,
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

          // Marks List Table Card (Full Width)
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
                      Row(
                        children: [
                          const Icon(Icons.description_outlined, size: 20, color: AppColors.primary),
                          AppSpacing.hSm,
                          Text(
                            'Mid-Term Examination Results',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
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
                              hintText: 'Search students...',
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
                            _buildDataColumn('STUDENT', isDark),
                            _buildDataColumn('EXAM', isDark),
                            _buildDataColumn('SUBJECT', isDark),
                            _buildDataColumn('MARKS', isDark),
                            _buildDataColumn('PERCENTAGE', isDark),
                            _buildDataColumn('GRADE', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredData.map((record) {
                            final name = record['studentName'] as String;
                            final rollNo = record['rollNo'] as String;
                            final examName = record['examName'] as String;
                            final subject = record['subject'] as String;
                            final maxMarks = record['maxMarks'] as int;
                            final obtained = record['obtainedMarks'] as int;
                            final percentage = record['percentage'] as int;
                            final grade = record['grade'] as String;
                            final status = record['status'] as String;

                            final gradeColor = _getGradeColor(grade);

                            return DataRow(
                              cells: [
                                // Student Avatar + Name + Roll No
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: AppColors.primary.withAlpha(25),
                                        child: Text(
                                          name.substring(0, 1),
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13),
                                        ),
                                      ),
                                      AppSpacing.hSm,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                          Text(
                                            rollNo,
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

                                DataCell(Text(examName, style: AppTypography.bodySmall)),
                                DataCell(Text(subject, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500))),

                                // Marks
                                DataCell(
                                  Text(
                                    status == 'absent' ? '-' : '$obtained/$maxMarks',
                                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),

                                // Percentage
                                DataCell(
                                  Text(
                                    status == 'absent' ? '-' : '$percentage%',
                                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),

                                // Grade Badge
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: gradeColor.withAlpha(20),
                                      borderRadius: AppRadius.sm,
                                      border: Border.all(color: gradeColor.withAlpha(60)),
                                    ),
                                    child: Text(
                                      grade,
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: gradeColor,
                                      ),
                                    ),
                                  ),
                                ),

                                // Status
                                DataCell(
                                  AppStatusBadge(
                                    status: status == 'completed'
                                        ? AppBadgeStatus.completed
                                        : status == 'absent'
                                            ? AppBadgeStatus.danger
                                            : AppBadgeStatus.pending,
                                    customLabel: status,
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
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Viewing marks card for $name...')));
                                      }
                                      if (action == 'edit') {
                                        context.go(RouteNames.examAssignMarksPath);
                                      }
                                      if (action == 'print') {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Printing report card for $name...')));
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'view',
                                        child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text('View Details')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Row(children: [Icon(Icons.edit_outlined, size: 16), SizedBox(width: 8), Text('Edit Marks')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'print',
                                        child: Row(children: [Icon(Icons.print_outlined, size: 16), SizedBox(width: 8), Text('Print Report')]),
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
              'Marks List',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Marks List',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'View and manage student examination marks',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'Export Report',
      icon: Icons.download_rounded,
      variant: AppButtonVariant.outline,
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exporting results CSV...')));
      },
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
