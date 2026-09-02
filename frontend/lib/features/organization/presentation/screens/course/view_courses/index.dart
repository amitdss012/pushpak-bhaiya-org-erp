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

class ViewCoursesScreen extends StatefulWidget {
  const ViewCoursesScreen({super.key});

  @override
  State<ViewCoursesScreen> createState() => _ViewCoursesScreenState();
}

class _ViewCoursesScreenState extends State<ViewCoursesScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _coursesData = [
    {
      'id': '1',
      'name': 'Computer Science',
      'code': 'CS101',
      'duration': '4 Years',
      'fee': 50000,
      'batches': 3,
      'students': 120,
      'department': 'Science',
      'status': 'active',
    },
    {
      'id': '2',
      'name': 'Commerce',
      'code': 'COM101',
      'duration': '3 Years',
      'fee': 45000,
      'batches': 2,
      'students': 85,
      'department': 'Commerce',
      'status': 'active',
    },
    {
      'id': '3',
      'name': 'Arts',
      'code': 'ART101',
      'duration': '3 Years',
      'fee': 35000,
      'batches': 2,
      'students': 65,
      'department': 'Arts',
      'status': 'active',
    },
    {
      'id': '4',
      'name': 'Science',
      'code': 'SCI101',
      'duration': '2 Years',
      'fee': 40000,
      'batches': 4,
      'students': 150,
      'department': 'Science',
      'status': 'active',
    },
    {
      'id': '5',
      'name': 'Engineering',
      'code': 'ENG101',
      'duration': '4 Years',
      'fee': 75000,
      'batches': 5,
      'students': 200,
      'department': 'Engineering',
      'status': 'active',
    },
    {
      'id': '6',
      'name': 'Medical',
      'code': 'MED101',
      'duration': '5 Years',
      'fee': 100000,
      'batches': 2,
      'students': 50,
      'department': 'Medical',
      'status': 'inactive',
    },
  ];

  void _showCourseDetails(Map<String, dynamic> course) {
    final isDark = context.isDarkMode;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Course Details',
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                AppSpacing.vMd,
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDark.withAlpha(120) : AppColors.backgroundLight,
                    borderRadius: AppRadius.md,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(25),
                          borderRadius: AppRadius.sm,
                        ),
                        child: const Center(
                          child: Icon(Icons.menu_book_rounded, color: AppColors.primary),
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course['name'] as String,
                              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Code: ${course['code']} • ${course['department']}',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.vLg,
                Row(
                  children: [
                    Expanded(child: _buildDetailField('Duration', course['duration'] as String, isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildDetailField('Annual Fee', '₹${(course['fee'] as int).toLocaleString()}', isDark)),
                  ],
                ),
                AppSpacing.vMd,
                Row(
                  children: [
                    Expanded(child: _buildDetailField('Active Batches', '${course['batches']} Batches', isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildDetailField('Enrolled Students', '${course['students']} Enrolled', isDark)),
                  ],
                ),
                AppSpacing.vLg,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: 'Edit Course',
                      variant: AppButtonVariant.outline,
                      icon: Icons.edit_outlined,
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.go(RouteNames.courseCreatePath);
                      },
                    ),
                    AppSpacing.hSm,
                    AppButton(
                      text: 'Manage Batches',
                      icon: Icons.groups_outlined,
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.go(RouteNames.courseBatchCreatePath);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelMedium.copyWith(
            fontSize: 10,
            letterSpacing: 0.5,
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            fontWeight: FontWeight.w700,
          ),
        ),
        AppSpacing.vXs,
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isTablet = context.isTablet;

    final filteredCourses = _coursesData.where((c) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (c['name'] as String).toLowerCase();
      final code = (c['code'] as String).toLowerCase();
      final dept = (c['department'] as String).toLowerCase();
      return name.contains(q) || code.contains(q) || dept.contains(q);
    }).toList();

    final totalStudents = _coursesData.fold<int>(0, (sum, c) => sum + (c['students'] as int));
    final totalBatches = _coursesData.fold<int>(0, (sum, c) => sum + (c['batches'] as int));

    // Stats Cards
    final card1 = OrgStatsCard(
      title: 'Total Courses',
      value: _coursesData.length.toString(),
      subtitle: 'Across all departments',
      icon: Icons.menu_book_rounded,
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = OrgStatsCard(
      title: 'Active Courses',
      value: _coursesData.where((c) => c['status'] == 'active').length.toString(),
      subtitle: 'Currently offering',
      icon: Icons.check_circle_outline_rounded,
      variant: OrgStatsCardVariant.success,
    );
    final card3 = OrgStatsCard(
      title: 'Total Batches',
      value: totalBatches.toString(),
      subtitle: 'Active & scheduled',
      icon: Icons.groups_outlined,
      variant: OrgStatsCardVariant.info,
    );
    final card4 = OrgStatsCard(
      title: 'Enrolled Students',
      value: totalStudents.toString(),
      subtitle: 'All courses',
      icon: Icons.school_outlined,
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

          // Courses Table Card (Full Width)
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
                        'All Courses',
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
                              hintText: 'Search courses...',
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
                            _buildDataColumn('COURSE NAME', isDark),
                            _buildDataColumn('DURATION', isDark),
                            _buildDataColumn('FEE', isDark),
                            _buildDataColumn('BATCHES', isDark),
                            _buildDataColumn('STUDENTS', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredCourses.map((course) {
                            final name = course['name'] as String;
                            final code = course['code'] as String;
                            final duration = course['duration'] as String;
                            final fee = course['fee'] as int;
                            final batches = course['batches'] as int;
                            final students = course['students'] as int;
                            final status = course['status'] as String;

                            final isActive = status == 'active';

                            return DataRow(
                              cells: [
                                // Course Name + Code with Avatar
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
                                          Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                          Text(
                                            code,
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

                                // Duration
                                DataCell(Text(duration, style: AppTypography.bodySmall)),

                                // Fee
                                DataCell(
                                  Text(
                                    '₹${fee.toLocaleString()}',
                                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),

                                // Batches
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                      borderRadius: AppRadius.full,
                                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                    ),
                                    child: Text(
                                      '$batches batches',
                                      style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),

                                // Students
                                DataCell(
                                  Text(
                                    '$students enrolled',
                                    style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                  ),
                                ),

                                // Status
                                DataCell(
                                  AppStatusBadge(
                                    status: isActive ? AppBadgeStatus.active : AppBadgeStatus.danger,
                                    customLabel: isActive ? 'Active' : 'Inactive',
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
                                      if (action == 'view') _showCourseDetails(course);
                                      if (action == 'edit') context.go(RouteNames.courseCreatePath);
                                      if (action == 'batches') context.go(RouteNames.courseBatchCreatePath);
                                      if (action == 'delete') {
                                        setState(() => _coursesData.remove(course));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Course "$name" deleted.'),
                                            backgroundColor: AppColors.error,
                                          ),
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
                                        child: Row(children: [Icon(Icons.edit_outlined, size: 16), SizedBox(width: 8), Text('Edit Course')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'batches',
                                        child: Row(children: [Icon(Icons.groups_outlined, size: 16), SizedBox(width: 8), Text('Manage Batches')]),
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
              'View Courses',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'View Courses',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Manage all courses and their details',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'Create Course',
      icon: Icons.add_rounded,
      onPressed: () => context.go(RouteNames.courseCreatePath),
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

extension IntExt on int {
  String toLocaleString() {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
