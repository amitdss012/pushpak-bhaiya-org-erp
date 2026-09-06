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
import '../../../../../../shared/widgets/app_text_field.dart';
import '../../../../../../shared/widgets/no_data_found_template.dart';
import '../../../widgets/org_stats_card.dart';

/// Screen displaying all Academic Sessions / Session Years for the Organization
/// with branch mappings, active session toggling, and full CRUD.
class AllSessionYearsScreen extends HookWidget {
  const AllSessionYearsScreen({super.key});

  void _openViewDialog(BuildContext context, AcademicSessionModel session) {
    final isDark = context.isDarkMode;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lg),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                borderRadius: AppRadius.sm,
              ),
              child: const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 20),
            ),
            AppSpacing.hSm,
            Expanded(
              child: Text(
                session.name,
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Session Name', session.name, isDark),
                if (session.code != null && session.code!.isNotEmpty)
                  _buildDetailRow('Session Code', session.code!, isDark),
                _buildDetailRow('Academic Years', '${session.startYear} - ${session.endYear}', isDark),
                _buildDetailRow('Start Date', session.startDate.toLocal().toString().split(' ')[0], isDark),
                _buildDetailRow('End Date', session.endDate.toLocal().toString().split(' ')[0], isDark),
                if (session.createdBy != null)
                  _buildDetailRow('Created By', '${session.createdBy!.fullName} (${session.createdBy!.email})', isDark),
                if (session.description != null && session.description!.isNotEmpty) ...[
                  AppSpacing.vSm,
                  Text(
                    'Description',
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                  AppSpacing.vXs,
                  Text(session.description!, style: AppTypography.bodySmall),
                ],
                AppSpacing.vMd,
                Text(
                  'Branch Mappings (${session.branchMappings.length})',
                  style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                AppSpacing.vXs,
                if (session.branchMappings.isEmpty)
                  Text(
                    'No branches mapped to this master session yet.',
                    style: AppTypography.bodySmall.copyWith(
                      fontStyle: FontStyle.italic,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  )
                else
                  ...session.branchMappings.map(
                    (m) => Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                        borderRadius: AppRadius.sm,
                        border: Border.all(
                          color: m.isCurrent
                              ? AppColors.success.withAlpha(80)
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m.branch?.name ?? 'Branch ${m.branchId.substring(0, 8)}',
                                  style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                ),
                                if (m.createdBy != null)
                                  Text(
                                    'Mapped by ${m.createdBy!.fullName}',
                                    style: AppTypography.labelSmall.copyWith(
                                      fontSize: 10,
                                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (m.isCurrent)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.success.withAlpha(25),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'ACTIVE FOR BRANCH',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.success,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _openEditDialog(
    BuildContext context,
    AcademicSessionModel session,
    void Function(UpdateSessionParams params) onUpdate,
  ) {
    final nameCtrl = TextEditingController(text: session.name);
    final codeCtrl = TextEditingController(text: session.code ?? '');
    final startYearCtrl = TextEditingController(text: session.startYear.toString());
    final endYearCtrl = TextEditingController(text: session.endYear.toString());
    final descCtrl = TextEditingController(text: session.description ?? '');

    DateTime startDate = session.startDate;
    DateTime endDate = session.endDate;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.lg),
          title: Text(
            'Edit Academic Session',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    controller: nameCtrl,
                    label: 'Session Name *',
                    hint: 'e.g. 2025-2026',
                  ),
                  AppSpacing.vMd,
                  AppTextField(
                    controller: codeCtrl,
                    label: 'Session Code',
                    hint: 'e.g. AY-2025-26',
                  ),
                  AppSpacing.vMd,
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: startYearCtrl,
                          label: 'Start Year *',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: AppTextField(
                          controller: endYearCtrl,
                          label: 'End Year *',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vMd,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Start Date', style: AppTypography.labelSmall),
                            AppSpacing.vXs,
                            OutlinedButton.icon(
                              icon: const Icon(Icons.calendar_today, size: 14),
                              label: Text(startDate.toLocal().toString().split(' ')[0]),
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: ctx,
                                  initialDate: startDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setDialogState(() => startDate = picked);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('End Date', style: AppTypography.labelSmall),
                            AppSpacing.vXs,
                            OutlinedButton.icon(
                              icon: const Icon(Icons.calendar_today, size: 14),
                              label: Text(endDate.toLocal().toString().split(' ')[0]),
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: ctx,
                                  initialDate: endDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setDialogState(() => endDate = picked);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vMd,
                  AppTextField(
                    controller: descCtrl,
                    label: 'Description',
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            AppButton(
              text: 'Save Changes',
              onPressed: () {
                final sYear = int.tryParse(startYearCtrl.text.trim());
                final eYear = int.tryParse(endYearCtrl.text.trim());
                if (nameCtrl.text.trim().isEmpty || sYear == null || eYear == null) {
                  return;
                }

                onUpdate(
                  UpdateSessionParams(
                    sessionId: session.id,
                    data: UpdateSessionInput(
                      name: nameCtrl.text.trim(),
                      code: codeCtrl.text.trim().isEmpty ? null : codeCtrl.text.trim(),
                      startYear: sYear,
                      endYear: eYear,
                      startDate: startDate,
                      endDate: endDate,
                      description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                    ),
                  ),
                );
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    AcademicSessionModel session,
    void Function(String id) onDelete,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lg),
        title: Text(
          'Delete Academic Session?',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to delete "${session.name}"? All branch mappings will also be archived.',
          style: AppTypography.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () {
              onDelete(session.id);
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorOrAccessDenied(Object? error, VoidCallback onRetry) {
    final errStr = error?.toString().toLowerCase() ?? '';
    final isAccessDenied = errStr.contains('403') ||
        errStr.contains('denied') ||
        errStr.contains('unauthorized') ||
        errStr.contains('forbidden') ||
        errStr.contains('permission');

    if (isAccessDenied) {
      return NoDataFoundTemplate.accessDenied(
        message:
            'You do not have permission to manage academic sessions. Please contact your administrator.',
        actionText: 'Retry',
        actionIcon: Icons.refresh_rounded,
        onAction: onRetry,
        cardWrapper: false,
      );
    }

    return NoDataFoundTemplate.error(
      message:
          'Failed to retrieve academic sessions from the server. Please check your connection or try again.',
      onRetry: onRetry,
      cardWrapper: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;

    final searchController = useTextEditingController();
    final searchQuery = useState<String>('');
    final selectedBranchId = useState<String?>(null);

    final sessionsQuery = useSessionsQuery(
      params: GetSessionsParams(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        branchId: selectedBranchId.value,
      ),
    );

    final updateSessionMutation = useUpdateSessionMutation(
      onSuccess: (_) => sessionsQuery.refetch(),
    );

    final setBranchCurrentMutation = useSetBranchCurrentSessionMutation(
      onSuccess: (_) => sessionsQuery.refetch(),
    );

    final deleteSessionMutation = useDeleteSessionMutation(
      onSuccess: (_) => sessionsQuery.refetch(),
    );

    final sessionList = sessionsQuery.dataOrNull?.sessions ?? [];
    final totalSessions = sessionList.length;

    // Collect all branches from mappings for the filter dropdown
    final branchMap = <String, String>{};
    for (final s in sessionList) {
      for (final m in s.branchMappings) {
        if (m.branch != null) {
          branchMap[m.branchId] = m.branch!.name;
        }
      }
    }

    final activeAcrossBranches = sessionList
        .where((s) => s.branchMappings.any((m) => m.isCurrent))
        .length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Academic Sessions',
                        style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w800),
                      ),
                      AppSpacing.vXs,
                      Text(
                        'Manage school academic years, start & end dates, and active branch sessions.',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                    ],
                  ),
                ),
                AppButton(
                  text: 'Add Session Year',
                  icon: Icons.add_rounded,
                  onPressed: () => context.goNamed(RouteNames.sessionAdd),
                ),
              ],
            ),
            AppSpacing.vLg,

            // KPI Stats Row
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                SizedBox(
                  width: isMobile ? double.infinity : 240,
                  child: OrgStatsCard(
                    title: 'Total Sessions',
                    value: totalSessions.toString(),
                    icon: Icons.calendar_today_rounded,
                    variant: OrgStatsCardVariant.primary,
                  ),
                ),
                SizedBox(
                  width: isMobile ? double.infinity : 240,
                  child: OrgStatsCard(
                    title: 'Active in Branches',
                    value: activeAcrossBranches.toString(),
                    icon: Icons.check_circle_outline_rounded,
                    variant: OrgStatsCardVariant.success,
                  ),
                ),
                SizedBox(
                  width: isMobile ? double.infinity : 240,
                  child: OrgStatsCard(
                    title: 'Mapped Branches',
                    value: branchMap.length.toString(),
                    icon: Icons.account_tree_outlined,
                    variant: OrgStatsCardVariant.info,
                  ),
                ),
              ],
            ),
            AppSpacing.vLg,

            // Filter & Search Toolbar
            AppCard(
              child: Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: isMobile ? double.infinity : 300,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by session name or code...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 20),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: AppRadius.sm),
                      ),
                      onChanged: (val) => searchQuery.value = val,
                    ),
                  ),
                  if (branchMap.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                        borderRadius: AppRadius.sm,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: selectedBranchId.value,
                          hint: const Text('All Branches'),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('All Branches')),
                            ...branchMap.entries.map(
                              (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                            ),
                          ],
                          onChanged: (val) => selectedBranchId.value = val,
                        ),
                      ),
                    ),
                  AppButton(
                    text: 'Refresh',
                    variant: AppButtonVariant.secondary,
                    icon: Icons.refresh_rounded,
                    onPressed: () => sessionsQuery.refetch(),
                  ),
                ],
              ),
            ),
            AppSpacing.vLg,

            // Main Content Area
            if (sessionsQuery.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xxl),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (sessionsQuery.failureReason != null)
              _buildErrorOrAccessDenied(
                sessionsQuery.failureReason,
                () => sessionsQuery.refetch(),
              )
            else if (sessionList.isEmpty)
              NoDataFoundTemplate(
                title: 'No Academic Sessions Found',
                message: searchQuery.value.isNotEmpty
                    ? 'No academic session matched "${searchQuery.value}".'
                    : 'Get started by creating your school organization\'s first academic session year.',
                actionText: 'Create Session Year',
                actionIcon: Icons.add_rounded,
                onAction: () => context.goNamed(RouteNames.sessionAdd),
                cardWrapper: true,
              )
            else
              AppCard(
                padding: EdgeInsets.zero,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sessionList.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                  itemBuilder: (ctx, idx) {
                    final session = sessionList[idx];
                    final hasCurrent = session.branchMappings.any((m) => m.isCurrent);

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: hasCurrent
                            ? AppColors.success.withAlpha(25)
                            : AppColors.primary.withAlpha(25),
                        child: Icon(
                          Icons.calendar_month_rounded,
                          color: hasCurrent ? AppColors.success : AppColors.primary,
                          size: 22,
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            session.name,
                            style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                          ),
                          if (session.code != null && session.code!.isNotEmpty) ...[
                            AppSpacing.hSm,
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: (isDark ? Colors.white : Colors.black).withAlpha(15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                session.code!,
                                style: AppTypography.labelSmall.copyWith(fontSize: 10),
                              ),
                            ),
                          ],
                          if (hasCurrent) ...[
                            AppSpacing.hSm,
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.success.withAlpha(25),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.success.withAlpha(50)),
                              ),
                              child: Text(
                                'ACTIVE',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSpacing.vXs,
                          Text(
                            'Years: ${session.startYear} - ${session.endYear}  •  ${session.startDate.toLocal().toString().split(' ')[0]} to ${session.endDate.toLocal().toString().split(' ')[0]}',
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                          if (session.createdBy != null) ...[
                            AppSpacing.vXs,
                            Text(
                              'Created by ${session.createdBy!.fullName}',
                              style: AppTypography.labelSmall.copyWith(
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                fontSize: 11,
                              ),
                            ),
                          ],
                          if (session.branchMappings.isNotEmpty) ...[
                            AppSpacing.vXs,
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: session.branchMappings.map((m) {
                                return InkWell(
                                  onTap: () {
                                    setBranchCurrentMutation.mutate(
                                      SetBranchCurrentSessionParams(
                                        branchId: m.branchId,
                                        branchAcademicSessionId: m.id,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: m.isCurrent
                                          ? AppColors.success.withAlpha(30)
                                          : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: m.isCurrent
                                            ? AppColors.success
                                            : (isDark ? AppColors.borderDark : AppColors.borderLight),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          m.isCurrent ? Icons.check_circle : Icons.radio_button_unchecked,
                                          size: 12,
                                          color: m.isCurrent ? AppColors.success : Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          m.branch?.name ?? 'Branch',
                                          style: AppTypography.labelSmall.copyWith(
                                            fontSize: 10,
                                            fontWeight: m.isCurrent ? FontWeight.w700 : FontWeight.w500,
                                            color: m.isCurrent ? AppColors.success : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined, size: 20),
                            tooltip: 'View Details',
                            onPressed: () => _openViewDialog(context, session),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            tooltip: 'Edit Session',
                            onPressed: () => _openEditDialog(
                              context,
                              session,
                              (params) => updateSessionMutation.mutate(params),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                            tooltip: 'Delete Session',
                            onPressed: () => _confirmDelete(
                              context,
                              session,
                              (id) => deleteSessionMutation.mutate(id),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
