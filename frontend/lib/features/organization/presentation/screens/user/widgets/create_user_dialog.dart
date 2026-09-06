import 'dart:math';
import 'package:flutter/material.dart';

import 'package:frontend/api/models/models.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/app_radius.dart';
import 'package:frontend/app/theme/app_spacing.dart';
import 'package:frontend/app/theme/app_typography.dart';
import 'package:frontend/core/extensions/context_extensions.dart';
import 'package:frontend/shared/widgets/app_button.dart';
import 'package:frontend/shared/widgets/app_text_field.dart';

/// Production-ready dialog to Create or Edit an Organization User.
class CreateUserDialog extends StatefulWidget {
  final OrgUserModel? user;
  final List<OrgRoleModel> availableRoles;
  final Future<void> Function(CreateOrgUserRequest request)? onCreate;
  final Future<void> Function(String userId, UpdateOrgUserRequest request)? onUpdate;

  const CreateUserDialog({
    super.key,
    this.user,
    required this.availableRoles,
    this.onCreate,
    this.onUpdate,
  });

  static Future<void> show({
    required BuildContext context,
    OrgUserModel? user,
    required List<OrgRoleModel> availableRoles,
    Future<void> Function(CreateOrgUserRequest request)? onCreate,
    Future<void> Function(String userId, UpdateOrgUserRequest request)? onUpdate,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CreateUserDialog(
        user: user,
        availableRoles: availableRoles,
        onCreate: onCreate,
        onUpdate: onUpdate,
      ),
    );
  }

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;

  String _department = 'IT';
  String _status = 'ACTIVE';
  bool _sendWelcomeEmail = true;
  bool _obscurePassword = true;
  bool _isSubmitting = false;
  late List<String> _selectedRoleIds;

  final List<String> _departments = [
    'IT',
    'HR',
    'Academics',
    'Finance',
    'Sales',
    'Operations',
    'Reception',
    'Management',
  ];

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    _firstNameController = TextEditingController(text: u?.firstName ?? '');
    _lastNameController = TextEditingController(text: u?.lastName ?? '');
    _emailController = TextEditingController(text: u?.email ?? '');
    _phoneController = TextEditingController(text: u?.phone ?? '');
    _passwordController = TextEditingController(text: u == null ? _generateSecurePassword() : '');
    _department = u?.department ?? 'IT';
    _status = u?.status ?? 'ACTIVE';

    if (u != null && u.roles.isNotEmpty) {
      _selectedRoleIds = u.roles.map((r) => r.id).toList();
    } else {
      final defaultRole = widget.availableRoles.where((r) => r.isDefault).firstOrNull;
      _selectedRoleIds = [defaultRole?.id ?? widget.availableRoles.firstOrNull?.id ?? '3'];
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _generateSecurePassword() {
    const chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789@#\$%';
    final random = Random.secure();
    return List.generate(10, (_) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRoleIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one role for this user.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      if (widget.user != null) {
        if (widget.onUpdate != null) {
          final req = UpdateOrgUserRequest(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            department: _department,
            status: _status,
            roleIds: _selectedRoleIds,
          );
          await widget.onUpdate!(widget.user!.id, req);
        }
      } else {
        if (widget.onCreate != null) {
          final req = CreateOrgUserRequest(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            phone: _phoneController.text.trim(),
            department: _department,
            status: _status,
            roleIds: _selectedRoleIds,
            sendWelcomeEmail: _sendWelcomeEmail,
          );
          await widget.onCreate!(req);
        }
      }
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isEditing = widget.user != null;

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(25),
                  borderRadius: AppRadius.sm,
                ),
                child: Icon(
                  isEditing ? Icons.manage_accounts_rounded : Icons.person_add_alt_1_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              AppSpacing.hMd,
              Text(
                isEditing ? 'Edit User Profile' : 'Create New Organization User',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
      content: SizedBox(
        width: 620,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing
                      ? 'Update account information, department, and role access.'
                      : 'Add a new member to your organization and grant appropriate role-based permissions.',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                AppSpacing.vLg,

                // 1. Basic Info (First & Last Name)
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _firstNameController,
                        label: 'First Name *',
                        hint: 'e.g. Rahul',
                        prefixIcon: const Icon(Icons.badge_outlined, size: 18),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'First name is required' : null,
                      ),
                    ),
                    AppSpacing.hMd,
                    Expanded(
                      child: AppTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        hint: 'e.g. Sharma',
                        prefixIcon: const Icon(Icons.badge_outlined, size: 18),
                      ),
                    ),
                  ],
                ),
                AppSpacing.vMd,

