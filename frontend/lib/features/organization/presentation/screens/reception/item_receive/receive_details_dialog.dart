import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_radius.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_button.dart';

class ReceiveDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback? onPrintReceipt;

  const ReceiveDetailsDialog({
    super.key,
    required this.item,
    this.onPrintReceipt,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    final itemName = item['itemName'] as String? ?? '';
    final id = item['id'] as String? ?? '';
    final description = item['description'] as String? ?? '';
    final quantity = item['quantity']?.toString() ?? '1';
    final senderName = item['senderName'] as String? ?? '';
    final senderPhone = item['senderPhone'] as String? ?? '';
    final senderAddress = item['senderAddress'] as String? ?? '';
    final courierService = item['courierService'] as String? ?? '';
    final trackingNumber = item['trackingNumber'] as String? ?? '';
    final receivedDate = item['receivedDate'] as String? ?? '';
    final department = item['department'] as String? ?? '';
    final receivedBy = item['receivedBy'] as String? ?? '';
    final condition = item['condition'] as String? ?? 'good';

    Color conditionColor;
    String conditionLabel;
    IconData conditionIcon;

    switch (condition) {
      case 'damaged':
        conditionColor = AppColors.error;
        conditionLabel = 'Damaged';
        conditionIcon = Icons.warning_amber_rounded;
        break;
      case 'partial':
        conditionColor = AppColors.warning;
        conditionLabel = 'Partial Received';
        conditionIcon = Icons.info_outline_rounded;
        break;
      default:
        conditionColor = AppColors.success;
        conditionLabel = 'Good Condition';
        conditionIcon = Icons.check_circle_outline_rounded;
    }

    return Dialog(
      backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Received Item Details',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              AppSpacing.vMd,

              // Item Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.backgroundDark.withAlpha(120)
                      : AppColors.backgroundLight,
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark.withAlpha(80)
                        : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(isDark ? 50 : 25),
                        borderRadius: AppRadius.sm,
                      ),
                      child: const Center(
                        child: Icon(Icons.all_inbox_rounded, color: AppColors.primary, size: 24),
                      ),
                    ),
                    AppSpacing.hMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itemName,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            description,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.textMutedDark
                                  : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: conditionColor.withAlpha(25),
                        borderRadius: AppRadius.full,
                        border: Border.all(color: conditionColor.withAlpha(60)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(conditionIcon, size: 12, color: conditionColor),
                          AppSpacing.hXs,
                          Text(
                            conditionLabel,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: conditionColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.vLg,

              // Details Grid
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildDetailItem('Receipt ID', id, isDark)),
                          AppSpacing.hMd,
                          Expanded(child: _buildDetailItem('Quantity', quantity, isDark)),
                        ],
                      ),
                      AppSpacing.vMd,
                      Row(
                        children: [
                          Expanded(child: _buildDetailItem('Sender', senderName, isDark)),
                          AppSpacing.hMd,
                          Expanded(child: _buildDetailItem('Phone', senderPhone, isDark)),
                        ],
                      ),
                      AppSpacing.vMd,
                      _buildDetailItem('Sender Address', senderAddress, isDark),
                      AppSpacing.vMd,
                      Row(
                        children: [
                          Expanded(child: _buildDetailItem('Courier', courierService, isDark)),
                          AppSpacing.hMd,
                          Expanded(child: _buildDetailItem('Tracking Number', trackingNumber, isDark)),
                        ],
                      ),
                      AppSpacing.vMd,
                      Row(
                        children: [
                          Expanded(child: _buildDetailItem('Received On', receivedDate, isDark)),
                          AppSpacing.hMd,
                          Expanded(child: _buildDetailItem('Department', department, isDark)),
                        ],
                      ),
                      AppSpacing.vMd,
                      _buildDetailItem('Received By', receivedBy, isDark),
                    ],
                  ),
                ),
              ),
              AppSpacing.vLg,

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    text: 'Print Receipt',
                    icon: Icons.print_rounded,
                    variant: AppButtonVariant.outline,
                    onPressed: onPrintReceipt ?? () {},
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
    );
  }

  Widget _buildDetailItem(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
}
