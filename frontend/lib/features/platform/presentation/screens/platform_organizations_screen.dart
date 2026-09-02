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

/// Platform Multi-Tenant Organizations Management Screen.
/// Fully responsive across Mobile, Tablet, Desktop, and Ultra-wide resolutions.
class PlatformOrganizationsScreen extends HookWidget {
  const PlatformOrganizationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.screenWidth < 700;

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
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Responsive Header & Action Bar
              _buildHeader(context, isDark, isMobile, showOnboardOrgDialog),
              AppSpacing.vLg,

              // 2. Responsive Search & Filter Bar
              _buildSearchFilterBar(
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
                _buildOrganizationsList(
                  context,
                  isDark,
                  isMobile,
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
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    bool isMobile,
    VoidCallback onOnboard,
  ) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Organizations',
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          AppSpacing.vXs,
          Text(
            'Manage tenant organizations, subscriptions, and instances.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Organizations',
                style: AppTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              AppSpacing.vXs,
              Text(
                'Manage tenant organizations, subscriptions, and provision new instances.',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildSearchFilterBar(
    BuildContext context,
    bool isDark,
    bool isMobile,
    TextEditingController searchController,
    ValueNotifier<String> searchQuery,
    ValueNotifier<String?> selectedStatus,
    ValueNotifier<int> currentPage,
  ) {
    final searchInput = TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search by organization name or email...',
        prefixIcon: const Icon(Icons.search_rounded, size: 20),
        suffixIcon: searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, size: 18),
                onPressed: () {
                  searchController.clear();
                  searchQuery.value = '';
                },
              )
            : null,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: AppRadius.sm),
      ),
      onSubmitted: (val) {
        searchQuery.value = val.trim();
        currentPage.value = 1;
      },
    );

    final statusDropdown = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selectedStatus.value,
          hint: const Text('All Statuses'),
          isExpanded: isMobile,
          items: const [
            DropdownMenuItem(value: null, child: Text('All Statuses')),
            DropdownMenuItem(value: 'ACTIVE', child: Text('Active Only')),
            DropdownMenuItem(value: 'SUSPENDED', child: Text('Suspended')),
            DropdownMenuItem(value: 'PENDING', child: Text('Pending')),
          ],
          onChanged: (val) {
            selectedStatus.value = val;
            currentPage.value = 1;
          },
        ),
      ),
    );

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                searchInput,
                AppSpacing.vSm,
                statusDropdown,
              ],
            )
          : Row(
              children: [
                Expanded(child: searchInput),
                AppSpacing.hMd,
                statusDropdown,
              ],
            ),
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
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(isDark ? 40 : 20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.corporate_fare_rounded,
                  size: 36,
                  color: AppColors.primary,
                ),
              ),
              AppSpacing.vMd,
              Text(
                'No Organizations Found',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              AppSpacing.vXs,
              Text(
                'No tenant organizations match your search filter or criteria.',
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
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrganizationsList(
    BuildContext context,
    bool isDark,
    bool isMobile,
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

        return AppCard(
          padding: const EdgeInsets.all(16),
          child: InkWell(
            onTap: () => onViewDetails(org.id),
            borderRadius: AppRadius.md,
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
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
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
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF334155)
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
                            ],
                          ),
                          AppSpacing.vXs,
                          Text(
                            'Owner: ${org.owner?.fullName ?? 'N/A'} • ${org.owner?.email ?? ''}',
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: org.status == 'ACTIVE'
                            ? AppColors.success.withAlpha(isDark ? 40 : 20)
                            : AppColors.warning.withAlpha(isDark ? 40 : 20),
                        borderRadius: AppRadius.full,
                        border: Border.all(
                          color: org.status == 'ACTIVE'
                              ? AppColors.success.withAlpha(100)
                              : AppColors.warning.withAlpha(100),
                        ),
                      ),
                      child: Text(
                        org.status,
                        style: AppTypography.labelSmall.copyWith(
                          color: org.status == 'ACTIVE'
                              ? AppColors.success
                              : AppColors.warning,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Plan: ${sub?.plan?.name ?? 'No Plan'} (${sub?.billingCycle ?? 'N/A'})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.visibility_outlined, size: 16),
                      label: const Text('View Details'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => onViewDetails(org.id),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
          'Page ${meta.page} of ${meta.totalPages} (${meta.total} orgs)',
          style: AppTypography.bodySmall.copyWith(
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.chevron_left_rounded, size: 16),
              label: const Text('Prev'),
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
          maxWidth: 620,
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
                      org?.name ?? 'Organization Details',
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
                  child: Center(child: Text('Organization details not found.')),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status & Profile Overview
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
                                        fontWeight: FontWeight.w700,
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
                                          ? const Color(0xFF334155)
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
                                              .withAlpha(isDark ? 40 : 20)
                                          : AppColors.warning
                                              .withAlpha(isDark ? 40 : 20),
                                      borderRadius: AppRadius.full,
                                      border: Border.all(
                                        color: org.status == 'ACTIVE'
                                            ? AppColors.success.withAlpha(100)
                                            : AppColors.warning.withAlpha(100),
                                      ),
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
                                        fontWeight: FontWeight.w700,
                                        color: isDark
                                            ? AppColors.textPrimaryDark
                                            : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                    Text(
                                      'Slug: ${org.slug} • Onboarded: ${_formatDate(org.createdAt)}',
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
                                          .withAlpha(isDark ? 40 : 20)
                                      : AppColors.warning
                                          .withAlpha(isDark ? 40 : 20),
                                  borderRadius: AppRadius.full,
                                  border: Border.all(
                                    color: org.status == 'ACTIVE'
                                        ? AppColors.success.withAlpha(100)
                                        : AppColors.warning.withAlpha(100),
                                  ),
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

                        // 1. Subscription Details Card
                        _buildSectionHeader(
                          'SUBSCRIPTION & BILLING DETAILS',
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
                            if (org.activeSubscription?.trialEndsAt != null)
                              _buildDetailRow(
                                'Trial Ends At',
                                _formatDate(
                                  org.activeSubscription?.trialEndsAt,
                                ),
                                isDark: isDark,
                                isMobile: isMobile,
                              ),
                            if (org.activeSubscription?.plan != null) ...[
                              _buildDetailRow(
                                'Plan Branch Limit',
                                'Up to ${org.activeSubscription!.plan!.maxBranches} Branches',
                                isDark: isDark,
                                isMobile: isMobile,
                              ),
                              _buildDetailRow(
                                'Student Quota',
                                '${org.activeSubscription!.plan!.maxStudentsPerBranch} Students / Branch',
                                isDark: isDark,
                                isMobile: isMobile,
                              ),
                            ],
                          ],
                        ),
                        AppSpacing.vLg,

                        // 2. Primary Owner Details Card
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

                        // 3. Organization Contacts
                        _buildSectionHeader(
                          'ORGANIZATION CONTACT & INFO',
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
                              'Branches Count',
                              '${org.branchesCount} Active Branches',
                              isDark: isDark,
                              isMobile: isMobile,
                            ),
                            _buildDetailRow(
                              'Users Count',
                              '${org.usersCount} Registered Users',
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
      child: Column(
        children: children,
      ),
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

    // Auto-select first plan if available
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
        label: 'Organization Name *',
        hint: 'e.g. Apex Academy',
        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
      ),
      AppSpacing.vSm,
      if (isMobile) ...[
        AppTextField(
          controller: orgEmailController,
          label: 'Org Contact Email',
          hint: 'contact@apex.com',
        ),
        AppSpacing.vSm,
        AppTextField(
          controller: orgPhoneController,
          label: 'Org Contact Phone',
          hint: '+91 9876543210',
        ),
      ] else
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: orgEmailController,
                label: 'Org Contact Email',
                hint: 'contact@apex.com',
              ),
            ),
            AppSpacing.hMd,
            Expanded(
              child: AppTextField(
                controller: orgPhoneController,
                label: 'Org Contact Phone',
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
        labelText: 'Select Plan Tier *',
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
        DropdownMenuItem(
          value: 'MONTHLY',
          child: Text('Monthly'),
        ),
        DropdownMenuItem(
          value: 'YEARLY',
          child: Text('Yearly'),
        ),
      ],
      onChanged: (v) => selectedBillingCycle.value = v ?? 'MONTHLY',
    );

    final ownerAccountFields = [
      if (isMobile) ...[
        AppTextField(
          controller: ownerFirstNameController,
          label: 'First Name *',
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
                label: 'First Name *',
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
        hint: 'john.doe@apex.com',
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
                        'Onboard New Organization',
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
                        // Section 1: Organization Details
                        Text(
                          'ORGANIZATION PROFILE',
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: AppColors.primary,
                          ),
                        ),
                        AppSpacing.vSm,
                        ...orgProfileFields,
                        AppSpacing.vLg,

                        // Section 2: Subscription Plan
                        Text(
                          'SUBSCRIPTION PLAN',
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

                        // Section 3: Owner Account
                        Text(
                          'PRIMARY OWNER ACCOUNT',
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
                      text: 'Provision Organization',
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
