import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/router/route_names.dart';
import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/app_card.dart';
import '../../../../../../shared/widgets/app_text_field.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  // Course Info Controllers
  final _courseNameController = TextEditingController();
  final _courseCodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _courseType = 'degree';
  String _department = 'science';

  // Duration & Schedule Controllers
  String _duration = '4years';
  final _semestersController = TextEditingController(text: '8');
  final _creditsController = TextEditingController(text: '180');
  String _startMonth = 'july';
  final _hoursPerWeekController = TextEditingController(text: '25');

  // Fee Structure Controllers
  final _annualFeeController = TextEditingController(text: '50000');
  final _admissionFeeController = TextEditingController(text: '5000');
  final _examFeeController = TextEditingController(text: '2000');
  final _labFeeController = TextEditingController(text: '3000');
  final _reExamFeeController = TextEditingController(text: '500');
  final _reAdmissionFeeController = TextEditingController(text: '2500');

  bool _yearlyPayment = true;
  bool _semesterPayment = true;
  bool _monthlyPayment = false;

  // Subjects
  final Map<String, bool> _subjects = {
    'Mathematics': true,
    'Physics': true,
    'Chemistry': true,
    'Biology': false,
    'English': true,
    'History': false,
    'Geography': false,
    'Computer Info': true,
  };
  final _otherSubjectsController = TextEditingController();

  // Settings
  bool _activeStatus = true;
  bool _allowEnrollment = true;
  bool _onlineAvailable = true;
  bool _certificateCourse = false;

  // Eligibility
  String _minQualification = '12th';
  final _minMarksController = TextEditingController(text: '50');
  final _minAgeController = TextEditingController(text: '17');
  final _maxAgeController = TextEditingController(text: '25');

  @override
  void dispose() {
    _courseNameController.dispose();
    _courseCodeController.dispose();
    _descriptionController.dispose();
    _semestersController.dispose();
    _creditsController.dispose();
    _hoursPerWeekController.dispose();
    _annualFeeController.dispose();
    _admissionFeeController.dispose();
    _examFeeController.dispose();
    _labFeeController.dispose();
    _reExamFeeController.dispose();
    _reAdmissionFeeController.dispose();
    _otherSubjectsController.dispose();
    _minMarksController.dispose();
    _minAgeController.dispose();
    _maxAgeController.dispose();
    super.dispose();
  }

  void _handleCreateCourse() {
    if (_courseNameController.text.trim().isEmpty || _courseCodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill required fields (Course Name and Code).'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Course "${_courseNameController.text}" created successfully!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.go(RouteNames.courseViewPath);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isDesktop = context.isDesktop || context.isUltraWide;
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

          // 2-Column Desktop Grid
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column (2/3)
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildCourseInfoCard(isDark),
                      AppSpacing.vLg,
                      _buildDurationCard(isDark),
                      AppSpacing.vLg,
                      _buildFeeStructureCard(isDark),
                    ],
                  ),
                ),
                AppSpacing.hLg,

                // Right Column (1/3)
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildSubjectsCard(isDark),
                      AppSpacing.vLg,
                      _buildSettingsCard(isDark),
                      AppSpacing.vLg,
                      _buildEligibilityCard(isDark),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildCourseInfoCard(isDark),
                AppSpacing.vLg,
                _buildDurationCard(isDark),
                AppSpacing.vLg,
                _buildFeeStructureCard(isDark),
                AppSpacing.vLg,
                _buildSubjectsCard(isDark),
                AppSpacing.vLg,
                _buildSettingsCard(isDark),
                AppSpacing.vLg,
                _buildEligibilityCard(isDark),
              ],
            ),

          AppSpacing.vXl,

          // Form Actions Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                text: 'Cancel',
                variant: AppButtonVariant.outline,
                onPressed: () => context.go(RouteNames.courseViewPath),
              ),
              AppSpacing.hMd,
              AppButton(
                text: 'Save as Draft',
                variant: AppButtonVariant.outline,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Course saved as draft.')),
                  );
                },
              ),
              AppSpacing.hMd,
              AppButton(
                text: 'Create Course',
                icon: Icons.add_circle_outline_rounded,
                onPressed: _handleCreateCourse,
              ),
            ],
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
              onTap: () => context.go(RouteNames.courseViewPath),
              child: Text(
                'Course Management',
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
              'Create Course',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Create Course',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Add a new course to your institution',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseInfoCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book_rounded, size: 20, color: AppColors.primary),
              AppSpacing.hSm,
              Text(
                'Course Information',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          AppSpacing.vLg,
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _courseNameController,
                  label: 'Course Name *',
                  hint: 'e.g., Computer Science',
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _courseCodeController,
                  label: 'Course Code *',
                  hint: 'e.g., CS101',
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
                    _buildFieldLabel('Course Type', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _courseType,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'degree', child: Text('Degree')),
                        DropdownMenuItem(value: 'diploma', child: Text('Diploma')),
                        DropdownMenuItem(value: 'certificate', child: Text('Certificate')),
                        DropdownMenuItem(value: 'professional', child: Text('Professional')),
                      ],
                      onChanged: (v) => setState(() => _courseType = v!),
                    ),
                  ],
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Department', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _department,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'science', child: Text('Science')),
                        DropdownMenuItem(value: 'commerce', child: Text('Commerce')),
                        DropdownMenuItem(value: 'arts', child: Text('Arts')),
                        DropdownMenuItem(value: 'engineering', child: Text('Engineering')),
                        DropdownMenuItem(value: 'medical', child: Text('Medical')),
                      ],
                      onChanged: (v) => setState(() => _department = v!),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel('Course Description', isDark),
              AppSpacing.vXs,
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Brief description of the course...',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDurationCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 20, color: AppColors.primary),
              AppSpacing.hSm,
              Text(
                'Duration & Schedule',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          AppSpacing.vLg,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Duration *', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _duration,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: '3months', child: Text('3 Months')),
                        DropdownMenuItem(value: '6months', child: Text('6 Months')),
                        DropdownMenuItem(value: '1year', child: Text('1 Year')),
                        DropdownMenuItem(value: '2years', child: Text('2 Years')),
                        DropdownMenuItem(value: '3years', child: Text('3 Years')),
                        DropdownMenuItem(value: '4years', child: Text('4 Years')),
                      ],
                      onChanged: (v) => setState(() => _duration = v!),
                    ),
                  ],
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _semestersController,
                  label: 'Semesters',
                  hint: 'e.g., 8',
                  keyboardType: TextInputType.number,
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _creditsController,
                  label: 'Total Credits',
                  hint: 'e.g., 180',
                  keyboardType: TextInputType.number,
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
                    _buildFieldLabel('Typical Start Month', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _startMonth,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'january', child: Text('January')),
                        DropdownMenuItem(value: 'april', child: Text('April')),
                        DropdownMenuItem(value: 'july', child: Text('July')),
                        DropdownMenuItem(value: 'october', child: Text('October')),
                      ],
                      onChanged: (v) => setState(() => _startMonth = v!),
                    ),
                  ],
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _hoursPerWeekController,
                  label: 'Hours Per Week',
                  hint: 'e.g., 25',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeeStructureCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.currency_rupee_rounded, size: 20, color: AppColors.primary),
              AppSpacing.hSm,
              Text(
                'Fee Structure',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          AppSpacing.vLg,
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _annualFeeController,
                  label: 'Annual Fee *',
                  hint: 'e.g., 50000',
                  keyboardType: TextInputType.number,
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _admissionFeeController,
                  label: 'Admission Fee',
                  hint: 'e.g., 5000',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _examFeeController,
                  label: 'Exam Fee (Per Semester)',
                  hint: 'e.g., 2000',
                  keyboardType: TextInputType.number,
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _labFeeController,
                  label: 'Lab Fee (If Applicable)',
                  hint: 'e.g., 3000',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _reExamFeeController,
                  label: 'Re-Exam Fee',
                  hint: 'e.g., 500',
                  keyboardType: TextInputType.number,
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _reAdmissionFeeController,
                  label: 'Re-Admission Fee',
                  hint: 'e.g., 2500',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          AppSpacing.vLg,
          _buildFieldLabel('Fee Payment Options', isDark),
          AppSpacing.vSm,
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _buildInlineSwitch('Yearly', _yearlyPayment, (v) => setState(() => _yearlyPayment = v), isDark),
              _buildInlineSwitch('Semester-wise', _semesterPayment, (v) => setState(() => _semesterPayment = v), isDark),
              _buildInlineSwitch('Monthly', _monthlyPayment, (v) => setState(() => _monthlyPayment = v), isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.subject_rounded, size: 20, color: AppColors.primary),
              AppSpacing.hSm,
              Text(
                'Course Subjects',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          AppSpacing.vLg,
          _buildFieldLabel('Select Subjects', isDark),
          AppSpacing.vSm,
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: _subjects.keys.map((subject) {
              final isChecked = _subjects[subject]!;
              return FilterChip(
                selected: isChecked,
                label: Text(subject),
                onSelected: (val) => setState(() => _subjects[subject] = val),
              );
            }).toList(),
          ),
          AppSpacing.vLg,
          const Divider(height: 1),
          AppSpacing.vMd,
          _buildFieldLabel('Other Subjects', isDark),
          AppSpacing.vXs,
          TextFormField(
            controller: _otherSubjectsController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Enter other subjects separated by commas...',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.settings_outlined, size: 20, color: AppColors.primary),
              AppSpacing.hSm,
              Text(
                'Course Settings',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          _buildSwitchRow('Active Status', 'Enable/disable course', _activeStatus, (v) => setState(() => _activeStatus = v), isDark),
          const Divider(height: 1),
          _buildSwitchRow('Allow Enrollment', 'Accept new students', _allowEnrollment, (v) => setState(() => _allowEnrollment = v), isDark),
          const Divider(height: 1),
          _buildSwitchRow('Online Available', 'Show on website', _onlineAvailable, (v) => setState(() => _onlineAvailable = v), isDark),
          const Divider(height: 1),
          _buildSwitchRow('Certificate Course', 'Issue completion certificate', _certificateCourse, (v) => setState(() => _certificateCourse = v), isDark),
        ],
      ),
    );
  }

  Widget _buildEligibilityCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Eligibility Criteria',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          AppSpacing.vLg,
          _buildFieldLabel('Minimum Qualification', isDark),
          AppSpacing.vXs,
          DropdownButtonFormField<String>(
            initialValue: _minQualification,
            isExpanded: true,
            decoration: const InputDecoration(),
            items: const [
              DropdownMenuItem(value: '10th', child: Text('10th Pass')),
              DropdownMenuItem(value: '12th', child: Text('12th Pass')),
              DropdownMenuItem(value: 'graduate', child: Text('Graduate')),
              DropdownMenuItem(value: 'postgraduate', child: Text('Post Graduate')),
            ],
            onChanged: (v) => setState(() => _minQualification = v!),
          ),
          AppSpacing.vMd,
          AppTextField(
            controller: _minMarksController,
            label: 'Minimum Marks (%)',
            hint: 'e.g., 50',
            keyboardType: TextInputType.number,
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _minAgeController,
                  label: 'Minimum Age',
                  hint: 'e.g., 17',
                  keyboardType: TextInputType.number,
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _maxAgeController,
                  label: 'Maximum Age',
                  hint: 'e.g., 25',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
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

  Widget _buildInlineSwitch(String label, bool value, ValueChanged<bool> onChanged, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.primary,
        ),
        AppSpacing.hXs,
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchRow(String title, String subtitle, bool value, ValueChanged<bool> onChanged, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
