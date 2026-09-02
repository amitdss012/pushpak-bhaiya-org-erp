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

class QuestionPaperBuilderScreen extends StatefulWidget {
  const QuestionPaperBuilderScreen({super.key});

  @override
  State<QuestionPaperBuilderScreen> createState() => _QuestionPaperBuilderScreenState();
}

class _QuestionPaperBuilderScreenState extends State<QuestionPaperBuilderScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _papersData = [
    {
      'id': '1',
      'paperCode': 'QP-2024-CS-001',
      'title': 'Mid-Term Computer Science',
      'course': 'Computer Science',
      'totalQuestions': 50,
      'totalMarks': 100,
      'duration': '2 hours',
      'createdDate': '2024-01-15',
      'status': 'published',
    },
    {
      'id': '2',
      'paperCode': 'QP-2024-PHY-001',
      'title': 'Physics Unit Test',
      'course': 'Science',
      'totalQuestions': 30,
      'totalMarks': 50,
      'duration': '1 hour',
      'createdDate': '2024-01-18',
      'status': 'published',
    },
    {
      'id': '3',
      'paperCode': 'QP-2024-MATH-001',
      'title': 'Mathematics Final Exam',
      'course': 'Commerce',
      'totalQuestions': 60,
      'totalMarks': 100,
      'duration': '3 hours',
      'createdDate': '2024-01-20',
      'status': 'draft',
    },
    {
      'id': '4',
      'paperCode': 'QP-2024-ENG-001',
      'title': 'English Comprehension',
      'course': 'Arts',
      'totalQuestions': 40,
      'totalMarks': 80,
      'duration': '1.5 hours',
      'createdDate': '2024-01-22',
      'status': 'draft',
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'published':
        return AppColors.success;
      case 'draft':
        return AppColors.warning;
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

    final filteredPapers = _papersData.where((p) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final code = (p['paperCode'] as String).toLowerCase();
      final title = (p['title'] as String).toLowerCase();
      final course = (p['course'] as String).toLowerCase();
      return code.contains(q) || title.contains(q) || course.contains(q);
    }).toList();

    // Stats Cards
    final card1 = const OrgStatsCard(
      title: 'Total Papers',
      value: '12',
      subtitle: 'Created this year',
      icon: Icons.description_outlined,
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = const OrgStatsCard(
      title: 'Questions Bank',
      value: '450',
      subtitle: 'Available questions',
      icon: Icons.help_outline_rounded,
      variant: OrgStatsCardVariant.info,
    );
    final card3 = const OrgStatsCard(
      title: 'MCQ Questions',
      value: '320',
      subtitle: 'Multiple choice',
      icon: Icons.check_box_outlined,
      variant: OrgStatsCardVariant.success,
    );
    final card4 = const OrgStatsCard(
      title: 'Descriptive',
      value: '130',
      subtitle: 'Long answer',
      icon: Icons.format_list_numbered_rounded,
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

          // Question Papers Table Card (Full Width)
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
                        'Question Papers',
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
                              hintText: 'Search question papers...',
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
                            _buildDataColumn('PAPER CODE', isDark),
                            _buildDataColumn('COURSE', isDark),
                            _buildDataColumn('QUESTIONS', isDark),
                            _buildDataColumn('TOTAL MARKS', isDark),
                            _buildDataColumn('DURATION', isDark),
                            _buildDataColumn('CREATED', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredPapers.map((paper) {
                            final code = paper['paperCode'] as String;
                            final title = paper['title'] as String;
                            final course = paper['course'] as String;
                            final questions = paper['totalQuestions'] as int;
                            final marks = paper['totalMarks'] as int;
                            final duration = paper['duration'] as String;
                            final created = paper['createdDate'] as String;
                            final status = paper['status'] as String;

                            final color = _getStatusColor(status);

                            return DataRow(
                              cells: [
                                // Paper Code & Title
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(code, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                      Text(
                                        title,
                                        style: AppTypography.bodySmall.copyWith(
                                          fontSize: 11,
                                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                DataCell(Text(course, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500))),

                                // Questions count
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.help_outline_rounded, size: 14, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                      AppSpacing.hXs,
                                      Text(questions.toString(), style: AppTypography.bodySmall),
                                    ],
                                  ),
                                ),

                                // Total Marks
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                      borderRadius: AppRadius.sm,
                                    ),
                                    child: Text(
                                      '$marks marks',
                                      style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),

                                DataCell(Text(duration, style: AppTypography.bodySmall)),
                                DataCell(Text(created, style: AppTypography.bodySmall)),

                                // Status Badge
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: color.withAlpha(20),
                                      borderRadius: AppRadius.sm,
                                      border: Border.all(color: color.withAlpha(60)),
                                    ),
                                    child: Text(
                                      status.toUpperCase(),
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: color,
                                      ),
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
                                      if (action == 'edit') {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Editing $code...')));
                                      }
                                      if (action == 'add') {
                                        context.go(RouteNames.onlineExamAddQuestionsPath);
                                      }
                                      if (action == 'preview') {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Previewing question paper for $code...')));
                                      }
                                      if (action == 'duplicate') {
                                        setState(() {
                                          _papersData.add({
                                            ...paper,
                                            'id': DateTime.now().millisecondsSinceEpoch.toString(),
                                            'paperCode': '${code}_COPY',
                                            'status': 'draft',
                                          });
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Duplicated $code.')));
                                      }
                                      if (action == 'delete') {
                                        setState(() => _papersData.remove(paper));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Deleted $code.'), backgroundColor: AppColors.error),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Row(children: [Icon(Icons.edit_outlined, size: 16), SizedBox(width: 8), Text('Edit Paper')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'add',
                                        child: Row(children: [Icon(Icons.add_circle_outline, size: 16), SizedBox(width: 8), Text('Add Questions')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'preview',
                                        child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text('Preview')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'duplicate',
                                        child: Row(children: [Icon(Icons.copy_rounded, size: 16), SizedBox(width: 8), Text('Duplicate')]),
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
              'Question Paper Builder',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Question Paper Builder',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Create and manage question papers for online exams',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'New Question Paper',
      icon: Icons.add_rounded,
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Creating new question paper template...')));
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
