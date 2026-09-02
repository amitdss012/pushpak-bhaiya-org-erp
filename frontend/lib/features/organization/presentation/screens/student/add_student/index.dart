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

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Personal
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  String _gender = 'male';
  String _bloodGroup = 'A+';
  final _nationalityController = TextEditingController(text: 'Indian');
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  // Academic
  final _rollNoController = TextEditingController(text: 'STU009');
  final _admissionDateController = TextEditingController(text: '2024-02-15');
  String _course = 'cs';
  String _batch = '2024-a';
  final _prevSchoolController = TextEditingController();
  final _prevClassController = TextEditingController();

  // Guardian
  final _fatherNameController = TextEditingController();
  final _fatherPhoneController = TextEditingController();
  final _fatherOccupationController = TextEditingController();
  final _fatherEmailController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _motherPhoneController = TextEditingController();
  final _motherOccupationController = TextEditingController();
  final _motherEmailController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyRelationController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  // Documents
  final Map<String, bool> _docsUploaded = {
    'Birth Certificate': false,
    'Previous Marksheet': false,
    'Transfer Certificate': false,
    'Address Proof': false,
    'ID Proof': false,
    'Medical Certificate': false,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _nationalityController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _rollNoController.dispose();
    _admissionDateController.dispose();
    _prevSchoolController.dispose();
    _prevClassController.dispose();
    _fatherNameController.dispose();
    _fatherPhoneController.dispose();
    _fatherOccupationController.dispose();
    _fatherEmailController.dispose();
    _motherNameController.dispose();
    _motherPhoneController.dispose();
    _motherOccupationController.dispose();
    _motherEmailController.dispose();
    _emergencyNameController.dispose();
    _emergencyRelationController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  void _handleSaveStudent() {
    if (_firstNameController.text.trim().isEmpty || _lastNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill required personal information (First & Last name).'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Student "${_firstNameController.text} ${_lastNameController.text}" registered successfully!'),
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
                Tab(icon: Icon(Icons.person_outline, size: 18), text: 'Personal'),
                Tab(icon: Icon(Icons.school_outlined, size: 18), text: 'Academic'),
                Tab(icon: Icon(Icons.home_outlined, size: 18), text: 'Guardian'),
                Tab(icon: Icon(Icons.description_outlined, size: 18), text: 'Documents'),
              ],
            ),
          ),
          AppSpacing.vLg,

          // Tab Views
          SizedBox(
            height: 650,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPersonalTab(isDark),
                _buildAcademicTab(isDark),
                _buildGuardianTab(isDark),
                _buildDocumentsTab(isDark),
              ],
            ),
          ),
          AppSpacing.vLg,

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                text: 'Cancel',
                variant: AppButtonVariant.outline,
                icon: Icons.close_rounded,
                onPressed: () => context.go(RouteNames.studentViewPath),
              ),
              AppSpacing.hMd,
              AppButton(
                text: 'Save Student',
                icon: Icons.save_rounded,
                onPressed: _handleSaveStudent,
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
            Text('Personal Information', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.vLg,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar Upload
                Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                      child: const Icon(Icons.upload_rounded, size: 30, color: AppColors.primary),
                    ),
                    AppSpacing.vSm,
                    AppButton(
                      text: 'Upload Photo',
                      variant: AppButtonVariant.outline,
                      height: 30,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Selecting photo...')),
                        );
                      },
                    ),
                  ],
                ),
                AppSpacing.hLg,

                // Inputs
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: AppTextField(controller: _firstNameController, label: 'First Name *', hint: 'Enter first name')),
                          AppSpacing.hMd,
                          Expanded(child: AppTextField(controller: _lastNameController, label: 'Last Name *', hint: 'Enter last name')),
                        ],
                      ),
                      AppSpacing.vMd,
                      Row(
                        children: [
                          Expanded(child: AppTextField(controller: _emailController, label: 'Email Address *', hint: 'student@email.com', keyboardType: TextInputType.emailAddress)),
                          AppSpacing.hMd,
                          Expanded(child: AppTextField(controller: _phoneController, label: 'Phone Number *', hint: '+91 98765 43210', keyboardType: TextInputType.phone)),
                        ],
                      ),
                      AppSpacing.vMd,
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
                        ],
                      ),
                      AppSpacing.vMd,
                      Row(
                        children: [
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
                                    DropdownMenuItem(value: 'A+', child: Text('A+')),
                                    DropdownMenuItem(value: 'A-', child: Text('A-')),
                                    DropdownMenuItem(value: 'B+', child: Text('B+')),
                                    DropdownMenuItem(value: 'B-', child: Text('B-')),
                                    DropdownMenuItem(value: 'O+', child: Text('O+')),
                                    DropdownMenuItem(value: 'O-', child: Text('O-')),
                                    DropdownMenuItem(value: 'AB+', child: Text('AB+')),
                                    DropdownMenuItem(value: 'AB-', child: Text('AB-')),
                                  ],
                                  onChanged: (v) => setState(() => _bloodGroup = v!),
                                ),
                              ],
                            ),
                          ),
                          AppSpacing.hMd,
                          Expanded(child: AppTextField(controller: _nationalityController, label: 'Nationality', hint: 'Enter nationality')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.vLg,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldLabel('Address', isDark),
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
                Expanded(child: AppTextField(controller: _cityController, label: 'City', hint: 'Enter city')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _stateController, label: 'State', hint: 'Enter state')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _pincodeController, label: 'PIN Code', hint: 'Enter PIN code')),
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
            Text('Academic Information', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.vLg,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _rollNoController, label: 'Roll Number', hint: 'Auto-generated', enabled: false)),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _admissionDateController, label: 'Admission Date *', hint: 'YYYY-MM-DD', suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18))),
              ],
            ),
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
                          DropdownMenuItem(value: 'arts', child: Text('Arts')),
                          DropdownMenuItem(value: 'science', child: Text('Science')),
                          DropdownMenuItem(value: 'engineering', child: Text('Engineering')),
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
                          DropdownMenuItem(value: '2024-a', child: Text('2024-A (Morning)')),
                          DropdownMenuItem(value: '2024-b', child: Text('2024-B (Afternoon)')),
                          DropdownMenuItem(value: '2024-c', child: Text('2024-C (Evening)')),
                        ],
                        onChanged: (v) => setState(() => _batch = v!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.vMd,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _prevSchoolController, label: 'Previous School/College', hint: 'Enter previous institution name')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _prevClassController, label: 'Previous Class/Grade', hint: 'Enter previous class')),
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
            AppSpacing.vLg,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _fatherNameController, label: 'Father\'s Name *', hint: 'Enter father\'s name')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _fatherPhoneController, label: 'Father\'s Phone', hint: '+91 98765 43210', keyboardType: TextInputType.phone)),
              ],
            ),
            AppSpacing.vMd,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _fatherOccupationController, label: 'Father\'s Occupation', hint: 'Enter occupation')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _fatherEmailController, label: 'Father\'s Email', hint: 'father@email.com', keyboardType: TextInputType.emailAddress)),
              ],
            ),
            AppSpacing.vLg,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _motherNameController, label: 'Mother\'s Name *', hint: 'Enter mother\'s name')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _motherPhoneController, label: 'Mother\'s Phone', hint: '+91 98765 43210', keyboardType: TextInputType.phone)),
              ],
            ),
            AppSpacing.vMd,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _motherOccupationController, label: 'Mother\'s Occupation', hint: 'Enter occupation')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _motherEmailController, label: 'Mother\'s Email', hint: 'mother@email.com', keyboardType: TextInputType.emailAddress)),
              ],
            ),
            AppSpacing.vLg,
            const Divider(height: 1),
            AppSpacing.vMd,
            Text('Emergency Contact', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.vMd,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _emergencyNameController, label: 'Contact Name', hint: 'Enter name')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _emergencyRelationController, label: 'Relation', hint: 'e.g., Uncle, Aunt')),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _emergencyPhoneController, label: 'Phone Number', hint: '+91 98765 43210', keyboardType: TextInputType.phone)),
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
            AppSpacing.vLg,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _docsUploaded.length,
              itemBuilder: (context, index) {
                final doc = _docsUploaded.keys.elementAt(index);
                final uploaded = _docsUploaded[doc]!;

                return InkWell(
                  onTap: () {
                    setState(() => _docsUploaded[doc] = !uploaded);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(uploaded ? '$doc removed' : '$doc uploaded successfully')),
                    );
                  },
                  borderRadius: AppRadius.md,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight,
                      borderRadius: AppRadius.md,
                      border: Border.all(
                        color: uploaded ? AppColors.success : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        style: uploaded ? BorderStyle.solid : BorderStyle.none,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          uploaded ? Icons.check_circle_rounded : Icons.cloud_upload_outlined,
                          color: uploaded ? AppColors.success : AppColors.primary,
                          size: 28,
                        ),
                        AppSpacing.hMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(doc, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                              Text(
                                uploaded ? 'Uploaded' : 'Click to upload PDF, JPG up to 5MB',
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 11,
                                  color: uploaded ? AppColors.success : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
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
              'Add Student',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Add New Student',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Register a new student in the system',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
