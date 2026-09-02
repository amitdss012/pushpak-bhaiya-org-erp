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

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  String _searchQuery = '';
  String _selectedDepartment = 'all';
  String _selectedRole = 'all';
  String _selectedStatus = 'all';

  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'userId': 'USR001',
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'phone': '+91 9876543210',
      'role': 'Admin',
      'department': 'IT',
      'status': 'active',
      'lastLogin': '2024-03-25 10:30 AM',
      'createdDate': '2024-01-15',
    },
    {
      'id': '2',
      'userId': 'USR002',
      'name': 'Sarah Smith',
      'email': 'sarah.smith@example.com',
      'phone': '+91 9876543211',
      'role': 'Manager',
      'department': 'HR',
      'status': 'active',
      'lastLogin': '2024-03-25 09:15 AM',
      'createdDate': '2024-01-20',
    },
    {
      'id': '3',
      'userId': 'USR003',
      'name': 'Mike Johnson',
      'email': 'mike.johnson@example.com',
      'phone': '+91 9876543212',
      'role': 'Employee',
      'department': 'Sales',
      'status': 'active',
      'lastLogin': '2024-03-24 06:45 PM',
      'createdDate': '2024-02-01',
    },
    {
      'id': '4',
      'userId': 'USR004',
      'name': 'Emily Davis',
      'email': 'emily.davis@example.com',
      'phone': '+91 9876543213',
      'role': 'Employee',
      'department': 'IT',
      'status': 'inactive',
      'lastLogin': '2024-03-20 02:30 PM',
      'createdDate': '2024-02-10',
    },
  ];

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return AppColors.primary;
      case 'manager':
        return AppColors.info;
      case 'employee':
        return AppColors.success;
      default:
        return AppColors.warning;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'inactive':
        return AppColors.warning;
      case 'suspended':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  void _openViewDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = ctx.isDarkMode;
        final roleColor = _getRoleColor(user['role'] as String);
        final statusColor = _getStatusColor(user['status'] as String);

        return AlertDialog(
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
                          (user['name'] as String).substring(0, 1).toUpperCase(),
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: roleColor),
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user['name'] as String, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
                            Text(user['email'] as String, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
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
                          (user['status'] as String).toUpperCase(),
                          style: AppTypography.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vLg,
                  const Divider(height: 1),
                  AppSpacing.vMd,
                  _buildDetailRow('User ID:', user['userId'] as String, isDark),
                  _buildDetailRow('Phone Number:', user['phone'] as String, isDark),
                  _buildDetailRow('Assigned Role:', user['role'] as String, isDark),
                  _buildDetailRow('Department:', user['department'] as String, isDark),
                  _buildDetailRow('Last Login:', user['lastLogin'] as String, isDark),
                  _buildDetailRow('Created Date:', user['createdDate'] as String, isDark),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
            AppButton(
              text: 'Edit User',
              icon: Icons.edit_outlined,
              onPressed: () {
                Navigator.of(ctx).pop();
                _openFormDialog(user: user);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          Text(value, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _openResetPasswordDialog(Map<String, dynamic> user) {
    final passController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text('Reset Password for ${user['name']}', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter a new temporary password for this user:', style: AppTypography.bodySmall),
              AppSpacing.vMd,
              AppTextField(controller: passController, label: 'New Password', hint: '••••••••', obscureText: true),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogCtx).pop(), child: const Text('Cancel')),
          AppButton(
            text: 'Update Password',
            icon: Icons.lock_reset_rounded,
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Password reset for ${user['name']}!'), backgroundColor: AppColors.success),
              );
            },
          ),
        ],
      ),
    );
  }

  void _openFormDialog({Map<String, dynamic>? user}) {
    final isEditing = user != null;
    final nameController = TextEditingController(text: user?['name'] ?? '');
    final emailController = TextEditingController(text: user?['email'] ?? '');
    final phoneController = TextEditingController(text: user?['phone'] ?? '');
    final userIdController = TextEditingController(text: user?['userId'] ?? 'USR00${_users.length + 1}');
    String role = user?['role'] ?? 'Employee';
    String department = user?['department'] ?? 'IT';
    String status = user?['status'] ?? 'active';

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: Text(
              isEditing ? 'Edit User Profile' : 'Add New User',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
            ),
            content: SizedBox(
              width: 520,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(child: AppTextField(controller: nameController, label: 'Full Name *', hint: 'John Doe')),
                        AppSpacing.hMd,
                        Expanded(child: AppTextField(controller: userIdController, label: 'User ID *', hint: 'USR005')),
                      ],
                    ),
                    AppSpacing.vMd,
                    Row(
                      children: [
                        Expanded(child: AppTextField(controller: emailController, label: 'Email Address *', hint: 'john@example.com')),
                        AppSpacing.hMd,
                        Expanded(child: AppTextField(controller: phoneController, label: 'Phone Number', hint: '+91 9876543210')),
                      ],
                    ),
                    AppSpacing.vMd,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Role *', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: role,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                                  DropdownMenuItem(value: 'Manager', child: Text('Manager')),
                                  DropdownMenuItem(value: 'Employee', child: Text('Employee')),
                                  DropdownMenuItem(value: 'HR Manager', child: Text('HR Manager')),
                                ],
                                onChanged: (v) => setDialogState(() => role = v!),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.hMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Department *', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: department,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'IT', child: Text('IT')),
                                  DropdownMenuItem(value: 'HR', child: Text('HR')),
                                  DropdownMenuItem(value: 'Sales', child: Text('Sales')),
                                  DropdownMenuItem(value: 'Finance', child: Text('Finance')),
                                ],
                                onChanged: (v) => setDialogState(() => department = v!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Account Status', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                        AppSpacing.vXs,
                        DropdownButtonFormField<String>(
                          initialValue: status,
                          isExpanded: true,
                          decoration: const InputDecoration(),
                          items: const [
                            DropdownMenuItem(value: 'active', child: Text('Active')),
                            DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                            DropdownMenuItem(value: 'suspended', child: Text('Suspended')),
                          ],
                          onChanged: (v) => setDialogState(() => status = v!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(dialogCtx).pop(), child: const Text('Cancel')),
              AppButton(
                text: isEditing ? 'Save Changes' : 'Create User',
                icon: Icons.check_rounded,
                onPressed: () {
                  if (nameController.text.trim().isEmpty || emailController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields.')));
                    return;
                  }
                  setState(() {
                    if (isEditing) {
                      user['name'] = nameController.text.trim();
                      user['userId'] = userIdController.text.trim();
                      user['email'] = emailController.text.trim();
                      user['phone'] = phoneController.text.trim();
                      user['role'] = role;
                      user['department'] = department;
                      user['status'] = status;
                    } else {
                      _users.add({
                        'id': '${DateTime.now().millisecondsSinceEpoch}',
                        'userId': userIdController.text.trim(),
                        'name': nameController.text.trim(),
                        'email': emailController.text.trim(),
                        'phone': phoneController.text.trim(),
                        'role': role,
                        'department': department,
                        'status': status,
                        'lastLogin': 'Never',
                        'createdDate': DateTime.now().toString().split(' ')[0],
                      });
                    }
                  });
                  Navigator.of(dialogCtx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEditing ? 'User profile updated!' : 'New user created!'), backgroundColor: AppColors.success),
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

    final filtered = _users.where((u) {
      final name = (u['name'] as String).toLowerCase();
      final email = (u['email'] as String).toLowerCase();
      final id = (u['userId'] as String).toLowerCase();
      final dept = (u['department'] as String).toLowerCase();
      final role = (u['role'] as String).toLowerCase();
      final status = (u['status'] as String).toLowerCase();
      final q = _searchQuery.toLowerCase();

      final matchesQuery = _searchQuery.isEmpty || name.contains(q) || email.contains(q) || id.contains(q);
      final matchesDept = _selectedDepartment == 'all' || dept == _selectedDepartment.toLowerCase();
      final matchesRole = _selectedRole == 'all' || role == _selectedRole.toLowerCase();
      final matchesStatus = _selectedStatus == 'all' || status == _selectedStatus.toLowerCase();

      return matchesQuery && matchesDept && matchesRole && matchesStatus;
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

          // Filter Card
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.filter_alt_outlined, size: 18, color: AppColors.primary),
                    AppSpacing.hSm,
                    Text('Filter Users', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
                AppSpacing.vMd,
                if (isMobile) ...[
                  TextField(
                    onChanged: (v) => setState(() => _searchQuery = v.trim()),
                    decoration: InputDecoration(
                      hintText: 'Search by name, email, ID...',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      prefixIcon: const Icon(Icons.search_rounded, size: 16),
                      border: OutlineInputBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          onChanged: (v) => setState(() => _searchQuery = v.trim()),
                          decoration: InputDecoration(
                            hintText: 'Search by name, email, ID...',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            prefixIcon: const Icon(Icons.search_rounded, size: 16),
                            border: OutlineInputBorder(borderRadius: AppRadius.sm),
                          ),
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedDepartment,
                          isExpanded: true,
                          decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('All Departments')),
                            DropdownMenuItem(value: 'IT', child: Text('IT')),
                            DropdownMenuItem(value: 'HR', child: Text('HR')),
                            DropdownMenuItem(value: 'Sales', child: Text('Sales')),
                            DropdownMenuItem(value: 'Finance', child: Text('Finance')),
                          ],
                          onChanged: (v) => setState(() => _selectedDepartment = v!),
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedRole,
                          isExpanded: true,
                          decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('All Roles')),
                            DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                            DropdownMenuItem(value: 'Manager', child: Text('Manager')),
                            DropdownMenuItem(value: 'Employee', child: Text('Employee')),
                          ],
                          onChanged: (v) => setState(() => _selectedRole = v!),
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedStatus,
                          isExpanded: true,
                          decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('All Status')),
                            DropdownMenuItem(value: 'active', child: Text('Active')),
                            DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                            DropdownMenuItem(value: 'suspended', child: Text('Suspended')),
                          ],
                          onChanged: (v) => setState(() => _selectedStatus = v!),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          AppSpacing.vXl,

          // Full-width Table Card
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'User Directory',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
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
                            _buildDataColumn('USER', isDark),
                            _buildDataColumn('USER ID', isDark),
                            _buildDataColumn('ROLE', isDark),
                            _buildDataColumn('DEPARTMENT', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('LAST LOGIN', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filtered.map((user) {
                            final name = user['name'] as String;
                            final email = user['email'] as String;
                            final userId = user['userId'] as String;
                            final role = user['role'] as String;
                            final dept = user['department'] as String;
                            final status = user['status'] as String;
                            final lastLogin = user['lastLogin'] as String;
                            final roleColor = _getRoleColor(role);
                            final statusColor = _getStatusColor(status);

                            return DataRow(
                              cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: roleColor.withAlpha(30),
                                        child: Text(
                                          name.substring(0, 1).toUpperCase(),
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: roleColor),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                                          Text(email, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(Text(userId, style: AppTypography.bodySmall.copyWith(fontFamily: 'monospace', fontWeight: FontWeight.w600))),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: roleColor.withAlpha(20),
                                      borderRadius: AppRadius.sm,
                                      border: Border.all(color: roleColor.withAlpha(60)),
                                    ),
                                    child: Text(
                                      role,
                                      style: AppTypography.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.w700, color: roleColor),
                                    ),
                                  ),
                                ),
                                DataCell(Text(dept, style: AppTypography.bodySmall)),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: statusColor.withAlpha(20),
                                      borderRadius: AppRadius.sm,
                                      border: Border.all(color: statusColor.withAlpha(60)),
                                    ),
                                    child: Text(
                                      status.toUpperCase(),
                                      style: AppTypography.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor),
                                    ),
                                  ),
                                ),
                                DataCell(Text(lastLogin, style: AppTypography.bodySmall)),
                                DataCell(
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert_rounded, size: 18, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                    onSelected: (val) {
                                      if (val == 'view') {
                                        _openViewDialog(user);
                                      } else if (val == 'edit') {
                                        _openFormDialog(user: user);
                                      } else if (val == 'reset') {
                                        _openResetPasswordDialog(user);
                                      } else if (val == 'delete') {
                                        setState(() => _users.remove(user));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Removed ${user['name']}.'), backgroundColor: AppColors.error),
                                        );
                                      }
                                    },
                                    itemBuilder: (ctx) => [
                                      const PopupMenuItem(
                                        value: 'view',
                                        child: Row(
                                          children: [
                                            Icon(Icons.visibility_outlined, size: 16),
                                            SizedBox(width: 8),
                                            Text('View Profile'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit_outlined, size: 16),
                                            SizedBox(width: 8),
                                            Text('Edit User'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'reset',
                                        child: Row(
                                          children: [
                                            Icon(Icons.lock_reset_rounded, size: 16),
                                            SizedBox(width: 8),
                                            Text('Reset Password'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                                            SizedBox(width: 8),
                                            Text('Delete', style: TextStyle(color: AppColors.error)),
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
    final total = _users.length;
    final active = _users.where((u) => u['status'] == 'active').length;
    final admins = _users.where((u) => u['role'] == 'Admin').length;
    final depts = _users.map((u) => u['department']).toSet().length;

    final cards = [
      OrgStatsCard(
        title: 'Total Users',
        value: '$total',
        subtitle: 'All system accounts',
        icon: Icons.group_outlined,
        variant: OrgStatsCardVariant.primary,
      ),
      OrgStatsCard(
        title: 'Active Users',
        value: '$active',
        subtitle: 'Currently active',
        icon: Icons.check_circle_outline_rounded,
        variant: OrgStatsCardVariant.success,
      ),
      OrgStatsCard(
        title: 'Administrators',
        value: '$admins',
        subtitle: 'Full access users',
        icon: Icons.admin_panel_settings_outlined,
        variant: OrgStatsCardVariant.warning,
      ),
      OrgStatsCard(
        title: 'Departments',
        value: '$depts',
        subtitle: 'Operational units',
        icon: Icons.apartment_rounded,
        variant: OrgStatsCardVariant.info,
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
              onTap: () => context.go(RouteNames.userAllPath),
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
              'All Users',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'All Users',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Manage system users and their permissions',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionBtn = AppButton(
      text: 'Add New User',
      icon: Icons.add_rounded,
      onPressed: () => _openFormDialog(),
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
