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
import '../../../../../../shared/widgets/app_status_badge.dart';
import '../../../../../../shared/widgets/app_text_field.dart';
import '../../../widgets/org_stats_card.dart';

class WalletRechargeScreen extends StatefulWidget {
  const WalletRechargeScreen({super.key});

  @override
  State<WalletRechargeScreen> createState() => _WalletRechargeScreenState();
}

class _WalletRechargeScreenState extends State<WalletRechargeScreen> {
  final _amountController = TextEditingController();
  final _remarksController = TextEditingController();
  final _searchController = TextEditingController();

  Map<String, dynamic>? _selectedInstitute;
  String _selectedPaymentMethod = 'upi'; // 'card', 'upi', 'netbanking'

  final List<Map<String, dynamic>> _institutesData = [
    {'id': 'main', 'name': 'Main Campus', 'directorName': 'Dr. Rajesh Kumar', 'balance': 125000},
    {'id': 'north', 'name': 'North Campus', 'directorName': 'Mrs. Priya Sharma', 'balance': 85000},
    {'id': 'south', 'name': 'South Campus', 'directorName': 'Mr. Anand Patel', 'balance': 65000},
    {'id': 'east', 'name': 'East Campus', 'directorName': 'Dr. Sanjay Gupta', 'balance': 45000},
    {'id': 'west', 'name': 'West Campus', 'directorName': 'Mrs. Meera Singh', 'balance': 35000},
  ];

  final List<Map<String, dynamic>> _rechargeHistory = [
    {'id': '1', 'branch': 'Main Campus', 'amount': 50000, 'method': 'UPI', 'date': '2024-01-15', 'status': 'completed'},
    {'id': '2', 'branch': 'North Campus', 'amount': 30000, 'method': 'Card', 'date': '2024-01-14', 'status': 'completed'},
    {'id': '3', 'branch': 'South Campus', 'amount': 25000, 'method': 'Net Banking', 'date': '2024-01-13', 'status': 'pending'},
    {'id': '4', 'branch': 'East Campus', 'amount': 20000, 'method': 'UPI', 'date': '2024-01-12', 'status': 'completed'},
    {'id': '5', 'branch': 'Main Campus', 'amount': 45000, 'method': 'Card', 'date': '2024-01-10', 'status': 'failed'},
  ];

  static const List<int> _quickAmounts = [5000, 10000, 25000, 50000, 100000];