                // 2. Email & Phone
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _emailController,
                        label: 'Email Address *',
                        hint: 'rahul.s@institute.org',
                        prefixIcon: const Icon(Icons.email_outlined, size: 18),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Email is required';
                          if (!v.contains('@') || !v.contains('.')) return 'Invalid email address';
                          return null;
                        },
                      ),
                    ),
                    AppSpacing.hMd,
                    Expanded(
                      child: AppTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        hint: '+91 98765 43210',
                        prefixIcon: const Icon(Icons.phone_outlined, size: 18),
                      ),
                    ),
                  ],
                ),
                AppSpacing.vMd,

                // 3. Password (Only if creating)
                if (!isEditing) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _passwordController,
                          label: 'Initial Temporary Password *',
                          hint: '••••••••',
                          obscureText: _obscurePassword,
                          prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              size: 18,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          validator: (v) =>
                              v == null || v.length < 6 ? 'Min 6 characters required' : null,
                        ),
                      ),
                      AppSpacing.hSm,
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _passwordController.text = _generateSecurePassword();
                            });
                          },
                          icon: const Icon(Icons.autorenew_rounded, size: 16),
                          label: const Text('Generate', style: TextStyle(fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vMd,
                ],

                // 4. Department & Status
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Department', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                          AppSpacing.vXs,
                          DropdownButtonFormField<String>(
                            initialValue: _department,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              border: OutlineInputBorder(borderRadius: AppRadius.sm),
                            ),
                            items: _departments.map((d) {
                              return DropdownMenuItem(value: d, child: Text(d));
                            }).toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _department = v);
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
                          Text('Account Status', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                          AppSpacing.vXs,
                          DropdownButtonFormField<String>(
                            initialValue: _status,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              border: OutlineInputBorder(borderRadius: AppRadius.sm),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'ACTIVE', child: Text('Active')),
                              DropdownMenuItem(value: 'INACTIVE', child: Text('Inactive')),
                              DropdownMenuItem(value: 'SUSPENDED', child: Text('Suspended')),
                            ],
                            onChanged: (v) {
                              if (v != null) setState(() => _status = v);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.vLg,

                // 5. Assign Roles Section
                Text(
                  'Assign Roles *',
                  style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                AppSpacing.vXs,
                Text(
                  'Select one or multiple roles to define access privileges across the system:',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                AppSpacing.vSm,
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.availableRoles.map((role) {
                    final isSelected = _selectedRoleIds.contains(role.id) ||
                        _selectedRoleIds.contains(role.name);

                    return FilterChip(
                      selected: isSelected,
                      label: Text(
                        role.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                        ),
                      ),
                      selectedColor: AppColors.primary,
                      checkmarkColor: Colors.white,
                      backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.sm,
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        ),
                      ),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            if (!_selectedRoleIds.contains(role.id)) {
                              _selectedRoleIds.add(role.id);
                            }
                          } else {
                            if (_selectedRoleIds.length > 1) {
                              _selectedRoleIds.remove(role.id);
                              _selectedRoleIds.remove(role.name);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('At least one role must remain assigned.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                AppSpacing.vMd,

                if (!isEditing)
                  Row(
                    children: [
                      Checkbox(
                        value: _sendWelcomeEmail,
                        activeColor: AppColors.primary,
                        onChanged: (v) => setState(() => _sendWelcomeEmail = v ?? true),
                      ),
                      Expanded(
                        child: Text(
                          'Send login credentials and onboarding instructions to user email',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          text: isEditing ? 'Save Changes' : 'Create User',
          icon: isEditing ? Icons.check_rounded : Icons.person_add_rounded,
          isLoading: _isSubmitting,
          onPressed: _handleSubmit,
        ),
      ],
    );
  }
}
