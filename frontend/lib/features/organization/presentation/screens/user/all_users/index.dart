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
import 'package:frontend/shared/widgets/app_text_field.dart';
import 'package:frontend/shared/widgets/no_data_found_template.dart';
import '../widgets/assign_role_dialog.dart';
import '../widgets/create_user_dialog.dart';

/// Screen displaying all Organization Users with full CRUD, filter, and role assignment capabilities.
class AllUsersScreen extends HookWidget {
  const AllUsersScreen({super.key});

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return AppColors.primary;
      case 'manager':
        return AppColors.info;
      case 'employee':
        return AppColors.success;
      case 'academic coordinator':
      case 'academic_manager':
        return const Color(0xFF8B5CF6);
      case 'accountant':
        return const Color(0xFFF59E0B);
      case 'receptionist':
        return const Color(0xFFEC4899);
      default:
        return AppColors.warning;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return AppColors.success;
      case 'INACTIVE':
        return AppColors.warning;
      case 'SUSPENDED':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  void _openViewDialog(BuildContext context, OrgUserModel user) {
    final isDark = context.isDarkMode;
    final primaryRole = user.primaryRole;
    final roleColor = _getRoleColor(primaryRole);
    final statusColor = _getStatusColor(user.status);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          title: Text(
            'User Profile Details',
            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: roleColor.withAlpha(30),
                        child: Text(
                          user.firstName.isNotEmpty
                              ? user.firstName.substring(0, 1).toUpperCase()
                              : 'U',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: roleColor,
                          ),
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName,
                              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800),
                            ),
                            Text(
                              user.email,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(20),
                          borderRadius: AppRadius.sm,
                          border: Border.all(color: statusColor.withAlpha(60)),
                        ),
                        child: Text(
                          user.status,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vLg,
                  const Divider(height: 1),
                  AppSpacing.vMd,
                  _buildDetailRow('User / Employee ID:', user.userId, isDark),
                  _buildDetailRow('Phone Number:', user.phone ?? 'Not provided', isDark),
                  _buildDetailRow('Department:', user.department, isDark),
                  _buildDetailRow('Scope:', user.scope, isDark),
                  _buildDetailRow(
                    'Assigned Roles:',
                    user.roles.map((r) => r.name).join(', '),
                    isDark,
                  ),
                  _buildDetailRow(
                    'Created Date:',
                    user.createdAt != null
                        ? '${user.createdAt!.day}/${user.createdAt!.month}/${user.createdAt!.year}'
                        : 'Recent',
                    isDark,
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
        );
      },
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

  Widget _buildErrorOrAccessDeniedState(Object? error, VoidCallback onRetry) {
    final errStr = error?.toString().toLowerCase() ?? '';
    final isAccessDenied = errStr.contains('403') ||
        errStr.contains('denied') ||
        errStr.contains('unauthorized') ||
        errStr.contains('forbidden') ||
        errStr.contains('permission');

    if (isAccessDenied) {
      return NoDataFoundTemplate.accessDenied(
        message:
            'You do not have permission to view or manage organization users. Please contact your organization administrator.',
        actionText: 'Retry',
        actionIcon: Icons.refresh_rounded,
        onAction: onRetry,
        cardWrapper: false,
      );
    }

    return NoDataFoundTemplate.error(
      message:
          'Failed to retrieve users from the server. Please verify your connection or try again.',
      onRetry: onRetry,
      cardWrapper: false,
    );
  }

