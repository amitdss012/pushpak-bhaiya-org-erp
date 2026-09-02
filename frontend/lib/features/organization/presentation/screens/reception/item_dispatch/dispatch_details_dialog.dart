import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_radius.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/app_status_badge.dart';

class DispatchDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback? onTrack;

  const DispatchDetailsDialog({
    super.key,
    required this.item,
    this.onTrack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    final itemName = item['itemName'] as String? ?? '';
    final id = item['id'] as String? ?? '';
    final description = item['description'] as String? ?? '';
    final quantity = item['quantity']?.toString() ?? '1';
    final recipientName = item['recipientName'] as String? ?? '';
    final recipientPhone = item['recipientPhone'] as String? ?? '';
    final recipientAddress = item['recipientAddress'] as String? ?? '';
    final courierService = item['courierService'] as String? ?? '';
    final trackingNumber = item['trackingNumber'] as String? ?? '';
    final dispatchDate = item['dispatchDate'] as String? ?? '';
    final expectedDelivery = item['expectedDelivery'] as String? ?? '';
    final status = item['status'] as String? ?? 'active';
    final dispatchedBy = item['dispatchedBy'] as String? ?? '';

    AppBadgeStatus badgeStatus;
    switch (status) {
      case 'completed':
        badgeStatus = AppBadgeStatus.completed;
        break;
      case 'pending':
        badgeStatus = AppBadgeStatus.pending;
        break;
      default:
        badgeStatus = AppBadgeStatus.active;
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
                    'Dispatch Details',
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
                        child: Icon(Icons.inventory_2_rounded, color: AppColors.primary, size: 24),
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
                    AppStatusBadge(status: badgeStatus),
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
                          Expanded(child: _buildDetailItem('Dispatch ID', id, isDark)),
                          AppSpacing.hMd,
                          Expanded(child: _buildDetailItem('Quantity', quantity, isDark)),
                        ],
                      ),
                      AppSpacing.vMd,
                      Row(
                        children: [
                          Expanded(child: _buildDetailItem('Recipient', recipientName, isDark)),
                          AppSpacing.hMd,
                          Expanded(child: _buildDetailItem('Phone', recipientPhone, isDark)),
                        ],
                      ),
                      AppSpacing.vMd,
                      _buildDetailItem('Delivery Address', recipientAddress, isDark),
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
                          Expanded(child: _buildDetailItem('Dispatched On', dispatchDate, isDark)),
                          AppSpacing.hMd,
                          Expanded(child: _buildDetailItem('Expected Delivery', expectedDelivery, isDark)),
                        ],
                      ),
                      AppSpacing.vMd,
                      _buildDetailItem('Dispatched By', dispatchedBy, isDark),
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
                    text: 'Track Shipment',
                    icon: Icons.local_shipping_rounded,
                    variant: AppButtonVariant.outline,
                    onPressed: onTrack ?? () {},
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
