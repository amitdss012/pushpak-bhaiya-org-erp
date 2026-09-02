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

class DepositVoucherScreen extends StatefulWidget {
  const DepositVoucherScreen({super.key});

  @override
  State<DepositVoucherScreen> createState() => _DepositVoucherScreenState();
}

class _DepositVoucherScreenState extends State<DepositVoucherScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _vouchers = [
    {
      'id': '1',
      'voucherNumber': 'DV-2024-001',
      'date': '2024-03-20',
      'headId': '3',
      'headName': 'Student Fee Income',
      'amount': 15000,
      'paymentMethod': 'cash',
      'depositedBy': 'John Doe',
      'description': 'Monthly tuition fee collection',
    },
    {
      'id': '2',
      'voucherNumber': 'DV-2024-002',
      'date': '2024-03-21',
      'headId': '3',
      'headName': 'Student Fee Income',
      'amount': 25000,
      'paymentMethod': 'bank_transfer',
      'depositedBy': 'Jane Smith',
      'bankName': 'HDFC Bank',
      'referenceNumber': 'TXN123456789',
      'description': 'Admission fee for new batch',
    },
  ];

  void _openViewDialog(Map<String, dynamic> voucher) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = ctx.isDarkMode;
        final amount = voucher['amount'];

        return AlertDialog(
          title: Text(
            'Deposit Voucher Details',
            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: 540,
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
                          Text('Voucher #: ${voucher['voucherNumber']}', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
                          Text('Date: ${voucher['date']}', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.success.withAlpha(15),
                          borderRadius: AppRadius.md,
                          border: Border.all(color: AppColors.success.withAlpha(40)),
                        ),
                        child: Column(
                          children: [
                            Text('AMOUNT', style: AppTypography.labelMedium.copyWith(fontSize: 10, fontWeight: FontWeight.w700)),
                            Text('₹$amount', style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w900, color: AppColors.success)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vLg,
                  const Divider(height: 1),
                  AppSpacing.vMd,
                  Text('PAYMENT & DEPOSITOR INFO', style: AppTypography.labelMedium.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  AppSpacing.vSm,
                  _buildDetailRow('Voucher Head:', voucher['headName'] as String, isDark),
                  _buildDetailRow('Payment Method:', (voucher['paymentMethod'] as String).replaceAll('_', ' ').toUpperCase(), isDark),
                  _buildDetailRow('Deposited By:', voucher['depositedBy'] ?? 'N/A', isDark),
                  if (voucher['bankName'] != null) _buildDetailRow('Bank Name:', voucher['bankName'] as String, isDark),
                  if (voucher['referenceNumber'] != null) _buildDetailRow('Reference #:', voucher['referenceNumber'] as String, isDark),
                  AppSpacing.vMd,
                  const Divider(height: 1),
                  AppSpacing.vMd,
                  Text('DESCRIPTION', style: AppTypography.labelMedium.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  AppSpacing.vXs,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                      borderRadius: AppRadius.sm,
                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                    child: Text(voucher['description'] ?? 'No description provided.', style: AppTypography.bodySmall),
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
            AppButton(
              text: 'Edit Voucher',
              icon: Icons.edit_outlined,
              onPressed: () {
                Navigator.of(ctx).pop();
                _openFormDialog(voucher: voucher);
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

  void _openFormDialog({Map<String, dynamic>? voucher}) {
    final isEditing = voucher != null;
    final numController = TextEditingController(text: voucher?['voucherNumber'] ?? 'DV-2024-00${_vouchers.length + 1}');
    final dateController = TextEditingController(text: voucher?['date'] ?? DateTime.now().toString().split(' ')[0]);
    final amountController = TextEditingController(text: '${voucher?['amount'] ?? ''}');
    final depositedByController = TextEditingController(text: voucher?['depositedBy'] ?? '');
    final bankController = TextEditingController(text: voucher?['bankName'] ?? '');
    final refController = TextEditingController(text: voucher?['referenceNumber'] ?? '');
    final descController = TextEditingController(text: voucher?['description'] ?? '');
    String headId = voucher?['headId'] ?? '3';
    String paymentMethod = voucher?['paymentMethod'] ?? 'cash';

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final isBank = paymentMethod == 'bank_transfer' || paymentMethod == 'cheque';

          return AlertDialog(
            title: Text(
              isEditing ? 'Edit Deposit Voucher' : 'Create Deposit Voucher',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
            ),
            content: SizedBox(
              width: 560,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: AppTextField(controller: numController, label: 'Voucher Number *', hint: 'DV-2024-001')),
                        AppSpacing.hMd,
                        Expanded(child: AppTextField(controller: dateController, label: 'Date *', hint: 'YYYY-MM-DD')),
                      ],
                    ),
                    AppSpacing.vMd,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Voucher Head *', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: headId,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: '1', child: Text('Salary Expense')),
                                  DropdownMenuItem(value: '2', child: Text('Office Rent')),
                                  DropdownMenuItem(value: '3', child: Text('Student Fee Income')),
                                  DropdownMenuItem(value: '4', child: Text('Other Income')),
                                ],
                                onChanged: (v) => setDialogState(() => headId = v!),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.hMd,
                        Expanded(child: AppTextField(controller: amountController, label: 'Amount *', hint: '0.00')),
                      ],
                    ),
                    AppSpacing.vMd,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Payment Method *', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: paymentMethod,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'cash', child: Text('Cash')),
                                  DropdownMenuItem(value: 'cheque', child: Text('Cheque')),
                                  DropdownMenuItem(value: 'bank_transfer', child: Text('Bank Transfer')),
                                  DropdownMenuItem(value: 'upi', child: Text('UPI')),
                                ],
                                onChanged: (v) => setDialogState(() => paymentMethod = v!),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.hMd,
                        Expanded(child: AppTextField(controller: depositedByController, label: 'Deposited By', hint: 'John Doe')),
                      ],
                    ),
                    if (isBank) ...[
                      AppSpacing.vMd,
                      Row(
                        children: [
                          Expanded(child: AppTextField(controller: bankController, label: 'Bank Name', hint: 'HDFC Bank')),
                          AppSpacing.hMd,
                          Expanded(child: AppTextField(controller: refController, label: 'Reference / Ref #', hint: 'TXN123456789')),
                        ],
                      ),
                    ],
                    AppSpacing.vMd,
                    Text('Description', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                    AppSpacing.vXs,
                    TextFormField(
                      controller: descController,
                      maxLines: 2,
                      decoration: const InputDecoration(hintText: 'Brief description of deposit...'),
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
                text: isEditing ? 'Update Voucher' : 'Create Voucher',
                icon: Icons.payments_outlined,
                onPressed: () {
                  if (numController.text.trim().isEmpty || amountController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all required fields.')),
                    );
                    return;
                  }
                  final amt = int.tryParse(amountController.text.trim()) ?? 0;
                  final headMap = {
                    '1': 'Salary Expense',
                    '2': 'Office Rent',
                    '3': 'Student Fee Income',
                    '4': 'Other Income',
                  };

                  setState(() {
                    if (isEditing) {
                      voucher['voucherNumber'] = numController.text.trim();
                      voucher['date'] = dateController.text.trim();
                      voucher['headId'] = headId;
                      voucher['headName'] = headMap[headId] ?? 'Other Income';
                      voucher['amount'] = amt;
                      voucher['paymentMethod'] = paymentMethod;
                      voucher['depositedBy'] = depositedByController.text.trim();
                      voucher['bankName'] = bankController.text.trim();
                      voucher['referenceNumber'] = refController.text.trim();
                      voucher['description'] = descController.text.trim();
                    } else {
                      _vouchers.add({
                        'id': '${DateTime.now().millisecondsSinceEpoch}',
                        'voucherNumber': numController.text.trim(),
                        'date': dateController.text.trim(),
                        'headId': headId,
                        'headName': headMap[headId] ?? 'Other Income',
                        'amount': amt,
                        'paymentMethod': paymentMethod,
                        'depositedBy': depositedByController.text.trim(),
                        'bankName': bankController.text.trim(),
                        'referenceNumber': refController.text.trim(),
                        'description': descController.text.trim(),
                      });
                    }
                  });
                  Navigator.of(dialogCtx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEditing ? 'Deposit voucher updated!' : 'Deposit voucher created!'),
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

    final filtered = _vouchers.where((v) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final num = (v['voucherNumber'] as String).toLowerCase();
        final head = (v['headName'] as String).toLowerCase();
        final dep = (v['depositedBy'] as String? ?? '').toLowerCase();
        return num.contains(q) || head.contains(q) || dep.contains(q);
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
                        'Deposit Voucher Records',
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
                              hintText: 'Search vouchers...',
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
                            _buildDataColumn('VOUCHER #', isDark),
                            _buildDataColumn('DATE', isDark),
                            _buildDataColumn('VOUCHER HEAD', isDark),
                            _buildDataColumn('AMOUNT', isDark),
                            _buildDataColumn('METHOD', isDark),
                            _buildDataColumn('DEPOSITED BY', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filtered.map((voucher) {
                            final num = voucher['voucherNumber'] as String;
                            final date = voucher['date'] as String;
                            final head = voucher['headName'] as String;
                            final amt = voucher['amount'];
                            final method = (voucher['paymentMethod'] as String).replaceAll('_', ' ');
                            final dep = voucher['depositedBy'] ?? 'N/A';

                            return DataRow(
                              cells: [
                                DataCell(Text(num, style: AppTypography.bodySmall.copyWith(fontFamily: 'monospace', fontWeight: FontWeight.w700))),
                                DataCell(Text(date, style: AppTypography.bodySmall)),
                                DataCell(Text(head, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600))),
                                DataCell(
                                  Text(
                                    '₹$amt',
                                    style: AppTypography.bodySmall.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.success,
                                    ),
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
                                    child: Text(
                                      method.toUpperCase(),
                                      style: AppTypography.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                DataCell(Text('$dep', style: AppTypography.bodySmall)),
                                DataCell(
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert_rounded, size: 18, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                    onSelected: (val) {
                                      if (val == 'view') {
                                        _openViewDialog(voucher);
                                      } else if (val == 'edit') {
                                        _openFormDialog(voucher: voucher);
                                      } else if (val == 'delete') {
                                        setState(() => _vouchers.remove(voucher));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Removed ${voucher['voucherNumber']}.'), backgroundColor: AppColors.error),
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

  Widget _buildHeader(bool isDark, bool isMobile) {
    final headerTexts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => context.go(RouteNames.expenseDepositVoucherPath),
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
              'Deposit Vouchers',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Deposit Vouchers',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'View and manage all deposit transactions',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionBtn = AppButton(
      text: 'Create Deposit Voucher',
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
