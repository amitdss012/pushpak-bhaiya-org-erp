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

class VoucherHeadsScreen extends StatefulWidget {
  const VoucherHeadsScreen({super.key});

  @override
  State<VoucherHeadsScreen> createState() => _VoucherHeadsScreenState();
}

class _VoucherHeadsScreenState extends State<VoucherHeadsScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _voucherHeads = [
    {
      'id': '1',
      'headName': 'Salary Expense',
      'headCode': 'VH-001',
      'headType': 'expense',
      'description': 'Monthly salary payments to staff',
      'openingBalance': 0,
      'balanceType': 'debit',
      'status': 'active',
      'createdDate': '2024-01-15',
    },
    {
      'id': '2',
      'headName': 'Office Rent',
      'headCode': 'VH-002',
      'headType': 'expense',
      'description': 'Monthly office rent payment',
      'openingBalance': 50000,
      'balanceType': 'debit',
      'status': 'active',
      'createdDate': '2024-01-20',
    },
    {
      'id': '3',
      'headName': 'Student Fee Income',
      'headCode': 'VH-003',
      'headType': 'income',
      'description': 'Fee collected from students',
      'openingBalance': 100000,
      'balanceType': 'credit',
      'status': 'active',
      'createdDate': '2024-02-01',
    },
    {
      'id': '4',
      'headName': 'Computer Equipment',
      'headCode': 'VH-004',
      'headType': 'asset',
      'description': 'Computer and IT equipment purchases',
      'openingBalance': 250000,
      'balanceType': 'debit',
      'status': 'active',
      'createdDate': '2024-02-10',
    },
  ];

  Color _getTypeColor(String type) {
    switch (type) {
      case 'income':
        return AppColors.success;
      case 'expense':
        return AppColors.error;
      case 'asset':
        return AppColors.primary;
      case 'liability':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  void _openViewDialog(Map<String, dynamic> head) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = ctx.isDarkMode;
        final typeColor = _getTypeColor(head['headType'] as String);
        return AlertDialog(
          title: Text(
            'Voucher Head Details',
            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(head['headName'] as String, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
                          Text('Code: ${head['headCode']}', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: typeColor.withAlpha(20),
                          borderRadius: AppRadius.sm,
                          border: Border.all(color: typeColor.withAlpha(60)),
                        ),
                        child: Text(
                          (head['headType'] as String).toUpperCase(),
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: typeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vLg,
                  const Divider(height: 1),
                  AppSpacing.vMd,
                  _buildDetailRow('Opening Balance:', '₹${head['openingBalance']}', isDark),
                  _buildDetailRow('Balance Type:', (head['balanceType'] as String).toUpperCase(), isDark),
                  _buildDetailRow('Status:', (head['status'] as String).toUpperCase(), isDark),
                  _buildDetailRow('Created Date:', head['createdDate'] as String, isDark),
                  AppSpacing.vMd,
                  const Divider(height: 1),
                  AppSpacing.vMd,
                  Text('DESCRIPTION', style: AppTypography.labelMedium.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  AppSpacing.vXs,
                  Text(head['description'] ?? 'No description provided.', style: AppTypography.bodySmall),
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
              text: 'Edit',
              icon: Icons.edit_outlined,
              onPressed: () {
                Navigator.of(ctx).pop();
                _openFormDialog(head: head);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          Text(value, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _openFormDialog({Map<String, dynamic>? head}) {
    final isEditing = head != null;
    final nameController = TextEditingController(text: head?['headName'] ?? '');
    final codeController = TextEditingController(text: head?['headCode'] ?? '');
    final balanceController = TextEditingController(text: '${head?['openingBalance'] ?? 0}');
    final descController = TextEditingController(text: head?['description'] ?? '');
    String headType = head?['headType'] ?? 'expense';
    String balanceType = head?['balanceType'] ?? 'debit';
    String status = head?['status'] ?? 'active';

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: Text(
              isEditing ? 'Edit Voucher Head' : 'Create Voucher Head',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
            ),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(controller: nameController, label: 'Head Name *', hint: 'e.g., Office Rent'),
                    AppSpacing.vMd,
                    AppTextField(controller: codeController, label: 'Head Code *', hint: 'e.g., VH-005'),
                    AppSpacing.vMd,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Head Type *', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: headType,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'income', child: Text('Income')),
                                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                                  DropdownMenuItem(value: 'asset', child: Text('Asset')),
                                  DropdownMenuItem(value: 'liability', child: Text('Liability')),
                                ],
                                onChanged: (v) => setDialogState(() => headType = v!),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.hMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Status', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: status,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'active', child: Text('Active')),
                                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                                ],
                                onChanged: (v) => setDialogState(() => status = v!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,
                    Row(
                      children: [
                        Expanded(child: AppTextField(controller: balanceController, label: 'Opening Balance', hint: '0')),
                        AppSpacing.hMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Balance Type', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: balanceType,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'debit', child: Text('Debit')),
                                  DropdownMenuItem(value: 'credit', child: Text('Credit')),
                                ],
                                onChanged: (v) => setDialogState(() => balanceType = v!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,
                    Text('Description', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                    AppSpacing.vXs,
                    TextFormField(
                      controller: descController,
                      maxLines: 2,
                      decoration: const InputDecoration(hintText: 'Brief description of category...'),
                    ),
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
                icon: Icons.check_rounded,
                onPressed: () {
                  if (nameController.text.trim().isEmpty || codeController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all required fields.')),
                    );
                    return;
                  }
                  final bal = int.tryParse(balanceController.text.trim()) ?? 0;
                  setState(() {
                    if (isEditing) {
                      head['headName'] = nameController.text.trim();
                      head['headCode'] = codeController.text.trim();
                      head['headType'] = headType;
                      head['openingBalance'] = bal;
                      head['balanceType'] = balanceType;
                      head['status'] = status;
                      head['description'] = descController.text.trim();
                    } else {
                      _voucherHeads.add({
                        'id': '${DateTime.now().millisecondsSinceEpoch}',
                        'headName': nameController.text.trim(),
                        'headCode': codeController.text.trim(),
                        'headType': headType,
                        'openingBalance': bal,
                        'balanceType': balanceType,
                        'status': status,
                        'description': descController.text.trim(),
                        'createdDate': DateTime.now().toString().split(' ')[0],
                      });
                    }
                  });
                  Navigator.of(dialogCtx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEditing ? 'Voucher head updated!' : 'Voucher head created!'),
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

    final filtered = _voucherHeads.where((h) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = (h['headName'] as String).toLowerCase();
        final code = (h['headCode'] as String).toLowerCase();
        return name.contains(q) || code.contains(q);
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
                        'All Voucher Heads',
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
                              hintText: 'Search voucher heads...',
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
                            _buildDataColumn('CODE', isDark),
                            _buildDataColumn('HEAD NAME', isDark),
                            _buildDataColumn('TYPE', isDark),
                            _buildDataColumn('OPENING BALANCE', isDark),
                            _buildDataColumn('BALANCE TYPE', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filtered.map((head) {
                            final code = head['headCode'] as String;
                            final name = head['headName'] as String;
                            final type = head['headType'] as String;
                            final bal = head['openingBalance'];
                            final balanceType = head['balanceType'] as String;
                            final status = head['status'] as String;
                            final typeColor = _getTypeColor(type);

                            return DataRow(
                              cells: [
                                DataCell(Text(code, style: AppTypography.bodySmall.copyWith(fontFamily: 'monospace', fontWeight: FontWeight.w600))),
                                DataCell(Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700))),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: typeColor.withAlpha(20),
                                      borderRadius: AppRadius.sm,
                                      border: Border.all(color: typeColor.withAlpha(60)),
                                    ),
                                    child: Text(
                                      type.toUpperCase(),
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: typeColor,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text('₹$bal', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600))),
                                DataCell(Text(balanceType.toUpperCase(), style: AppTypography.bodySmall)),
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
                                      if (val == 'view') {
                                        _openViewDialog(head);
                                      } else if (val == 'edit') {
                                        _openFormDialog(head: head);
                                      } else if (val == 'delete') {
                                        setState(() => _voucherHeads.remove(head));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Removed ${head['headName']}.'), backgroundColor: AppColors.error),
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
                                            Text('View Details'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit_outlined, size: 16),
                                            SizedBox(width: 8),
                                            Text('Edit'),
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
    final totalHeads = _voucherHeads.length;
    final incomeHeads = _voucherHeads.where((h) => h['headType'] == 'income').length;
    final expenseHeads = _voucherHeads.where((h) => h['headType'] == 'expense').length;
    final totalBal = _voucherHeads.fold<int>(0, (sum, h) => sum + (h['openingBalance'] as int));

    final cards = [
      OrgStatsCard(
        title: 'Total Heads',
        value: '$totalHeads',
        subtitle: 'All account categories',
        icon: Icons.category_outlined,
        variant: OrgStatsCardVariant.primary,
      ),
      OrgStatsCard(
        title: 'Income Heads',
        value: '$incomeHeads',
        subtitle: 'Revenue streams',
        icon: Icons.trending_up_rounded,
        variant: OrgStatsCardVariant.success,
      ),
      OrgStatsCard(
        title: 'Expense Heads',
        value: '$expenseHeads',
        subtitle: 'Cost categories',
        icon: Icons.trending_down_rounded,
        variant: OrgStatsCardVariant.warning,
      ),
      OrgStatsCard(
        title: 'Total Opening Bal.',
        value: '₹$totalBal',
        subtitle: 'Consolidated balance',
        icon: Icons.account_balance_wallet_outlined,
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
              onTap: () => context.go(RouteNames.expenseVoucherHeadsPath),
              child: Text(
                'Expense',
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
              'All Voucher Heads',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'All Voucher Heads',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Manage and view all voucher heads',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionBtn = AppButton(
      text: 'Create New Voucher Head',
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
