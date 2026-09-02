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

class ViewBranchScreen extends StatefulWidget {
  const ViewBranchScreen({super.key});

  @override
  State<ViewBranchScreen> createState() => _ViewBranchScreenState();
}

class _ViewBranchScreenState extends State<ViewBranchScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _branchesData = [
    {
      'id': '1',
      'name': 'Main Campus',
      'code': 'BR001',
      'type': 'Main Branch',
      'instituteType': 'Computer Institute',
      'city': 'Mumbai',
      'state': 'Maharashtra',
      'students': 1200,
      'staff': 85,
      'revenue': 2500000,
      'status': 'active',
      'expiryDate': '2025-12-31',
    },
    {
      'id': '2',
      'name': 'North Campus',
      'code': 'BR002',
      'type': 'Sub Branch',
      'instituteType': 'Typing Institute',
      'city': 'Delhi',
      'state': 'Delhi',
      'students': 850,
      'staff': 60,
      'revenue': 1800000,
      'status': 'active',
      'expiryDate': '2025-06-30',
    },
    {
      'id': '3',
      'name': 'South Campus',
      'code': 'BR003',
      'type': 'Sub Branch',
      'instituteType': 'Computer Institute',
      'city': 'Bangalore',
      'state': 'Karnataka',
      'students': 650,
      'staff': 45,
      'revenue': 1400000,
      'status': 'active',
      'expiryDate': '2025-09-15',
    },
    {
      'id': '4',
      'name': 'East Campus',
      'code': 'BR004',
      'type': 'Franchise',
      'instituteType': 'Paramedical Institute',
      'city': 'Kolkata',
      'state': 'West Bengal',
      'students': 420,
      'staff': 32,
      'revenue': 950000,
      'status': 'active',
      'expiryDate': '2025-03-31',
    },
    {
      'id': '5',
      'name': 'West Campus',
      'code': 'BR005',
      'type': 'Sub Branch',
      'instituteType': 'Other',
      'city': 'Ahmedabad',
      'state': 'Gujarat',
      'students': 380,
      'staff': 28,
      'revenue': 820000,
      'status': 'inactive',
      'expiryDate': '2024-12-31',
    },
  ];

  void _showBranchDetails(Map<String, dynamic> branch) {
    final isDark = context.isDarkMode;
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                      'Branch Details',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
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
                          color: AppColors.primary.withAlpha(30),
                          borderRadius: AppRadius.sm,
                        ),
                        child: const Center(child: Icon(Icons.business_rounded, color: AppColors.primary)),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              branch['name'] as String,
                              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '${branch['code']} • ${branch['instituteType']}',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppStatusBadge(
                        status: branch['status'] == 'active' ? AppBadgeStatus.active : AppBadgeStatus.pending,
                        customLabel: branch['status'] == 'active' ? 'Active' : 'Inactive',
                      ),
                    ],
                  ),
                ),
                AppSpacing.vLg,
                Row(
                  children: [
                    Expanded(child: _buildDetailItem('Type', branch['type'] as String, isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildDetailItem('Location', '${branch['city']}, ${branch['state']}', isDark)),
                  ],
                ),
                AppSpacing.vMd,
                Row(
                  children: [
                    Expanded(child: _buildDetailItem('Students', branch['students'].toString(), isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildDetailItem('Staff', branch['staff'].toString(), isDark)),
                  ],
                ),
                AppSpacing.vMd,
                Row(
                  children: [
                    Expanded(child: _buildDetailItem('Monthly Revenue', '₹${((branch['revenue'] as int) / 100000).toFixed(1)}L', isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildDetailItem('Expiry Date', branch['expiryDate'] as String, isDark)),
                  ],
                ),
                AppSpacing.vLg,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: 'Close',
                      onPressed: () => Navigator.of(context).pop(),
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

  void _showCertificateDialog(Map<String, dynamic> branch) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating Center Certificate for ${branch['name']}...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleDelete(Map<String, dynamic> branch) {
    setState(() {
      _branchesData.removeWhere((b) => b['id'] == branch['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Branch ${branch['name']} removed.'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, bool isDark) {
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

    final filteredBranches = _branchesData.where((b) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (b['name'] as String).toLowerCase();
      final code = (b['code'] as String).toLowerCase();
      final city = (b['city'] as String).toLowerCase();
      final type = (b['type'] as String).toLowerCase();
      return name.contains(q) || code.contains(q) || city.contains(q) || type.contains(q);
    }).toList();

    final totalStudents = _branchesData.fold<int>(0, (sum, b) => sum + (b['students'] as int));
    final totalStaff = _branchesData.fold<int>(0, (sum, b) => sum + (b['staff'] as int));
    final totalRevenue = _branchesData.fold<int>(0, (sum, b) => sum + (b['revenue'] as int));
    final activeBranches = _branchesData.where((b) => b['status'] == 'active').length;

    // Stat Cards
    final card1 = OrgStatsCard(
      title: 'Total Branches',
      value: _branchesData.length.toString(),
      subtitle: '$activeBranches active',
      icon: Icons.business_rounded,
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = OrgStatsCard(
      title: 'Total Students',
      value: totalStudents.toString(),
      subtitle: 'Across all branches',
      icon: Icons.school_rounded,
      variant: OrgStatsCardVariant.info,
    );
    final card3 = OrgStatsCard(
      title: 'Total Staff',
      value: totalStaff.toString(),
      subtitle: 'Teaching & non-teaching',
      icon: Icons.people_outline_rounded,
      variant: OrgStatsCardVariant.success,
    );
    final card4 = OrgStatsCard(
      title: 'Total Revenue',
      value: '₹${(totalRevenue / 100000).toStringAsFixed(1)}L',
      subtitle: 'This month',
      icon: Icons.currency_rupee_rounded,
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

          // Branches Data Table Card
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
                        'All Branches',
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
                              hintText: 'Search branches...',
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
                      _buildDataColumn('BRANCH', isDark),
                      _buildDataColumn('TYPE', isDark),
                      _buildDataColumn('LOCATION', isDark),
                      _buildDataColumn('STUDENTS', isDark),
                      _buildDataColumn('STAFF', isDark),
                      _buildDataColumn('REVENUE', isDark),
                      _buildDataColumn('EXPIRY', isDark),
                      _buildDataColumn('STATUS', isDark),
                      _buildDataColumn('ACTIONS', isDark),
                    ],
                    rows: filteredBranches.map((branch) {
                      final name = branch['name'] as String;
                      final code = branch['code'] as String;
                      final type = branch['type'] as String;
                      final instituteType = branch['instituteType'] as String;
                      final city = branch['city'] as String;
                      final state = branch['state'] as String;
                      final students = branch['students'] as int;
                      final staff = branch['staff'] as int;
                      final revenue = branch['revenue'] as int;
                      final expiryDate = branch['expiryDate'] as String;
                      final status = branch['status'] as String;

                      final expiry = DateTime.tryParse(expiryDate) ?? DateTime(2025);
                      final today = DateTime.now();
                      final isExpired = expiry.isBefore(today);
                      final isExpiringSoon = !isExpired && expiry.difference(today).inDays <= 30;

                      final expiryColor = isExpired
                          ? AppColors.error
                          : isExpiringSoon
                              ? AppColors.warning
                              : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight);

                      return DataRow(
                        cells: [
                          // Branch Name & Code
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withAlpha(30),
                                    borderRadius: AppRadius.sm,
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.business_rounded, color: AppColors.primary, size: 18),
                                  ),
                                ),
                                AppSpacing.hSm,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      name,
                                      style: AppTypography.bodySmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                    Text(
                                      code,
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 10.5,
                                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Type & Institute
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                    borderRadius: AppRadius.full,
                                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                  ),
                                  child: Text(
                                    type,
                                    style: AppTypography.bodySmall.copyWith(fontSize: 10.5, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                AppSpacing.vXs,
                                Text(
                                  instituteType,
                                  style: AppTypography.bodySmall.copyWith(
                                    fontSize: 10.5,
                                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Location
                          DataCell(
                            Text(
                              '$city, $state',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ),

                          // Students
                          DataCell(
                            Text(
                              students.toString(),
                              style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),

                          // Staff
                          DataCell(
                            Text(
                              staff.toString(),
                              style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),

                          // Revenue
                          DataCell(
                            Text(
                              '₹${(revenue / 100000).toStringAsFixed(1)}L',
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ),

                          // Expiry Date
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.event_available_rounded, size: 14, color: expiryColor),
                                AppSpacing.hXs,
                                Text(
                                  expiryDate,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: expiryColor,
                                    fontWeight: isExpired || isExpiringSoon ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Status
                          DataCell(
                            AppStatusBadge(
                              status: status == 'active' ? AppBadgeStatus.active : AppBadgeStatus.pending,
                              customLabel: status == 'active' ? 'Active' : 'Inactive',
                            ),
                          ),

                          // Action Menu
                          DataCell(
                            PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_horiz_rounded,
                                size: 18,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                              onSelected: (action) {
                                if (action == 'view') _showBranchDetails(branch);
                                if (action == 'edit') context.go(RouteNames.branchCreatePath);
                                if (action == 'cert') _showCertificateDialog(branch);
                                if (action == 'staff') context.go(RouteNames.branchViewPath);
                                if (action == 'reports') context.go(RouteNames.branchTransactionsPath);
                                if (action == 'delete') _handleDelete(branch);
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'view',
                                  child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text('View Details')]),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(children: [Icon(Icons.edit_outlined, size: 16), SizedBox(width: 8), Text('Edit Branch')]),
                                ),
                                const PopupMenuItem(
                                  value: 'cert',
                                  child: Row(children: [Icon(Icons.card_membership_outlined, size: 16), SizedBox(width: 8), Text('Center Certificate')]),
                                ),
                                const PopupMenuItem(
                                  value: 'staff',
                                  child: Row(children: [Icon(Icons.people_outline, size: 16), SizedBox(width: 8), Text('Manage Staff')]),
                                ),
                                const PopupMenuItem(
                                  value: 'reports',
                                  child: Row(children: [Icon(Icons.bar_chart_rounded, size: 16), SizedBox(width: 8), Text('View Reports')]),
                                ),
                                const PopupMenuItem(
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
            Text(
              'Branch Management',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
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
              'View Branches',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'View Branches',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Manage all branches and their details',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'Add Branch',
      icon: Icons.add_rounded,
      onPressed: () => context.go(RouteNames.branchCreatePath),
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

extension DoubleExt on double {
  String toFixed(int fractionDigits) => toStringAsFixed(fractionDigits);
}