  void _openResetPasswordDialog(
    BuildContext context,
    OrgUserModel user,
    void Function(String userId, String pass) onReset,
  ) {
    final passController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        title: Text(
          'Reset Password for ${user.fullName}',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter a new temporary password for this user account:',
                style: AppTypography.bodySmall,
              ),
              AppSpacing.vMd,
              AppTextField(
                controller: passController,
                label: 'New Password',
                hint: '••••••••',
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Update Password',
            icon: Icons.lock_reset_rounded,
            onPressed: () {
              if (passController.text.trim().length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password must be at least 6 characters.')),
                );
                return;
              }
              Navigator.of(dialogCtx).pop();
              onReset(user.id, passController.text.trim());
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;

    final searchQuery = useState<String>('');
    final selectedDepartment = useState<String>('all');
    final selectedRole = useState<String>('all');
    final selectedStatus = useState<String>('all');

    final usersQuery = useOrgUsersQuery(
      search: searchQuery.value,
      department: selectedDepartment.value,
      role: selectedRole.value,
      status: selectedStatus.value,
    );

    final rolesQuery = useOrgRolesQuery();
    final availableRoles = rolesQuery.dataOrNull ?? [];

    final createUserMutation = useCreateOrgUserMutation(
      onSuccess: (_) => usersQuery.refetch(),
    );

    final updateUserMutation = useUpdateOrgUserMutation(
      onSuccess: (_) => usersQuery.refetch(),
    );

    final assignRolesMutation = useAssignUserRolesMutation(
      onSuccess: (_) => usersQuery.refetch(),
    );

    final resetPasswordMutation = useResetUserPasswordMutation();

    final deleteUserMutation = useDeleteOrgUserMutation(
      onSuccess: (_) => usersQuery.refetch(),
    );

    final users = usersQuery.dataOrNull ?? [];
    final activeCount = users.where((u) => u.status.toUpperCase() == 'ACTIVE').length;
    final inactiveCount = users.where((u) => u.status.toUpperCase() != 'ACTIVE').length;
    final departments = {'all', ...users.map((u) => u.department).toSet()};

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
                        'User Management',
                        style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w800),
                      ),
                      AppSpacing.vXs,
                      Text(
                        'Create users, assign organizational roles, and configure system access privileges.',
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
                      onPressed: () => context.goNamed(RouteNames.userRoles),
                      icon: const Icon(Icons.shield_outlined, size: 18),
                      label: const Text('Manage Roles'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                      ),
                    ),
                    AppButton(
                      text: 'Add New User',
                      icon: Icons.person_add_rounded,
                      onPressed: () {
                        CreateUserDialog.show(
                          context: context,
                          availableRoles: availableRoles,
                          onCreate: (req) async {
                            createUserMutation.mutate(req);
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
                      title: 'Total Users',
                      value: '${users.length}',
                      icon: Icons.people_alt_rounded,
                      variant: OrgStatsCardVariant.primary,
                      trend: const OrgStatsCardTrend(value: 12, isPositive: true),
                    ),
                    OrgStatsCard(
                      title: 'Active Users',
                      value: '$activeCount',
                      icon: Icons.check_circle_rounded,
                      variant: OrgStatsCardVariant.success,
                      trend: const OrgStatsCardTrend(value: 8, isPositive: true),
                    ),
                    OrgStatsCard(
                      title: 'Inactive / Suspended',
                      value: '$inactiveCount',
                      icon: Icons.pause_circle_filled_rounded,
                      variant: OrgStatsCardVariant.warning,
                      trend: const OrgStatsCardTrend(value: 2, isPositive: false),
                    ),
                    OrgStatsCard(
                      title: 'Configured Roles',
                      value: '${availableRoles.length}',
                      icon: Icons.admin_panel_settings_rounded,
                      variant: OrgStatsCardVariant.info,
                      trend: const OrgStatsCardTrend(value: 4, isPositive: true),
                    ),
                  ],
                );
              },
            ),
            AppSpacing.vLg,

            // Filters & Search Card
            AppCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search by user name, email, or employee ID...',
                            prefixIcon: const Icon(Icons.search_rounded, size: 20),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: AppRadius.sm),
                          ),
                          onChanged: (v) => searchQuery.value = v,
                        ),
                      ),
                      if (!isMobile) ...[
                        AppSpacing.hMd,
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedDepartment.value,
                            decoration: InputDecoration(
                              labelText: 'Department',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              border: OutlineInputBorder(borderRadius: AppRadius.sm),
                            ),
                            items: departments.map((d) {
                              return DropdownMenuItem(
                                value: d,
                                child: Text(d == 'all' ? 'All Departments' : d),
                              );
                            }).toList(),
                            onChanged: (v) {
                              if (v != null) selectedDepartment.value = v;
                            },
                          ),
                        ),
                        AppSpacing.hMd,
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedRole.value,
                            decoration: InputDecoration(
                              labelText: 'Role',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              border: OutlineInputBorder(borderRadius: AppRadius.sm),
                            ),
                            items: [
                              const DropdownMenuItem(value: 'all', child: Text('All Roles')),
                              ...availableRoles.map((r) => DropdownMenuItem(value: r.name, child: Text(r.name))),
                            ],
                            onChanged: (v) {
                              if (v != null) selectedRole.value = v;
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.vLg,

            // User Table Card
            AppCard(
              padding: EdgeInsets.zero,
              child: usersQuery.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(60),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : usersQuery.isError
                      ? _buildErrorOrAccessDeniedState(
                          usersQuery.failureReason,
                          usersQuery.refetch,
                        )
                      : users.isEmpty
                          ? NoDataFoundTemplate(
                              icon: Icons.group_off_rounded,
                              title: 'No Users Found',
                              message: (searchQuery.value.isNotEmpty ||
                                      selectedDepartment.value != 'all' ||
                                      selectedRole.value != 'all' ||
                                      selectedStatus.value != 'all')
                                  ? 'No organization users match your search criteria or selected filters.'
                                  : 'No user accounts have been created in this organization yet. Click below to add the first user.',
                              actionText: 'Add New User',
                              actionIcon: Icons.person_add_alt_1_rounded,
                              onAction: () {
                                CreateUserDialog.show(
                                  context: context,
                                  availableRoles: availableRoles,
                                  onCreate: (req) async {
                                    createUserMutation.mutate(req);
                                  },
                                );
                              },
                              secondaryActionText:
                                  (searchQuery.value.isNotEmpty ||
                                          selectedDepartment.value != 'all' ||
                                          selectedRole.value != 'all' ||
                                          selectedStatus.value != 'all')
                                      ? 'Clear Filters'
                                      : null,
                              onSecondaryAction: (searchQuery.value.isNotEmpty ||
                                      selectedDepartment.value != 'all' ||
                                      selectedRole.value != 'all' ||
                                      selectedStatus.value != 'all')
                                  ? () {
                                      searchQuery.value = '';
                                      selectedDepartment.value = 'all';
                                      selectedRole.value = 'all';
                                      selectedStatus.value = 'all';
                                    }
                                  : null,
                              cardWrapper: false,
                            )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            horizontalMargin: 20,
                            columnSpacing: 24,
                            headingRowColor: WidgetStateProperty.all(
                              isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                            ),
                            columns: const [
                              DataColumn(label: Text('USER PROFILE')),
                              DataColumn(label: Text('EMPLOYEE ID')),
                              DataColumn(label: Text('ASSIGNED ROLES')),
                              DataColumn(label: Text('DEPARTMENT')),
                              DataColumn(label: Text('STATUS')),
                              DataColumn(label: Text('ACTIONS')),
                            ],
                            rows: users.map((user) {
                              final statusColor = _getStatusColor(user.status);

                              return DataRow(
                                cells: [
                                  // User profile
                                  DataCell(
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          backgroundColor: AppColors.primary.withAlpha(25),
                                          child: Text(
                                            user.firstName.isNotEmpty
                                                ? user.firstName.substring(0, 1).toUpperCase()
                                                : 'U',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                        AppSpacing.hMd,
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              user.fullName,
                                              style: AppTypography.bodySmall.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              user.email,
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
                                  ),

                                  // ID
                                  DataCell(
                                    Text(
                                      user.userId,
                                      style: AppTypography.bodySmall.copyWith(
                                        fontFamily: 'monospace',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  // Roles chips
                                  DataCell(
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 4,
                                      children: user.roles.map((r) {
                                        final color = _getRoleColor(r.name);
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: color.withAlpha(20),
                                            borderRadius: AppRadius.sm,
                                            border: Border.all(color: color.withAlpha(60)),
                                          ),
                                          child: Text(
                                            r.name,
                                            style: AppTypography.bodySmall.copyWith(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: color,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),

                                  // Department
                                  DataCell(Text(user.department, style: AppTypography.bodySmall)),

                                  // Status
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: statusColor.withAlpha(20),
                                        borderRadius: AppRadius.sm,
                                        border: Border.all(color: statusColor.withAlpha(60)),
                                      ),
                                      child: Text(
                                        user.status,
                                        style: AppTypography.bodySmall.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: statusColor,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Actions
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.visibility_outlined, size: 18),
                                          tooltip: 'View Profile',
                                          onPressed: () => _openViewDialog(context, user),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.assignment_ind_outlined, size: 18),
                                          tooltip: 'Assign Roles',
                                          color: AppColors.primary,
                                          onPressed: () {
                                            AssignRoleDialog.show(
                                              context: context,
                                              user: user,
                                              availableRoles: availableRoles,
                                              onAssign: (req) async {
                                                assignRolesMutation.mutate(req);
                                              },
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined, size: 18),
                                          tooltip: 'Edit User',
                                          onPressed: () {
                                            CreateUserDialog.show(
                                              context: context,
                                              user: user,
                                              availableRoles: availableRoles,
                                              onUpdate: (id, req) async {
                                                updateUserMutation.mutate(
                                                  UpdateOrgUserParams(id: id, data: req),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        PopupMenuButton<String>(
                                          icon: const Icon(Icons.more_vert_rounded, size: 18),
                                          onSelected: (action) {
                                            switch (action) {
                                              case 'reset_pass':
                                                _openResetPasswordDialog(
                                                  context,
                                                  user,
                                                  (uid, p) {
                                                    resetPasswordMutation.mutate(
                                                      ResetUserPasswordParams(
                                                        userId: uid,
                                                        newPassword: p,
                                                      ),
                                                    );
                                                  },
                                                );
                                                break;
                                              case 'toggle_status':
                                                final newStatus = user.status == 'ACTIVE'
                                                    ? 'INACTIVE'
                                                    : 'ACTIVE';
                                                updateUserMutation.mutate(
                                                  UpdateOrgUserParams(
                                                    id: user.id,
                                                    data: UpdateOrgUserRequest(status: newStatus),
                                                  ),
                                                );
                                                break;
                                              case 'delete':
                                                deleteUserMutation.mutate(user.id);
                                                break;
                                            }
                                          },
                                          itemBuilder: (_) => [
                                            const PopupMenuItem(
                                              value: 'reset_pass',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.lock_reset_rounded, size: 16),
                                                  SizedBox(width: 8),
                                                  Text('Reset Password'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'toggle_status',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    user.status == 'ACTIVE'
                                                        ? Icons.pause_circle_outline
                                                        : Icons.play_circle_outline,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(user.status == 'ACTIVE'
                                                      ? 'Deactivate User'
                                                      : 'Activate User'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete_outline_rounded,
                                                      size: 16, color: AppColors.error),
                                                  SizedBox(width: 8),
                                                  Text('Delete User',
                                                      style: TextStyle(color: AppColors.error)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
