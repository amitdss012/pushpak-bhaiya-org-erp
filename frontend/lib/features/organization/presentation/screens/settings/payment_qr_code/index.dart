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

class PaymentQRCodeScreen extends StatefulWidget {
  const PaymentQRCodeScreen({super.key});

  @override
  State<PaymentQRCodeScreen> createState() => _PaymentQRCodeScreenState();
}

class _PaymentQRCodeScreenState extends State<PaymentQRCodeScreen> {
  final _qrNameController = TextEditingController(text: 'Main Fee Collection');
  final _upiIdController = TextEditingController(text: 'school@upi');
  final _merchantNameController = TextEditingController(text: 'Pushpak Academy');
  final _amountController = TextEditingController();
  final _descController = TextEditingController(text: 'Annual School Tuition Fee');

  String _paymentType = 'static';
  bool _setAsPrimary = true;
  bool _isQrGenerated = true;

  final List<Map<String, dynamic>> _existingQRCodes = [
    {'id': 1, 'name': 'Main Account UPI', 'upiId': 'school@upi', 'isActive': true},
    {'id': 2, 'name': 'Fee Collection', 'upiId': 'schoolfee@paytm', 'isActive': true},
    {'id': 3, 'name': 'Hostel Fees', 'upiId': 'hostel@upi', 'isActive': false},
  ];

  @override
  void dispose() {
    _qrNameController.dispose();
    _upiIdController.dispose();
    _merchantNameController.dispose();
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _handleGenerateQR() {
    setState(() => _isQrGenerated = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment QR Code generated successfully!'), backgroundColor: AppColors.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop || context.isUltraWide;

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

          // 2 Columns Grid
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: _buildCreateQRCard(isDark)),
                AppSpacing.hLg,
                Expanded(flex: 1, child: _buildQRPreviewCard(isDark)),
              ],
            )
          else
            Column(
              children: [
                _buildCreateQRCard(isDark),
                AppSpacing.vLg,
                _buildQRPreviewCard(isDark),
              ],
            ),

          AppSpacing.vXl,

          // Existing QR Codes List
          _buildExistingQRCodesCard(isDark),
        ],
      ),
    );
  }

  Widget _buildCreateQRCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.qr_code_rounded, color: AppColors.primary),
              AppSpacing.hSm,
              Text('Create QR Code', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          AppSpacing.vXs,
          Text('Generate a new payment QR code for fee collection', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
          AppSpacing.vLg,
          AppTextField(controller: _qrNameController, label: 'QR Code Name', hint: 'e.g., Main Fee Collection'),
          AppSpacing.vMd,
          AppTextField(controller: _upiIdController, label: 'UPI ID', hint: 'e.g., school@upi'),
          AppSpacing.vMd,
          AppTextField(controller: _merchantNameController, label: 'Merchant Name', hint: 'School Name'),
          AppSpacing.vMd,
          _buildFieldLabel('Payment Type', isDark),
          AppSpacing.vXs,
          DropdownButtonFormField<String>(
            initialValue: _paymentType,
            isExpanded: true,
            decoration: const InputDecoration(),
            items: const [
              DropdownMenuItem(value: 'static', child: Text('Static QR (Fixed Amount)')),
              DropdownMenuItem(value: 'dynamic', child: Text('Dynamic QR (Variable Amount)')),
            ],
            onChanged: (v) => setState(() => _paymentType = v!),
          ),
          AppSpacing.vMd,
          AppTextField(controller: _amountController, label: 'Default Amount (Optional)', hint: '0.00'),
          AppSpacing.vMd,
          _buildFieldLabel('Payment Description', isDark),
          AppSpacing.vXs,
          TextFormField(
            controller: _descController,
            maxLines: 2,
            decoration: const InputDecoration(hintText: 'Fee payment for...'),
          ),
          AppSpacing.vLg,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
              borderRadius: AppRadius.sm,
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Set as Primary', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                    Text('Use as default payment QR', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                  ],
                ),
                Switch(value: _setAsPrimary, onChanged: (v) => setState(() => _setAsPrimary = v), activeTrackColor: AppColors.primary),
              ],
            ),
          ),
          AppSpacing.vLg,
          AppButton(
            text: 'Generate QR Code',
            icon: Icons.qr_code_2_rounded,
            onPressed: _handleGenerateQR,
          ),
        ],
      ),
    );
  }

  Widget _buildQRPreviewCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('QR Code Preview', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                AppSpacing.vXs,
                Text('Preview of the generated QR code', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
              ],
            ),
          ),
          AppSpacing.vXl,
          Container(
            width: 220,
            height: 220,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.md,
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: _isQrGenerated
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code_2_rounded, size: 140, color: Colors.black87),
                      AppSpacing.vXs,
                      Text(_upiIdController.text, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w600)),
                    ],
                  )
                : Icon(Icons.qr_code_rounded, size: 80, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          ),
          AppSpacing.vMd,
          Text(_qrNameController.text, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
          Text(_merchantNameController.text, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          AppSpacing.vLg,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                text: 'Download',
                icon: Icons.download_rounded,
                variant: AppButtonVariant.outline,
                onPressed: _isQrGenerated
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloading QR Code image...')));
                      }
                    : null,
                height: 36,
              ),
              AppSpacing.hSm,
              AppButton(
                text: 'Print',
                icon: Icons.print_outlined,
                variant: AppButtonVariant.outline,
                onPressed: _isQrGenerated
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Printing QR Code sticker...')));
                      }
                    : null,
                height: 36,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExistingQRCodesCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Existing QR Codes', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vXs,
          Text('Manage your configured payment QR codes', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
          AppSpacing.vLg,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _existingQRCodes.length,
            separatorBuilder: (ctx, i) => AppSpacing.vSm,
            itemBuilder: (ctx, index) {
              final qr = _existingQRCodes[index];
              final isActive = qr['isActive'] as bool;

              return Container(
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
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(20),
                            borderRadius: AppRadius.sm,
                          ),
                          child: const Icon(Icons.qr_code_2_rounded, color: AppColors.primary, size: 24),
                        ),
                        AppSpacing.hMd,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(qr['name'] as String, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                            Text(qr['upiId'] as String, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Switch(
                          value: isActive,
                          onChanged: (v) => setState(() => qr['isActive'] = v),
                          activeTrackColor: AppColors.primary,
                        ),
                        IconButton(
                          icon: const Icon(Icons.download_rounded, size: 18),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloading ${qr['name']} QR.')));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.visibility_outlined, size: 18),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Viewing ${qr['name']} QR.')));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                          onPressed: () {
                            setState(() => _existingQRCodes.removeAt(index));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Removed ${qr['name']}.'), backgroundColor: AppColors.error));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
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
              'Payment QR Code',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Payment QR Code',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Configure UPI QR codes for payment collection',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label, bool isDark) {
    return Text(
      label,
      style: AppTypography.labelMedium.copyWith(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
