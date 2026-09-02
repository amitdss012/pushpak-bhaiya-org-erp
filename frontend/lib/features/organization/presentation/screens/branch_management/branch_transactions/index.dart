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
import '../../../widgets/org_stats_card.dart';

class BranchTransactionsScreen extends StatefulWidget {
  const BranchTransactionsScreen({super.key});

  @override
  State<BranchTransactionsScreen> createState() => _BranchTransactionsScreenState();
}

class _BranchTransactionsScreenState extends State<BranchTransactionsScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _transactionsData = [
    {
      'id': '1',
      'date': '2024-01-15',
      'branch': 'Main Campus',
      'type': 'credit',
      'category': 'Fee Collection',
      'description': 'Student fee payment - Batch A',
      'amount': 125000,
      'balance': 485000,
      'reference': 'TXN001234',
    },
    {
      'id': '2',
      'date': '2024-01-15',
      'branch': 'Main Campus',
      'type': 'debit',
      'category': 'Salary',
      'description': 'Staff salary disbursement',
      'amount': 85000,
      'balance': 400000,
      'reference': 'TXN001235',
    },
    {
      'id': '3',
      'date': '2024-01-14',
      'branch': 'North Campus',
      'type': 'credit',
      'category': 'Fee Collection',
      'description': 'Exam fee collection',
      'amount': 45000,
      'balance': 485000,
      'reference': 'TXN001236',
    },
    {
      'id': '4',
      'date': '2024-01-14',
      'branch': 'South Campus',
      'type': 'debit',
      'category': 'Utilities',
      'description': 'Electricity bill payment',
      'amount': 12000,
      'balance': 53000,
      'reference': 'TXN001237',
    },
    {
      'id': '5',
      'date': '2024-01-13',
      'branch': 'Main Campus',
      'type': 'credit',
      'category': 'Wallet Recharge',
      'description': 'Admin wallet recharge',
      'amount': 50000,
      'balance': 485000,
      'reference': 'TXN001238',
    },
    {
      'id': '6',
      'date': '2024-01-13',
      'branch': 'East Campus',
      'type': 'debit',
      'category': 'Maintenance',
      'description': 'Building repair work',
      'amount': 25000,
      'balance': 45000,
      'reference': 'TXN001239',
    },
    {
      'id': '7',
      'date': '2024-01-12',
      'branch': 'North Campus',
      'type': 'credit',
      'category': 'Fee Collection',
      'description': 'Late fee payment - 15 students',
      'amount': 7500,
      'balance': 440000,
      'reference': 'TXN001240',
    },
    {
      'id': '8',
      'date': '2024-01-12',
      'branch': 'Main Campus',
      'type': 'debit',
      'category': 'Purchase',
      'description': 'Lab equipment purchase',
      'amount': 35000,
      'balance': 435000,
      'reference': 'TXN001241',
    },
  ];

  void _showTransactionDetails(Map<String, dynamic> txn) {
    final isDark = context.isDarkMode;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaction Details',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                AppSpacing.vMd,
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDark.withAlpha(120) : AppColors.backgroundLight,
                    borderRadius: AppRadius.md,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: (txn['type'] == 'credit' ? AppColors.success : AppColors.error).withAlpha(30),
                          borderRadius: AppRadius.sm,
                        ),
                        child: Center(
                          child: Icon(
                            txn['type'] == 'credit' ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                            color: txn['type'] == 'credit' ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${txn['type'] == 'credit' ? '+' : '-'}₹${(txn['amount'] as int).toLocaleString()}',
                              style: AppTypography.titleLarge.copyWith(
                                fontWeight: FontWeight.w800,
                                color: txn['type'] == 'credit' ? AppColors.success : AppColors.error,
                              ),
                            ),
                            Text(
                              txn['category'] as String,
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
                AppSpacing.vLg,
                Row(
                  children: [
                    Expanded(child: _buildDetailItem('Reference', txn['reference'] as String, isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildDetailItem('Branch', txn['branch'] as String, isDark)),
                  ],
                ),
                AppSpacing.vMd,
                Row(
                  children: [
                    Expanded(child: _buildDetailItem('Date', txn['date'] as String, isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildDetailItem('Closing Balance', '₹${(txn['balance'] as int).toLocaleString()}', isDark)),
                  ],
                ),
                AppSpacing.vMd,
                _buildDetailItem('Description', txn['description'] as String, isDark),
                AppSpacing.vLg,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: 'Print Receipt',
                      icon: Icons.print_rounded,
                      variant: AppButtonVariant.outline,
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Printing Receipt for ${txn['reference']}...'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    AppSpacing.hSm,
                    AppButton(
                      text: 'Close',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelMedium.copyWith(
            fontSize: 10,
            letterSpacing: 0.5,
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            fontWeight: FontWeight.w700,
          ),
        ),
        AppSpacing.vXs,
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isTablet = context.isTablet;

    final filteredTransactions = _transactionsData.where((txn) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final branch = (txn['branch'] as String).toLowerCase();
      final cat = (txn['category'] as String).toLowerCase();
      final desc = (txn['description'] as String).toLowerCase();
      final ref = (txn['reference'] as String).toLowerCase();
      return branch.contains(q) || cat.contains(q) || desc.contains(q) || ref.contains(q);
    }).toList();

    final totalCredits = _transactionsData.where((t) => t['type'] == 'credit').fold<int>(0, (sum, t) => sum + (t['amount'] as int));
    final totalDebits = _transactionsData.where((t) => t['type'] == 'debit').fold<int>(0, (sum, t) => sum + (t['amount'] as int));

    // Stats Cards
    final card1 = OrgStatsCard(
      title: 'Total Transactions',
      value: _transactionsData.length.toString(),
      subtitle: 'This month',
      icon: Icons.currency_rupee_rounded,
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = OrgStatsCard(
      title: 'Total Credits',
      value: '₹${(totalCredits / 1000).toStringAsFixed(0)}K',
      subtitle: 'Incoming funds',
      icon: Icons.trending_up_rounded,
      variant: OrgStatsCardVariant.success,
    );
    final card3 = OrgStatsCard(
      title: 'Total Debits',
      value: '₹${(totalDebits / 1000).toStringAsFixed(0)}K',
      subtitle: 'Outgoing funds',
      icon: Icons.trending_down_rounded,
      variant: OrgStatsCardVariant.warning,
    );
    final card4 = OrgStatsCard(
      title: 'Net Balance',
      value: '₹${((totalCredits - totalDebits) / 1000).toStringAsFixed(0)}K',
      subtitle: 'Credits - Debits',
      icon: Icons.account_balance_wallet_rounded,
      variant: OrgStatsCardVariant.info,
    );

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

          // Stats Grid
          if (isDesktop)
            Row(
              children: [
                Expanded(child: card1),
                AppSpacing.hLg,
                Expanded(child: card2),
                AppSpacing.hLg,
                Expanded(child: card3),
                AppSpacing.hLg,
                Expanded(child: card4),
              ],
            )
          else if (isTablet)
            Column(
              children: [
                Row(children: [Expanded(child: card1), AppSpacing.hMd, Expanded(child: card2)]),
                AppSpacing.vMd,
                Row(children: [Expanded(child: card3), AppSpacing.hMd, Expanded(child: card4)]),
              ],
            )
          else
            Column(
              children: [
                card1,
                AppSpacing.vMd,
                card2,
                AppSpacing.vMd,
                card3,
                AppSpacing.vMd,
                card4,
              ],
            ),

          AppSpacing.vXl,

          // DataTable Card
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
                        'Transaction History',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                            borderRadius: AppRadius.sm,
                            border: Border.all(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                          ),
                          child: TextField(
                            onChanged: (val) => setState(() => _searchQuery = val.trim()),
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search transactions...',
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
                          dataRowMinHeight: 60,
                          dataRowMaxHeight: 64,
                          horizontalMargin: 20,
                          columnSpacing: 24,
                    headingRowColor: WidgetStateProperty.all(
                      isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight.withAlpha(120),
                    ),
                    columns: [
                      _buildDataColumn('DATE', isDark),
                      _buildDataColumn('BRANCH', isDark),
                      _buildDataColumn('TYPE', isDark),
                      _buildDataColumn('CATEGORY', isDark),
                      _buildDataColumn('DESCRIPTION', isDark),
                      _buildDataColumn('AMOUNT', isDark),
                      _buildDataColumn('BALANCE', isDark),
                      _buildDataColumn('ACTIONS', isDark),
                    ],
                    rows: filteredTransactions.map((txn) {
                      final date = txn['date'] as String;
                      final branch = txn['branch'] as String;
                      final type = txn['type'] as String;
                      final category = txn['category'] as String;
                      final description = txn['description'] as String;
                      final reference = txn['reference'] as String;
                      final amount = txn['amount'] as int;
                      final balance = txn['balance'] as int;

                      final isCredit = type == 'credit';

                      return DataRow(
                        cells: [
                          // Date
                          DataCell(Text(date, style: AppTypography.bodySmall)),

                          // Branch
                          DataCell(Text(branch, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500))),

                          // Type
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                  size: 14,
                                  color: isCredit ? AppColors.success : AppColors.error,
                                ),
                                AppSpacing.hXs,
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: (isCredit ? AppColors.success : AppColors.error).withAlpha(25),
                                    borderRadius: AppRadius.full,
                                    border: Border.all(color: (isCredit ? AppColors.success : AppColors.error).withAlpha(60)),
                                  ),
                                  child: Text(
                                    isCredit ? 'Credit' : 'Debit',
                                    style: AppTypography.bodySmall.copyWith(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: isCredit ? AppColors.success : AppColors.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Category
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                borderRadius: AppRadius.full,
                                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                              ),
                              child: Text(
                                category,
                                style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),

                          // Description & Ref
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(description, style: AppTypography.bodySmall),
                                Text(
                                  reference,
                                  style: AppTypography.bodySmall.copyWith(
                                    fontSize: 10.5,
                                    fontFamily: 'monospace',
                                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Amount
                          DataCell(
                            Text(
                              '${isCredit ? '+' : '-'}₹${amount.toLocaleString()}',
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isCredit ? AppColors.success : AppColors.error,
                              ),
                            ),
                          ),

                          // Balance
                          DataCell(
                            Text('₹${balance.toLocaleString()}', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                          ),

                          // Actions
                          DataCell(
                            PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_horiz_rounded,
                                size: 18,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                              onSelected: (action) {
                                if (action == 'view') _showTransactionDetails(txn);
                                if (action == 'receipt') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Downloading receipt for $reference...')),
                                  );
                                }
                                if (action == 'print') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Printing transaction $reference...')),
                                  );
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'view',
                                  child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text('View Details')]),
                                ),
                                PopupMenuItem(
                                  value: 'receipt',
                                  child: Row(children: [Icon(Icons.download_outlined, size: 16), SizedBox(width: 8), Text('Download Receipt')]),
                                ),
                                PopupMenuItem(
                                  value: 'print',
                                  child: Row(children: [Icon(Icons.print_outlined, size: 16), SizedBox(width: 8), Text('Print')]),
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
              onTap: () => context.go(RouteNames.branchViewPath),
              child: Text(
                'Branch Management',
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
              'Transactions',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Branch Transactions',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'View all financial transactions across branches',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'Export',
      icon: Icons.download_rounded,
      variant: AppButtonVariant.outline,
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exporting transactions data...')),
        );
      },
      height: 38,
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerTexts,
          AppSpacing.vMd,
          actionButton,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: headerTexts),
        actionButton,
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

extension IntExt on int {
  String toLocaleString() {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
