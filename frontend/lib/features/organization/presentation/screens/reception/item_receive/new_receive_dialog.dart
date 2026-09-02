import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_radius.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/app_text_field.dart';

class NewReceiveDialog extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onSubmit;

  const NewReceiveDialog({super.key, required this.onSubmit});

  @override
  State<NewReceiveDialog> createState() => _NewReceiveDialogState();
}

class _NewReceiveDialogState extends State<NewReceiveDialog> {
  final _formKey = GlobalKey<FormState>();

  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _descriptionController = TextEditingController();
  final _senderNameController = TextEditingController();
  final _senderPhoneController = TextEditingController();
  final _senderAddressController = TextEditingController();
  String? _selectedCourier;
  final _trackingNumberController = TextEditingController();
  late final TextEditingController _receivedDateController;
  String? _selectedDepartment;
  String _selectedCondition = 'good';
  final _receivedByController = TextEditingController();
  final _remarksController = TextEditingController();
  bool _notifyDepartmentHead = false;

  static const List<DropdownMenuItem<String>> _courierItems = [
    DropdownMenuItem(value: 'bluedart', child: Text('Blue Dart')),
    DropdownMenuItem(value: 'dtdc', child: Text('DTDC')),
    DropdownMenuItem(value: 'fedex', child: Text('FedEx')),
    DropdownMenuItem(value: 'delhivery', child: Text('Delhivery')),
    DropdownMenuItem(value: 'indiapost', child: Text('India Post')),
    DropdownMenuItem(value: 'handdelivery', child: Text('Hand Delivery')),
  ];

  static const List<DropdownMenuItem<String>> _departmentItems = [
    DropdownMenuItem(value: 'Administration', child: Text('Administration')),
    DropdownMenuItem(value: 'Academics', child: Text('Academics')),
    DropdownMenuItem(value: 'Accounts', child: Text('Accounts')),
    DropdownMenuItem(value: 'IT Department', child: Text('IT Department')),
    DropdownMenuItem(value: 'Library', child: Text('Library')),
    DropdownMenuItem(value: 'Sports', child: Text('Sports')),
    DropdownMenuItem(value: 'Science Department', child: Text('Science Department')),
    DropdownMenuItem(value: 'Arts Department', child: Text('Arts Department')),
  ];

  static const List<DropdownMenuItem<String>> _conditionItems = [
    DropdownMenuItem(value: 'good', child: Text('Good Condition')),
    DropdownMenuItem(value: 'partial', child: Text('Partially Received')),
    DropdownMenuItem(value: 'damaged', child: Text('Damaged')),
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _receivedDateController = TextEditingController(
      text:
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
    );
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _senderNameController.dispose();
    _senderPhoneController.dispose();
    _senderAddressController.dispose();
    _trackingNumberController.dispose();
    _receivedDateController.dispose();
    _receivedByController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final newItem = {
      'id': 'RCV${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      'itemName': _itemNameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'quantity': int.tryParse(_quantityController.text.trim()) ?? 1,
      'senderName': _senderNameController.text.trim(),
      'senderAddress': _senderAddressController.text.trim(),
      'senderPhone': _senderPhoneController.text.trim(),
      'courierService': _selectedCourier != null ? _selectedCourier!.toUpperCase() : 'Standard Delivery',
      'trackingNumber': _trackingNumberController.text.trim().isNotEmpty
          ? _trackingNumberController.text.trim()
          : 'TRK${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      'receivedDate': _receivedDateController.text.trim(),
      'receivedBy': _receivedByController.text.trim().isNotEmpty ? _receivedByController.text.trim() : 'Reception Staff',
      'department': _selectedDepartment ?? 'Administration',
      'condition': _selectedCondition,
      'status': 'completed',
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
                        const Icon(Icons.all_inbox_rounded, color: AppColors.primary, size: 20),
                        AppSpacing.hSm,
                        Text(
                          'Log Received Item',
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

                // Scrollable form fields
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

                        // Section 2: Sender Details
                        _buildSectionHeader('Sender Details', isDark),
                        AppSpacing.vSm,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: _senderNameController,
                                label: 'Sender Name *',
                                hint: 'Enter sender name/company',
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Sender name is required.'
                                    : null,
                              ),
                            ),
                            AppSpacing.hMd,
                            Expanded(
                              child: AppTextField(
                                controller: _senderPhoneController,
                                label: 'Phone Number',
                                hint: '+91 98765 43210',
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.vSm,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sender Address',
                              style: AppTypography.labelMedium.copyWith(
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            AppSpacing.vXs,
                            TextFormField(
                              controller: _senderAddressController,
                              maxLines: 2,
                              decoration: const InputDecoration(
                                hintText: "Sender's address",
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.vLg,

                        // Section 3: Shipping & Receiving Details
                        _buildSectionHeader('Shipping & Receiving Details', isDark),
                        AppSpacing.vSm,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Courier Service',
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: _receivedDateController,
                                label: 'Received Date *',
                                hint: 'YYYY-MM-DD HH:MM',
                              ),
                            ),
                            AppSpacing.hMd,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Forward to Department *',
                                    style: AppTypography.labelMedium.copyWith(
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimaryLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  AppSpacing.vXs,
                                  DropdownButtonFormField<String>(
                                    initialValue: _selectedDepartment,
                                    decoration: const InputDecoration(
                                      hintText: 'Select department',
                                    ),
                                    items: _departmentItems,
                                    onChanged: (v) => setState(() => _selectedDepartment = v),
                                    validator: (v) => v == null ? 'Select department.' : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.vSm,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Item Condition *',
                                    style: AppTypography.labelMedium.copyWith(
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimaryLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  AppSpacing.vXs,
                                  DropdownButtonFormField<String>(
                                    initialValue: _selectedCondition,
                                    decoration: const InputDecoration(
                                      hintText: 'Condition',
                                    ),
                                    items: _conditionItems,
                                    onChanged: (v) => setState(() => _selectedCondition = v ?? 'good'),
                                  ),
                                ],
                              ),
                            ),
                            AppSpacing.hMd,
                            Expanded(
                              child: AppTextField(
                                controller: _receivedByController,
                                label: 'Received By *',
                                hint: 'Name of receiving person',
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Receiving person name required.'
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
                                hintText: 'Any additional notes or issues...',
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.vMd,

                        // Upload Attachments Dropzone
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.backgroundDark.withAlpha(80)
                                : AppColors.backgroundLight.withAlpha(120),
                            borderRadius: AppRadius.md,
                            border: Border.all(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 20),
                              AppSpacing.hSm,
                              Text(
                                'Upload delivery receipt or photos',
                                style: AppTypography.bodySmall.copyWith(
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.vMd,

                        // Checkbox
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Notify department head about this delivery',
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          value: _notifyDepartmentHead,
                          onChanged: (v) => setState(() => _notifyDepartmentHead = v ?? false),
                          controlAffinity: ListTileControlAffinity.leading,
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
                      text: 'Log Item',
                      icon: Icons.check_rounded,
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
