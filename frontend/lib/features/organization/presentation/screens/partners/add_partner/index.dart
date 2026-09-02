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

class AddPartnerScreen extends StatefulWidget {
  const AddPartnerScreen({super.key});

  @override
  State<AddPartnerScreen> createState() => _AddPartnerScreenState();
}

class _AddPartnerScreenState extends State<AddPartnerScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _partners = [
    {
      'id': '1',
      'partnerName': 'John Education Services',
      'partnerType': 'organization',
      'email': 'john@edu.com',
      'phone': '+91 9876543210',
      'city': 'Mumbai',
      'commissionRate': '10',
      'status': 'active',
      'joinedDate': '2024-01-15',
      'contactPerson': 'John Doe',
    },
    {
      'id': '2',
      'partnerName': 'Sarah Learning Hub',
      'partnerType': 'individual',
      'email': 'sarah@learning.com',
      'phone': '+91 9876543211',
      'city': 'Delhi',
      'commissionRate': '8',
      'status': 'active',
      'joinedDate': '2024-02-20',
      'contactPerson': 'Sarah Smith',
    },
  ];

  void _openPartnerDialog({Map<String, dynamic>? partner}) {
    final isEditing = partner != null;
    final nameController = TextEditingController(text: partner?['partnerName'] ?? '');
    final emailController = TextEditingController(text: partner?['email'] ?? '');
    final phoneController = TextEditingController(text: partner?['phone'] ?? '');
    final commController = TextEditingController(text: partner?['commissionRate'] ?? '10');
    final cityController = TextEditingController(text: partner?['city'] ?? '');
    String partnerType = partner?['partnerType'] ?? 'individual';

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: Text(
              isEditing ? 'Update Partner' : 'Register Partner',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
            ),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(controller: nameController, label: 'Partner Name *', hint: 'Enter partner name'),
                    AppSpacing.vMd,
                    Text('Type', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: partnerType,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'individual', child: Text('Individual')),
                        DropdownMenuItem(value: 'organization', child: Text('Organization')),
                      ],
                      onChanged: (v) => setDialogState(() => partnerType = v!),
                    ),
                    AppSpacing.vMd,
                    AppTextField(controller: commController, label: 'Commission Rate (%)', hint: '10'),
                    AppSpacing.vMd,
                    AppTextField(controller: emailController, label: 'Email *', hint: 'partner@example.com'),
                    AppSpacing.vMd,
                    AppTextField(controller: phoneController, label: 'Phone *', hint: '+91 9876543210'),
                    AppSpacing.vMd,
                    AppTextField(controller: cityController, label: 'City', hint: 'Mumbai'),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: const Text('Cancel'),
              ),
              AppButton(
                text: isEditing ? 'Update' : 'Create',
                icon: Icons.person_add_rounded,
                onPressed: () {
                  if (nameController.text.trim().isEmpty || emailController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all required fields.')),
                    );
                    return;
                  }
                  setState(() {
                    if (isEditing) {
                      partner['partnerName'] = nameController.text.trim();
                      partner['partnerType'] = partnerType;
                      partner['email'] = emailController.text.trim();
                      partner['phone'] = phoneController.text.trim();
                      partner['commissionRate'] = commController.text.trim();
                      partner['city'] = cityController.text.trim();
                    } else {
                      _partners.add({
                        'id': '${DateTime.now().millisecondsSinceEpoch}',
                        'partnerName': nameController.text.trim(),
                        'partnerType': partnerType,
                        'email': emailController.text.trim(),
                        'phone': phoneController.text.trim(),
                        'city': cityController.text.trim(),
                        'commissionRate': commController.text.trim(),
                        'status': 'active',
                        'joinedDate': DateTime.now().toString().split(' ')[0],
                        'contactPerson': nameController.text.trim(),
                      });
                    }
                  });
                  Navigator.of(dialogCtx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEditing ? 'Partner updated successfully!' : 'Partner registered successfully!'),
                      backgroundColor: AppColors.success,
                    ),
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

    final filteredPartners = _partners.where((p) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = (p['partnerName'] as String).toLowerCase();
        final email = (p['email'] as String).toLowerCase();
        final phone = (p['phone'] as String).toLowerCase();
        return name.contains(q) || email.contains(q) || phone.contains(q);
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

          // Main Card with Search & Full-width DataTable
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
                        'All Registered Partners',
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
                              hintText: 'Search partners...',
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
                            _buildDataColumn('PARTNER NAME', isDark),
                            _buildDataColumn('TYPE', isDark),
                            _buildDataColumn('EMAIL', isDark),
                            _buildDataColumn('PHONE', isDark),
                            _buildDataColumn('COMM.', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredPartners.map((partner) {
                            final name = partner['partnerName'] as String;
                            final type = partner['partnerType'] as String;
                            final email = partner['email'] as String;
                            final phone = partner['phone'] as String;
                            final comm = partner['commissionRate'] as String;
                            final status = partner['status'] as String;
                            final isOrg = type == 'organization';

                            return DataRow(
                              cells: [
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                                      if (partner['contactPerson'] != null)
                                        Text(partner['contactPerson'] as String, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                                    ],
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
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(isOrg ? Icons.apartment_rounded : Icons.person_outline_rounded, size: 13, color: AppColors.primary),
                                        AppSpacing.hXs,
                                        Text(type.toUpperCase(), style: AppTypography.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(Text(email, style: AppTypography.bodySmall)),
                                DataCell(Text(phone, style: AppTypography.bodySmall)),
                                DataCell(Text('$comm%', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary))),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: status == 'active' ? AppColors.success.withAlpha(20) : AppColors.borderLight.withAlpha(50),
                                      borderRadius: AppRadius.sm,
                                      border: Border.all(color: status == 'active' ? AppColors.success.withAlpha(60) : AppColors.borderLight),
                                    ),
                                    child: Text(
                                      status.toUpperCase(),
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: status == 'active' ? AppColors.success : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert_rounded, size: 18, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                    onSelected: (val) {
                                      if (val == 'edit') {
                                        _openPartnerDialog(partner: partner);
                                      } else if (val == 'delete') {
                                        setState(() => _partners.remove(partner));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Removed ${partner['partnerName']}.'), backgroundColor: AppColors.error),
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
                                            Text('Edit Partner'),
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

  Widget _buildHeader(bool isDark, bool isMobile) {
    final headerTexts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => context.go(RouteNames.partnersAllPath),
              child: Text(
                'Partners',
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
              'Partner Management',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Add & Manage Partners',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Register and configure partner profiles',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionBtn = AppButton(
      text: 'Register New Partner',
      icon: Icons.add_rounded,
      onPressed: () => _openPartnerDialog(),
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
