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

class StudentAdmissionFormScreen extends StatefulWidget {
  const StudentAdmissionFormScreen({super.key});

  @override
  State<StudentAdmissionFormScreen> createState() => _StudentAdmissionFormScreenState();
}

class _StudentAdmissionFormScreenState extends State<StudentAdmissionFormScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Personal Controllers
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController(text: '2005-06-15');
  String _gender = 'male';
  String _bloodGroup = 'aplus';
  String _nationality = 'indian';
  final _religionController = TextEditingController(text: 'Hindu');
  String _category = 'general';
  final _aadharController = TextEditingController();
  final _apaarController = TextEditingController();
  final _admissionDateController = TextEditingController(text: '2024-01-15');
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _altMobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  // Academic Controllers
  String _course = 'cs';
  String _batch = 'morning';
  String _academicYear = '2024-25';

  // 10th
  final _prevSchool10Controller = TextEditingController();
  String _board10 = 'cbse';
  final _passingYear10Controller = TextEditingController(text: '2022');
  final _percentage10Controller = TextEditingController(text: '85%');
  final _rollNo10Controller = TextEditingController();
  final _subjects10Controller = TextEditingController(text: 'Eng, Math, Sci, SST, Hindi');

  // 12th
  final _prevCollege12Controller = TextEditingController();
  String _board12 = 'cbse';
  final _passingYear12Controller = TextEditingController(text: '2024');
  final _percentage12Controller = TextEditingController(text: '88%');
  String _stream12 = 'science';
  final _subjects12Controller = TextEditingController(text: 'Physics, Chem, Math, Eng, CS');

  // Guardian Controllers
  final _fatherNameController = TextEditingController();
  final _fatherOccupationController = TextEditingController();
  final _fatherMobileController = TextEditingController();
  final _fatherEmailController = TextEditingController();
  final _fatherIncomeController = TextEditingController(text: '600000');
  final _motherNameController = TextEditingController();
  final _motherOccupationController = TextEditingController();
  final _motherMobileController = TextEditingController();
  final _guardianNameController = TextEditingController();
  final _guardianRelationController = TextEditingController();
  final _guardianMobileController = TextEditingController();
  final _guardianAddressController = TextEditingController();

  // Documents status
  final Map<String, bool> _documents = {
    '10th Marksheet': true,
    '12th Marksheet': false,
    'Transfer Certificate': false,
    'Aadhar Card': true,
    'APAAR Card': false,
    'Caste Certificate': false,
  };

  // Payment
  String _paymentMethod = 'upi';
  bool _termsAgreed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _religionController.dispose();
    _aadharController.dispose();
    _apaarController.dispose();
    _admissionDateController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _altMobileController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _prevSchool10Controller.dispose();
    _passingYear10Controller.dispose();
    _percentage10Controller.dispose();
    _rollNo10Controller.dispose();
    _subjects10Controller.dispose();
    _prevCollege12Controller.dispose();
    _passingYear12Controller.dispose();
    _percentage12Controller.dispose();
    _subjects12Controller.dispose();
    _fatherNameController.dispose();
    _fatherOccupationController.dispose();
    _fatherMobileController.dispose();
    _fatherEmailController.dispose();
    _fatherIncomeController.dispose();
    _motherNameController.dispose();
    _motherOccupationController.dispose();
    _motherMobileController.dispose();
    _guardianNameController.dispose();
    _guardianRelationController.dispose();
    _guardianMobileController.dispose();
    _guardianAddressController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_termsAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to terms and conditions to proceed.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Admission Application APP2024006 submitted successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
    context.go(RouteNames.studentViewPath);
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
          AppSpacing.vLg,

          // Application Status Bar Card
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        borderRadius: AppRadius.sm,
                        border: Border.all(color: AppColors.primary.withAlpha(60)),
                      ),
                      child: Text(
                        'Application No: APP2024006',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    AppSpacing.hSm,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                        borderRadius: AppRadius.sm,
                      ),
                      child: Text(
                        'Draft',
                        style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Started: January 15, 2024',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.vLg,

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
                Tab(icon: Icon(Icons.person_outline, size: 18), text: 'Personal'),
                Tab(icon: Icon(Icons.school_outlined, size: 18), text: 'Academic'),
                Tab(icon: Icon(Icons.people_outline, size: 18), text: 'Guardian'),
                Tab(icon: Icon(Icons.file_present_rounded, size: 18), text: 'Documents'),
                Tab(icon: Icon(Icons.credit_card_rounded, size: 18), text: 'Payment'),
              ],
            ),
          ),
          AppSpacing.vLg,

          // Tab Views
          SizedBox(
            height: 820,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPersonalTab(isDark),
                _buildAcademicTab(isDark),
                _buildGuardianTab(isDark),
                _buildDocumentsTab(isDark),
                _buildPaymentTab(isDark),
              ],
            ),
          ),
          AppSpacing.vLg,

          // Navigation Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppButton(
                text: 'Save as Draft',
                variant: AppButtonVariant.outline,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Application draft saved.')),
                  );
                },
              ),
              Row(
                children: [
                  if (_tabController.index > 0)
                    AppButton(
                      text: 'Previous',
                      variant: AppButtonVariant.outline,
                      onPressed: () {
                        setState(() => _tabController.index -= 1);
                      },
                    ),
                  AppSpacing.hSm,
                  AppButton(
                    text: _tabController.index == 4 ? 'Submit Application' : 'Continue',
                    icon: _tabController.index == 4 ? Icons.check_circle_outline : Icons.arrow_forward_rounded,
                    onPressed: () {
                      if (_tabController.index < 4) {
                        setState(() => _tabController.index += 1);
                      } else {
                        _handleSubmit();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalTab(bool isDark) {
    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            Text(
              'Enter the applicant\'s personal details',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            AppSpacing.vLg,

            // Names
            Row(
              children: [
                Expanded(child: AppTextField(controller: _firstNameController, label: 'First Name *', hint: 'First name')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _middleNameController, label: 'Middle Name', hint: 'Middle name')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _lastNameController, label: 'Last Name *', hint: 'Last name')),
              ],
            ),
            AppSpacing.vMd,

            // DOB, Gender, Blood Group
            Row(
              children: [
                Expanded(child: AppTextField(controller: _dobController, label: 'Date of Birth *', hint: 'YYYY-MM-DD', suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18))),
                AppSpacing.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('Gender *', isDark),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: _gender,
                        isExpanded: true,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: 'male', child: Text('Male')),
                          DropdownMenuItem(value: 'female', child: Text('Female')),
                          DropdownMenuItem(value: 'other', child: Text('Other')),
                        ],
                        onChanged: (v) => setState(() => _gender = v!),
                      ),
                    ],
                  ),
                ),
                AppSpacing.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('Blood Group', isDark),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: _bloodGroup,
                        isExpanded: true,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: 'aplus', child: Text('A+')),
                          DropdownMenuItem(value: 'aminus', child: Text('A-')),
                          DropdownMenuItem(value: 'bplus', child: Text('B+')),
                          DropdownMenuItem(value: 'bminus', child: Text('B-')),
                          DropdownMenuItem(value: 'oplus', child: Text('O+')),
                          DropdownMenuItem(value: 'ominus', child: Text('O-')),
                          DropdownMenuItem(value: 'abplus', child: Text('AB+')),
                          DropdownMenuItem(value: 'abminus', child: Text('AB-')),
                        ],
                        onChanged: (v) => setState(() => _bloodGroup = v!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.vMd,

            // Nationality, Religion, Category
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('Nationality *', isDark),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: _nationality,
                        isExpanded: true,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: 'indian', child: Text('Indian')),
                          DropdownMenuItem(value: 'other', child: Text('Other')),
                        ],
                        onChanged: (v) => setState(() => _nationality = v!),
                      ),
                    ],
                  ),
                ),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _religionController, label: 'Religion', hint: 'Religion')),
                AppSpacing.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('Category', isDark),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: _category,
                        isExpanded: true,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: 'general', child: Text('General')),
                          DropdownMenuItem(value: 'obc', child: Text('OBC')),
                          DropdownMenuItem(value: 'sc', child: Text('SC')),
                          DropdownMenuItem(value: 'st', child: Text('ST')),
                          DropdownMenuItem(value: 'ews', child: Text('EWS')),
                        ],
                        onChanged: (v) => setState(() => _category = v!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.vMd,

            // Aadhar, APAAR, Date of Admission
            Row(
              children: [
                Expanded(child: AppTextField(controller: _aadharController, label: 'Aadhar Number', hint: 'XXXX XXXX XXXX')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _apaarController, label: 'APAAR Number', hint: 'Enter APAAR Number')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _admissionDateController, label: 'Date of Admission', hint: 'YYYY-MM-DD', suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18))),
              ],
            ),
            AppSpacing.vLg,

            // Contact Info
            Text(
              'Contact Information',
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            AppSpacing.vMd,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _emailController, label: 'Email Address *', hint: 'student@email.com', keyboardType: TextInputType.emailAddress)),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _mobileController, label: 'Mobile Number *', hint: '+91 98765 43210', keyboardType: TextInputType.phone)),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _altMobileController, label: 'Alternate Number', hint: '+91 98765 43211', keyboardType: TextInputType.phone)),
              ],
            ),
            AppSpacing.vMd,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldLabel('Permanent Address *', isDark),
                AppSpacing.vXs,
                TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: const InputDecoration(hintText: 'Enter full address...'),
                ),
              ],
            ),
            AppSpacing.vMd,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _cityController, label: 'City *', hint: 'City')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _stateController, label: 'State *', hint: 'State')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _pincodeController, label: 'Pincode *', hint: 'Pincode')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicTab(bool isDark) {
    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Academic Information',
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              'Enter course selection and previous education details',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            AppSpacing.vLg,

            // Course selection
            Text('Course Selection', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.vMd,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('Course *', isDark),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: _course,
                        isExpanded: true,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: 'cs', child: Text('Computer Science')),
                          DropdownMenuItem(value: 'commerce', child: Text('Commerce')),
                          DropdownMenuItem(value: 'engineering', child: Text('Engineering')),
                          DropdownMenuItem(value: 'arts', child: Text('Arts')),
                        ],
                        onChanged: (v) => setState(() => _course = v!),
                      ),
                    ],
                  ),
                ),
                AppSpacing.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('Batch *', isDark),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: _batch,
                        isExpanded: true,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: 'morning', child: Text('Morning Batch')),
                          DropdownMenuItem(value: 'evening', child: Text('Evening Batch')),
                        ],
                        onChanged: (v) => setState(() => _batch = v!),
                      ),
                    ],
                  ),
                ),
                AppSpacing.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('Academic Year', isDark),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: _academicYear,
                        isExpanded: true,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: '2024-25', child: Text('2024-25')),
                          DropdownMenuItem(value: '2025-26', child: Text('2025-26')),
                        ],
                        onChanged: (v) => setState(() => _academicYear = v!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.vXl,

            // 10th
            Text('Previous Education - 10th Standard', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.vMd,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _prevSchool10Controller, label: 'School Name *', hint: 'School name')),
                AppSpacing.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('Board *', isDark),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: _board10,
                        isExpanded: true,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: 'cbse', child: Text('CBSE')),
                          DropdownMenuItem(value: 'icse', child: Text('ICSE')),
                          DropdownMenuItem(value: 'state', child: Text('State Board')),
                        ],
                        onChanged: (v) => setState(() => _board10 = v!),
                      ),
                    ],
                  ),
                ),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _passingYear10Controller, label: 'Year of Passing *', hint: '2022', keyboardType: TextInputType.number)),
              ],
            ),
            AppSpacing.vMd,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _percentage10Controller, label: 'Percentage/CGPA *', hint: '85%')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _rollNo10Controller, label: 'Roll Number', hint: 'Roll number')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _subjects10Controller, label: 'Subjects', hint: 'Main subjects')),
              ],
            ),
            AppSpacing.vXl,

            // 12th
            Text('Previous Education - 12th Standard', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.vMd,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _prevCollege12Controller, label: 'School/College Name', hint: 'College name')),
                AppSpacing.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('Board', isDark),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: _board12,
                        isExpanded: true,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: 'cbse', child: Text('CBSE')),
                          DropdownMenuItem(value: 'icse', child: Text('ISC')),
                          DropdownMenuItem(value: 'state', child: Text('State Board')),
                        ],
                        onChanged: (v) => setState(() => _board12 = v!),
                      ),
                    ],
                  ),
                ),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _passingYear12Controller, label: 'Year of Passing', hint: '2024', keyboardType: TextInputType.number)),
              ],
            ),
            AppSpacing.vMd,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _percentage12Controller, label: 'Percentage/CGPA', hint: '88%')),
                AppSpacing.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('Stream', isDark),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: _stream12,
                        isExpanded: true,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: 'science', child: Text('Science')),
                          DropdownMenuItem(value: 'commerce', child: Text('Commerce')),
                          DropdownMenuItem(value: 'arts', child: Text('Arts')),
                        ],
                        onChanged: (v) => setState(() => _stream12 = v!),
                      ),
                    ],
                  ),
                ),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _subjects12Controller, label: 'Subjects', hint: 'Main subjects')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuardianTab(bool isDark) {
    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Guardian Information', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            Text('Enter parent/guardian details', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
            AppSpacing.vLg,

            // Father
            Text('Father\'s Details', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.vMd,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _fatherNameController, label: 'Father\'s Name *', hint: 'Full name')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _fatherOccupationController, label: 'Occupation', hint: 'Occupation')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _fatherMobileController, label: 'Mobile Number', hint: '+91 98765 43210', keyboardType: TextInputType.phone)),
              ],
            ),
            AppSpacing.vMd,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _fatherEmailController, label: 'Email Address', hint: 'father@email.com', keyboardType: TextInputType.emailAddress)),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _fatherIncomeController, label: 'Annual Income', hint: 'e.g., 600000', keyboardType: TextInputType.number)),
              ],
            ),
            AppSpacing.vXl,

            // Mother
            Text('Mother\'s Details', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.vMd,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _motherNameController, label: 'Mother\'s Name *', hint: 'Full name')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _motherOccupationController, label: 'Occupation', hint: 'Occupation')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _motherMobileController, label: 'Mobile Number', hint: '+91 98765 43210', keyboardType: TextInputType.phone)),
              ],
            ),
            AppSpacing.vXl,

            // Local Guardian
            Text('Local Guardian (If different from parents)', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.vMd,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _guardianNameController, label: 'Guardian Name', hint: 'Full name')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _guardianRelationController, label: 'Relationship', hint: 'e.g., Uncle, Aunt')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _guardianMobileController, label: 'Mobile Number', hint: '+91 98765 43210', keyboardType: TextInputType.phone)),
              ],
            ),
            AppSpacing.vMd,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldLabel('Guardian Address', isDark),
                AppSpacing.vXs,
                TextFormField(
                  controller: _guardianAddressController,
                  maxLines: 2,
                  decoration: const InputDecoration(hintText: 'Guardian\'s address...'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsTab(bool isDark) {
    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Document Upload', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            Text('Upload required documents for admission verification', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
            AppSpacing.vLg,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _documents.length,
              itemBuilder: (context, index) {
                final docName = _documents.keys.elementAt(index);
                final isUploaded = _documents[docName]!;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight,
                    borderRadius: AppRadius.md,
                    border: Border.all(
                      color: isUploaded ? AppColors.success.withAlpha(80) : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isUploaded ? Icons.check_circle_rounded : Icons.description_outlined,
                            color: isUploaded ? AppColors.success : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                            size: 24,
                          ),
                          AppSpacing.hMd,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(docName, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                              Text(
                                isUploaded ? 'Uploaded (PDF 1.2MB)' : 'Required (PDF, Max 5MB)',
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 11,
                                  color: isUploaded ? AppColors.success : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      AppButton(
                        text: isUploaded ? 'Replace' : 'Upload',
                        variant: isUploaded ? AppButtonVariant.outline : AppButtonVariant.primary,
                        height: 32,
                        onPressed: () {
                          setState(() => _documents[docName] = true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Document "$docName" uploaded.')),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTab(bool isDark) {
    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fee Payment', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            Text('Review and pay admission fees', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
            AppSpacing.vLg,

            // Fee breakdown table
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                borderRadius: AppRadius.sm,
              ),
              child: Column(
                children: [
                  _buildFeeRow('Admission Fee', '₹5,000', isDark),
                  const Divider(height: 1),
                  _buildFeeRow('Tuition Fee (First Semester)', '₹25,000', isDark),
                  const Divider(height: 1),
                  _buildFeeRow('Library Fee', '₹2,000', isDark),
                  const Divider(height: 1),
                  _buildFeeRow('Lab Fee', '₹3,000', isDark),
                  const Divider(height: 1),
                  Container(
                    color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800)),
                        Text('₹35,000', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.vLg,

            // Payment Methods
            Text('Payment Method', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.vSm,
            Row(
              children: [
                Expanded(child: _buildPaymentMethodCard('card', 'Credit / Debit Card', Icons.credit_card_rounded, isDark)),
                AppSpacing.hMd,
                Expanded(child: _buildPaymentMethodCard('upi', 'UPI Payment', Icons.qr_code_2_rounded, isDark)),
                AppSpacing.hMd,
                Expanded(child: _buildPaymentMethodCard('netbanking', 'Net Banking', Icons.account_balance_rounded, isDark)),
              ],
            ),
            AppSpacing.vLg,

            // Terms Checkbox
            Row(
              children: [
                Checkbox(
                  value: _termsAgreed,
                  onChanged: (v) => setState(() => _termsAgreed = v ?? false),
                  activeColor: AppColors.primary,
                ),
                AppSpacing.hXs,
                Expanded(
                  child: Text(
                    'I agree to the terms and conditions and confirm that all information provided is accurate.',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeRow(String title, String amount, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.bodySmall),
          Text(amount, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(String id, String label, IconData icon, bool isDark) {
    final isSelected = _paymentMethod == id;
    return InkWell(
      onTap: () => setState(() => _paymentMethod = id),
      borderRadius: AppRadius.md,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withAlpha(isDark ? 30 : 15) : (isDark ? AppColors.surfaceDark : AppColors.backgroundLight),
          borderRadius: AppRadius.md,
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight), size: 28),
            AppSpacing.vSm,
            Text(
              label,
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

  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => context.go(RouteNames.studentViewPath),
              child: Text(
                'Student Management',
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
              'Admission Form',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Student Admission Form',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Complete admission application form',
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
