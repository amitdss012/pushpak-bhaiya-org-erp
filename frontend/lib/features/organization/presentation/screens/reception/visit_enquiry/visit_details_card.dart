import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_card.dart';
import '../../../../../../shared/widgets/app_text_field.dart';

class VisitDetailsCard extends StatelessWidget {
  final TextEditingController visitDateController;
  final TextEditingController visitTimeController;
  final String? selectedPurpose;
  final ValueChanged<String?> onPurposeChanged;
  final String? selectedPersonToMeet;
  final ValueChanged<String?> onPersonToMeetChanged;
  final String? selectedDepartment;
  final ValueChanged<String?> onDepartmentChanged;
  final TextEditingController noOfPersonsController;
  final TextEditingController enquiryReasonController;
  final TextEditingController locationController;
  final TextEditingController remarksController;

  const VisitDetailsCard({
    super.key,
    required this.visitDateController,
    required this.visitTimeController,
    required this.selectedPurpose,
    required this.onPurposeChanged,
    required this.selectedPersonToMeet,
    required this.onPersonToMeetChanged,
    required this.selectedDepartment,
    required this.onDepartmentChanged,
    required this.noOfPersonsController,
    required this.enquiryReasonController,
    required this.locationController,
    required this.remarksController,
  });

  static const List<DropdownMenuItem<String>> _purposeItems = [
    DropdownMenuItem(value: 'admission', child: Text('Admission Enquiry')),
    DropdownMenuItem(value: 'fee', child: Text('Fee Related')),
    DropdownMenuItem(value: 'meeting', child: Text('Meeting')),
    DropdownMenuItem(value: 'complaint', child: Text('Complaint')),
    DropdownMenuItem(value: 'delivery', child: Text('Delivery')),
    DropdownMenuItem(value: 'interview', child: Text('Interview')),
    DropdownMenuItem(value: 'other', child: Text('Other')),
  ];

  static const List<DropdownMenuItem<String>> _personItems = [
    DropdownMenuItem(value: 'principal', child: Text('Principal')),
    DropdownMenuItem(value: 'admin', child: Text('Admin Officer')),
    DropdownMenuItem(value: 'accounts', child: Text('Accounts Dept')),
    DropdownMenuItem(value: 'teacher', child: Text('Class Teacher')),
    DropdownMenuItem(value: 'counselor', child: Text('Counselor')),
    DropdownMenuItem(value: 'other', child: Text('Other Staff')),
  ];

