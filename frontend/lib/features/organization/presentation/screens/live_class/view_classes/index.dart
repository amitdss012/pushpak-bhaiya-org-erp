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

class ViewLiveClassesScreen extends StatefulWidget {
  const ViewLiveClassesScreen({super.key});

  @override
  State<ViewLiveClassesScreen> createState() => _ViewLiveClassesScreenState();
}

class _ViewLiveClassesScreenState extends State<ViewLiveClassesScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _classesData = [
    {
      'id': '1',
      'title': 'Introduction to Algorithms',
      'subject': 'Computer Science',
      'instructor': 'Dr. John Smith',
      'course': 'Computer Science',
      'batch': '2024-A',
      'date': '2024-01-30',
      'time': '10:00 AM',
      'duration': '1 hour',
      'platform': 'Zoom',
      'attendees': 42,
      'totalStudents': 45,
      'status': 'active',
    },
    {
      'id': '2',
      'title': 'Organic Chemistry Basics',
      'subject': 'Chemistry',
      'instructor': 'Prof. Sarah Johnson',
      'course': 'Science',
      'batch': '2024-B',
      'date': '2024-01-30',
      'time': '2:00 PM',
      'duration': '1.5 hours',
      'platform': 'Google Meet',
      'attendees': 0,
      'totalStudents': 38,
      'status': 'scheduled',
    },
    {
      'id': '3',
      'title': 'Financial Accounting',
      'subject': 'Accounting',
      'instructor': 'Mr. Michael Brown',
      'course': 'Commerce',
      'batch': '2024-A',
      'date': '2024-01-29',
      'time': '11:00 AM',
      'duration': '1 hour',
      'platform': 'Zoom',
      'attendees': 35,
      'totalStudents': 40,
      'status': 'completed',
    },
    {
      'id': '4',
      'title': 'English Literature',
      'subject': 'English',
      'instructor': 'Ms. Emily Davis',
      'course': 'Arts',
      'batch': '2024-C',
      'date': '2024-01-31',
      'time': '3:00 PM',
      'duration': '1 hour',
      'platform': 'Microsoft Teams',
      'attendees': 0,
      'totalStudents': 32,
      'status': 'scheduled',
    },
    {
      'id': '5',
      'title': 'Physics Lab Session',
      'subject': 'Physics',
      'instructor': 'Dr. Robert Wilson',
      'course': 'Science',
      'batch': '2024-A',
      'date': '2024-01-28',
      'time': '9:00 AM',
      'duration': '2 hours',
      'platform': 'Zoom',
      'attendees': 28,
      'totalStudents': 30,
      'status': 'completed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isTablet = context.isTablet;

    final filteredClasses = _classesData.where((c) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final title = (c['title'] as String).toLowerCase();
      final subject = (c['subject'] as String).toLowerCase();
      final instructor = (c['instructor'] as String).toLowerCase();
      final batch = (c['batch'] as String).toLowerCase();
      return title.contains(q) || subject.contains(q) || instructor.contains(q) || batch.contains(q);
    }).toList();

    final liveCount = _classesData.where((c) => c['status'] == 'active').length;
    final upcomingCount = _classesData.where((c) => c['status'] == 'scheduled').length;

    // Stats Cards
    final card1 = const OrgStatsCard(
      title: 'Total Classes',
      value: '24',
      subtitle: 'This month',
      icon: Icons.video_camera_front_outlined,
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = OrgStatsCard(
      title: 'Live Now',
      value: liveCount.toString(),
      subtitle: 'In progress',
      icon: Icons.play_circle_outline_rounded,
      variant: OrgStatsCardVariant.success,
    );
    final card3 = OrgStatsCard(
      title: 'Upcoming',
      value: upcomingCount.toString(),
      subtitle: 'Scheduled',
      icon: Icons.calendar_today_rounded,
      variant: OrgStatsCardVariant.info,
    );
    final card4 = const OrgStatsCard(
      title: 'Avg. Attendance',
      value: '87%',
      subtitle: 'This week',
      icon: Icons.groups_outlined,
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

          // Classes Table Card (Full Width)
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
                        'Class Schedule',
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
                              hintText: 'Search classes...',
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
                            _buildDataColumn('CLASS', isDark),
                            _buildDataColumn('INSTRUCTOR', isDark),
                            _buildDataColumn('BATCH', isDark),
                            _buildDataColumn('SCHEDULE', isDark),
                            _buildDataColumn('PLATFORM', isDark),
                            _buildDataColumn('ATTENDANCE', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredClasses.map((liveClass) {
                            final title = liveClass['title'] as String;
                            final subject = liveClass['subject'] as String;
                            final instructor = liveClass['instructor'] as String;
                            final course = liveClass['course'] as String;
                            final batch = liveClass['batch'] as String;
                            final date = liveClass['date'] as String;
                            final time = liveClass['time'] as String;
                            final duration = liveClass['duration'] as String;
                            final platform = liveClass['platform'] as String;
                            final attendees = liveClass['attendees'] as int;
                            final total = liveClass['totalStudents'] as int;
                            final status = liveClass['status'] as String;

                            AppBadgeStatus badgeStatus;
                            switch (status) {
                              case 'active':
                                badgeStatus = AppBadgeStatus.active;
                                break;
                              case 'completed':
                                badgeStatus = AppBadgeStatus.completed;
                                break;
                              case 'cancelled':
                                badgeStatus = AppBadgeStatus.danger;
                                break;
                              default:
                                badgeStatus = AppBadgeStatus.pending;
                            }

                            return DataRow(
                              cells: [
                                // Class
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(title, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                      Text(
                                        subject,
                                        style: AppTypography.bodySmall.copyWith(
                                          fontSize: 11,
                                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Instructor
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundColor: AppColors.primary.withAlpha(25),
                                        child: Text(
                                          instructor.split(' ').last.substring(0, 1),
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 11),
                                        ),
                                      ),
                                      AppSpacing.hSm,
                                      Text(instructor, style: AppTypography.bodySmall),
                                    ],
                                  ),
                                ),

                                // Batch
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(batch, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500)),
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

                                // Schedule
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.calendar_today_rounded, size: 14, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                      AppSpacing.hXs,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(date, style: AppTypography.bodySmall),
                                          Text(
                                            '$time ($duration)',
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

                                // Platform
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                      borderRadius: AppRadius.sm,
                                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                    ),
                                    child: Text(platform, style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w600)),
                                  ),
                                ),

                                // Attendance
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.people_outline_rounded, size: 14, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                      AppSpacing.hXs,
                                      Text('$attendees/$total', style: AppTypography.bodySmall),
                                    ],
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
                                      if (action == 'join') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Launching $platform for $title...'), backgroundColor: AppColors.success),
                                        );
                                      }
                                      if (action == 'view') {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Viewing class details for $title...')));
                                      }
                                      if (action == 'edit') {
                                        context.go(RouteNames.liveClassSetupPath);
                                      }
                                      if (action == 'recording') {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opening recording for $title...')));
                                      }
                                      if (action == 'attendance') {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloading attendance report for $title...')));
                                      }
                                      if (action == 'cancel') {
                                        setState(() => liveClass['status'] = 'cancelled');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Cancelled $title.'), backgroundColor: AppColors.error),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) {
                                      final items = <PopupMenuEntry<String>>[
                                        const PopupMenuItem(
                                          value: 'view',
                                          child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text('View Details')]),
                                        ),
                                      ];

                                      if (status == 'active') {
                                        items.insert(
                                          0,
                                          const PopupMenuItem(
                                            value: 'join',
                                            child: Row(children: [Icon(Icons.videocam_rounded, size: 16, color: AppColors.success), SizedBox(width: 8), Text('Join Class', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold))]),
                                          ),
                                        );
                                      }
                                      if (status == 'scheduled') {
                                        items.add(
                                          const PopupMenuItem(
                                            value: 'edit',
                                            child: Row(children: [Icon(Icons.edit_outlined, size: 16), SizedBox(width: 8), Text('Edit')]),
                                          ),
                                        );
                                        items.add(
                                          const PopupMenuItem(
                                            value: 'cancel',
                                            child: Row(children: [Icon(Icons.cancel_outlined, size: 16, color: AppColors.error), SizedBox(width: 8), Text('Cancel', style: TextStyle(color: AppColors.error))]),
                                          ),
                                        );
                                      }
                                      if (status == 'completed') {
                                        items.add(
                                          const PopupMenuItem(
                                            value: 'recording',
                                            child: Row(children: [Icon(Icons.play_circle_outline_rounded, size: 16), SizedBox(width: 8), Text('View Recording')]),
                                          ),
                                        );
                                        items.add(
                                          const PopupMenuItem(
                                            value: 'attendance',
                                            child: Row(children: [Icon(Icons.assignment_turned_in_outlined, size: 16), SizedBox(width: 8), Text('Attendance Report')]),
                                          ),
                                        );
                                      }

                                      return items;
                                    },
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
              onTap: () => context.go(RouteNames.liveClassViewPath),
              child: Text(
                'Live Class',
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
              'View Classes',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Live Classes',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'View and manage live class sessions',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'Schedule Class',
      icon: Icons.add_rounded,
      onPressed: () => context.go(RouteNames.liveClassSetupPath),
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
