import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_radius.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/app_text_field.dart';

class NewDispatchDialog extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onSubmit;

  const NewDispatchDialog({super.key, required this.onSubmit});

  @override
  State<NewDispatchDialog> createState() => _NewDispatchDialogState();
}

class _NewDispatchDialogState extends State<NewDispatchDialog> {
  final _formKey = GlobalKey<FormState>();

  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _descriptionController = TextEditingController();
  final _recipientNameController = TextEditingController();
  final _recipientPhoneController = TextEditingController();
  final _recipientAddressController = TextEditingController();
  String? _selectedCourier;
  final _trackingNumberController = TextEditingController();
  late final TextEditingController _dispatchDateController;
  final _expectedDeliveryController = TextEditingController();
  final _remarksController = TextEditingController();

  static const List<DropdownMenuItem<String>> _courierItems = [
    DropdownMenuItem(value: 'bluedart', child: Text('Blue Dart')),
    DropdownMenuItem(value: 'dtdc', child: Text('DTDC')),
    DropdownMenuItem(value: 'fedex', child: Text('FedEx')),
    DropdownMenuItem(value: 'delhivery', child: Text('Delhivery')),
    DropdownMenuItem(value: 'indiapost', child: Text('India Post')),
    DropdownMenuItem(value: 'self', child: Text('Self Delivery')),
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dispatchDateController = TextEditingController(
      text:
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
    );
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _recipientNameController.dispose();
    _recipientPhoneController.dispose();
    _recipientAddressController.dispose();
    _trackingNumberController.dispose();
    _dispatchDateController.dispose();
    _expectedDeliveryController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      controller.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final newItem = {
      'id': 'DSP${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      'itemName': _itemNameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'quantity': int.tryParse(_quantityController.text.trim()) ?? 1,
      'recipientName': _recipientNameController.text.trim(),
      'recipientAddress': _recipientAddressController.text.trim(),
      'recipientPhone': _recipientPhoneController.text.trim(),
      'courierService': _selectedCourier != null ? _selectedCourier!.toUpperCase() : 'Standard Courier',
      'trackingNumber': _trackingNumberController.text.trim().isNotEmpty
          ? _trackingNumberController.text.trim()
          : 'TRK${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      'dispatchDate': _dispatchDateController.text.trim(),
      'expectedDelivery': _expectedDeliveryController.text.trim().isNotEmpty
          ? _expectedDeliveryController.text.trim()
          : 'In 3 days',
      'status': 'active',
      'dispatchedBy': 'Admin Staff',
    };

    widget.onSubmit(newItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Dialog(
      backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.send_rounded, color: AppColors.primary, size: 20),
                        AppSpacing.hSm,
                        Text(
                          'New Item Dispatch',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                AppSpacing.vMd,

                // Form body
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section 1: Item Details
                        _buildSectionHeader('Item Details', isDark),
                        AppSpacing.vSm,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: AppTextField(
                                controller: _itemNameController,
                                label: 'Item Name *',
                                hint: 'Enter item name',
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Item name is required.'
                                    : null,
                              ),
                            ),
                            AppSpacing.hMd,
                            Expanded(
                              flex: 1,
                              child: AppTextField(
                                controller: _quantityController,
                                label: 'Quantity *',
                                hint: '1',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.vSm,
                        AppTextField(
                          controller: _descriptionController,
                          label: 'Description',
                          hint: 'Brief description of the item',
                        ),
                        AppSpacing.vLg,

                        // Section 2: Recipient Details
                        _buildSectionHeader('Recipient Details', isDark),
                        AppSpacing.vSm,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: _recipientNameController,
                                label: 'Recipient Name *',
                                hint: 'Enter recipient name',
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Recipient name is required.'
                                    : null,
                              ),
                            ),
                            AppSpacing.hMd,
                            Expanded(
                              child: AppTextField(
                                controller: _recipientPhoneController,
                                label: 'Phone Number *',
                                hint: '+91 98765 43210',
                                keyboardType: TextInputType.phone,
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Phone number is required.'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.vSm,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery Address *',
                              style: AppTypography.labelMedium.copyWith(
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            AppSpacing.vXs,
                            TextFormField(
                              controller: _recipientAddressController,
                              maxLines: 2,
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Delivery address is required.'
                                  : null,
                              decoration: const InputDecoration(
                                hintText: 'Full delivery address',
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.vLg,

                        // Section 3: Shipping Details
                        _buildSectionHeader('Shipping Details', isDark),
                        AppSpacing.vSm,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Courier Service *',
                                    style: AppTypography.labelMedium.copyWith(
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimaryLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  AppSpacing.vXs,
                                  DropdownButtonFormField<String>(
                                    initialValue: _selectedCourier,
                                    decoration: const InputDecoration(
                                      hintText: 'Select courier',
                                    ),
                                    items: _courierItems,
                                    onChanged: (v) => setState(() => _selectedCourier = v),
                                    validator: (v) => v == null ? 'Select a courier.' : null,
                                  ),
                                ],
                              ),
                            ),
                            AppSpacing.hMd,
                            Expanded(
                              child: AppTextField(
                                controller: _trackingNumberController,
                                label: 'Tracking Number',
                                hint: 'Enter tracking number',
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.vSm,
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => _pickDate(_dispatchDateController),
                                child: IgnorePointer(
                                  child: AppTextField(
                                    controller: _dispatchDateController,
                                    label: 'Dispatch Date *',
                                    hint: 'YYYY-MM-DD',
                                    suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                                  ),
                                ),
                              ),
                            ),
                            AppSpacing.hMd,
                            Expanded(
                              child: InkWell(
                                onTap: () => _pickDate(_expectedDeliveryController),
                                child: IgnorePointer(
                                  child: AppTextField(
                                    controller: _expectedDeliveryController,
                                    label: 'Expected Delivery',
                                    hint: 'YYYY-MM-DD',
                                    suffixIcon: const Icon(Icons.event_available_rounded, size: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.vSm,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Remarks',
                              style: AppTypography.labelMedium.copyWith(
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            AppSpacing.vXs,
                            TextFormField(
                              controller: _remarksController,
                              maxLines: 2,
                              decoration: const InputDecoration(
                                hintText: 'Any additional notes...',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                AppSpacing.vLg,

                // Footer Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: 'Cancel',
                      variant: AppButtonVariant.outline,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    AppSpacing.hSm,
                    AppButton(
                      text: 'Dispatch Item',
                      icon: Icons.send_rounded,
                      onPressed: _handleSubmit,
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

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title.toUpperCase(),
      style: AppTypography.labelMedium.copyWith(
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
      ),
    );
  }
}
