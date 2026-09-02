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
import '../../../../../../shared/widgets/app_text_field.dart';
import '../../../widgets/org_stats_card.dart';

class UserRolesScreen extends StatefulWidget {
  const UserRolesScreen({super.key});

  @override
  State<UserRolesScreen> createState() => _UserRolesScreenState();
}

class _UserRolesScreenState extends State<UserRolesScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _roles = [
    {
      'id': '1',
      'roleName': 'Admin',
      'description': 'Full system access with all permissions',
      'userCount': 5,
      'permissions': ['all'],
      'isDefault': false,
      'createdDate': '2024-01-01',
    },
    {
      'id': '2',
      'roleName': 'Manager',
      'description': 'Can manage team and view reports',
      'userCount': 12,
      'permissions': ['view_reports', 'manage_team', 'approve_requests'],
      'isDefault': true,
      'createdDate': '2024-01-05',
    },
    {
      'id': '3',
      'roleName': 'Employee',
      'description': 'Basic employee access',
      'userCount': 50,
      'permissions': ['view_profile', 'mark_attendance'],
      'isDefault': true,
      'createdDate': '2024-01-10',
    },
    {
      'id': '4',
      'roleName': 'HR Manager',
      'description': 'Human resources management',
      'userCount': 3,
      'permissions': ['manage_employees', 'view_attendance', 'manage_leave'],
      'isDefault': false,
      'createdDate': '2024-01-15',
    },
  ];

  final List<String> _allAvailablePermissions = [
    'view_dashboard',
    'view_students',
    'add_student',
    'edit_student',
    'mark_attendance',
    'view_attendance',
    'create_exam',
    'assign_marks',
    'collect_fee',
    'view_fee',
    'view_users',
    'manage_roles',
  ];

  void _openRoleDialog({Map<String, dynamic>? role}) {
    final isEditing = role != null;
    final nameController = TextEditingController(text: role?['roleName'] ?? '');
    final descController = TextEditingController(text: role?['description'] ?? '');
    bool isDefault = role?['isDefault'] ?? false;
    final selectedPermissions = List<String>.from(role?['permissions'] ?? ['view_dashboard']);

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: Text(
              isEditing ? 'Edit Role: ${role['roleName']}' : 'Create New Role',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
            ),
            content: SizedBox(
              width: 550,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(controller: nameController, label: 'Role Name *', hint: 'e.g., Academic Coordinator'),
                    AppSpacing.vMd,
                    AppTextField(controller: descController, label: 'Description', hint: 'Role responsibilities...'),
                    AppSpacing.vMd,
                    Row(
                      children: [
                        Checkbox(
                          value: isDefault,
                          onChanged: (v) => setDialogState(() => isDefault = v ?? false),
                        ),
                        Text('Set as Default Role for new users', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    AppSpacing.vMd,
                    Text('Assigned Permissions', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700)),
                    AppSpacing.vSm,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _allAvailablePermissions.map((perm) {
                        final isSelected = selectedPermissions.contains(perm);
                        return FilterChip(
                          label: Text(perm.replaceAll('_', ' '), style: const TextStyle(fontSize: 11)),
                          selected: isSelected,
                          onSelected: (selected) {
                            setDialogState(() {
                              if (selected) {
                                selectedPermissions.add(perm);
                              } else {
                                selectedPermissions.remove(perm);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(dialogCtx).pop(), child: const Text('Cancel')),
              AppButton(
                text: isEditing ? 'Save Changes' : 'Create Role',
                icon: Icons.check_rounded,
                onPressed: () {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please provide a role name.')));
                    return;
                  }
                  setState(() {
                    if (isEditing) {
                      role['roleName'] = nameController.text.trim();
                      role['description'] = descController.text.trim();
                      role['isDefault'] = isDefault;
                      role['permissions'] = selectedPermissions;
                    } else {
                      _roles.add({
                        'id': '${DateTime.now().millisecondsSinceEpoch}',
                        'roleName': nameController.text.trim(),
                        'description': descController.text.trim(),
                        'userCount': 0,
                        'permissions': selectedPermissions,
                        'isDefault': isDefault,
                        'createdDate': DateTime.now().toString().split(' ')[0],
                      });
                    }
                  });
                  Navigator.of(dialogCtx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEditing ? 'Role updated!' : 'Role created!'), backgroundColor: AppColors.success),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;

    final filtered = _roles.where((r) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = (r['roleName'] as String).toLowerCase();
        final desc = (r['description'] as String).toLowerCase();
        return name.contains(q) || desc.contains(q);
      }
      return true;
    }).toList();

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

          // 4 Stats Cards
          _buildStatsCards(isMobile),
          AppSpacing.vXl,

          // Full-width Table Card
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
                        'Role Directory',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 260),
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                            borderRadius: AppRadius.sm,
                            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                          ),
                          child: TextField(
                            onChanged: (val) => setState(() => _searchQuery = val.trim()),
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search roles...',
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
                          dataRowMinHeight: 56,
                          dataRowMaxHeight: 64,
                          horizontalMargin: 20,
                          columnSpacing: 20,
                          headingRowColor: WidgetStateProperty.all(
                            isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight.withAlpha(120),
                          ),
                          columns: [
                            _buildDataColumn('ROLE NAME', isDark),
                            _buildDataColumn('DESCRIPTION', isDark),
                            _buildDataColumn('ASSIGNED USERS', isDark),
                            _buildDataColumn('PERMISSIONS', isDark),
                            _buildDataColumn('DEFAULT', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filtered.map((role) {
                            final name = role['roleName'] as String;
                            final desc = role['description'] as String;
                            final count = role['userCount'];
                            final perms = (role['permissions'] as List).cast<String>();
                            final isDef = role['isDefault'] as bool;

                            return DataRow(
                              cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withAlpha(20),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.shield_outlined, size: 16, color: AppColors.primary),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 200),
                                    child: Text(desc, overflow: TextOverflow.ellipsis, style: AppTypography.bodySmall),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                      borderRadius: AppRadius.sm,
                                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                    ),
                                    child: Text('$count Users', style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                                DataCell(
                                  Wrap(
                                    spacing: 4,
                                    children: perms.take(2).map((p) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.info.withAlpha(20),
                                          borderRadius: AppRadius.sm,
                                        ),
                                        child: Text(
                                          p.replaceAll('_', ' '),
                                          style: AppTypography.bodySmall.copyWith(fontSize: 9, color: AppColors.info, fontWeight: FontWeight.w700),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                DataCell(
                                  isDef
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppColors.success.withAlpha(20),
                                            borderRadius: AppRadius.sm,
                                          ),
                                          child: Text('YES', style: AppTypography.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.success)),
                                        )
                                      : Text('NO', style: AppTypography.bodySmall.copyWith(fontSize: 10, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                                ),
                                DataCell(
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert_rounded, size: 18, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                    onSelected: (val) {
                                      if (val == 'edit') {
                                        _openRoleDialog(role: role);
                                      } else if (val == 'delete') {
                                        setState(() => _roles.remove(role));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Removed ${role['roleName']}.'), backgroundColor: AppColors.error),
                                        );
                                      }
                                    },
                                    itemBuilder: (ctx) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit_outlined, size: 16),
                                            SizedBox(width: 8),
                                            Text('Edit Role'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                                            SizedBox(width: 8),
                                            Text('Delete Role', style: TextStyle(color: AppColors.error)),
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

  Widget _buildStatsCards(bool isMobile) {
    final totalRoles = _roles.length;
    final systemRoles = _roles.where((r) => r['roleName'] == 'Admin' || r['roleName'] == 'Employee').length;
    final customRoles = totalRoles - systemRoles;
    final totalAssigned = _roles.fold<int>(0, (sum, r) => sum + (r['userCount'] as int));

    final cards = [
      OrgStatsCard(
        title: 'Total Roles',
        value: '$totalRoles',
        subtitle: 'Configured roles',
        icon: Icons.security_rounded,
        variant: OrgStatsCardVariant.primary,
      ),
      OrgStatsCard(
        title: 'System Roles',
        value: '$systemRoles',
        subtitle: 'Core system roles',
        icon: Icons.shield_rounded,
        variant: OrgStatsCardVariant.info,
      ),
      OrgStatsCard(
        title: 'Custom Roles',
        value: '$customRoles',
        subtitle: 'Organization defined',
        icon: Icons.tune_rounded,
        variant: OrgStatsCardVariant.warning,
      ),
      OrgStatsCard(
        title: 'Assigned Users',
        value: '$totalAssigned',
        subtitle: 'Across all roles',
        icon: Icons.people_outline_rounded,
        variant: OrgStatsCardVariant.success,
      ),
    ];

    if (isMobile) {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList(),
      );
    }

    return Row(
      children: cards
          .map(
            (c) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: c,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildHeader(bool isDark, bool isMobile) {
    final headerTexts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => context.go(RouteNames.userRolesPath),
              child: Text(
                'User Management',
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
              'User Roles',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'User Roles',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Manage system roles and permissions',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionBtn = AppButton(
      text: 'Create New Role',
      icon: Icons.add_rounded,
      onPressed: () => _openRoleDialog(),
      height: 38,
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerTexts,
          AppSpacing.vMd,
          actionBtn,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: headerTexts),
        actionBtn,
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
