import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/api/hooks/hooks.dart';
import 'package:frontend/api/models/models.dart';
import 'package:frontend/app/router/route_names.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/app_radius.dart';
import 'package:frontend/app/theme/app_spacing.dart';
import 'package:frontend/app/theme/app_typography.dart';
import 'package:frontend/core/extensions/context_extensions.dart';
import 'package:frontend/features/organization/presentation/widgets/org_stats_card.dart';
import 'package:frontend/shared/widgets/app_button.dart';
import 'package:frontend/shared/widgets/app_card.dart';
import 'package:frontend/shared/widgets/no_data_found_template.dart';
import '../widgets/create_role_dialog.dart';

class UserRolesScreen extends HookWidget {
  const UserRolesScreen({super.key});

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
            'You do not have permission to view or configure organization roles. Please contact your organization administrator.',
        actionText: 'Retry',
        actionIcon: Icons.refresh_rounded,
        onAction: onRetry,
      );
    }

    return NoDataFoundTemplate.error(
      message:
          'Failed to retrieve roles from the server. Please check your connection and try again.',
      onRetry: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    final searchQuery = useState<String>('');

    final rolesQuery = useOrgRolesQuery();
    final permissionsQuery = useOrgPermissionsQuery();

    final createRoleMutation = useCreateOrgRoleMutation(
      onSuccess: (_) => rolesQuery.refetch(),
    );

    final updateRoleMutation = useUpdateOrgRoleMutation(
      onSuccess: (_) => rolesQuery.refetch(),
    );

    final deleteRoleMutation = useDeleteOrgRoleMutation(
      onSuccess: (_) => rolesQuery.refetch(),
    );

    final roles = rolesQuery.dataOrNull ?? [];
    final categories = permissionsQuery.dataOrNull ?? [];

    final filteredRoles = roles.where((r) {
      if (searchQuery.value.trim().isEmpty) return true;
      final q = searchQuery.value.trim().toLowerCase();
      return r.name.toLowerCase().contains(q) ||
          (r.description?.toLowerCase().contains(q) ?? false);
    }).toList();

    final defaultRolesCount = roles.where((r) => r.isDefault).length;
    final customRolesCount = roles.where((r) => !r.isSystem).length;
    final totalUserCount = roles.fold<int>(0, (sum, r) => sum + r.userCount);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Roles & Access Levels',
                        style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w800),
                      ),
                      AppSpacing.vXs,
                      Text(
                        'Configure custom organizational roles, scope boundaries, and assign permission profiles.',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => context.goNamed(RouteNames.userAccessControl),
                      icon: const Icon(Icons.grid_view_rounded, size: 18),
                      label: const Text('Access Control Matrix'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                      ),
                    ),
                    AppButton(
                      text: 'Create New Role',
                      icon: Icons.add_moderator_rounded,
                      onPressed: () {
                        CreateRoleDialog.show(
                          context: context,
                          categories: categories,
                          onCreate: (req) async {
                            createRoleMutation.mutate(req);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            AppSpacing.vLg,

            // Stats row
            LayoutBuilder(
              builder: (ctx, constraints) {
                final isCompact = constraints.maxWidth < 700;
                return GridView.count(
                  crossAxisCount: isCompact ? 2 : 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isCompact ? 1.8 : 2.2,
                  children: [
                    OrgStatsCard(
                      title: 'Total Roles',
                      value: '${roles.length}',
                      icon: Icons.admin_panel_settings_rounded,
                      variant: OrgStatsCardVariant.primary,
                      trend: const OrgStatsCardTrend(value: 6, isPositive: true),
                    ),
                    OrgStatsCard(
                      title: 'Custom Roles',
                      value: '$customRolesCount',
                      icon: Icons.shield_outlined,
                      variant: OrgStatsCardVariant.info,
                      trend: const OrgStatsCardTrend(value: 3, isPositive: true),
                    ),
                    OrgStatsCard(
                      title: 'Default Roles',
                      value: '$defaultRolesCount',
                      icon: Icons.star_border_rounded,
                      variant: OrgStatsCardVariant.warning,
                      trend: const OrgStatsCardTrend(value: 2, isPositive: true),
                    ),
                    OrgStatsCard(
                      title: 'Assigned User Seats',
                      value: '$totalUserCount',
                      icon: Icons.badge_outlined,
                      variant: OrgStatsCardVariant.success,
                      trend: const OrgStatsCardTrend(value: 70, isPositive: true),
                    ),
                  ],
                );
              },
            ),
            AppSpacing.vLg,

            // Search Bar
            AppCard(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search roles by title, key, or scope...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                ),
                onChanged: (v) => searchQuery.value = v,
              ),
            ),
            AppSpacing.vLg,

            // Roles Grid Cards
            if (rolesQuery.isLoading)
              const Padding(
                padding: EdgeInsets.all(60),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (rolesQuery.isError)
              _buildErrorOrAccessDenied(
                  rolesQuery.failureReason, rolesQuery.refetch)
            else if (filteredRoles.isEmpty)
              NoDataFoundTemplate(
                icon: Icons.shield_outlined,
                title: 'No Roles Found',
                message: searchQuery.value.isNotEmpty
                    ? 'No roles match your search term "${searchQuery.value}".'
                    : 'No roles have been created for this organization yet. Click below to define the first role.',
                actionText: 'Create New Role',
                actionIcon: Icons.add_moderator_rounded,
                onAction: () {
                  CreateRoleDialog.show(
                    context: context,
                    categories: categories,
                    onCreate: (req) async {
                      createRoleMutation.mutate(req);
                    },
                  );
                },
                secondaryActionText:
                    searchQuery.value.isNotEmpty ? 'Clear Search' : null,
                onSecondaryAction: searchQuery.value.isNotEmpty
                    ? () => searchQuery.value = ''
                    : null,
              )
            else
              LayoutBuilder(
                builder: (ctx, constraints) {
                  final crossAxisCount = constraints.maxWidth > 950 ? 2 : 1;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 240,
                    ),
                    itemCount: filteredRoles.length,
                    itemBuilder: (ctx, idx) {
                      final role = filteredRoles[idx];

                      return AppCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header & Badges
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withAlpha(20),
                                        borderRadius: AppRadius.sm,
                                      ),
                                      child: Icon(
                                        role.isSystem
                                            ? Icons.lock_person_rounded
                                            : Icons.admin_panel_settings_rounded,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                    ),
                                    AppSpacing.hMd,
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          role.name,
                                          style: AppTypography.titleMedium.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          role.scope == 'ORGANIZATION'
                                              ? 'Organization Wide Scope'
                                              : 'Branch Level Scope',
                                          style: AppTypography.bodySmall.copyWith(
                                            fontSize: 11,
                                            color: isDark
                                                ? AppColors.textMutedDark
                                                : AppColors.textMutedLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Wrap(
                                  spacing: 6,
                                  children: [
                                    if (role.isDefault)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.info.withAlpha(20),
                                          borderRadius: AppRadius.sm,
                                          border: Border.all(color: AppColors.info.withAlpha(60)),
                                        ),
                                        child: Text(
                                          'DEFAULT',
                                          style: AppTypography.bodySmall.copyWith(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.info,
                                          ),
                                        ),
                                      ),
                                    if (role.isSystem)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.warning.withAlpha(20),
                                          borderRadius: AppRadius.sm,
                                          border: Border.all(color: AppColors.warning.withAlpha(60)),
                                        ),
                                        child: Text(
                                          'SYSTEM',
                                          style: AppTypography.bodySmall.copyWith(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.warning,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            AppSpacing.vMd,

                            // Description
                            Text(
                              role.description ?? 'Custom access role for staff members.',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                            const Spacer(),

                            // Permissions count & Users attached
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.people_outline_rounded,
                                        size: 16, color: AppColors.primary),
                                    AppSpacing.hXs,
                                    Text(
                                      '${role.userCount} users assigned',
                                      style: AppTypography.bodySmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.verified_user_outlined,
                                        size: 16, color: AppColors.success),
                                    AppSpacing.hXs,
                                    Text(
                                      '${role.permissions.length} permissions granted',
                                      style: AppTypography.bodySmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            AppSpacing.vSm,
                            const Divider(height: 1),
                            AppSpacing.vSm,

                            // Actions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    context.goNamed(
                                      RouteNames.userAccessControl,
                                      queryParameters: {'roleId': role.id},
                                    );
                                  },
                                  icon: const Icon(Icons.tune_rounded, size: 16),
                                  label: const Text('Access Matrix', style: TextStyle(fontSize: 12)),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, size: 18),
                                      tooltip: 'Edit Role',
                                      onPressed: () {
                                        CreateRoleDialog.show(
                                          context: context,
                                          role: role,
                                          categories: categories,
                                          onUpdate: (id, req) async {
                                            updateRoleMutation.mutate(
                                              UpdateOrgRoleParams(id: id, data: req),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.copy_rounded, size: 18),
                                      tooltip: 'Clone Role',
                                      onPressed: () {
                                        CreateRoleDialog.show(
                                          context: context,
                                          categories: categories,
                                          role: OrgRoleModel(
                                            id: '',
                                            name: '${role.name} (Copy)',
                                            slug: '${role.slug}_copy',
                                            description: role.description,
                                            scope: role.scope,
                                            permissions: role.permissions,
                                          ),
                                          onCreate: (req) async {
                                            createRoleMutation.mutate(req);
                                          },
                                        );
                                      },
                                    ),
                                    if (!role.isSystem)
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline_rounded,
                                            size: 18, color: AppColors.error),
                                        tooltip: 'Delete Role',
                                        onPressed: () {
                                          deleteRoleMutation.mutate(role.id);
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
