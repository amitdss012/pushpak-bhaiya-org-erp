import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../api/hooks/platfrom/use_organizations.dart';
import '../../../../api/hooks/platfrom/use_subscription_plans.dart';
import '../../../../api/models/models.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/provider/app_query_client.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';

/// Luxury, fully responsive Platform Multi-Tenant Organizations Management.
/// Adapts gracefully across Mobile, Tablet, Desktop, and Ultra-wide viewports.
class PlatformOrganizationsScreen extends HookWidget {
  const PlatformOrganizationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final screenWidth = context.screenWidth;
    final isMobile = screenWidth < 700;
    final isDesktop = screenWidth >= 980;

    final searchController = useTextEditingController();
    final searchQuery = useState<String>('');
    final selectedStatus = useState<String?>(null);
    final currentPage = useState<int>(1);

    // Fetch organizations query
    final orgsQuery = useOrganizationsQuery(
      params: GetOrganizationsParams(
        page: currentPage.value,
        limit: 10,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        status: selectedStatus.value,
      ),
    );

    final orgsData = orgsQuery.dataOrNull;
    final orgsList = orgsData?.data ?? [];
    final pagination = orgsData?.pagination;

    void showOnboardOrgDialog() {
      showDialog(
        context: context,
        builder: (dialogCtx) => _OnboardOrgDialog(
          onSuccess: () {
            AppQueryClient.instance.invalidateQueries(
              queryKey: const ['platform', 'organizations'],
            );
          },
        ),
      );
    }

    void showOrgDetailsDialog(String orgId) {
      showDialog(
        context: context,
        builder: (dialogCtx) => _OrganizationDetailsDialog(orgId: orgId),
      );
    }

    return SelectionArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 28,
                vertical: isMobile ? 16 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Responsive Executive Header
                  _buildExecutiveHeader(
                    context,
                    isDark,
                    isMobile,
                    pagination?.total ?? orgsList.length,
                    showOnboardOrgDialog,
                  ),
                  AppSpacing.vLg,

                  // 2. Responsive Search & Segmented Filter Bar
                  _buildSearchFilterToolbar(
                    context,
                    isDark,
                    isMobile,
                    searchController,
                    searchQuery,
                    selectedStatus,
                    currentPage,
                  ),
                  AppSpacing.vLg,

                  // 3. Content Area
                  if (orgsQuery.isPending)
                    const Padding(
                      padding: EdgeInsets.all(64),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (orgsList.isEmpty)
                    _buildEmptyState(context, isDark, showOnboardOrgDialog)
                  else ...[
                    if (isDesktop)
                      _buildDesktopOrganizationsTable(
                        context,
                        isDark,
                        orgsList,
                        showOrgDetailsDialog,
                      )
                    else
                      _buildMobileOrganizationsList(
                        context,
                        isDark,
                        orgsList,
                        showOrgDetailsDialog,
                      ),
                    AppSpacing.vLg,

                    // 4. Pagination Controls
                    if (pagination != null && pagination.totalPages > 1)
                      _buildPaginationControls(
                        context,
                        isDark,
                        pagination,
                        onPageChange: (newPage) => currentPage.value = newPage,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 1. Executive Header
  // ===========================================================================
  Widget _buildExecutiveHeader(
    BuildContext context,
    bool isDark,
    bool isMobile,
    int totalCount,
    VoidCallback onOnboard,
  ) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                'Tenant Organizations',
                style: (isMobile
                        ? AppTypography.titleLarge
                        : AppTypography.headlineMedium)
                    .copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ),
            AppSpacing.hSm,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(isDark ? 40 : 20),
                borderRadius: AppRadius.full,
              ),
              child: Text(
                '$totalCount Registered',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.vXs,
        Text(
          'Manage multi-tenant educational institutions, subscription entitlements, and campus profiles.',
          style: AppTypography.bodySmall.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          titleBlock,
          AppSpacing.vMd,
          AppButton(
            text: 'Onboard Organization',
            icon: Icons.add_business_rounded,
            onPressed: onOnboard,
            height: 42,
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: titleBlock),
        AppSpacing.hMd,
        AppButton(
          text: 'Onboard Organization',
          icon: Icons.add_business_rounded,
          onPressed: onOnboard,
          height: 44,
        ),
      ],
    );
  }

