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

class OnlineAdmissionListScreen extends StatefulWidget {
  const OnlineAdmissionListScreen({super.key});

  @override
  State<OnlineAdmissionListScreen> createState() => _OnlineAdmissionListScreenState();
}

class _OnlineAdmissionListScreenState extends State<OnlineAdmissionListScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _admissionsData = [
    {
      'id': '1',
      'applicationNo': 'APP2024001',
      'date': '2024-01-15',
      'name': 'Rahul Verma',
      'email': 'rahul@example.com',
      'phone': '+91 98765 43210',
      'course': 'Computer Science',
      'batch': 'CS-2024-A',
      'documents': ['Photo', '10th Marksheet', '12th Marksheet', 'Aadhar'],
      'paymentStatus': 'paid',
      'status': 'pending',
    },
    {
      'id': '2',
      'applicationNo': 'APP2024002',
      'date': '2024-01-14',
      'name': 'Priya Singh',
      'email': 'priya@example.com',
      'phone': '+91 87654 32109',
      'course': 'Commerce',
      'batch': 'COM-2024-A',
      'documents': ['Photo', '10th Marksheet', '12th Marksheet'],
      'paymentStatus': 'paid',
      'status': 'under_review',
    },
    {
      'id': '3',
      'applicationNo': 'APP2024003',
      'date': '2024-01-14',
      'name': 'Amit Kumar',
      'email': 'amit@example.com',
      'phone': '+91 76543 21098',
      'course': 'Engineering',
      'batch': 'ENG-2024-A',
      'documents': ['Photo', '10th Marksheet', '12th Marksheet', 'Aadhar', 'Transfer Certificate'],
      'paymentStatus': 'paid',
      'status': 'approved',
    },
    {
      'id': '4',
      'applicationNo': 'APP2024004',
      'date': '2024-01-13',
      'name': 'Sneha Gupta',
      'email': 'sneha@example.com',
      'phone': '+91 65432 10987',
      'course': 'Science',
      'batch': 'SCI-2024-A',
      'documents': ['Photo', '10th Marksheet'],
      'paymentStatus': 'pending',
      'status': 'pending',
    },
    {
      'id': '5',
      'applicationNo': 'APP2024005',
      'date': '2024-01-12',
      'name': 'Vikram Rao',
      'email': 'vikram@example.com',
      'phone': '+91 54321 09876',
      'course': 'Arts',
      'batch': 'ART-2024-A',
      'documents': ['Photo', '10th Marksheet', '12th Marksheet', 'Aadhar'],
      'paymentStatus': 'failed',
      'status': 'rejected',
    },
  ];

  void _showApplicationDetails(Map<String, dynamic> admission) {
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
                      'Application Details',
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
                          child: Icon(Icons.school_rounded, color: AppColors.primary),
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              admission['name'] as String,
                              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'App No: ${admission['applicationNo']} • ${admission['course']}',
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
                    Expanded(child: _buildDetailField('Email', admission['email'] as String, isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildDetailField('Phone', admission['phone'] as String, isDark)),
                  ],
                ),
                AppSpacing.vMd,
                Row(
                  children: [
                    Expanded(child: _buildDetailField('Batch', admission['batch'] as String, isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildDetailField('Payment Status', (admission['paymentStatus'] as String).toUpperCase(), isDark)),
                  ],
                ),
                AppSpacing.vMd,
                _buildDetailField(
                  'Uploaded Documents',
                  (admission['documents'] as List).join(', '),
                  isDark,
                ),
                AppSpacing.vLg,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: 'Reject',
                      variant: AppButtonVariant.outline,
                      onPressed: () {
                        setState(() => admission['status'] = 'rejected');
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Application rejected.'), backgroundColor: AppColors.error),
                        );
                      },
                    ),
                    AppSpacing.hSm,
                    AppButton(
                      text: 'Approve Admission',
                      icon: Icons.check_circle_outline,
                      onPressed: () {
                        setState(() => admission['status'] = 'approved');
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Application approved!'), backgroundColor: AppColors.success),
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

    final filteredAdmissions = _admissionsData.where((a) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (a['name'] as String).toLowerCase();
      final appNo = (a['applicationNo'] as String).toLowerCase();
      final course = (a['course'] as String).toLowerCase();
      final email = (a['email'] as String).toLowerCase();
      return name.contains(q) || appNo.contains(q) || course.contains(q) || email.contains(q);
    }).toList();

    final pendingCount = _admissionsData.where((a) => a['status'] == 'pending' || a['status'] == 'under_review').length;
    final approvedCount = _admissionsData.where((a) => a['status'] == 'approved').length;
    final rejectedCount = _admissionsData.where((a) => a['status'] == 'rejected').length;

    // Stats Cards
    final card1 = OrgStatsCard(
      title: 'Total Applications',
      value: _admissionsData.length.toString(),
      subtitle: 'This session',
      icon: Icons.school_rounded,
      trend: const OrgStatsCardTrend(value: 12, isPositive: true),
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = OrgStatsCard(
      title: 'Pending Review',
      value: pendingCount.toString(),
      subtitle: 'Needs attention',
      icon: Icons.access_time_rounded,
      variant: OrgStatsCardVariant.warning,
    );
    final card3 = OrgStatsCard(
      title: 'Approved',
      value: approvedCount.toString(),
      subtitle: 'Ready for enrollment',
      icon: Icons.check_circle_outline_rounded,
      trend: const OrgStatsCardTrend(value: 8, isPositive: true),
      variant: OrgStatsCardVariant.success,
    );
    final card4 = OrgStatsCard(
      title: 'Rejected',
      value: rejectedCount.toString(),
      subtitle: 'This session',
      icon: Icons.cancel_outlined,
      variant: OrgStatsCardVariant.defaultVariant,
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

          // Admissions Table Card (Full Width)
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
                        'Online Admissions',
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
                              hintText: 'Search applications...',
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
                            _buildDataColumn('APPLICATION', isDark),
                            _buildDataColumn('APPLICANT', isDark),
                            _buildDataColumn('COURSE', isDark),
                            _buildDataColumn('DOCUMENTS', isDark),
                            _buildDataColumn('PAYMENT', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredAdmissions.map((admission) {
                            final appNo = admission['applicationNo'] as String;
                            final date = admission['date'] as String;
                            final name = admission['name'] as String;
                            final email = admission['email'] as String;
                            final course = admission['course'] as String;
                            final batch = admission['batch'] as String;
                            final docs = (admission['documents'] as List).cast<String>();
                            final payment = admission['paymentStatus'] as String;
                            final status = admission['status'] as String;

                            AppBadgeStatus badgeStatus;
                            switch (status) {
                              case 'approved':
                                badgeStatus = AppBadgeStatus.completed;
                                break;
                              case 'under_review':
                              case 'pending':
                                badgeStatus = AppBadgeStatus.pending;
                                break;
                              case 'rejected':
                                badgeStatus = AppBadgeStatus.danger;
                                break;
                              default:
                                badgeStatus = AppBadgeStatus.info;
                            }

                            return DataRow(
                              cells: [
                                // Application
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(appNo, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                      Text(
                                        date,
                                        style: AppTypography.bodySmall.copyWith(
                                          fontSize: 11,
                                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Applicant
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                      Text(
                                        email,
                                        style: AppTypography.bodySmall.copyWith(
                                          fontSize: 11,
                                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Course & Batch
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(course, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500)),
                                      Text(
                                        batch,
                                        style: AppTypography.bodySmall.copyWith(
                                          fontSize: 11,
                                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Documents badge
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                      borderRadius: AppRadius.full,
                                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                    ),
                                    child: Text(
                                      '${docs.length} uploaded',
                                      style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),

                                // Payment
                                DataCell(
                                  AppStatusBadge(
                                    status: payment == 'paid'
                                        ? AppBadgeStatus.completed
                                        : payment == 'pending'
                                            ? AppBadgeStatus.warning
                                            : AppBadgeStatus.danger,
                                    customLabel: payment.toUpperCase(),
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
                                      if (action == 'view') _showApplicationDetails(admission);
                                      if (action == 'approve') {
                                        setState(() => admission['status'] = 'approved');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Application $appNo approved.'), backgroundColor: AppColors.success),
                                        );
                                      }
                                      if (action == 'request') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Document request email sent to $name.')),
                                        );
                                      }
                                      if (action == 'reject') {
                                        setState(() => admission['status'] = 'rejected');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Application $appNo rejected.'), backgroundColor: AppColors.error),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'view',
                                        child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text('View Application')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'approve',
                                        child: Row(children: [Icon(Icons.check_circle_outline, size: 16, color: AppColors.success), SizedBox(width: 8), Text('Approve', style: TextStyle(color: AppColors.success))]),
                                      ),
                                      PopupMenuItem(
                                        value: 'request',
                                        child: Row(children: [Icon(Icons.file_upload_outlined, size: 16), SizedBox(width: 8), Text('Request Documents')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'reject',
                                        child: Row(children: [Icon(Icons.cancel_outlined, size: 16, color: AppColors.error), SizedBox(width: 8), Text('Reject', style: TextStyle(color: AppColors.error))]),
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
              'Online Admission List',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Online Admission List',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Manage online admission applications',
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
          const SnackBar(content: Text('Exporting admission records...')),
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
