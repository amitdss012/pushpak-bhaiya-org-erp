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

class ViewStudentsScreen extends StatefulWidget {
  const ViewStudentsScreen({super.key});

  @override
  State<ViewStudentsScreen> createState() => _ViewStudentsScreenState();
}

class _ViewStudentsScreenState extends State<ViewStudentsScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _studentsData = [
    {
      'id': '1',
      'name': 'John Doe',
      'rollNo': 'STU001',
      'email': 'john.doe@email.com',
      'phone': '+91 98765 43210',
      'course': 'Computer Science',
      'batch': '2024-A',
      'status': 'active',
      'admissionDate': '2024-01-15',
    },
    {
      'id': '2',
      'name': 'Sarah Smith',
      'rollNo': 'STU002',
      'email': 'sarah.smith@email.com',
      'phone': '+91 98765 43211',
      'course': 'Commerce',
      'batch': '2024-B',
      'status': 'active',
      'admissionDate': '2024-01-18',
    },
    {
      'id': '3',
      'name': 'Mike Johnson',
      'rollNo': 'STU003',
      'email': 'mike.j@email.com',
      'phone': '+91 98765 43212',
      'course': 'Arts',
      'batch': '2024-A',
      'status': 'pending',
      'admissionDate': '2024-01-20',
    },
    {
      'id': '4',
      'name': 'Emily Brown',
      'rollNo': 'STU004',
      'email': 'emily.b@email.com',
      'phone': '+91 98765 43213',
      'course': 'Science',
      'batch': '2024-C',
      'status': 'active',
      'admissionDate': '2024-01-22',
    },
    {
      'id': '5',
      'name': 'David Wilson',
      'rollNo': 'STU005',
      'email': 'david.w@email.com',
      'phone': '+91 98765 43214',
      'course': 'Engineering',
      'batch': '2024-A',
      'status': 'inactive',
      'admissionDate': '2024-01-10',
    },
    {
      'id': '6',
      'name': 'Lisa Anderson',
      'rollNo': 'STU006',
      'email': 'lisa.a@email.com',
      'phone': '+91 98765 43215',
      'course': 'Medical',
      'batch': '2024-B',
      'status': 'active',
      'admissionDate': '2024-01-25',
    },
    {
      'id': '7',
      'name': 'James Taylor',
      'rollNo': 'STU007',
      'email': 'james.t@email.com',
      'phone': '+91 98765 43216',
      'course': 'Computer Science',
      'batch': '2024-C',
      'status': 'active',
      'admissionDate': '2024-01-28',
    },
    {
      'id': '8',
      'name': 'Emma Martinez',
      'rollNo': 'STU008',
      'email': 'emma.m@email.com',
      'phone': '+91 98765 43217',
      'course': 'Commerce',
      'batch': '2024-A',
      'status': 'pending',
      'admissionDate': '2024-02-01',
    },
  ];

  void _showStudentDetails(Map<String, dynamic> student) {
    final isDark = context.isDarkMode;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
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
                      'Student Profile',
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
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primary.withAlpha(30),
                        child: Text(
                          (student['name'] as String).substring(0, 1),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student['name'] as String,
                              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Roll No: ${student['rollNo']} • ${student['course']}',
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
                    Expanded(child: _buildDetailField('Email', student['email'] as String, isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildDetailField('Phone', student['phone'] as String, isDark)),
                  ],
                ),
                AppSpacing.vMd,
                Row(
                  children: [
                    Expanded(child: _buildDetailField('Batch', student['batch'] as String, isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildDetailField('Admission Date', student['admissionDate'] as String, isDark)),
                  ],
                ),
                AppSpacing.vLg,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: 'Fee Details',
                      variant: AppButtonVariant.outline,
                      icon: Icons.receipt_long_outlined,
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Viewing fee details for ${student['name']}...')),
                        );
                      },
                    ),
                    AppSpacing.hSm,
                    AppButton(
                      text: 'Edit Profile',
                      icon: Icons.edit_outlined,
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.go(RouteNames.studentAdmissionFormPath);
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

    final filteredStudents = _studentsData.where((s) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (s['name'] as String).toLowerCase();
      final roll = (s['rollNo'] as String).toLowerCase();
      final course = (s['course'] as String).toLowerCase();
      final email = (s['email'] as String).toLowerCase();
      return name.contains(q) || roll.contains(q) || course.contains(q) || email.contains(q);
    }).toList();

    // Stats Cards
    final card1 = OrgStatsCard(
      title: 'Total Students',
      value: _studentsData.length.toString(),
      subtitle: 'Enrolled in system',
      icon: Icons.school_rounded,
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = OrgStatsCard(
      title: 'Active Students',
      value: _studentsData.where((s) => s['status'] == 'active').length.toString(),
      subtitle: 'Regular attendance',
      icon: Icons.check_circle_outline_rounded,
      variant: OrgStatsCardVariant.success,
    );
    final card3 = OrgStatsCard(
      title: 'Pending Verification',
      value: _studentsData.where((s) => s['status'] == 'pending').length.toString(),
      subtitle: 'Awaiting docs',
      icon: Icons.access_time_rounded,
      variant: OrgStatsCardVariant.warning,
    );
    final card4 = const OrgStatsCard(
      title: 'Total Batches',
      value: '4',
      subtitle: 'Active batches',
      icon: Icons.groups_outlined,
      variant: OrgStatsCardVariant.info,
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

          // Students Table Card (Full Width)
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
                        'Enrolled Students',
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
                          columnSpacing: 24,
                          headingRowColor: WidgetStateProperty.all(
                            isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight.withAlpha(120),
                          ),
                          columns: [
                            _buildDataColumn('STUDENT', isDark),
                            _buildDataColumn('CONTACT', isDark),
                            _buildDataColumn('COURSE', isDark),
                            _buildDataColumn('BATCH', isDark),
                            _buildDataColumn('ADMISSION DATE', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredStudents.map((student) {
                            final name = student['name'] as String;
                            final rollNo = student['rollNo'] as String;
                            final email = student['email'] as String;
                            final phone = student['phone'] as String;
                            final course = student['course'] as String;
                            final batch = student['batch'] as String;
                            final admissionDate = student['admissionDate'] as String;
                            final status = student['status'] as String;

                            AppBadgeStatus badgeStatus;
                            switch (status) {
                              case 'active':
                                badgeStatus = AppBadgeStatus.active;
                                break;
                              case 'pending':
                                badgeStatus = AppBadgeStatus.pending;
                                break;
                              case 'inactive':
                                badgeStatus = AppBadgeStatus.danger;
                                break;
                              default:
                                badgeStatus = AppBadgeStatus.info;
                            }

                            return DataRow(
                              cells: [
                                // Student (Avatar + Name + Roll)
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

                                // Contact
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(email, style: AppTypography.bodySmall),
                                      Text(
                                        phone,
                                        style: AppTypography.bodySmall.copyWith(
                                          fontSize: 11,
                                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Course
                                DataCell(Text(course, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500))),

                                // Batch
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                      borderRadius: AppRadius.full,
                                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                    ),
                                    child: Text(
                                      batch,
                                      style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),

                                // Admission Date
                                DataCell(Text(admissionDate, style: AppTypography.bodySmall)),

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
                                      if (action == 'view') _showStudentDetails(student);
                                      if (action == 'edit') context.go(RouteNames.studentAdmissionFormPath);
                                      if (action == 'fee') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Opening fee ledger for $name...')),
                                        );
                                      }
                                      if (action == 'delete') {
                                        setState(() => _studentsData.remove(student));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Student "$name" deleted.'),
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
                                        child: Row(children: [Icon(Icons.edit_outlined, size: 16), SizedBox(width: 8), Text('Edit Student')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'fee',
                                        child: Row(children: [Icon(Icons.receipt_long_outlined, size: 16), SizedBox(width: 8), Text('Fee Details')]),
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
              onTap: () => context.go(RouteNames.studentViewPath),
              child: Text(
                'Student Management',
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
              'View Students',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'View Students',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Manage and view all enrolled students',
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
          text: 'Import',
          icon: Icons.upload_file_rounded,
          variant: AppButtonVariant.outline,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Importing student records...')),
            );
          },
          height: 38,
        ),
        AppSpacing.hSm,
        AppButton(
          text: 'Export',
          icon: Icons.download_rounded,
          variant: AppButtonVariant.outline,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Exporting student directory CSV...')),
            );
          },
          height: 38,
        ),
        AppSpacing.hSm,
        AppButton(
          text: 'Add Student',
          icon: Icons.add_rounded,
          onPressed: () => context.go(RouteNames.studentAdmissionFormPath),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: actionButtons,
          ),
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