  // ===========================================================================
  // 2. Search & Segmented Filter Toolbar
  // ===========================================================================
  Widget _buildSearchFilterToolbar(
    BuildContext context,
    bool isDark,
    bool isMobile,
    TextEditingController searchController,
    ValueNotifier<String> searchQuery,
    ValueNotifier<String?> selectedStatus,
    ValueNotifier<int> currentPage,
  ) {
    final searchField = TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search by institution name, subdomain slug, or owner email...',
        hintStyle: AppTypography.bodySmall.copyWith(
          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
        ),
        prefixIcon: const Icon(Icons.search_rounded, size: 20),
        suffixIcon: searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, size: 18),
                onPressed: () {
                  searchController.clear();
                  searchQuery.value = '';
                  currentPage.value = 1;
                },
              )
            : null,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: AppRadius.md),
      ),
      onSubmitted: (val) {
        searchQuery.value = val.trim();
        currentPage.value = 1;
      },
    );

    // Segmented Status Filter Chips
    final statusChips = [
      {'label': 'All Statuses', 'value': null},
      {'label': 'Active', 'value': 'ACTIVE'},
      {'label': 'Suspended', 'value': 'SUSPENDED'},
      {'label': 'Pending', 'value': 'PENDING'},
    ];

    final filterBar = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: statusChips.map((chip) {
          final isSelected = selectedStatus.value == chip['value'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(chip['label'] as String),
              selected: isSelected,
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              labelStyle: AppTypography.labelSmall.copyWith(
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight),
              ),
              backgroundColor: isDark
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFF1F5F9),
              selectedColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.full),
              onSelected: (_) {
                selectedStatus.value = chip['value'];
                currentPage.value = 1;
              },
            ),
          );
        }).toList(),
      ),
    );

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          searchField,
          AppSpacing.vMd,
          filterBar,
        ],
      ),
    );
  }

  // ===========================================================================
  // 3A. Desktop Organizations Table (>= 980px)
  // ===========================================================================
  Widget _buildDesktopOrganizationsTable(
    BuildContext context,
    bool isDark,
    List<OrganizationListItemModel> orgs,
    void Function(String) onViewDetails,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 40 : 6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth =
              constraints.maxWidth > 960 ? constraints.maxWidth : 960.0;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2.8),
                  1: FlexColumnWidth(2.2),
                  2: FlexColumnWidth(1.8),
                  3: FixedColumnWidth(125),
                  4: FixedColumnWidth(110),
                  5: FixedColumnWidth(135),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
          // Table Header
          TableRow(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B).withAlpha(150)
                  : const Color(0xFFF8FAFC),
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                ),
              ),
            ),
            children: [
              _buildTableHeaderCell('INSTITUTION / TENANT', isDark),
              _buildTableHeaderCell('PRIMARY OWNER', isDark),
              _buildTableHeaderCell('SUBSCRIBED PLAN', isDark),
              _buildTableHeaderCell('BRANCHES', isDark),
              _buildTableHeaderCell('STATUS', isDark),
              _buildTableHeaderCell('ACTIONS', isDark),
            ],
          ),

          // Data Rows
          ...orgs.map((org) {
            final sub = org.activeSubscription;
            final isActive = org.status == 'ACTIVE';

            return TableRow(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                  ),
                ),
              ),
              children: [
                // Institution Name & Avatar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            AppColors.primary.withAlpha(isDark ? 50 : 25),
                        child: Text(
                          org.name.isNotEmpty ? org.name[0].toUpperCase() : 'O',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      AppSpacing.hSm,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              org.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                            ),
                            Text(
                              org.slug,
                              style: AppTypography.labelSmall.copyWith(
                                fontFamily: 'monospace',
                                color: isDark
                                    ? AppColors.textMutedDark
                                    : AppColors.textMutedLight,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Owner Info
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        org.owner?.fullName ?? 'N/A',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        org.owner?.email ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                // Plan Tier
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(isDark ? 30 : 15),
                      borderRadius: AppRadius.sm,
                    ),
                    child: Text(
                      sub?.plan?.name ?? 'No Plan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),

                // Branches Count
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Text(
                    '${org.branchesCount} campuses',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontSize: 12,
                    ),
                  ),
                ),

                // Status Badge
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: (isActive
                                ? AppColors.success
                                : AppColors.warning)
                            .withAlpha(isDark ? 35 : 20),
                        borderRadius: AppRadius.full,
                        border: Border.all(
                          color: (isActive
                                  ? AppColors.success
                                  : AppColors.warning)
                              .withAlpha(isDark ? 90 : 60),
                        ),
                      ),
                      child: Text(
                        org.status,
                        style: AppTypography.labelSmall.copyWith(
                          color: isActive
                              ? AppColors.success
                              : AppColors.warning,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),

                // Actions
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.visibility_outlined, size: 15),
                    label: const Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                    onPressed: () => onViewDetails(org.id),
                  ),
                ),
              ],
            );
          }),
        ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTableHeaderCell(String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          fontSize: 10,
        ),
      ),
    );
  }

  // ===========================================================================
  // 3B. Mobile & Tablet Organizations Cards (< 980px)
  // ===========================================================================
  Widget _buildMobileOrganizationsList(
    BuildContext context,
    bool isDark,
    List<OrganizationListItemModel> orgs,
    void Function(String) onViewDetails,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orgs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final org = orgs[index];
        final sub = org.activeSubscription;
        final isActive = org.status == 'ACTIVE';

        return AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        AppColors.primary.withAlpha(isDark ? 50 : 25),
                    child: Text(
                      org.name.isNotEmpty ? org.name[0].toUpperCase() : 'O',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  AppSpacing.hSm,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          org.name,
                          style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        AppSpacing.vXs,
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFE2E8F0),
                                borderRadius: AppRadius.sm,
                              ),
                              child: Text(
                                org.slug,
                                style: AppTypography.labelSmall.copyWith(
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            AppSpacing.hSm,
                            Text(
                              '${org.branchesCount} campuses',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.textMutedDark
                                    : AppColors.textMutedLight,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (isActive ? AppColors.success : AppColors.warning)
                          .withAlpha(isDark ? 35 : 20),
                      borderRadius: AppRadius.full,
                      border: Border.all(
                        color: (isActive
                                ? AppColors.success
                                : AppColors.warning)
                            .withAlpha(isDark ? 90 : 60),
                      ),
                    ),
                    child: Text(
                      org.status,
                      style: AppTypography.labelSmall.copyWith(
                        color: isActive ? AppColors.success : AppColors.warning,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Text(
                'Owner: ${org.owner?.fullName ?? 'N/A'} • ${org.owner?.email ?? ''}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  fontSize: 11,
                ),
              ),
              AppSpacing.vSm,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Plan: ${sub?.plan?.name ?? 'No Plan'} (${sub?.billingCycle ?? 'N/A'})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.visibility_outlined, size: 14),
                    label: const Text('View Details'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                    onPressed: () => onViewDetails(org.id),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // 4. Pagination Controls
  // ===========================================================================
  Widget _buildPaginationControls(
    BuildContext context,
    bool isDark,
    PaginationMeta meta, {
    required void Function(int) onPageChange,
  }) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'Showing page ${meta.page} of ${meta.totalPages} (${meta.total} institutions)',
          style: AppTypography.bodySmall.copyWith(
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.chevron_left_rounded, size: 16),
              label: const Text('Previous'),
              onPressed: meta.hasPrevPage
                  ? () => onPageChange(meta.page - 1)
                  : null,
            ),
            AppSpacing.hSm,
            OutlinedButton.icon(
              icon: const Icon(Icons.chevron_right_rounded, size: 16),
              label: const Text('Next'),
              onPressed: meta.hasNextPage
                  ? () => onPageChange(meta.page + 1)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    bool isDark,
    VoidCallback onOnboard,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: AppCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(isDark ? 40 : 20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.corporate_fare_rounded,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              AppSpacing.vMd,
              Text(
                'No Tenant Organizations Found',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              AppSpacing.vXs,
              Text(
                'No institutions match your search query or selected status filters.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              AppSpacing.vLg,
              AppButton(
                text: 'Onboard First Organization',
                icon: Icons.add_business_rounded,
                onPressed: onOnboard,
                height: 42,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Detailed Full Information Modal Dialog for an Organization.
class _OrganizationDetailsDialog extends HookWidget {
  final String orgId;

  const _OrganizationDetailsDialog({required this.orgId});

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'N/A';
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.screenWidth < 600;
    final orgQuery = useOrganizationQuery(orgId);
    final org = orgQuery.dataOrNull;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: isMobile ? 16 : 24,
      ),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 640,
          maxHeight: MediaQuery.sizeOf(context).height * 0.88,
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      org?.name ?? 'Institution Details',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: (isMobile
                              ? AppTypography.titleMedium
                              : AppTypography.titleLarge)
                          .copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 16),

              if (orgQuery.isPending)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (org == null)
                const Expanded(
                  child: Center(
                    child: Text('Institution details not found.'),
                  ),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Overview Header
                        if (isMobile)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.primary
                                        .withAlpha(isDark ? 50 : 25),
                                    child: Text(
                                      org.name.isNotEmpty
                                          ? org.name[0].toUpperCase()
                                          : 'O',
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  AppSpacing.hSm,
                                  Expanded(
                                    child: Text(
                                      org.name,
                                      style: AppTypography.titleSmall.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: isDark
                                            ? AppColors.textPrimaryDark
                                            : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              AppSpacing.vSm,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFE2E8F0),
                                      borderRadius: AppRadius.sm,
                                    ),
                                    child: Text(
                                      org.slug,
                                      style: AppTypography.labelSmall.copyWith(
                                        fontFamily: 'monospace',
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: org.status == 'ACTIVE'
                                          ? AppColors.success
                                              .withAlpha(isDark ? 35 : 20)
                                          : AppColors.warning
                                              .withAlpha(isDark ? 35 : 20),
                                      borderRadius: AppRadius.full,
                                    ),
                                    child: Text(
                                      org.status,
                                      style: AppTypography.labelSmall.copyWith(
                                        color: org.status == 'ACTIVE'
                                            ? AppColors.success
                                            : AppColors.warning,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: AppColors.primary
                                    .withAlpha(isDark ? 50 : 25),
                                child: Text(
                                  org.name.isNotEmpty
                                      ? org.name[0].toUpperCase()
                                      : 'O',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              AppSpacing.hMd,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      org.name,
                                      style: AppTypography.titleMedium.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: isDark
                                            ? AppColors.textPrimaryDark
                                            : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                    Text(
                                      'Subdomain Slug: ${org.slug} • Onboarded: ${_formatDate(org.createdAt)}',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: isDark
                                            ? AppColors.textMutedDark
                                            : AppColors.textMutedLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: org.status == 'ACTIVE'
                                      ? AppColors.success
                                          .withAlpha(isDark ? 35 : 20)
                                      : AppColors.warning
                                          .withAlpha(isDark ? 35 : 20),
                                  borderRadius: AppRadius.full,
                                ),
                                child: Text(
                                  org.status,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: org.status == 'ACTIVE'
                                        ? AppColors.success
                                        : AppColors.warning,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        AppSpacing.vLg,

                        // 1. Subscription & Billing Details
                        _buildSectionHeader(
                          'SUBSCRIPTION & BILLING ENTITLEMENTS',
                          Icons.loyalty_rounded,
                        ),
                        AppSpacing.vSm,
                        _buildInfoCard(
                          isDark,
                          children: [
                            _buildDetailRow(
                              'Subscribed Plan',
                              org.activeSubscription?.plan?.name ??
                                  'No Active Plan',
                              isHighlight: true,
                              isDark: isDark,
                              isMobile: isMobile,
                            ),
                            _buildDetailRow(
                              'Billing Cycle',
                              org.activeSubscription?.billingCycle ?? 'N/A',
                              isDark: isDark,
                              isMobile: isMobile,
                            ),
                            _buildDetailRow(
                              'Subscription Status',
                              org.activeSubscription?.status ?? 'INACTIVE',
                              isDark: isDark,
                              isMobile: isMobile,
                            ),
                            _buildDetailRow(
                              'Subscribed Date',
                              _formatDate(
                                org.activeSubscription?.currentPeriodStart,
                              ),
                              isDark: isDark,
                              isMobile: isMobile,
                            ),
                            _buildDetailRow(
                              'Expires / Renews On',
                              _formatDate(
                                org.activeSubscription?.currentPeriodEnd,
                              ),
                              isHighlight: true,
                              isDark: isDark,
                              isMobile: isMobile,
                            ),
                            if (org.activeSubscription?.plan != null) ...[
                              _buildDetailRow(
                                'Campus Branch Quota',
                                'Up to ${org.activeSubscription!.plan!.maxBranches} Campuses',
                                isDark: isDark,
                                isMobile: isMobile,
                              ),
                              _buildDetailRow(
                                'Student Capacity',
                                '${org.activeSubscription!.plan!.maxStudentsPerBranch} Students / Branch',
                                isDark: isDark,
                                isMobile: isMobile,
                              ),
                            ],
                          ],
                        ),
                        AppSpacing.vLg,

                        // 2. Primary Owner Account Details
                        _buildSectionHeader(
                          'PRIMARY OWNER ACCOUNT',
                          Icons.person_rounded,
                        ),
                        AppSpacing.vSm,
                        _buildInfoCard(
                          isDark,
                          children: [
                            _buildDetailRow(
                              'Owner Name',
                              org.owner?.fullName ?? 'N/A',
                              isDark: isDark,
                              isMobile: isMobile,
                            ),
                            _buildDetailRow(
                              'Owner Email',
                              org.owner?.email ?? 'N/A',
                              isDark: isDark,
                              isMobile: isMobile,
                            ),
                            _buildDetailRow(
                              'Owner Phone',
                              org.owner?.phone ?? 'N/A',
                              isDark: isDark,
                              isMobile: isMobile,
                            ),
                            _buildDetailRow(
                              'Account Status',
                              org.owner?.status ?? 'ACTIVE',
                              isDark: isDark,
                              isMobile: isMobile,
                            ),
                          ],
                        ),
                        AppSpacing.vLg,

                        // 3. Institution Details
                        _buildSectionHeader(
                          'INSTITUTION PROFILE & LOCATION',
                          Icons.business_rounded,
                        ),
                        AppSpacing.vSm,
                        _buildInfoCard(
                          isDark,
                          children: [
                            _buildDetailRow(
                              'Contact Email',
                              org.email ?? 'N/A',
                              isDark: isDark,
                              isMobile: isMobile,
                            ),
                            _buildDetailRow(
                              'Contact Phone',
                              org.phone ?? 'N/A',
                              isDark: isDark,
                              isMobile: isMobile,
                            ),
                            _buildDetailRow(
                              'Address',
                              org.address ?? 'N/A',
                              isDark: isDark,
                              isMobile: isMobile,
                            ),
                            _buildDetailRow(
                              'City / State',
                              '${org.city ?? ''} ${org.state ?? ''}'.trim().isNotEmpty
                                  ? '${org.city ?? ''}, ${org.state ?? ''}'
                                  : 'N/A',
                              isDark: isDark,
                              isMobile: isMobile,
                            ),
                            _buildDetailRow(
                              'Active Campuses',
                              '${org.branchesCount} Branches',
                              isDark: isDark,
                              isMobile: isMobile,
                            ),
                            _buildDetailRow(
                              'Registered Users',
                              '${org.usersCount} Accounts',
                              isDark: isDark,
                              isMobile: isMobile,
                            ),
                          ],
                        ),
                        AppSpacing.vLg,
                      ],
                    ),
                  ),
                ),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        AppSpacing.hSm,
        Text(
          title,
          style: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(bool isDark, {required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B).withAlpha(140)
            : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isHighlight = false,
    required bool isDark,
    bool isMobile = false,
  }) {
    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  fontSize: 11,
                ),
              ),
            ),
            AppSpacing.hSm,
            Expanded(
              flex: 5,
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600,
                  color: isHighlight
                      ? AppColors.primary
                      : (isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600,
                color: isHighlight
                    ? AppColors.primary
                    : (isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Onboard Organization Multi-Step Form Dialog.
class _OnboardOrgDialog extends HookWidget {
  final VoidCallback onSuccess;

  const _OnboardOrgDialog({required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.screenWidth < 600;
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final plansQuery = useSubscriptionPlansQuery();
    final plans = plansQuery.dataOrNull ?? [];

    final orgNameController = useTextEditingController();
    final orgSlugController = useTextEditingController();
    final orgEmailController = useTextEditingController();
    final orgPhoneController = useTextEditingController();

    final ownerFirstNameController = useTextEditingController();
    final ownerLastNameController = useTextEditingController();
    final ownerEmailController = useTextEditingController();
    final ownerPasswordController = useTextEditingController();

    final selectedPlanId = useState<String?>(null);
    final selectedBillingCycle = useState<String>('MONTHLY');

    useEffect(() {
      if (plans.isNotEmpty && selectedPlanId.value == null) {
        selectedPlanId.value = plans.first.id;
      }
      return null;
    }, [plans]);

    final onboardMutation = useOnboardOrganizationMutation(
      onSuccess: (_) {
        onSuccess();
        Navigator.of(context).pop();
      },
    );

    void handleSubmit() {
      if (!formKey.currentState!.validate()) return;
      if (selectedPlanId.value == null) return;

      onboardMutation.mutate(
        OnboardOrganizationRequest(
          organization: {
            'name': orgNameController.text.trim(),
            if (orgSlugController.text.trim().isNotEmpty)
              'slug': orgSlugController.text.trim(),
            if (orgEmailController.text.trim().isNotEmpty)
              'email': orgEmailController.text.trim(),
            if (orgPhoneController.text.trim().isNotEmpty)
              'phone': orgPhoneController.text.trim(),
          },
          subscription: {
            'planId': selectedPlanId.value!,
            'billingCycle': selectedBillingCycle.value,
            'status': 'ACTIVE',
          },
          owner: {
            'firstName': ownerFirstNameController.text.trim(),
            if (ownerLastNameController.text.trim().isNotEmpty)
              'lastName': ownerLastNameController.text.trim(),
            'email': ownerEmailController.text.trim(),
            'password': ownerPasswordController.text,
          },
        ),
      );
    }

    final orgProfileFields = [
      AppTextField(
        controller: orgNameController,
        label: 'Institution Name *',
        hint: 'e.g. Apex Public School',
        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
      ),
      AppSpacing.vSm,
      if (isMobile) ...[
        AppTextField(
          controller: orgEmailController,
          label: 'Contact Email',
          hint: 'contact@apex.edu.in',
        ),
        AppSpacing.vSm,
        AppTextField(
          controller: orgPhoneController,
          label: 'Contact Phone',
          hint: '+91 9876543210',
        ),
      ] else
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: orgEmailController,
                label: 'Contact Email',
                hint: 'contact@apex.edu.in',
              ),
            ),
            AppSpacing.hMd,
            Expanded(
              child: AppTextField(
                controller: orgPhoneController,
                label: 'Contact Phone',
                hint: '+91 9876543210',
              ),
            ),
          ],
        ),
    ];

    final planDropdownField = DropdownButtonFormField<String>(
      initialValue: selectedPlanId.value,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Select Subscription Tier *',
        isDense: true,
      ),
      items: plans.map((p) {
        return DropdownMenuItem(
          value: p.id,
          child: Text(
            '${p.name} (₹${p.priceMonthly.toInt()}/mo)',
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (v) => selectedPlanId.value = v,
    );

    final billingCycleDropdownField = DropdownButtonFormField<String>(
      initialValue: selectedBillingCycle.value,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Billing Cycle',
        isDense: true,
      ),
      items: const [
        DropdownMenuItem(value: 'MONTHLY', child: Text('Monthly')),
        DropdownMenuItem(value: 'YEARLY', child: Text('Yearly')),
      ],
      onChanged: (v) => selectedBillingCycle.value = v ?? 'MONTHLY',
    );

    final ownerAccountFields = [
      if (isMobile) ...[
        AppTextField(
          controller: ownerFirstNameController,
          label: 'Principal / Admin First Name *',
          hint: 'John',
          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
        ),
        AppSpacing.vSm,
        AppTextField(
          controller: ownerLastNameController,
          label: 'Last Name',
          hint: 'Doe',
        ),
      ] else
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: ownerFirstNameController,
                label: 'Principal / Admin First Name *',
                hint: 'John',
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
            ),
            AppSpacing.hMd,
            Expanded(
              child: AppTextField(
                controller: ownerLastNameController,
                label: 'Last Name',
                hint: 'Doe',
              ),
            ),
          ],
        ),
      AppSpacing.vSm,
      AppTextField(
        controller: ownerEmailController,
        label: 'Owner Login Email *',
        hint: 'principal@apex.edu.in',
        keyboardType: TextInputType.emailAddress,
        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
      ),
      AppSpacing.vSm,
      AppTextField(
        controller: ownerPasswordController,
        label: 'Initial Password *',
        hint: '••••••••',
        obscureText: true,
        validator: (v) {
          if (v == null || v.isEmpty) return 'Required';
          if (v.length < 6) return 'At least 6 chars';
          return null;
        },
      ),
    ];

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: isMobile ? 16 : 24,
      ),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 580,
          maxHeight: MediaQuery.sizeOf(context).height * 0.90,
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Onboard Institution',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: (isMobile
                                ? AppTypography.titleMedium
                                : AppTypography.titleLarge)
                            .copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                AppSpacing.vMd,
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'INSTITUTION PROFILE',
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: AppColors.primary,
                          ),
                        ),
                        AppSpacing.vSm,
                        ...orgProfileFields,
                        AppSpacing.vLg,

                        Text(
                          'SUBSCRIPTION TIER',
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: AppColors.primary,
                          ),
                        ),
                        AppSpacing.vSm,
                        if (isMobile) ...[
                          planDropdownField,
                          AppSpacing.vSm,
                          billingCycleDropdownField,
                        ] else
                          Row(
                            children: [
                              Expanded(flex: 2, child: planDropdownField),
                              AppSpacing.hMd,
                              Expanded(child: billingCycleDropdownField),
                            ],
                          ),
                        AppSpacing.vLg,

                        Text(
                          'PRIMARY OWNER / PRINCIPAL CREDENTIALS',
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: AppColors.primary,
                          ),
                        ),
                        AppSpacing.vSm,
                        ...ownerAccountFields,
                      ],
                    ),
                  ),
                ),
                AppSpacing.vLg,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    AppSpacing.hSm,
                    AppButton(
                      text: 'Provision Institution',
                      isLoading: onboardMutation.isPending,
                      onPressed: handleSubmit,
                      height: 42,
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
}
