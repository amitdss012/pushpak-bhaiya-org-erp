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
import 'package:frontend/core/utils/use_app_mutation.dart';
import 'package:frontend/shared/widgets/app_button.dart';
import 'package:frontend/shared/widgets/app_card.dart';
import 'package:frontend/shared/widgets/no_data_found_template.dart';

/// Interactive Access Control Permission Matrix screen for managing granular privileges per role.
class AccessControlScreen extends HookWidget {
  final String? initialRoleId;
  const AccessControlScreen({super.key, this.initialRoleId});

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
            'You do not have permission to configure access control permissions. Please contact your organization administrator.',
        actionText: 'Retry',
        actionIcon: Icons.refresh_rounded,
        onAction: onRetry,
      );
    }

    return NoDataFoundTemplate.error(
      message:
          'Failed to retrieve access control permissions from the server. Please check your connection and try again.',
      onRetry: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    final rolesQuery = useOrgRolesQuery();
    final permissionsQuery = useOrgPermissionsQuery();

    final roles = rolesQuery.dataOrNull ?? [];
    final categories = permissionsQuery.dataOrNull ?? [];

    final selectedRoleId = useState<String>(initialRoleId ?? '');
    final activePermissions = useState<Set<String>>({});
    final initialPermissions = useState<Set<String>>({});
    final searchFilter = useState<String>('');

    // Fetch granular permissions specifically for the chosen role
    final roleQuery = useOrgRoleQuery(
      selectedRoleId.value,
      enabled: selectedRoleId.value.isNotEmpty,
    );

    final updatePermissionsMutation = useUpdateRolePermissionsMutation(
      onSuccess: (_) {
        rolesQuery.refetch();
        roleQuery.refetch();
      },
    );

    // Initialize or sync selected role when roles load
    useEffect(() {
      if (roles.isNotEmpty) {
        if (selectedRoleId.value.isEmpty ||
            !roles.any((r) => r.id == selectedRoleId.value)) {
          final target = (initialRoleId != null && roles.any((r) => r.id == initialRoleId))
              ? roles.firstWhere((r) => r.id == initialRoleId)
              : roles.first;
          selectedRoleId.value = target.id;
          final perms = Set<String>.from(target.permissions);
          activePermissions.value = perms;
          initialPermissions.value = Set<String>.from(perms);
        }
      }
      return null;
    }, [roles]);

    // When the selected role's permissions arrive from the backend, update state and render
    useEffect(() {
      final roleData = roleQuery.dataOrNull;
      if (roleData != null && roleData.id == selectedRoleId.value) {
        final perms = Set<String>.from(roleData.permissions);
        activePermissions.value = perms;
        initialPermissions.value = Set<String>.from(perms);
      }
      return null;
    }, [roleQuery.dataOrNull, selectedRoleId.value]);

    // Handle role switch - immediately update role, show cached permissions or clear and fetch fresh
    void onRoleChanged(String? newRoleId) {
      if (newRoleId == null || newRoleId == selectedRoleId.value) return;
      selectedRoleId.value = newRoleId;
      final targetRole = roles.where((r) => r.id == newRoleId).firstOrNull;
      if (targetRole != null && targetRole.permissions.isNotEmpty) {
        final perms = Set<String>.from(targetRole.permissions);
        activePermissions.value = perms;
        initialPermissions.value = Set<String>.from(perms);
      } else {
        activePermissions.value = {};
        initialPermissions.value = {};
      }
    }

    final selectedRole = roles.where((r) => r.id == selectedRoleId.value).firstOrNull;
    final isDirty = !_setsEqual(activePermissions.value, initialPermissions.value);
    final totalPermsCount = categories.fold<int>(0, (sum, c) => sum + c.permissions.length);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => context.goNamed(RouteNames.userRoles),
                            icon: const Icon(Icons.arrow_back_rounded),
                            tooltip: 'Back to Roles',
                          ),
                          AppSpacing.hSm,
                          Text(
                            'Access Control Matrix',
                            style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      AppSpacing.vXs,
                      Text(
                        'Configure granular permission capabilities and feature access rights across all modules.',
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
                      onPressed: isDirty
                          ? () {
                              activePermissions.value = Set<String>.from(initialPermissions.value);
                            }
                          : null,
                      icon: const Icon(Icons.restore_rounded, size: 18),
                      label: const Text('Reset Changes'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                      ),
                    ),
                    AppButton(
                      text: 'Save Permissions',
                      icon: Icons.check_circle_outline_rounded,
                      isLoading: updatePermissionsMutation.isLoading,
                      onPressed: (isDirty && selectedRoleId.value.isNotEmpty)
                          ? () {
                              updatePermissionsMutation.mutate(
                                UpdateRolePermissionsRequest(
                                  roleId: selectedRoleId.value,
                                  permissions: activePermissions.value.toList(),
                                ),
                              );
                              initialPermissions.value =
                                  Set<String>.from(activePermissions.value);
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            ),
            AppSpacing.vLg,

            if (rolesQuery.isLoading || permissionsQuery.isLoading)
              const Padding(
                padding: EdgeInsets.all(60),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (rolesQuery.isError || permissionsQuery.isError)
              _buildErrorOrAccessDenied(
                rolesQuery.failureReason ?? permissionsQuery.failureReason,
                () {
                  rolesQuery.refetch();
                  permissionsQuery.refetch();
                },
              )
            else if (roles.isEmpty)
              NoDataFoundTemplate(
                icon: Icons.shield_outlined,
                title: 'No Roles Configured',
                message:
                    'There are no roles available in this organization. Create a role first to configure its access permissions.',
                actionText: 'Go to Roles',
                actionIcon: Icons.arrow_back_rounded,
                onAction: () => context.goNamed(RouteNames.userRoles),
              )
            else if (categories.isEmpty)
              NoDataFoundTemplate(
                icon: Icons.rule_folder_outlined,
                title: 'No Permissions Found',
                message:
                    'No system permissions catalog was returned by the server.',
                actionText: 'Retry',
                actionIcon: Icons.refresh_rounded,
                onAction: () => permissionsQuery.refetch(),
              )
            else ...[
              // Role Selector & Control Toolbar
              AppCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Role picker dropdown
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<String>(
                            key: ValueKey(selectedRoleId.value),
                            initialValue: roles.any((r) => r.id == selectedRoleId.value)
                                ? selectedRoleId.value
                                : null,
                            decoration: InputDecoration(
                              labelText: 'Select Role to Configure',
                              prefixIcon: const Icon(Icons.shield_outlined, size: 20),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(borderRadius: AppRadius.sm),
                            ),
                            items: roles.map((r) {
                              return DropdownMenuItem(
                                value: r.id,
                                child: Row(
                                  children: [
                                    Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    if (r.isDefault) ...[
                                      const SizedBox(width: 8),
                                      const Text('(Default)', style: TextStyle(fontSize: 11, color: AppColors.info)),
                                    ],
                                    if (r.isSystem) ...[
                                      const SizedBox(width: 8),
                                      const Text('(System)', style: TextStyle(fontSize: 11, color: AppColors.warning)),
                                    ],
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: onRoleChanged,
                          ),
                        ),
                        AppSpacing.hMd,

                        // Live search
                        Expanded(
                          flex: 4,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search permission key or module...',
                              prefixIcon: const Icon(Icons.search_rounded, size: 20),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(borderRadius: AppRadius.sm),
                            ),
                            onChanged: (v) => searchFilter.value = v,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,

                    // Summary bar & bulk actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(20),
                                borderRadius: AppRadius.sm,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (roleQuery.isLoading) ...[
                                    const SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Fetching Permissions...',
                                      style: AppTypography.bodySmall.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ] else
                                    Text(
                                      '${activePermissions.value.length} of $totalPermsCount Permissions Granted',
                                      style: AppTypography.bodySmall.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (selectedRole?.isSystem == true) ...[
                              AppSpacing.hSm,
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withAlpha(20),
                                  borderRadius: AppRadius.sm,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.lock_outline_rounded,
                                        size: 14, color: AppColors.warning),
                                    const SizedBox(width: 4),
                                    Text(
                                      'System Admin Role',
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.warning,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                final allKeys = categories
                                    .expand((c) => c.permissions.map((p) => p.key))
                                    .toSet();
                                activePermissions.value = allKeys;
                              },
                              icon: const Icon(Icons.select_all_rounded, size: 16),
                              label: const Text('Grant All', style: TextStyle(fontSize: 12)),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                activePermissions.value = {'view_dashboard'};
                              },
                              icon: const Icon(Icons.deselect_rounded, size: 16),
                              label: const Text('Revoke All', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppSpacing.vLg,

              // Permission Categories Cards
              if (roleQuery.isLoading && activePermissions.value.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(50),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (searchFilter.value.trim().isNotEmpty &&
                  categories.every((c) => c.permissions.where((p) {
                        final q = searchFilter.value.trim().toLowerCase();
                        return p.name.toLowerCase().contains(q) ||
                            p.key.toLowerCase().contains(q) ||
                            (p.description?.toLowerCase().contains(q) ?? false) ||
                            c.name.toLowerCase().contains(q);
                      }).isEmpty))
                NoDataFoundTemplate(
                  icon: Icons.search_off_rounded,
                  title: 'No Matching Permissions',
                  message:
                      'No permissions match your search "${searchFilter.value}".',
                  actionText: 'Clear Search',
                  onAction: () => searchFilter.value = '',
                  isCompact: true,
                )
              else
                ...categories.map((category) {
                final filteredPerms = category.permissions.where((p) {
                  if (searchFilter.value.trim().isEmpty) return true;
                  final q = searchFilter.value.trim().toLowerCase();
                  return p.name.toLowerCase().contains(q) ||
                      p.key.toLowerCase().contains(q) ||
                      (p.description?.toLowerCase().contains(q) ?? false) ||
                      category.name.toLowerCase().contains(q);
                }).toList();

                if (filteredPerms.isEmpty) return const SizedBox.shrink();

                final categoryKeys = category.permissions.map((p) => p.key).toSet();
                final enabledInCategory =
                    activePermissions.value.where((k) => categoryKeys.contains(k)).length;
                final allCategoryEnabled = enabledInCategory == category.permissions.length;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      category.name,
                                      style: AppTypography.titleMedium.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    AppSpacing.hSm,
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: enabledInCategory > 0
                                            ? AppColors.primary.withAlpha(20)
                                            : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                                        borderRadius: AppRadius.sm,
                                      ),
                                      child: Text(
                                        '$enabledInCategory / ${category.permissions.length}',
                                        style: AppTypography.bodySmall.copyWith(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: enabledInCategory > 0
                                              ? AppColors.primary
                                              : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                AppSpacing.vXs,
                                Text(
                                  category.description,
                                  style: AppTypography.bodySmall.copyWith(
                                    fontSize: 11,
                                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                final updated = Set<String>.from(activePermissions.value);
                                if (allCategoryEnabled) {
                                  updated.removeAll(categoryKeys);
                                } else {
                                  updated.addAll(categoryKeys);
                                }
                                activePermissions.value = updated;
                              },
                              child: Text(
                                allCategoryEnabled ? 'Deselect Module' : 'Select Module',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.vMd,
                        const Divider(height: 1),
                        AppSpacing.vMd,

                        // Grid of permission toggle switches
                        LayoutBuilder(
                          builder: (ctx, constraints) {
                            final cols = constraints.maxWidth > 900 ? 2 : 1;
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cols,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 12,
                                mainAxisExtent: 80,
                              ),
                              itemCount: filteredPerms.length,
                              itemBuilder: (ctx, pIdx) {
                                final perm = filteredPerms[pIdx];
                                final isGranted = activePermissions.value.contains(perm.key);

                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isGranted
                                        ? AppColors.primary.withAlpha(isDark ? 25 : 10)
                                        : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                                    borderRadius: AppRadius.sm,
                                    border: Border.all(
                                      color: isGranted
                                          ? AppColors.primary.withAlpha(80)
                                          : (isDark ? AppColors.borderDark : AppColors.borderLight),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    perm.name,
                                                    style: AppTypography.labelMedium.copyWith(
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                if (perm.isLocked) ...[
                                                  const SizedBox(width: 4),
                                                  const Icon(
                                                    Icons.shield_outlined,
                                                    size: 14,
                                                    color: AppColors.warning,
                                                  ),
                                                ],
                                              ],
                                            ),
                                            Text(
                                              perm.description ?? perm.key,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTypography.bodySmall.copyWith(
                                                fontSize: 11,
                                                color: isDark
                                                    ? AppColors.textMutedDark
                                                    : AppColors.textMutedLight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Switch(
                                        value: isGranted,
                                        activeThumbColor: AppColors.primary,
                                        onChanged: (val) {
                                          final updated =
                                              Set<String>.from(activePermissions.value);
                                          if (val) {
                                            updated.add(perm.key);
                                          } else {
                                            updated.remove(perm.key);
                                          }
                                          activePermissions.value = updated;
                                        },
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
              }),
            ],
          ],
        ),
      ),
    );
  }

  bool _setsEqual(Set<String> a, Set<String> b) {
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }
}
