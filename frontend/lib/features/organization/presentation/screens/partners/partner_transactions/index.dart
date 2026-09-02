import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/router/route_names.dart';
import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_radius.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_card.dart';
import '../../../widgets/org_stats_card.dart';

class PartnerTransactionsScreen extends StatefulWidget {
  const PartnerTransactionsScreen({super.key});

  @override
  State<PartnerTransactionsScreen> createState() => _PartnerTransactionsScreenState();
}

class _PartnerTransactionsScreenState extends State<PartnerTransactionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filterStatus = 'all';

  final List<Map<String, dynamic>> _transactions = [
    {
      'id': '1',
      'partnerId': '1',
      'partnerName': 'John Education Services',
      'type': 'commission',
      'amount': 5000,
      'status': 'completed',
      'description': 'Commission for student admission - Batch 2024',
      'date': '15 Mar 2024',
      'referenceId': 'COMM-2024-001',
      'paymentMethod': 'Bank Transfer',
    },
    {
      'id': '2',
      'partnerId': '1',
      'partnerName': 'John Education Services',
      'type': 'payment',
      'amount': 10000,
      'status': 'completed',
      'description': 'Partner incentive payment',
      'date': '10 Mar 2024',
      'referenceId': 'PAY-2024-045',
      'paymentMethod': 'UPI',
    },
    {
      'id': '3',
      'partnerId': '1',
      'partnerName': 'John Education Services',
      'type': 'commission',
      'amount': 3500,
      'status': 'pending',
      'description': 'Commission for online course enrollment',
      'date': '20 Mar 2024',
      'referenceId': 'COMM-2024-002',
      'paymentMethod': 'Pending',
    },
    {
      'id': '4',
      'partnerId': '1',
      'partnerName': 'John Education Services',
      'type': 'refund',
      'amount': 2000,
      'status': 'completed',
      'description': 'Refund for cancelled admission',
      'date': '05 Mar 2024',
      'referenceId': 'REF-2024-012',
      'paymentMethod': 'Bank Transfer',
    },
    {
      'id': '5',
      'partnerId': '1',
      'partnerName': 'John Education Services',
      'type': 'adjustment',
      'amount': 500,
      'status': 'completed',
      'description': 'Tax adjustment for February 2024',
      'date': '01 Mar 2024',
      'referenceId': 'ADJ-2024-003',
      'paymentMethod': 'System Adj',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;

    final totalCommission = _transactions.where((t) => t['type'] == 'commission').fold<int>(0, (sum, t) => sum + (t['amount'] as int));
    final totalPayment = _transactions.where((t) => t['type'] == 'payment').fold<int>(0, (sum, t) => sum + (t['amount'] as int));
    final totalRefund = _transactions.where((t) => t['type'] == 'refund').fold<int>(0, (sum, t) => sum + (t['amount'] as int));
    final netAmount = totalCommission + totalPayment - totalRefund;

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

          // 4 Summary Cards
          _buildSummaryCards(totalCommission, totalPayment, totalRefund, netAmount, isMobile),
          AppSpacing.vXl,

          // Transactions Card with Filter Tabs & Full-width DataTable
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
                        'All Transactions',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 150,
                            height: 38,
                            child: DropdownButtonFormField<String>(
                              initialValue: _filterStatus,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'all', child: Text('All Status')),
                                DropdownMenuItem(value: 'completed', child: Text('Completed')),
                                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                                DropdownMenuItem(value: 'failed', child: Text('Failed')),
                              ],
                              onChanged: (v) => setState(() => _filterStatus = v!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Tabs Row
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorColor: AppColors.primary,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    onTap: (_) => setState(() {}),
                    tabs: const [
                      Tab(text: 'All'),
                      Tab(text: 'Commission'),
                      Tab(text: 'Payment'),
                      Tab(text: 'Refund'),
                      Tab(text: 'Adjustment'),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Table
                _buildTransactionsTable(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTable(bool isDark) {
    String currentType;
    switch (_tabController.index) {
      case 1:
        currentType = 'commission';
        break;
      case 2:
        currentType = 'payment';
        break;
      case 3:
        currentType = 'refund';
        break;
      case 4:
        currentType = 'adjustment';
        break;
      default:
        currentType = 'all';
    }

    final filtered = _transactions.where((t) {
      if (currentType != 'all' && t['type'] != currentType) return false;
      if (_filterStatus != 'all' && t['status'] != _filterStatus) return false;
      return true;
    }).toList();

    if (filtered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Text(
            'No transactions found matching the selected filter.',
            style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          ),
        ),
      );
    }

    return LayoutBuilder(
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
                _buildDataColumn('DATE', isDark),
                _buildDataColumn('REFERENCE ID', isDark),
                _buildDataColumn('TYPE', isDark),
                _buildDataColumn('DESCRIPTION', isDark),
                _buildDataColumn('AMOUNT', isDark),
                _buildDataColumn('STATUS', isDark),
                _buildDataColumn('PAYMENT METHOD', isDark),
              ],
              rows: filtered.map((tx) {
                final date = tx['date'] as String;
                final ref = tx['referenceId'] as String;
                final type = tx['type'] as String;
                final desc = tx['description'] as String;
                final amount = tx['amount'] as int;
                final status = tx['status'] as String;
                final method = tx['paymentMethod'] as String? ?? '-';

                Color typeColor;
                switch (type) {
                  case 'commission':
                    typeColor = AppColors.success;
                    break;
                  case 'payment':
                    typeColor = AppColors.primary;
                    break;
                  case 'refund':
                    typeColor = AppColors.error;
                    break;
                  case 'adjustment':
                    typeColor = AppColors.warning;
                    break;
                  default:
                    typeColor = AppColors.info;
                }

                Color statusColor;
                switch (status) {
                  case 'completed':
                    statusColor = AppColors.success;
                    break;
                  case 'pending':
                    statusColor = AppColors.warning;
                    break;
                  default:
                    statusColor = AppColors.error;
                }

                return DataRow(
                  cells: [
                    DataCell(Text(date, style: AppTypography.bodySmall)),
                    DataCell(Text(ref, style: AppTypography.bodySmall.copyWith(fontFamily: 'monospace', fontWeight: FontWeight.w600))),
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
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 240),
                        child: Text(desc, style: AppTypography.bodySmall, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    DataCell(
                      Text(
                        '₹$amount',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: type == 'refund' ? AppColors.error : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                        ),
                      ),
                    ),
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
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(method, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight))),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCards(int totalCommission, int totalPayment, int totalRefund, int netAmount, bool isMobile) {
    final cards = [
      OrgStatsCard(
        title: 'Total Commission',
        value: '₹$totalCommission',
        subtitle: 'From all admissions',
        icon: Icons.trending_up_rounded,
        variant: OrgStatsCardVariant.success,
      ),
      OrgStatsCard(
        title: 'Total Payments',
        value: '₹$totalPayment',
        subtitle: 'Total paid out',
        icon: Icons.payments_outlined,
        variant: OrgStatsCardVariant.primary,
      ),
      OrgStatsCard(
        title: 'Total Refunds',
        value: '₹$totalRefund',
        subtitle: 'Refunds processed',
        icon: Icons.trending_down_rounded,
        variant: OrgStatsCardVariant.defaultVariant,
      ),
      OrgStatsCard(
        title: 'Net Amount',
        value: '₹$netAmount',
        subtitle: 'Comm. + Pay - Refund',
        icon: Icons.account_balance_wallet_outlined,
        variant: OrgStatsCardVariant.warning,
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

  Widget _buildHeader(bool isDark) {
    return Column(
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
          'Partner Transactions',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'View and manage partner financial transactions',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
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
