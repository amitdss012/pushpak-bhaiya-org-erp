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

class AccessControlScreen extends StatefulWidget {
  const AccessControlScreen({super.key});

  @override
  State<AccessControlScreen> createState() => _AccessControlScreenState();
}

class _AccessControlScreenState extends State<AccessControlScreen> {
  String _selectedRole = 'Manager';

  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'dashboard',
      'name': 'Dashboard',
      'description': 'Access to dashboard and overview features',
      'permissions': [
        {'id': 'view_dashboard', 'name': 'View Dashboard', 'description': 'Access to main dashboard', 'enabled': true, 'locked': false},
        {'id': 'view_analytics', 'name': 'View Analytics', 'description': 'Access to analytics data', 'enabled': true, 'locked': false},
        {'id': 'export_reports', 'name': 'Export Reports', 'description': 'Download reports', 'enabled': false, 'locked': false},
      ],
    },
    {
      'id': 'student_management',
      'name': 'Student Management',
      'description': 'Manage student records and admissions',
      'permissions': [
        {'id': 'view_students', 'name': 'View Students', 'description': 'View student list', 'enabled': true, 'locked': false},
        {'id': 'add_student', 'name': 'Add Student', 'description': 'Create new student', 'enabled': false, 'locked': false},
        {'id': 'edit_student', 'name': 'Edit Student', 'description': 'Modify student data', 'enabled': false, 'locked': false},
        {'id': 'delete_student', 'name': 'Delete Student', 'description': 'Remove student', 'enabled': false, 'locked': true},
      ],
    },
    {
      'id': 'attendance',
      'name': 'Attendance Management',
      'description': 'Manage attendance tracking',
      'permissions': [
        {'id': 'mark_attendance', 'name': 'Mark Attendance', 'description': 'Mark daily attendance', 'enabled': true, 'locked': false},
        {'id': 'view_attendance', 'name': 'View Attendance', 'description': 'View attendance records', 'enabled': true, 'locked': false},
        {'id': 'edit_attendance', 'name': 'Edit Attendance', 'description': 'Modify attendance', 'enabled': false, 'locked': false},
        {'id': 'export_attendance', 'name': 'Export Attendance', 'description': 'Download attendance data', 'enabled': false, 'locked': false},
      ],
    },
    {
      'id': 'exam_management',
      'name': 'Exam & Marks',
      'description': 'Manage exams and marks',
      'permissions': [
        {'id': 'create_exam', 'name': 'Create Exam', 'description': 'Schedule new exam', 'enabled': false, 'locked': false},
        {'id': 'view_exam', 'name': 'View Exams', 'description': 'View exam schedule', 'enabled': true, 'locked': false},
        {'id': 'assign_marks', 'name': 'Assign Marks', 'description': 'Enter student marks', 'enabled': false, 'locked': false},
        {'id': 'edit_marks', 'name': 'Edit Marks', 'description': 'Modify marks', 'enabled': false, 'locked': true},
      ],
    },
    {
      'id': 'fee_management',
      'name': 'Fee Management',
      'description': 'Manage fee collection and tracking',
      'permissions': [
        {'id': 'collect_fee', 'name': 'Collect Fee', 'description': 'Receive fee payments', 'enabled': false, 'locked': false},
        {'id': 'view_fee', 'name': 'View Fee Records', 'description': 'View fee details', 'enabled': true, 'locked': false},
        {'id': 'refund_fee', 'name': 'Process Refund', 'description': 'Issue refunds', 'enabled': false, 'locked': true},
        {'id': 'fee_reports', 'name': 'Fee Reports', 'description': 'Generate fee reports', 'enabled': false, 'locked': false},
      ],
    },
    {
      'id': 'user_management',
      'name': 'User Management',
      'description': 'Manage system users and roles',
      'permissions': [
        {'id': 'view_users', 'name': 'View Users', 'description': 'View user list', 'enabled': true, 'locked': false},
        {'id': 'add_user', 'name': 'Add User', 'description': 'Create new user', 'enabled': false, 'locked': false},
        {'id': 'edit_user', 'name': 'Edit User', 'description': 'Modify user data', 'enabled': false, 'locked': false},
        {'id': 'delete_user', 'name': 'Delete User', 'description': 'Remove user', 'enabled': false, 'locked': true},
        {'id': 'manage_roles', 'name': 'Manage Roles', 'description': 'Assign roles', 'enabled': false, 'locked': true},
      ],
    },
  ];

  void _savePermissions() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Permissions updated successfully for $_selectedRole!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _resetDefaults() {
    setState(() {
      for (var cat in _categories) {
        for (var perm in cat['permissions']) {
          if (!(perm['locked'] as bool)) {
            perm['enabled'] = false;
          }
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reset permissions to defaults.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 28,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          _buildHeader(isDark),
          AppSpacing.vXl,

          // Role Selector Card
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.security_rounded, size: 20, color: AppColors.primary),
                    AppSpacing.hSm,
                    Text('Select Role:', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                    AppSpacing.hMd,
                    SizedBox(
                      width: 180,
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedRole,
                        decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                        items: const [
                          DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                          DropdownMenuItem(value: 'Manager', child: Text('Manager')),
                          DropdownMenuItem(value: 'Employee', child: Text('Employee')),
                          DropdownMenuItem(value: 'HR Manager', child: Text('HR Manager')),
                        ],
                        onChanged: (v) => setState(() => _selectedRole = v!),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  children: [
                    AppButton(
                      text: 'Reset Defaults',
                      icon: Icons.refresh_rounded,
                      variant: AppButtonVariant.outline,
                      onPressed: _resetDefaults,
                      height: 38,
                    ),
                    AppButton(
                      text: 'Save Permissions',
                      icon: Icons.save_rounded,
                      onPressed: _savePermissions,
                      height: 38,
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.vXl,

          // Categories Grid
          ..._categories.map((category) {
            final perms = category['permissions'] as List;
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: AppCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(category['name'] as String, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                            Text(category['description'] as String, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(20),
                            borderRadius: AppRadius.sm,
                          ),
                          child: Text('${perms.length} Permissions', style: AppTypography.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,
                    const Divider(height: 1),
                    AppSpacing.vSm,
                    ...perms.map((perm) {
                      final isLocked = perm['locked'] as bool;
                      final isEnabled = perm['enabled'] as bool;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  if (isLocked)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.error),
                                    ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(perm['name'] as String, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                      Text(perm['description'] as String, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: isEnabled,
                              onChanged: isLocked
                                  ? null
                                  : (val) {
                                      setState(() => perm['enabled'] = val);
                                    },
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => context.go(RouteNames.userAccessControlPath),
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
              'Access Control',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Access Control & Permissions',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Configure granular permissions for each role',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
