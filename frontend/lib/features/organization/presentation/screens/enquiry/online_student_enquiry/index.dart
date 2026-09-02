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
import '../../../../../../shared/widgets/app_text_field.dart';
import '../../../widgets/org_stats_card.dart';

class OnlineStudentEnquiryScreen extends StatefulWidget {
  const OnlineStudentEnquiryScreen({super.key});

  @override
  State<OnlineStudentEnquiryScreen> createState() => _OnlineStudentEnquiryScreenState();
}

class _OnlineStudentEnquiryScreenState extends State<OnlineStudentEnquiryScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _enquiriesData = [
    {
      'id': '1',
      'date': '2024-01-15',
      'name': 'Arjun Mehta',
      'phone': '+91 98765 43210',
      'email': 'arjun@example.com',
      'currentClass': '10th',
      'applyingFor': '11th Science',
      'parentName': 'Rajesh Mehta',
      'parentPhone': '+91 98765 43211',
      'city': 'Mumbai',
      'preferredBranch': 'Main Campus',
      'status': 'new',
    },
    {
      'id': '2',
      'date': '2024-01-15',
      'name': 'Kavya Nair',
      'phone': '+91 87654 32109',
      'email': 'kavya@example.com',
      'currentClass': '12th',
      'applyingFor': 'B.Tech CSE',
      'parentName': 'Suresh Nair',
      'parentPhone': '+91 87654 32110',
      'city': 'Pune',
      'preferredBranch': 'North Campus',
      'status': 'contacted',
    },
    {
      'id': '3',
      'date': '2024-01-14',
      'name': 'Rohan Desai',
      'phone': '+91 76543 21098',
      'email': 'rohan@example.com',
      'currentClass': '9th',
      'applyingFor': '10th',
      'parentName': 'Mahesh Desai',
      'parentPhone': '+91 76543 21099',
      'city': 'Delhi',
      'preferredBranch': 'Main Campus',
      'status': 'scheduled',
    },
    {
      'id': '4',
      'date': '2024-01-14',
      'name': 'Ishika Kapoor',
      'phone': '+91 65432 10987',
      'email': 'ishika@example.com',
      'currentClass': '12th',
      'applyingFor': 'BBA',
      'parentName': 'Vinod Kapoor',
      'parentPhone': '+91 65432 10988',
      'city': 'Bangalore',
      'preferredBranch': 'South Campus',
      'status': 'visited',
    },
    {
      'id': '5',
      'date': '2024-01-13',
      'name': 'Aditya Rao',
      'phone': '+91 54321 09876',
      'email': 'aditya@example.com',
      'currentClass': 'Graduate',
      'applyingFor': 'MBA',
      'parentName': 'Krishna Rao',
      'parentPhone': '+91 54321 09877',
      'city': 'Hyderabad',
      'preferredBranch': 'Main Campus',
      'status': 'applied',
    },
  ];

  void _showStudentDetails(Map<String, dynamic> enquiry) {
    final isDark = context.isDarkMode;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Student Enquiry Details',
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
                            (enquiry['name'] as String).substring(0, 2).toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ),
                        AppSpacing.hMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                enquiry['name'] as String,
                                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                '${enquiry['phone']} • ${enquiry['email']}',
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
                      Expanded(child: _buildDetailField('Current Class', enquiry['currentClass'] as String, isDark)),
                      AppSpacing.hMd,
                      Expanded(child: _buildDetailField('Applying For', enquiry['applyingFor'] as String, isDark)),
                    ],
                  ),
                  AppSpacing.vMd,
                  Row(
                    children: [
                      Expanded(child: _buildDetailField('Parent Name', enquiry['parentName'] as String, isDark)),
                      AppSpacing.hMd,
                      Expanded(child: _buildDetailField('Parent Phone', enquiry['parentPhone'] as String, isDark)),
                    ],
                  ),
                  AppSpacing.vMd,
                  Row(
                    children: [
                      Expanded(child: _buildDetailField('Preferred Branch', enquiry['preferredBranch'] as String, isDark)),
                      AppSpacing.hMd,
                      Expanded(child: _buildDetailField('City', enquiry['city'] as String, isDark)),
                    ],
                  ),
                  AppSpacing.vLg,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton(
                        text: 'Schedule Visit',
                        icon: Icons.calendar_today_rounded,
                        variant: AppButtonVariant.outline,
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _showScheduleVisitDialog(enquiry);
                        },
                      ),
                      AppSpacing.hSm,
                      AppButton(
                        text: 'Convert to Application',
                        icon: Icons.check_circle_outline_rounded,
                        onPressed: () {
                          setState(() => enquiry['status'] = 'applied');
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${enquiry['name']} converted to application!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showScheduleVisitDialog(Map<String, dynamic> enquiry) {
    final isDark = context.isDarkMode;
    final dateController = TextEditingController(text: '2024-01-20');
    final timeController = TextEditingController(text: '10:30 AM');

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
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
                      'Schedule Campus Visit',
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
                AppSpacing.vSm,
                Text(
                  'Schedule visit for ${enquiry['name']}',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                AppSpacing.vLg,
                AppTextField(
                  controller: dateController,
                  label: 'Visit Date',
                  hint: 'YYYY-MM-DD',
                  suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                ),
                AppSpacing.vMd,
                AppTextField(
                  controller: timeController,
                  label: 'Visit Time',
                  hint: 'HH:MM AM/PM',
                  suffixIcon: const Icon(Icons.access_time_rounded, size: 18),
                ),
                AppSpacing.vLg,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: 'Cancel',
                      variant: AppButtonVariant.outline,
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                    AppSpacing.hSm,
                    AppButton(
                      text: 'Confirm Schedule',
                      icon: Icons.check_rounded,
                      onPressed: () {
                        setState(() => enquiry['status'] = 'scheduled');
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Visit scheduled for ${enquiry['name']} on ${dateController.text} at ${timeController.text}!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
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

    final filteredEnquiries = _enquiriesData.where((e) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (e['name'] as String).toLowerCase();
      final currentClass = (e['currentClass'] as String).toLowerCase();
      final applying = (e['applyingFor'] as String).toLowerCase();
      final parent = (e['parentName'] as String).toLowerCase();
      final branch = (e['preferredBranch'] as String).toLowerCase();
      final city = (e['city'] as String).toLowerCase();
      return name.contains(q) || currentClass.contains(q) || applying.contains(q) || parent.contains(q) || branch.contains(q) || city.contains(q);
    }).toList();

    final statusCounts = {
      'new': _enquiriesData.where((e) => e['status'] == 'new').length,
      'contacted': _enquiriesData.where((e) => e['status'] == 'contacted').length,
      'scheduled': _enquiriesData.where((e) => e['status'] == 'scheduled').length,
      'visited': _enquiriesData.where((e) => e['status'] == 'visited').length,
      'applied': _enquiriesData.where((e) => e['status'] == 'applied').length,
    };

    // Top Stats Cards
    final card1 = OrgStatsCard(
      title: 'Total Enquiries',
      value: _enquiriesData.length.toString(),
      subtitle: 'This month',
      icon: Icons.school_rounded,
      trend: const OrgStatsCardTrend(value: 18, isPositive: true),
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = OrgStatsCard(
      title: 'New Leads',
      value: statusCounts['new'].toString(),
      subtitle: 'Pending contact',
      icon: Icons.group_outlined,
      variant: OrgStatsCardVariant.info,
    );
    final card3 = OrgStatsCard(
      title: 'Visits Scheduled',
      value: statusCounts['scheduled'].toString(),
      subtitle: 'This week',
      icon: Icons.access_time_rounded,
      variant: OrgStatsCardVariant.warning,
    );
    final card4 = const OrgStatsCard(
      title: 'Conversion Rate',
      value: '32%',
      subtitle: 'Enquiry to application',
      icon: Icons.trending_up_rounded,
      trend: OrgStatsCardTrend(value: 5, isPositive: true),
      variant: OrgStatsCardVariant.success,
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

          AppSpacing.vLg,

          // 5 Status Counter Mini-Cards
          if (isDesktop)
            Row(
              children: [
                Expanded(child: _buildStatusCountCard('New', statusCounts['new']!, isDark ? AppColors.textMutedDark : AppColors.textMutedLight, isDark)),
                AppSpacing.hMd,
                Expanded(child: _buildStatusCountCard('Contacted', statusCounts['contacted']!, AppColors.primary, isDark)),
                AppSpacing.hMd,
                Expanded(child: _buildStatusCountCard('Scheduled', statusCounts['scheduled']!, AppColors.warning, isDark)),
                AppSpacing.hMd,
                Expanded(child: _buildStatusCountCard('Visited', statusCounts['visited']!, AppColors.success, isDark)),
                AppSpacing.hMd,
                Expanded(child: _buildStatusCountCard('Applied', statusCounts['applied']!, AppColors.success, isDark)),
              ],
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatusCountCard('New', statusCounts['new']!, isDark ? AppColors.textMutedDark : AppColors.textMutedLight, isDark, width: 130),
                  AppSpacing.hMd,
                  _buildStatusCountCard('Contacted', statusCounts['contacted']!, AppColors.primary, isDark, width: 130),
                  AppSpacing.hMd,
                  _buildStatusCountCard('Scheduled', statusCounts['scheduled']!, AppColors.warning, isDark, width: 130),
                  AppSpacing.hMd,
                  _buildStatusCountCard('Visited', statusCounts['visited']!, AppColors.success, isDark, width: 130),
                  AppSpacing.hMd,
                  _buildStatusCountCard('Applied', statusCounts['applied']!, AppColors.success, isDark, width: 130),
                ],
              ),
            ),

          AppSpacing.vXl,

          // Student Enquiries Table Card (Full Width)
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
                        'Student Enquiries',
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
                              hintText: 'Search student enquiries...',
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
                            _buildDataColumn('DATE', isDark),
                            _buildDataColumn('STUDENT', isDark),
                            _buildDataColumn('CURRENT CLASS', isDark),
                            _buildDataColumn('APPLYING FOR', isDark),
                            _buildDataColumn('PARENT', isDark),
                            _buildDataColumn('PREFERRED BRANCH', isDark),
                            _buildDataColumn('CITY', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredEnquiries.map((enquiry) {
                            final date = enquiry['date'] as String;
                            final name = enquiry['name'] as String;
                            final email = enquiry['email'] as String;
                            final currentClass = enquiry['currentClass'] as String;
                            final applyingFor = enquiry['applyingFor'] as String;
                            final parentName = enquiry['parentName'] as String;
                            final parentPhone = enquiry['parentPhone'] as String;
                            final preferredBranch = enquiry['preferredBranch'] as String;
                            final city = enquiry['city'] as String;
                            final status = enquiry['status'] as String;

                            AppBadgeStatus badgeStatus;
                            switch (status) {
                              case 'new':
                                badgeStatus = AppBadgeStatus.info;
                                break;
                              case 'contacted':
                                badgeStatus = AppBadgeStatus.pending;
                                break;
                              case 'scheduled':
                                badgeStatus = AppBadgeStatus.active;
                                break;
                              case 'visited':
                              case 'applied':
                                badgeStatus = AppBadgeStatus.completed;
                                break;
                              default:
                                badgeStatus = AppBadgeStatus.info;
                            }

                            return DataRow(
                              cells: [
                                // Date
                                DataCell(Text(date, style: AppTypography.bodySmall)),

                                // Student
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                      Text(
                                        email,
                                        style: AppTypography.bodySmall.copyWith(
                                          fontSize: 10.5,
                                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Current Class
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                      borderRadius: AppRadius.full,
                                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                    ),
                                    child: Text(
                                      currentClass,
                                      style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),

                                // Applying For
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withAlpha(20),
                                      borderRadius: AppRadius.full,
                                    ),
                                    child: Text(
                                      applyingFor,
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),

                                // Parent
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(parentName, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500)),
                                      Text(
                                        parentPhone,
                                        style: AppTypography.bodySmall.copyWith(
                                          fontSize: 10.5,
                                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Preferred Branch
                                DataCell(Text(preferredBranch, style: AppTypography.bodySmall)),

                                // City
                                DataCell(Text(city, style: AppTypography.bodySmall)),

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
                                      if (action == 'view') _showStudentDetails(enquiry);
                                      if (action == 'schedule') _showScheduleVisitDialog(enquiry);
                                      if (action == 'info') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Information pack sent to ${enquiry['email']}!')),
                                        );
                                      }
                                      if (action == 'convert') {
                                        setState(() => enquiry['status'] = 'applied');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${enquiry['name']} converted to application!'),
                                            backgroundColor: AppColors.success,
                                          ),
                                        );
                                      }
                                      if (action == 'close') {
                                        setState(() => enquiry['status'] = 'closed');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Enquiry for ${enquiry['name']} closed.')),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'view',
                                        child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text('View Details')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'schedule',
                                        child: Row(children: [Icon(Icons.calendar_today_outlined, size: 16), SizedBox(width: 8), Text('Schedule Visit')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'info',
                                        child: Row(children: [Icon(Icons.mark_email_read_outlined, size: 16), SizedBox(width: 8), Text('Send Info Pack')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'convert',
                                        child: Row(children: [Icon(Icons.check_circle_outline_rounded, size: 16), SizedBox(width: 8), Text('Convert to Application')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'close',
                                        child: Row(children: [Icon(Icons.close_rounded, size: 16, color: AppColors.error), SizedBox(width: 8), Text('Mark as Closed', style: TextStyle(color: AppColors.error))]),
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
              onTap: () => context.go(RouteNames.enquiryBranchPath),
              child: Text(
                'Enquiry Management',
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
              'Online Student Enquiry',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Online Student Enquiries',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Manage admission enquiries from prospective students',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'Export Data',
      icon: Icons.download_rounded,
      variant: AppButtonVariant.outline,
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exporting student enquiries data...')),
        );
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

  Widget _buildStatusCountCard(String label, int count, Color countColor, bool isDark, {double? width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: countColor,
            ),
          ),
          AppSpacing.vXs,
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
        ],
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
