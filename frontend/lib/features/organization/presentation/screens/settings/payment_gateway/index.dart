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

class PaymentGatewayScreen extends StatefulWidget {
  const PaymentGatewayScreen({super.key});

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _keyIdController = TextEditingController(text: 'rzp_live_xxxxxxxxxx');
  final _keySecretController = TextEditingController(text: '••••••••••••••••');
  final _webhookSecretController = TextEditingController(text: 'whsec_xxxxxxxxxx');

  bool _testMode = false;
  bool _webhookVerification = true;

  final List<Map<String, dynamic>> _gateways = [
    {
      'id': 'razorpay',
      'name': 'Razorpay',
      'description': 'Accept payments via UPI, Cards, Netbanking, Wallets',
      'status': 'connected',
      'icon': Icons.payment_rounded,
      'color': const Color(0xFF0C2340),
    },
    {
      'id': 'paytm',
      'name': 'Paytm',
      'description': 'Accept payments via Paytm Wallet, UPI, Cards',
      'status': 'disconnected',
      'icon': Icons.account_balance_wallet_rounded,
      'color': const Color(0xFF002E6E),
    },
    {
      'id': 'stripe',
      'name': 'Stripe',
      'description': 'Global payment processing for cards and wallets',
      'status': 'disconnected',
      'icon': Icons.credit_card_rounded,
      'color': const Color(0xFF635BFF),
    },
    {
      'id': 'phonepe',
      'name': 'PhonePe',
      'description': 'Accept UPI payments via PhonePe',
      'status': 'disconnected',
      'icon': Icons.phone_android_rounded,
      'color': const Color(0xFF5F259F),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _keyIdController.dispose();
    _keySecretController.dispose();
    _webhookSecretController.dispose();
    super.dispose();
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

          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
              borderRadius: AppRadius.md,
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: isMobile,
              tabAlignment: isMobile ? TabAlignment.start : TabAlignment.fill,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              tabs: const [
                Tab(text: 'Payment Gateways'),
                Tab(text: 'Gateway Settings'),
                Tab(text: 'Transaction Logs'),
              ],
            ),
          ),
          AppSpacing.vLg,

          // Tab View
          SizedBox(
            height: 600,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGatewaysTab(isDark),
                _buildSettingsTab(isDark),
                _buildTransactionsTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGatewaysTab(bool isDark) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: _gateways.map((gw) {
          final isConnected = gw['status'] == 'connected';
          return SizedBox(
            width: 380,
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: (gw['color'] as Color).withAlpha(30),
                              borderRadius: AppRadius.sm,
                            ),
                            child: Icon(gw['icon'] as IconData, color: gw['color'] as Color, size: 24),
                          ),
                          AppSpacing.hMd,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(gw['name'] as String, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isConnected ? AppColors.success.withAlpha(20) : AppColors.borderLight.withAlpha(50),
                          borderRadius: AppRadius.sm,
                          border: Border.all(color: isConnected ? AppColors.success.withAlpha(60) : AppColors.borderLight),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isConnected ? Icons.check_circle_outline_rounded : Icons.info_outline_rounded,
                              size: 13,
                              color: isConnected ? AppColors.success : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                            ),
                            AppSpacing.hXs,
                            Text(
                              isConnected ? 'Connected' : 'Not Connected',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isConnected ? AppColors.success : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vMd,
                  Text(
                    gw['description'] as String,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  AppSpacing.vLg,
                  Row(
                    children: [
                      if (isConnected) ...[
                        AppButton(
                          text: 'Configure',
                          variant: AppButtonVariant.outline,
                          height: 34,
                          onPressed: () => _tabController.animateTo(1),
                        ),
                        AppSpacing.hSm,
                        AppButton(
                          text: 'Disconnect',
                          variant: AppButtonVariant.outline,
                          height: 34,
                          onPressed: () {
                            setState(() => gw['status'] = 'disconnected');
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${gw['name']} disconnected.')));
                          },
                        ),
                      ] else ...[
                        AppButton(
                          text: 'Connect',
                          height: 34,
                          onPressed: () {
                            setState(() => gw['status'] = 'connected');
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${gw['name']} connected!'), backgroundColor: AppColors.success));
                          },
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingsTab(bool isDark) {
    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.credit_card_rounded, color: AppColors.primary),
                AppSpacing.hSm,
                Text('Razorpay Configuration', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            AppSpacing.vXs,
            Text('Configure your Razorpay API credentials for payment processing', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
            AppSpacing.vLg,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _keyIdController, label: 'API Key ID', hint: 'rzp_live_xxxxxxxxxx', obscureText: true)),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _keySecretController, label: 'API Key Secret', hint: '••••••••••••••••', obscureText: true)),
              ],
            ),
            AppSpacing.vLg,
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                borderRadius: AppRadius.sm,
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.public_rounded, size: 20, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                      AppSpacing.hMd,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Test Mode', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                          Text('Use test credentials for development', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                        ],
                      ),
                    ],
                  ),
                  Switch(value: _testMode, onChanged: (v) => setState(() => _testMode = v), activeTrackColor: AppColors.primary),
                ],
              ),
            ),
            AppSpacing.vMd,
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                borderRadius: AppRadius.sm,
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shield_outlined, size: 20, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                      AppSpacing.hMd,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Webhook Verification', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                          Text('Verify webhook signatures for enhanced security', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                        ],
                      ),
                    ],
                  ),
                  Switch(value: _webhookVerification, onChanged: (v) => setState(() => _webhookVerification = v), activeTrackColor: AppColors.primary),
                ],
              ),
            ),
            AppSpacing.vLg,
            AppTextField(controller: _webhookSecretController, label: 'Webhook Secret', hint: 'whsec_xxxxxxxxxx', obscureText: true),
            AppSpacing.vLg,
            AppButton(
              text: 'Save Configuration',
              icon: Icons.save_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Razorpay configuration saved!'), backgroundColor: AppColors.success),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsTab(bool isDark) {
    return SingleChildScrollView(
      child: AppCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.credit_card_outlined, size: 56, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              AppSpacing.vLg,
              Text('No transactions yet', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
              AppSpacing.vXs,
              Text(
                'Transactions will appear here once payments are processed through your configured gateways.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
            ],
          ),
        ),
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
              onTap: () => context.go(RouteNames.settingsGeneralPath),
              child: Text(
                'Settings',
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
              'Payment Gateway',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Payment Gateway',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Configure payment gateways for fee collection',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
