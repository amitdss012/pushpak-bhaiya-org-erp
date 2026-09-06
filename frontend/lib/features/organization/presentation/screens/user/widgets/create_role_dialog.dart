import 'package:flutter/material.dart';

import 'package:frontend/api/models/models.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/app_radius.dart';
import 'package:frontend/app/theme/app_spacing.dart';
import 'package:frontend/app/theme/app_typography.dart';
import 'package:frontend/core/extensions/context_extensions.dart';
import 'package:frontend/shared/widgets/app_button.dart';
import 'package:frontend/shared/widgets/app_text_field.dart';

/// Dialog to Create or Edit an Organization Custom Role with Permission assignment.
class CreateRoleDialog extends StatefulWidget {
  final OrgRoleModel? role;
  final List<OrgPermissionCategory> categories;
  final Future<void> Function(CreateOrgRoleRequest request)? onCreate;
  final Future<void> Function(String roleId, UpdateOrgRoleRequest request)? onUpdate;

  const CreateRoleDialog({
    super.key,
    this.role,
    required this.categories,
    this.onCreate,
    this.onUpdate,
  });

  static Future<void> show({
    required BuildContext context,
    OrgRoleModel? role,
    required List<OrgPermissionCategory> categories,
    Future<void> Function(CreateOrgRoleRequest request)? onCreate,
    Future<void> Function(String roleId, UpdateOrgRoleRequest request)? onUpdate,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CreateRoleDialog(
        role: role,
        categories: categories,
        onCreate: onCreate,
        onUpdate: onUpdate,
      ),
    );
  }

  @override
  State<CreateRoleDialog> createState() => _CreateRoleDialogState();
}

