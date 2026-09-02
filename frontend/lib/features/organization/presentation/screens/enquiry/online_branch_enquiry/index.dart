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

class OnlineBranchEnquiryScreen extends StatefulWidget {
  const OnlineBranchEnquiryScreen({super.key});

  @override
  State<OnlineBranchEnquiryScreen> createState() => _OnlineBranchEnquiryScreenState();
}

class _OnlineBranchEnquiryScreenState extends State<OnlineBranchEnquiryScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _enquiriesData = [
    {
      'id': '1',
      'date': '2024-01-15 10:30 AM',
      'branch': 'Main Campus',
      'name': 'Ravi Kumar',
      'phone': '+91 98765 43210',
      'email': 'ravi@example.com',
      'enquiryType': 'Admission',
      'message': 'Interested in admission for B.Tech program for the upcoming academic session.',
      'ipAddress': '192.168.1.100',
      'status': 'pending',
    },
    {
      'id': '2',
      'date': '2024-01-15 09:15 AM',
      'branch': 'North Campus',
      'name': 'Anita Sharma',
      'phone': '+91 87654 32109',
      'email': 'anita@example.com',
      'enquiryType': 'Fee Structure',
      'message': 'Please share the detailed semester-wise fee structure for MBA program.',
      'ipAddress': '192.168.1.101',
      'status': 'reviewed',
    },
    {
      'id': '3',
      'date': '2024-01-14 04:45 PM',
      'branch': 'Main Campus',
      'name': 'Deepak Verma',
      'phone': '+91 76543 21098',
      'email': 'deepak@example.com',
      'enquiryType': 'Course Details',
      'message': 'Looking for detailed curriculum syllabus information about BCA course.',
      'ipAddress': '192.168.1.102',
      'status': 'responded',
    },
    {
      'id': '4',
      'date': '2024-01-14 02:30 PM',
      'branch': 'South Campus',
      'name': 'Meera Joshi',
      'phone': '+91 65432 10987',
      'email': 'meera@example.com',
      'enquiryType': 'Scholarship',
      'message': 'What merit-based scholarships are available for high-scoring students?',
      'ipAddress': '192.168.1.103',
      'status': 'pending',
    },
    {
      'id': '5',
      'date': '2024-01-13 11:00 AM',
      'branch': 'East Campus',
      'name': 'Suresh Reddy',
      'phone': '+91 54321 09876',
      'email': 'suresh@example.com',
      'enquiryType': 'Hostel',
      'message': 'Need information about hostel accommodation, mess facilities, and fees.',
      'ipAddress': '192.168.1.104',
      'status': 'closed',
    },
  ];

  void _showFullMessageDialog(Map<String, dynamic> enquiry) {
    final isDark = context.isDarkMode;
    final responseController = TextEditingController();

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
                        'Online Enquiry Message',
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              enquiry['name'] as String,
                              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(25),
                                borderRadius: AppRadius.full,
                              ),
                              child: Text(
                                enquiry['branch'] as String,
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.vXs,
                        Row(
                          children: [
                            Text(
                              '${enquiry['phone']} • ${enquiry['email']}',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.vMd,
                  Row(
                    children: [
                      Expanded(child: _buildDetailField('Enquiry Type', enquiry['enquiryType'] as String, isDark)),
                      AppSpacing.hMd,
                      Expanded(child: _buildDetailField('Received At', enquiry['date'] as String, isDark)),
                      AppSpacing.hMd,
                      Expanded(child: _buildDetailField('IP Address', enquiry['ipAddress'] as String, isDark)),
                    ],
                  ),
                  AppSpacing.vMd,
                  _buildDetailField('Message Content', enquiry['message'] as String, isDark),
                  AppSpacing.vLg,

                  // Reply Section
                  Text(
                    'Quick Response',
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  AppSpacing.vXs,
                  TextFormField(
                    controller: responseController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Type reply to send via email / SMS...',
                    ),
                  ),
                  AppSpacing.vLg,

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton(
                        text: 'Mark Reviewed',
                        variant: AppButtonVariant.outline,
                        onPressed: () {
                          setState(() => enquiry['status'] = 'reviewed');
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${enquiry['name']} marked as reviewed.')),
                          );
                        },
                      ),
                      AppSpacing.hSm,
                      AppButton(
                        text: 'Send Response',
                        icon: Icons.send_rounded,
                        onPressed: () {
                          if (responseController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter a response message.')),
                            );
                            return;
                          }
                          setState(() => enquiry['status'] = 'responded');
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Response sent to ${enquiry['email']}!'),
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
      final branch = (e['branch'] as String).toLowerCase();
      final type = (e['enquiryType'] as String).toLowerCase();
      final msg = (e['message'] as String).toLowerCase();
      return name.contains(q) || branch.contains(q) || type.contains(q) || msg.contains(q);
    }).toList();

    // Stats Cards
    final card1 = OrgStatsCard(
      title: 'Total Online Enquiries',
      value: _enquiriesData.length.toString(),
      subtitle: 'This month',
      icon: Icons.language_rounded,
      trend: const OrgStatsCardTrend(value: 20, isPositive: true),
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = OrgStatsCard(
      title: 'Pending Review',
      value: _enquiriesData.where((e) => e['status'] == 'pending').length.toString(),
      subtitle: 'Needs attention',
      icon: Icons.access_time_rounded,
      variant: OrgStatsCardVariant.warning,
    );
    final card3 = OrgStatsCard(
      title: 'Responded',
      value: _enquiriesData.where((e) => e['status'] == 'responded').length.toString(),
      subtitle: 'This week',
      icon: Icons.check_circle_outline_rounded,
      variant: OrgStatsCardVariant.success,
    );
    final card4 = const OrgStatsCard(
      title: 'By Branch',
      value: '4',
      subtitle: 'Active branches',
      icon: Icons.business_rounded,
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

          // Table Card (Full Width)
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
                        'Online Enquiries',
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
                              hintText: 'Search online enquiries...',
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
                            _buildDataColumn('RECEIVED', isDark),
                            _buildDataColumn('BRANCH', isDark),
                            _buildDataColumn('ENQUIRER', isDark),
                            _buildDataColumn('TYPE', isDark),
                            _buildDataColumn('MESSAGE', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredEnquiries.map((enquiry) {
                            final date = enquiry['date'] as String;
                            final dateParts = date.split(' ');
                            final dateOnly = dateParts[0];
                            final timeOnly = dateParts.length > 1 ? dateParts.sublist(1).join(' ') : '';

                            final branch = enquiry['branch'] as String;
                            final name = enquiry['name'] as String;
                            final email = enquiry['email'] as String;
                            final enquiryType = enquiry['enquiryType'] as String;
                            final message = enquiry['message'] as String;
                            final status = enquiry['status'] as String;

                            AppBadgeStatus badgeStatus;
                            switch (status) {
                              case 'pending':
                                badgeStatus = AppBadgeStatus.pending;
                                break;
                              case 'reviewed':
                                badgeStatus = AppBadgeStatus.info;
                                break;
                              case 'responded':
                                badgeStatus = AppBadgeStatus.completed;
                                break;
                              default:
                                badgeStatus = AppBadgeStatus.info;
                            }

                            return DataRow(
                              cells: [
                                // Received
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(dateOnly, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500)),
                                      Text(
                                        timeOnly,
                                        style: AppTypography.bodySmall.copyWith(
                                          fontSize: 10.5,
                                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Branch
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                      borderRadius: AppRadius.full,
                                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                    ),
                                    child: Text(
                                      branch,
                                      style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),

                                // Enquirer
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

                                // Type
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withAlpha(20),
                                      borderRadius: AppRadius.full,
                                    ),
                                    child: Text(
                                      enquiryType,
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),

                                // Message Preview
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 240),
                                    child: Text(
                                      message,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      ),
                                    ),
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
                                      if (action == 'view') _showFullMessageDialog(enquiry);
                                      if (action == 'review') {
                                        setState(() => enquiry['status'] = 'reviewed');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('${enquiry['name']} marked as reviewed.')),
                                        );
                                      }
                                      if (action == 'respond') _showFullMessageDialog(enquiry);
                                      if (action == 'lead') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${enquiry['name']} converted to lead!'),
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
                                        child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text('View Full Message')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'review',
                                        child: Row(children: [Icon(Icons.check_circle_outline_rounded, size: 16), SizedBox(width: 8), Text('Mark as Reviewed')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'respond',
                                        child: Row(children: [Icon(Icons.reply_rounded, size: 16), SizedBox(width: 8), Text('Send Response')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'lead',
                                        child: Row(children: [Icon(Icons.person_add_alt_1_outlined, size: 16), SizedBox(width: 8), Text('Convert to Lead')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'close',
                                        child: Row(children: [Icon(Icons.close_rounded, size: 16, color: AppColors.error), SizedBox(width: 8), Text('Close', style: TextStyle(color: AppColors.error))]),
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
              'Online Branch Enquiry',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Online Branch Enquiries',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Manage enquiries received from branch websites',
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
          const SnackBar(content: Text('Exporting online enquiries data...')),
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