  @override
  void dispose() {
    _amountController.dispose();
    _remarksController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleRecharge() {
    if (_selectedInstitute == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an institute to recharge.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final amount = int.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid recharge amount.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _selectedInstitute!['balance'] = (_selectedInstitute!['balance'] as int) + amount;
      _rechargeHistory.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'branch': _selectedInstitute!['name'],
        'amount': amount,
        'method': _selectedPaymentMethod.toUpperCase(),
        'date': 'Today',
        'status': 'completed',
      });
      _amountController.clear();
      _remarksController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Recharge of ₹$amount to ${_selectedInstitute!['name']} initiated successfully!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isTablet = context.isTablet;
    final isMobile = context.isMobile;

    final filteredInstitutes = _institutesData.where((inst) {
      final q = _searchController.text.toLowerCase();
      if (q.isEmpty) return false;
      final name = (inst['name'] as String).toLowerCase();
      final dir = (inst['directorName'] as String).toLowerCase();
      return name.contains(q) || dir.contains(q);
    }).toList();

    // Stats Cards
    final card1 = const OrgStatsCard(
      title: 'Total Balance',
      value: '₹4,85,000',
      subtitle: 'All branches combined',
      icon: Icons.account_balance_wallet_rounded,
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = const OrgStatsCard(
      title: 'This Month Recharge',
      value: '₹1,70,000',
      subtitle: '5 transactions',
      icon: Icons.credit_card_rounded,
      variant: OrgStatsCardVariant.info,
    );
    final card3 = const OrgStatsCard(
      title: 'Pending Recharges',
      value: '1',
      subtitle: '₹25,000 pending',
      icon: Icons.history_rounded,
      variant: OrgStatsCardVariant.warning,
    );
    final card4 = const OrgStatsCard(
      title: 'Active Branches',
      value: '4',
      subtitle: 'With wallet enabled',
      icon: Icons.business_rounded,
      variant: OrgStatsCardVariant.success,
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
          _buildHeader(isDark),
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

          // 2-Column Content Layout
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left 2/3: New Recharge Form
                Expanded(
                  flex: 2,
                  child: _buildRechargeFormCard(filteredInstitutes, isDark),
                ),
                AppSpacing.hLg,

                // Right 1/3: Recent History & Balances
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildRecentRechargesCard(isDark),
                      AppSpacing.vLg,
                      _buildBranchBalancesCard(isDark),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildRechargeFormCard(filteredInstitutes, isDark),
                AppSpacing.vLg,
                _buildRecentRechargesCard(isDark),
                AppSpacing.vLg,
                _buildBranchBalancesCard(isDark),
              ],
            ),
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
              'Wallet Recharge',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Wallet Recharge',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Recharge branch wallets for transactions',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildRechargeFormCard(List<Map<String, dynamic>> filteredInstitutes, bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary, size: 20),
              AppSpacing.hSm,
              Text(
                'New Recharge',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          AppSpacing.vXs,
          Text(
            'Add funds to a branch wallet',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          AppSpacing.vLg,

          // Institute Search Autocomplete
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Institute *',
                      style: AppTypography.labelMedium.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppSpacing.vXs,
                    TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Search by name or director...',
                        prefixIcon: Icon(Icons.search_rounded, size: 18),
                      ),
                    ),
                    if (filteredInstitutes.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
                          borderRadius: AppRadius.sm,
                          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: filteredInstitutes.map((inst) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedInstitute = inst;
                                  _searchController.text = inst['name'];
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          inst['name'] as String,
                                          style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          'Director: ${inst['directorName']}',
                                          style: AppTypography.bodySmall.copyWith(
                                            fontSize: 11,
                                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '₹${(inst['balance'] as int).toLocaleString()}',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.success,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    if (_selectedInstitute != null) ...[
                      AppSpacing.vSm,
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.backgroundDark.withAlpha(120) : AppColors.backgroundLight,
                          borderRadius: AppRadius.sm,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedInstitute!['name'] as String,
                                  style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'Director: ${_selectedInstitute!['directorName']}',
                                  style: AppTypography.bodySmall.copyWith(
                                    fontSize: 11,
                                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Current: ₹${(_selectedInstitute!['balance'] as int).toLocaleString()}',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _amountController,
                  label: 'Recharge Amount *',
                  hint: 'Enter amount',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          AppSpacing.vLg,

          // Quick Select Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Select Amount',
                style: AppTypography.labelMedium.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.vSm,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _quickAmounts.map((amt) {
                  return InkWell(
                    onTap: () => setState(() => _amountController.text = amt.toString()),
                    borderRadius: AppRadius.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                        borderRadius: AppRadius.sm,
                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      child: Text(
                        '₹${amt.toLocaleString()}',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          AppSpacing.vLg,

          // Payment Method Selector Cards
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Method',
                style: AppTypography.labelMedium.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.vSm,
              Row(
                children: [
                  Expanded(
                    child: _buildPaymentMethodCard(
                      'card',
                      'Credit/Debit Card',
                      Icons.credit_card_rounded,
                      isDark,
                    ),
                  ),
                  AppSpacing.hMd,
                  Expanded(
                    child: _buildPaymentMethodCard(
                      'upi',
                      'UPI Payment',
                      Icons.account_balance_wallet_rounded,
                      isDark,
                    ),
                  ),
                  AppSpacing.hMd,
                  Expanded(
                    child: _buildPaymentMethodCard(
                      'netbanking',
                      'Net Banking',
                      Icons.account_balance_rounded,
                      isDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.vLg,

          // Remarks
          AppTextField(
            controller: _remarksController,
            label: 'Remarks (Optional)',
            hint: 'Add a note for this recharge',
          ),
          AppSpacing.vLg,

          // Form Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                text: 'Cancel',
                variant: AppButtonVariant.outline,
                onPressed: () {
                  setState(() {
                    _selectedInstitute = null;
                    _searchController.clear();
                    _amountController.clear();
                    _remarksController.clear();
                  });
                },
              ),
              AppSpacing.hMd,
              AppButton(
                text: 'Proceed to Payment',
                icon: Icons.arrow_outward_rounded,
                onPressed: _handleRecharge,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(String key, String title, IconData icon, bool isDark) {
    final isSelected = _selectedPaymentMethod == key;
    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = key),
      borderRadius: AppRadius.md,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(isDark ? 40 : 15)
              : (isDark ? AppColors.surfaceDark : AppColors.backgroundLight),
          borderRadius: AppRadius.md,
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: isSelected ? AppColors.primary : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
            AppSpacing.vSm,
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRechargesCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history_rounded, size: 18, color: AppColors.primary),
              AppSpacing.hSm,
              Text(
                'Recent Recharges',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          ..._rechargeHistory.map((item) {
            final branch = item['branch'] as String;
            final date = item['date'] as String;
            final method = item['method'] as String;
            final amount = item['amount'] as int;
            final status = item['status'] as String;

            AppBadgeStatus badgeStatus;
            switch (status) {
              case 'completed':
                badgeStatus = AppBadgeStatus.completed;
                break;
              case 'pending':
                badgeStatus = AppBadgeStatus.pending;
                break;
              default:
                badgeStatus = AppBadgeStatus.danger;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(branch, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                      Text(
                        '$date • $method',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 10.5,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${amount.toLocaleString()}',
                        style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                      ),
                      AppSpacing.vXs,
                      AppStatusBadge(status: badgeStatus, customLabel: status),
                    ],
                  ),
                ],
              ),
            );
          }),
          AppSpacing.vSm,
          const Divider(height: 1),
          AppSpacing.vSm,
          Center(
            child: TextButton(
              onPressed: () => context.go(RouteNames.branchTransactionsPath),
              child: const Text('View All Transactions'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchBalancesCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Branch Balances',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          AppSpacing.vMd,
          ..._institutesData.map((inst) {
            final name = inst['name'] as String;
            final director = inst['directorName'] as String;
            final balance = inst['balance'] as int;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500)),
                      Text(
                        director,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 10.5,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '₹${balance.toLocaleString()}',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
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