class _CreateRoleDialogState extends State<CreateRoleDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _slugController;
  late final TextEditingController _descController;

  String _scope = 'ORGANIZATION';
  bool _isDefault = false;
  bool _isSubmitting = false;
  late Set<String> _selectedPermissions;

  @override
  void initState() {
    super.initState();
    final r = widget.role;
    _nameController = TextEditingController(text: r?.name ?? '');
    _slugController = TextEditingController(text: r?.slug ?? '');
    _descController = TextEditingController(text: r?.description ?? '');
    _scope = r?.scope ?? 'ORGANIZATION';
    _isDefault = r?.isDefault ?? false;
    _selectedPermissions = Set<String>.from(r?.permissions ?? ['view_dashboard']);

    _nameController.addListener(() {
      if (widget.role == null) {
        final generated = _nameController.text
            .trim()
            .toLowerCase()
            .replaceAll(RegExp(r'\s+'), '_')
            .replaceAll(RegExp(r'[^a-z0-9_]'), '');
        _slugController.text = generated;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _applyTemplate(String template) {
    setState(() {
      switch (template) {
        case 'admin':
          _nameController.text = 'Administrator';
          _descController.text = 'Full administrative control across all modules';
          _selectedPermissions = widget.categories
              .expand((c) => c.permissions.map((p) => p.key))
              .toSet();
          break;
        case 'academic_manager':
          _nameController.text = 'Academic Coordinator';
          _descController.text = 'Manages courses, batches, exams, and attendance';
          _selectedPermissions = {
            'view_dashboard',
            'view_analytics',
            'view_students',
            'create_student',
            'edit_student',
            'view_courses',
            'create_course',
            'manage_batches',
            'batch_timings',
            'view_exams',
            'create_exam',
            'assign_marks',
            'generate_marksheet',
            'view_attendance',
            'mark_attendance',
          };
          break;
        case 'accountant':
          _nameController.text = 'Accountant / Cashier';
          _descController.text = 'Handles fee collection, refunds, and expense vouchers';
          _selectedPermissions = {
            'view_dashboard',
            'view_fees',
            'collect_fee',
            'refund_fee',
            'fee_reports',
            'expense_vouchers',
            'view_students',
          };
          break;
        case 'receptionist':
          _nameController.text = 'Front-Desk Receptionist';
          _descController.text = 'Visitor logs, courier dispatch, and direct enquiries';
          _selectedPermissions = {
            'view_dashboard',
            'view_enquiries',
            'create_enquiry',
            'manage_dispatch',
            'manage_receive',
            'view_students',
          };
          break;
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPermissions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one permission for this role.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      if (widget.role != null) {
        if (widget.onUpdate != null) {
          final req = UpdateOrgRoleRequest(
            name: _nameController.text.trim(),
            description: _descController.text.trim(),
            scope: _scope,
            isDefault: _isDefault,
            permissions: _selectedPermissions.toList(),
          );
          await widget.onUpdate!(widget.role!.id, req);
        }
      } else {
        if (widget.onCreate != null) {
          final req = CreateOrgRoleRequest(
            name: _nameController.text.trim(),
            slug: _slugController.text.trim(),
            scope: _scope,
            description: _descController.text.trim(),
            isDefault: _isDefault,
            permissions: _selectedPermissions.toList(),
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
    final isEditing = widget.role != null;

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
                  isEditing ? Icons.edit_note_rounded : Icons.admin_panel_settings_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              AppSpacing.hMd,
              Text(
                isEditing ? 'Edit Role: ${widget.role!.name}' : 'Create New Organization Role',
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
        width: 680,
        height: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isEditing) ...[
                  Text('Quick Role Presets:', style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w700)),
                  AppSpacing.vXs,
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.star_rounded, size: 14, color: AppColors.primary),
                        label: const Text('Admin', style: TextStyle(fontSize: 11)),
                        onPressed: () => _applyTemplate('admin'),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.school_rounded, size: 14, color: AppColors.info),
                        label: const Text('Academic Coordinator', style: TextStyle(fontSize: 11)),
                        onPressed: () => _applyTemplate('academic_manager'),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.account_balance_wallet_rounded, size: 14, color: AppColors.success),
                        label: const Text('Accountant', style: TextStyle(fontSize: 11)),
                        onPressed: () => _applyTemplate('accountant'),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.support_agent_rounded, size: 14, color: AppColors.warning),
                        label: const Text('Receptionist', style: TextStyle(fontSize: 11)),
                        onPressed: () => _applyTemplate('receptionist'),
                      ),
                    ],
                  ),
                  AppSpacing.vMd,
                  const Divider(height: 1),
                  AppSpacing.vMd,
                ],

                // Role Name & Slug
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: AppTextField(
                        controller: _nameController,
                        label: 'Role Title *',
                        hint: 'e.g. Branch Supervisor',
                        prefixIcon: const Icon(Icons.shield_outlined, size: 18),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Role title is required' : null,
                      ),
                    ),
                    AppSpacing.hMd,
                    Expanded(
                      flex: 2,
                      child: AppTextField(
                        controller: _slugController,
                        label: 'Slug Identifier',
                        hint: 'branch_supervisor',
                        prefixIcon: const Icon(Icons.tag_rounded, size: 18),
                        enabled: !isEditing,
                      ),
                    ),
                  ],
                ),
                AppSpacing.vMd,

                // Description
                AppTextField(
                  controller: _descController,
                  label: 'Role Description',
                  hint: 'Specify responsibilities and key areas of access...',
                  prefixIcon: const Icon(Icons.notes_rounded, size: 18),
                ),
                AppSpacing.vMd,

                // Scope & Default Flag
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Role Scope', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                          AppSpacing.vXs,
                          DropdownButtonFormField<String>(
                            initialValue: _scope,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              border: OutlineInputBorder(borderRadius: AppRadius.sm),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'ORGANIZATION', child: Text('Organization Wide')),
                              DropdownMenuItem(value: 'BRANCH', child: Text('Branch Specific')),
                            ],
                            onChanged: (v) {
                              if (v != null) setState(() => _scope = v);
                            },
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.hMd,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _isDefault,
                              activeColor: AppColors.primary,
                              onChanged: (v) => setState(() => _isDefault = v ?? false),
                            ),
                            Expanded(
                              child: Text(
                                'Set as Default Role for newly onboarded staff',
                                style: AppTypography.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.vLg,

                // Permission Selection Chips Grouped by Module
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Assigned Permissions (${_selectedPermissions.length} selected)',
                      style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedPermissions = widget.categories
                                  .expand((c) => c.permissions.map((p) => p.key))
                                  .toSet();
                            });
                          },
                          child: const Text('Select All', style: TextStyle(fontSize: 12)),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => _selectedPermissions = {'view_dashboard'});
                          },
                          child: const Text('Deselect All', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
                AppSpacing.vSm,

                // Category wise chips
                ...widget.categories.map((cat) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                      borderRadius: AppRadius.sm,
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cat.name,
                              style: AppTypography.labelSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  final allKeys = cat.permissions.map((p) => p.key).toSet();
                                  if (_selectedPermissions.containsAll(allKeys)) {
                                    _selectedPermissions.removeAll(allKeys);
                                  } else {
                                    _selectedPermissions.addAll(allKeys);
                                  }
                                });
                              },
                              child: Text(
                                'Toggle Category',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.vXs,
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: cat.permissions.map((perm) {
                            final isSelected = _selectedPermissions.contains(perm.key);
                            return FilterChip(
                              label: Text(perm.name, style: const TextStyle(fontSize: 11)),
                              selected: isSelected,
                              selectedColor: AppColors.primary,
                              checkmarkColor: Colors.white,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedPermissions.add(perm.key);
                                  } else {
                                    _selectedPermissions.remove(perm.key);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }),
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
          text: isEditing ? 'Save Changes' : 'Create Role',
          icon: isEditing ? Icons.check_rounded : Icons.add_moderator_rounded,
          isLoading: _isSubmitting,
          onPressed: _handleSubmit,
        ),
      ],
    );
  }
}
