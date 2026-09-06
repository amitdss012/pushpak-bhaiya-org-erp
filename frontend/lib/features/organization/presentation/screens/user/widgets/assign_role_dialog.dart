import 'package:flutter/material.dart';

import 'package:frontend/api/models/models.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/app_radius.dart';
import 'package:frontend/app/theme/app_spacing.dart';
import 'package:frontend/app/theme/app_typography.dart';
import 'package:frontend/core/extensions/context_extensions.dart';
import 'package:frontend/shared/widgets/app_button.dart';

/// Modal dialog specifically designed for assigning and configuring roles for a User.
class AssignRoleDialog extends StatefulWidget {
  final OrgUserModel user;
  final List<OrgRoleModel> availableRoles;
  final Future<void> Function(AssignUserRolesRequest request) onAssign;

  const AssignRoleDialog({
    super.key,
    required this.user,
    required this.availableRoles,
    required this.onAssign,
  });

  static Future<void> show({
    required BuildContext context,
    required OrgUserModel user,
    required List<OrgRoleModel> availableRoles,
    required Future<void> Function(AssignUserRolesRequest request) onAssign,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AssignRoleDialog(
        user: user,
        availableRoles: availableRoles,
        onAssign: onAssign,
      ),
    );
  }

  @override
  State<AssignRoleDialog> createState() => _AssignRoleDialogState();
}

class _AssignRoleDialogState extends State<AssignRoleDialog> {
  late List<String> _selectedRoleIds;
  String? _primaryRoleId;
  String _searchQuery = '';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedRoleIds = widget.user.roles.map((r) => r.id).toList();
    if (_selectedRoleIds.isEmpty && widget.availableRoles.isNotEmpty) {
      _selectedRoleIds = [widget.availableRoles.first.id];
    }
    _primaryRoleId = widget.user.roles.firstOrNull?.id ?? _selectedRoleIds.firstOrNull;
  }

  Future<void> _handleSave() async {
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
      final req = AssignUserRolesRequest(
        userId: widget.user.id,
        roleIds: _selectedRoleIds,
        primaryRoleId: _primaryRoleId,
      );
      await widget.onAssign(req);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    final filteredRoles = widget.availableRoles.where((r) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.trim().toLowerCase();
      return r.name.toLowerCase().contains(q) ||
          (r.description?.toLowerCase().contains(q) ?? false);
    }).toList();

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
                child: const Icon(
                  Icons.assignment_ind_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              AppSpacing.hMd,
              Text(
                'Assign Roles to User',
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
        width: 540,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User header card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: AppRadius.sm,
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary.withAlpha(30),
                      child: Text(
                        widget.user.firstName.isNotEmpty
                            ? widget.user.firstName.substring(0, 1).toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AppSpacing.hMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.fullName,
                            style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${widget.user.email} • ${widget.user.department}',
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.vMd,

              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search roles...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 18),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
              AppSpacing.vMd,

              Text(
                'Available Roles (${widget.availableRoles.length})',
                style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w700),
              ),
              AppSpacing.vXs,

              // Role cards list
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: filteredRoles.length,
                  separatorBuilder: (ctx, idx) => AppSpacing.vSm,
                  itemBuilder: (ctx, idx) {
                    final role = filteredRoles[idx];
                    final isChecked = _selectedRoleIds.contains(role.id) ||
                        _selectedRoleIds.contains(role.name);
                    final isPrimary = _primaryRoleId == role.id;

                    return Container(
                      decoration: BoxDecoration(
                        color: isChecked
                            ? AppColors.primary.withAlpha(isDark ? 30 : 15)
                            : (isDark ? AppColors.surfaceDark : Colors.transparent),
                        borderRadius: AppRadius.sm,
                        border: Border.all(
                          color: isChecked
                              ? AppColors.primary
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          width: isChecked ? 1.5 : 1.0,
                        ),
                      ),
                      child: CheckboxListTile(
                        value: isChecked,
                        activeColor: AppColors.primary,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Row(
                          children: [
                            Text(
                              role.name,
                              style: AppTypography.labelMedium.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (role.isDefault) ...[
                              AppSpacing.hSm,
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.info.withAlpha(20),
                                  borderRadius: AppRadius.sm,
                                ),
                                child: Text(
                                  'DEFAULT',
                                  style: AppTypography.bodySmall.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.info,
                                  ),
                                ),
                              ),
                            ],
                            if (isChecked && isPrimary) ...[
                              AppSpacing.hSm,
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withAlpha(20),
                                  borderRadius: AppRadius.sm,
                                ),
                                child: Text(
                                  'PRIMARY',
                                  style: AppTypography.bodySmall.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (role.description != null && role.description!.isNotEmpty)
                              Text(
                                role.description!,
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 11,
                                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                ),
                              ),
                            Text(
                              '${role.permissions.length} granular permissions granted',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 10,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        onChanged: (selected) {
                          setState(() {
                            if (selected == true) {
                              if (!_selectedRoleIds.contains(role.id)) {
                                _selectedRoleIds.add(role.id);
                              }
                              _primaryRoleId ??= role.id;
                            } else {
                              if (_selectedRoleIds.length > 1) {
                                _selectedRoleIds.remove(role.id);
                                _selectedRoleIds.remove(role.name);
                                if (_primaryRoleId == role.id) {
                                  _primaryRoleId = _selectedRoleIds.firstOrNull;
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('At least one role must remain assigned to the user.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          text: 'Apply Roles',
          icon: Icons.check_circle_rounded,
          isLoading: _isSubmitting,
          onPressed: _handleSave,
        ),
      ],
    );
  }
}