  static const List<DropdownMenuItem<String>> _departmentItems = [
    DropdownMenuItem(value: 'administration', child: Text('Administration')),
    DropdownMenuItem(value: 'academics', child: Text('Academics')),
    DropdownMenuItem(value: 'accounts', child: Text('Accounts')),
    DropdownMenuItem(value: 'hr', child: Text('Human Resources')),
    DropdownMenuItem(value: 'it', child: Text('IT Department')),
  ];

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      visitDateController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
    );
    if (picked != null) {
      visitTimeController.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isDesktop = context.isDesktop || context.isUltraWide || context.isTablet;

    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              AppSpacing.hSm,
              Text(
                'Visit Details',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          AppSpacing.vLg,

          // Row 1: Visit Date & Visit Time
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(context),
                    child: IgnorePointer(
                      child: AppTextField(
                        controller: visitDateController,
                        label: 'Visit Date *',
                        hint: 'YYYY-MM-DD',
                        suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Visit date is required.'
                            : null,
                      ),
                    ),
                  ),
                ),
                AppSpacing.hMd,
                Expanded(
                  child: InkWell(
                    onTap: () => _pickTime(context),
                    child: IgnorePointer(
                      child: AppTextField(
                        controller: visitTimeController,
                        label: 'Visit Time *',
                        hint: 'HH:MM',
                        suffixIcon: const Icon(Icons.schedule_rounded, size: 18),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Visit time is required.'
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else ...[
            InkWell(
              onTap: () => _pickDate(context),
              child: IgnorePointer(
                child: AppTextField(
                  controller: visitDateController,
                  label: 'Visit Date *',
                  hint: 'YYYY-MM-DD',
                  suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Visit date is required.'
                      : null,
                ),
              ),
            ),
            AppSpacing.vMd,
            InkWell(
              onTap: () => _pickTime(context),
              child: IgnorePointer(
                child: AppTextField(
                  controller: visitTimeController,
                  label: 'Visit Time *',
                  hint: 'HH:MM',
                  suffixIcon: const Icon(Icons.schedule_rounded, size: 18),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Visit time is required.'
                      : null,
                ),
              ),
            ),
          ],
          AppSpacing.vMd,

          // Row 2: Purpose of Visit & Person to Meet
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Purpose of Visit *',
                        style: AppTypography.labelMedium.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: selectedPurpose,
                        decoration: const InputDecoration(
                          hintText: 'Select purpose',
                        ),
                        items: _purposeItems,
                        onChanged: onPurposeChanged,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Please select a purpose.'
                            : null,
                      ),
                    ],
                  ),
                ),
                AppSpacing.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Person to Meet *',
                        style: AppTypography.labelMedium.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: selectedPersonToMeet,
                        decoration: const InputDecoration(
                          hintText: 'Select person',
                        ),
                        items: _personItems,
                        onChanged: onPersonToMeetChanged,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Please select a person to meet.'
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            )
          else ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Purpose of Visit *',
                  style: AppTypography.labelMedium.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.vXs,
                DropdownButtonFormField<String>(
                  initialValue: selectedPurpose,
                  decoration: const InputDecoration(
                    hintText: 'Select purpose',
                  ),
                  items: _purposeItems,
                  onChanged: onPurposeChanged,
                  validator: (val) => val == null || val.isEmpty
                      ? 'Please select a purpose.'
                      : null,
                ),
              ],
            ),
            AppSpacing.vMd,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Person to Meet *',
                  style: AppTypography.labelMedium.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.vXs,
                DropdownButtonFormField<String>(
                  initialValue: selectedPersonToMeet,
                  decoration: const InputDecoration(
                    hintText: 'Select person',
                  ),
                  items: _personItems,
                  onChanged: onPersonToMeetChanged,
                  validator: (val) => val == null || val.isEmpty
                      ? 'Please select a person to meet.'
                      : null,
                ),
              ],
            ),
          ],
          AppSpacing.vMd,

          // Row 3: Department & Number of Persons
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Department',
                        style: AppTypography.labelMedium.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: selectedDepartment,
                        decoration: const InputDecoration(
                          hintText: 'Select department',
                        ),
                        items: _departmentItems,
                        onChanged: onDepartmentChanged,
                      ),
                    ],
                  ),
                ),
                AppSpacing.hMd,
                Expanded(
                  child: AppTextField(
                    controller: noOfPersonsController,
                    label: 'Number of Persons',
                    hint: '1',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            )
          else ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Department',
                  style: AppTypography.labelMedium.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.vXs,
                DropdownButtonFormField<String>(
                  initialValue: selectedDepartment,
                  decoration: const InputDecoration(
                    hintText: 'Select department',
                  ),
                  items: _departmentItems,
                  onChanged: onDepartmentChanged,
                ),
              ],
            ),
            AppSpacing.vMd,
            AppTextField(
              controller: noOfPersonsController,
              label: 'Number of Persons',
              hint: '1',
              keyboardType: TextInputType.number,
            ),
          ],
          AppSpacing.vMd,

          // Row 4: Enquiry Reason & Visitor Location/City
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Enquiry Reason',
                        style: AppTypography.labelMedium.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AppSpacing.vXs,
                      TextFormField(
                        controller: enquiryReasonController,
                        maxLines: 2,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Describe the reason for enquiry in detail...',
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.hMd,
                Expanded(
                  child: AppTextField(
                    controller: locationController,
                    label: 'Visitor Location / City',
                    hint: 'Enter city or area',
                  ),
                ),
              ],
            )
          else ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enquiry Reason',
                  style: AppTypography.labelMedium.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.vXs,
                TextFormField(
                  controller: enquiryReasonController,
                  maxLines: 2,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Describe the reason for enquiry in detail...',
                  ),
                ),
              ],
            ),
            AppSpacing.vMd,
            AppTextField(
              controller: locationController,
              label: 'Visitor Location / City',
              hint: 'Enter city or area',
            ),
          ],
          AppSpacing.vMd,

          // Row 5: Remarks / Notes
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Remarks / Notes',
                style: AppTypography.labelMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.vXs,
              TextFormField(
                controller: remarksController,
                maxLines: 3,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
                decoration: const InputDecoration(
                  hintText: 'Any additional information about the visit...',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
