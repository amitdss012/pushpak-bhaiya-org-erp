import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_card.dart';
import '../../../../../../shared/widgets/app_text_field.dart';

class VisitorInformationCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final String? selectedIdType;
  final ValueChanged<String?> onIdTypeChanged;
  final TextEditingController idNumberController;
  final TextEditingController companyController;
  final TextEditingController addressController;

  const VisitorInformationCard({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.selectedIdType,
    required this.onIdTypeChanged,
    required this.idNumberController,
    required this.companyController,
    required this.addressController,
  });

  static const List<DropdownMenuItem<String>> _idTypeItems = [
    DropdownMenuItem(value: 'aadhar', child: Text('Aadhar Card')),
    DropdownMenuItem(value: 'pan', child: Text('PAN Card')),
    DropdownMenuItem(value: 'driving', child: Text('Driving License')),
    DropdownMenuItem(value: 'passport', child: Text('Passport')),
    DropdownMenuItem(value: 'voter', child: Text('Voter ID')),
  ];

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
                Icons.person_add_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              AppSpacing.hSm,
              Text(
                'Visitor Information',
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

          // Row 1: Visitor Name & Phone Number
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    controller: nameController,
                    label: 'Visitor Name *',
                    hint: 'Enter full name',
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Visitor name is required.'
                        : null,
                  ),
                ),
                AppSpacing.hMd,
                Expanded(
                  child: AppTextField(
                    controller: phoneController,
                    label: 'Phone Number *',
                    hint: '+91 98765 43210',
                    keyboardType: TextInputType.phone,
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Phone number is required.'
                        : null,
                  ),
                ),
              ],
            )
          else ...[
            AppTextField(
              controller: nameController,
              label: 'Visitor Name *',
              hint: 'Enter full name',
              validator: (val) => val == null || val.trim().isEmpty
                  ? 'Visitor name is required.'
                  : null,
            ),
            AppSpacing.vMd,
            AppTextField(
              controller: phoneController,
              label: 'Phone Number *',
              hint: '+91 98765 43210',
              keyboardType: TextInputType.phone,
              validator: (val) => val == null || val.trim().isEmpty
                  ? 'Phone number is required.'
                  : null,
            ),
          ],
          AppSpacing.vMd,

          // Row 2: Email Address & ID Type
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    controller: emailController,
                    label: 'Email Address',
                    hint: 'visitor@email.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                AppSpacing.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'ID Type',
                        style: AppTypography.labelMedium.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: selectedIdType,
                        decoration: const InputDecoration(
                          hintText: 'Select ID type',
                        ),
                        items: _idTypeItems,
                        onChanged: onIdTypeChanged,
                      ),
                    ],
                  ),
                ),
              ],
            )
          else ...[
            AppTextField(
              controller: emailController,
              label: 'Email Address',
              hint: 'visitor@email.com',
              keyboardType: TextInputType.emailAddress,
            ),
            AppSpacing.vMd,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ID Type',
                  style: AppTypography.labelMedium.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.vXs,
                DropdownButtonFormField<String>(
                  initialValue: selectedIdType,
                  decoration: const InputDecoration(
                    hintText: 'Select ID type',
                  ),
                  items: _idTypeItems,
                  onChanged: onIdTypeChanged,
                ),
              ],
            ),
          ],
          AppSpacing.vMd,

          // Row 3: ID Number & Organization/Company
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    controller: idNumberController,
                    label: 'ID Number',
                    hint: 'Enter ID number',
                  ),
                ),
                AppSpacing.hMd,
                Expanded(
                  child: AppTextField(
                    controller: companyController,
                    label: 'Organization/Company',
                    hint: 'Enter organization name',
                  ),
                ),
              ],
            )
          else ...[
            AppTextField(
              controller: idNumberController,
              label: 'ID Number',
              hint: 'Enter ID number',
            ),
            AppSpacing.vMd,
            AppTextField(
              controller: companyController,
              label: 'Organization/Company',
              hint: 'Enter organization name',
            ),
          ],
          AppSpacing.vMd,

          // Row 4: Address
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Address',
                style: AppTypography.labelMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.vXs,
              TextFormField(
                controller: addressController,
                maxLines: 2,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
                decoration: const InputDecoration(
                  hintText: "Enter visitor's address",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
