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

class OnlineExamMarksScreen extends StatefulWidget {
  const OnlineExamMarksScreen({super.key});

  @override
  State<OnlineExamMarksScreen> createState() => _OnlineExamMarksScreenState();
}

class _OnlineExamMarksScreenState extends State<OnlineExamMarksScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _resultsData = [
    {
      'id': '1',
      'studentName': 'Alice Johnson',
      'rollNo': 'CS2024001',
      'examTitle': 'Mid-Term Online Test',
      'startTime': '10:00 AM',
      'submitTime': '10:45 AM',
      'totalQuestions': 50,
      'attempted': 48,
      'correct': 42,
      'wrong': 6,
      'score': 84,
      'maxScore': 100,
      'percentage': 84,
      'status': 'completed',
    },
    {
      'id': '2',
      'studentName': 'Bob Smith',
      'rollNo': 'CS2024002',
      'examTitle': 'Mid-Term Online Test',
      'startTime': '10:00 AM',
      'submitTime': '10:58 AM',
      'totalQuestions': 50,
      'attempted': 50,
      'correct': 38,
      'wrong': 12,
      'score': 76,
      'maxScore': 100,
      'percentage': 76,
      'status': 'completed',
    },
    {
      'id': '3',
      'studentName': 'Charlie Brown',
      'rollNo': 'CS2024003',
      'examTitle': 'Mid-Term Online Test',
      'startTime': '10:00 AM',
      'submitTime': '-',
      'totalQuestions': 50,
      'attempted': 25,
      'correct': 0,
      'wrong': 0,
      'score': 0,
      'maxScore': 100,
      'percentage': 0,
      'status': 'in_progress',
    },
    {
      'id': '4',
      'studentName': 'Diana Ross',
      'rollNo': 'CS2024004',
      'examTitle': 'Mid-Term Online Test',
      'startTime': '-',
      'submitTime': '-',
      'totalQuestions': 50,
      'attempted': 0,
      'correct': 0,
      'wrong': 0,
      'score': 0,
      'maxScore': 100,
      'percentage': 0,
      'status': 'absent',
    },
    {
      'id': '5',
      'studentName': 'Edward Wilson',
      'rollNo': 'CS2024005',
      'examTitle': 'Mid-Term Online Test',
      'startTime': '10:00 AM',
      'submitTime': '10:52 AM',
      'totalQuestions': 50,
      'attempted': 50,
      'correct': 45,
      'wrong': 5,
      'score': 90,
      'maxScore': 100,
      'percentage': 90,
      'status': 'completed',
    },
  ];

  Color _getPercentageColor(int percentage) {
    if (percentage >= 80) return AppColors.success;
    if (percentage >= 60) return AppColors.info;
    if (percentage >= 40) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isTablet = context.isTablet;

    final filteredResults = _resultsData.where((r) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (r['studentName'] as String).toLowerCase();
      final roll = (r['rollNo'] as String).toLowerCase();
      return name.contains(q) || roll.contains(q);
    }).toList();

    final completedCount = _resultsData.where((r) => r['status'] == 'completed').length;
    final inProgressCount = _resultsData.where((r) => r['status'] == 'in_progress').length;
    final absentCount = _resultsData.where((r) => r['status'] == 'absent').length;

    // Stats Cards
    final card1 = const OrgStatsCard(
      title: 'Total Students',
      value: '45',
      subtitle: 'Registered for exam',
      icon: Icons.groups_outlined,
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = OrgStatsCard(
      title: 'Completed',
      value: completedCount.toString(),
      subtitle: 'Submitted successfully',
      icon: Icons.check_circle_outline_rounded,
      variant: OrgStatsCardVariant.success,
    );
    final card3 = OrgStatsCard(
      title: 'In Progress',
      value: inProgressCount.toString(),
      subtitle: 'Currently attempting',
      icon: Icons.access_time_rounded,
      variant: OrgStatsCardVariant.info,
    );
    final card4 = OrgStatsCard(
      title: 'Absent',
      value: absentCount.toString(),
      subtitle: 'Did not attempt',
      icon: Icons.error_outline_rounded,
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

          // Results Table Card (Full Width)
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
                        'Mid-Term Online Test Results',
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
                          columnSpacing: 20,
                          headingRowColor: WidgetStateProperty.all(
                            isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight.withAlpha(120),
                          ),
                          columns: [
                            _buildDataColumn('STUDENT', isDark),
                            _buildDataColumn('PROGRESS', isDark),
                            _buildDataColumn('CORRECT/WRONG', isDark),
                            _buildDataColumn('SCORE', isDark),
                            _buildDataColumn('PERCENTAGE', isDark),
                            _buildDataColumn('TIMING', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredResults.map((result) {
                            final name = result['studentName'] as String;
                            final rollNo = result['rollNo'] as String;
                            final attempted = result['attempted'] as int;
                            final total = result['totalQuestions'] as int;
                            final correct = result['correct'] as int;
                            final wrong = result['wrong'] as int;
                            final score = result['score'] as int;
                            final maxScore = result['maxScore'] as int;
                            final percentage = result['percentage'] as int;
                            final startTime = result['startTime'] as String;
                            final submitTime = result['submitTime'] as String;
                            final status = result['status'] as String;

                            final pctColor = _getPercentageColor(percentage);

                            AppBadgeStatus badgeStatus;
                            switch (status) {
                              case 'completed':
                                badgeStatus = AppBadgeStatus.completed;
                                break;
                              case 'in_progress':
                                badgeStatus = AppBadgeStatus.active;
                                break;
                              default:
                                badgeStatus = AppBadgeStatus.danger;
                            }

                            final progressValue = total > 0 ? (attempted / total) : 0.0;

                            return DataRow(
                              cells: [
                                // Student
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

                                // Progress Bar
                                DataCell(
                                  SizedBox(
                                    width: 110,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('$attempted/$total', style: AppTypography.bodySmall.copyWith(fontSize: 11)),
                                            Text('${(progressValue * 100).round()}%', style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                        AppSpacing.vXs,
                                        LinearProgressIndicator(
                                          value: progressValue,
                                          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                                          minHeight: 4,
                                          borderRadius: AppRadius.full,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Correct / Wrong
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.success.withAlpha(20),
                                          borderRadius: AppRadius.sm,
                                        ),
                                        child: Text('✓ $correct', style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
                                      ),
                                      AppSpacing.hXs,
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.error.withAlpha(20),
                                          borderRadius: AppRadius.sm,
                                        ),
                                        child: Text('✗ $wrong', style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.error)),
                                      ),
                                    ],
                                  ),
                                ),

                                // Score
                                DataCell(
                                  Text(
                                    status == 'absent' ? '-' : '$score/$maxScore',
                                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),

                                // Percentage Badge
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: pctColor.withAlpha(20),
                                      borderRadius: AppRadius.sm,
                                      border: Border.all(color: pctColor.withAlpha(60)),
                                    ),
                                    child: Text(
                                      status == 'absent' ? '-' : '$percentage%',
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: pctColor,
                                      ),
                                    ),
                                  ),
                                ),

                                // Timing
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Start: $startTime', style: AppTypography.bodySmall.copyWith(fontSize: 11)),
                                      Text('Submit: $submitTime', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                                    ],
                                  ),
                                ),

                                // Status
                                DataCell(AppStatusBadge(status: badgeStatus, customLabel: status == 'in_progress' ? 'In Progress' : status)),

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
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Viewing $name result details...')));
                                      }
                                      if (action == 'answers') {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Viewing student answers for $name...')));
                                      }
                                      if (action == 'download') {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloading report for $name...')));
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'view',
                                        child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text('View Details')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'answers',
                                        child: Row(children: [Icon(Icons.assignment_turned_in_outlined, size: 16), SizedBox(width: 8), Text('View Answers')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'download',
                                        child: Row(children: [Icon(Icons.download_rounded, size: 16), SizedBox(width: 8), Text('Download Report')]),
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
              onTap: () => context.go(RouteNames.onlineExamCreatePath),
              child: Text(
                'Online Exam',
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
              'Exam Marks',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Online Exam Marks',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'View and analyze online examination results',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'Export Results',
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
