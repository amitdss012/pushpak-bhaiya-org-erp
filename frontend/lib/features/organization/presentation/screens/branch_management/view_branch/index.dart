import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../api/hooks/hooks.dart';
import '../../../../../../api/models/models.dart';
import '../../../../../../app/router/route_names.dart';
import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_radius.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/app_card.dart';
import '../../../../../../shared/widgets/app_status_badge.dart';
import '../../../../../../shared/widgets/no_data_found_template.dart';
import '../../../widgets/org_stats_card.dart';

class ViewBranchScreen extends HookWidget {
  const ViewBranchScreen({super.key});

  void _showBranchDetails(BuildContext context, BranchModel branch) {
    final isDark = context.isDarkMode;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
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
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(30),
                          borderRadius: AppRadius.sm,
                        ),
                        child: branch.logo != null && branch.logo!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: AppRadius.sm,
                                child: Image.network(
                                  branch.logo!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => const Icon(Icons.business_rounded, color: AppColors.primary),
                                ),
                              )
                            : const Center(child: Icon(Icons.business_rounded, color: AppColors.primary)),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              branch.name,
                              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '${branch.code ?? 'No Code'} • ${branch.branchType.toUpperCase()} • ${branch.instituteType}',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppStatusBadge(
                        status: branch.isActive ? AppBadgeStatus.active : AppBadgeStatus.pending,
                        customLabel: branch.status,
                      ),
                    ],
                  ),
                ),
                AppSpacing.vLg,
                Row(
                  children: [
                    Expanded(child: _buildDetailItem('Type', branch.branchType.toUpperCase(), isDark)),
                    AppSpacing.hMd,
                    Expanded(
                      child: _buildDetailItem(
                        'Location',
                        [branch.city, branch.state].where((e) => e != null && e.isNotEmpty).join(', ').isEmpty
                            ? 'Not specified'
                            : [branch.city, branch.state].where((e) => e != null && e.isNotEmpty).join(', '),
                        isDark,
                      ),
                    ),
                  ],
                ),
                AppSpacing.vMd,
                Row(
                  children: [
                    Expanded(child: _buildDetailItem('Students', branch.studentsCount.toString(), isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildDetailItem('Staff', branch.staffCount.toString(), isDark)),
                  ],
                ),
                AppSpacing.vMd,
                Row(
                  children: [
                    Expanded(child: _buildDetailItem('Contact Phone', branch.phone ?? 'N/A', isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildDetailItem('Email', branch.email ?? 'N/A', isDark)),
                  ],
                ),
                if (branch.directorName != null && branch.directorName!.isNotEmpty) ...[
                  AppSpacing.vMd,
                  Row(
                    children: [
                      Expanded(child: _buildDetailItem('Director', branch.directorName!, isDark)),
                      AppSpacing.hMd,
                      Expanded(child: _buildDetailItem('Blood Group', branch.directorBloodGroup ?? 'N/A', isDark)),
                    ],
                  ),
                ],
                AppSpacing.vMd,
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        'Registration Date',
                        branch.registrationDate != null ? branch.registrationDate!.toLocal().toString().split(' ')[0] : 'N/A',
                        isDark,
                      ),
                    ),
                    AppSpacing.hMd,
                    Expanded(
                      child: _buildDetailItem(
                        'Expiry Date',
                        branch.expiryDate != null ? branch.expiryDate!.toLocal().toString().split(' ')[0] : 'N/A',
                        isDark,
                      ),
                    ),
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

    final searchController = useTextEditingController();
    final searchQuery = useState<String>('');
    final selectedStatus = useState<String?>(null);

    final branchesQuery = useBranchesQuery(
      search: searchQuery.value.isEmpty ? null : searchQuery.value,
      status: selectedStatus.value,
    );

    final response = branchesQuery.dataOrNull;
    final branchList = response?.branches ?? [];
    final stats = response?.stats;

    // Stat Cards from backend metrics
    final totalBranchesCount = stats?.totalBranches ?? branchList.length;
    final activeBranchesCount = stats?.activeBranches ?? branchList.where((b) => b.isActive).length;
    final inactiveBranchesCount = stats?.inactiveBranches ?? branchList.where((b) => !b.isActive).length;
    final totalStudentsCount = stats?.totalStudents ?? branchList.fold<int>(0, (sum, b) => sum + b.studentsCount);
    final totalStaffCount = stats?.totalStaff ?? branchList.fold<int>(0, (sum, b) => sum + b.staffCount);

    final card1 = OrgStatsCard(
      title: 'Total Branches',
      value: totalBranchesCount.toString(),
      subtitle: '$activeBranchesCount active',
      icon: Icons.business_rounded,
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = OrgStatsCard(
      title: 'Total Students',
      value: totalStudentsCount.toString(),
      subtitle: 'Across all branches',
      icon: Icons.school_rounded,
      variant: OrgStatsCardVariant.info,
    );
    final card3 = OrgStatsCard(
      title: 'Total Staff',
      value: totalStaffCount.toString(),
      subtitle: 'Teaching & non-teaching',
      icon: Icons.people_outline_rounded,
      variant: OrgStatsCardVariant.success,
    );
    final card4 = OrgStatsCard(
      title: 'Inactive Branches',
      value: inactiveBranchesCount.toString(),
      subtitle: '$activeBranchesCount operating smoothly',
      icon: Icons.domain_disabled_rounded,
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
          _buildHeader(context, isDark, isMobile),
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
                      Row(
                        children: [
                          Text(
                            'All Branches',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          AppSpacing.hSm,
                          if (branchesQuery.isFetching)
                            const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
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
                            controller: searchController,
                            onChanged: (val) => searchQuery.value = val.trim(),
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
                              suffixIcon: searchQuery.value.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded, size: 14),
                                      onPressed: () {
                                        searchController.clear();
                                        searchQuery.value = '';
                                      },
                                    )
                                  : null,
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

                // Query State Handlers
                if (branchesQuery.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(48.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (branchesQuery.failureReason != null)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: NoDataFoundTemplate.error(
                      message: 'Failed to load branches: ${branchesQuery.failureReason}',
                      onRetry: () => branchesQuery.refetch(),
                      cardWrapper: false,
                    ),
                  )
                else if (branchList.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: searchQuery.value.isNotEmpty
                        ? NoDataFoundTemplate(
                            icon: Icons.search_off_rounded,
                            title: 'No Matching Branches',
                            message: 'No branches matched "${searchQuery.value}".',
                            actionText: 'Clear Search',
                            onAction: () {
                              searchController.clear();
                              searchQuery.value = '';
                            },
                            cardWrapper: false,
                          )
                        : NoDataFoundTemplate(
                            icon: Icons.business_rounded,
                            title: 'No Branches Registered',
                            message: 'Get started by creating your first branch in the system.',
                            actionText: 'Add Branch',
                            actionIcon: Icons.add_rounded,
                            onAction: () => context.go(RouteNames.branchCreatePath),
                            cardWrapper: false,
                          ),
                  )
                else
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
                              isDark
                                  ? AppColors.backgroundDark.withAlpha(80)
                                  : AppColors.backgroundLight.withAlpha(120),
                            ),
                            columns: [
                              _buildDataColumn('BRANCH', isDark),
                              _buildDataColumn('TYPE', isDark),
                              _buildDataColumn('LOCATION', isDark),
                              _buildDataColumn('STUDENTS', isDark),
                              _buildDataColumn('STAFF', isDark),
                              _buildDataColumn('EXPIRY', isDark),
                              _buildDataColumn('STATUS', isDark),
                              _buildDataColumn('ACTIONS', isDark),
                            ],
                            rows: branchList.map((branch) {
                              final name = branch.name;
                              final code = branch.code ?? '-';
                              final type = branch.branchType.toUpperCase();
                              final instituteType = branch.instituteType;
                              final location = [branch.city, branch.state]
                                  .where((e) => e != null && e.isNotEmpty)
                                  .join(', ');
                              final students = branch.studentsCount;
                              final staff = branch.staffCount;
                              final expiryDate = branch.expiryDate != null
                                  ? branch.expiryDate!.toLocal().toString().split(' ')[0]
                                  : 'Permanent';

                              final expiry = branch.expiryDate;
                              final today = DateTime.now();
                              final isExpired = expiry != null && expiry.isBefore(today);
                              final isExpiringSoon = expiry != null &&
                                  !isExpired &&
                                  expiry.difference(today).inDays <= 30;

                              final expiryColor = isExpired
                                  ? AppColors.error
                                  : isExpiringSoon
                                      ? AppColors.warning
                                      : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight);

                              return DataRow(
                                cells: [
                                  // Branch Name, Logo & Code
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
                                          child: branch.logo != null && branch.logo!.isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius: AppRadius.sm,
                                                  child: Image.network(
                                                    branch.logo!,
                                                    width: 36,
                                                    height: 36,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (ctx, err, stack) => const Icon(
                                                      Icons.business_rounded,
                                                      color: AppColors.primary,
                                                      size: 18,
                                                    ),
                                                  ),
                                                )
                                              : const Center(
                                                  child: Icon(
                                                    Icons.business_rounded,
                                                    color: AppColors.primary,
                                                    size: 18,
                                                  ),
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
                                            border: Border.all(
                                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                            ),
                                          ),
                                          child: Text(
                                            type,
                                            style: AppTypography.bodySmall.copyWith(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w600,
                                            ),
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
                                      location.isEmpty ? '-' : location,
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
                                      status: branch.isActive ? AppBadgeStatus.active : AppBadgeStatus.pending,
                                      customLabel: branch.status,
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
                                        if (action == 'view') _showBranchDetails(context, branch);
                                        if (action == 'edit') context.go(RouteNames.branchCreatePath);
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'view',
                                          child: Row(
                                            children: [
                                              Icon(Icons.visibility_outlined, size: 16),
                                              SizedBox(width: 8),
                                              Text('View Details'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit_outlined, size: 16),
                                              SizedBox(width: 8),
                                              Text('Edit Branch'),
                                            ],
                                          ),
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

  Widget _buildHeader(BuildContext context, bool isDark, bool isMobile) {
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
