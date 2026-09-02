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

class CreateExamScreen extends StatefulWidget {
  const CreateExamScreen({super.key});

  @override
  State<CreateExamScreen> createState() => _CreateExamScreenState();
}

class _CreateExamScreenState extends State<CreateExamScreen> {
  final _examNameController = TextEditingController();
  String _examType = 'mid-term';
  String _course = 'cs';
  String _batch = '2024-a';
  final _examDateController = TextEditingController(text: '2024-02-15');
  final _startTimeController = TextEditingController(text: '10:00 AM');
  final _durationController = TextEditingController(text: '120');
  final _totalMarksController = TextEditingController(text: '100');
  final _passingMarksController = TextEditingController(text: '35');
  final _instructionsController = TextEditingController();

  String _venue = 'hall-a';
  String _supervisor = 'john';

  bool _hallTicket = false;
  bool _seating = false;
  bool _notify = true;
  bool _grading = false;

  @override
  void dispose() {
    _examNameController.dispose();
    _examDateController.dispose();
    _startTimeController.dispose();
    _durationController.dispose();
    _totalMarksController.dispose();
    _passingMarksController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _handleReset() {
    setState(() {
      _examNameController.clear();
      _examType = 'mid-term';
      _course = 'cs';
      _batch = '2024-a';
      _examDateController.text = '2024-02-15';
      _startTimeController.text = '10:00 AM';
      _durationController.text = '120';
      _totalMarksController.text = '100';
      _passingMarksController.text = '35';
      _instructionsController.clear();
      _venue = 'hall-a';
      _supervisor = 'john';
      _hallTicket = false;
      _seating = false;
      _notify = true;
      _grading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form reset to default values.')),
    );
  }

  void _handleCreateExam() {
    if (_examNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an exam name.'), backgroundColor: AppColors.warning),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exam "${_examNameController.text}" scheduled successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
    context.go(RouteNames.examSchedulePath);
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

          // Main Form Content
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildExamDetailsCard(isDark),
                      AppSpacing.vLg,
                      _buildVenueCard(isDark),
                    ],
                  ),
                ),
                AppSpacing.hLg,
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildSettingsCard(isDark),
                      AppSpacing.vLg,
                      _buildActionsCard(),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildExamDetailsCard(isDark),
                AppSpacing.vLg,
                _buildVenueCard(isDark),
                AppSpacing.vLg,
                _buildSettingsCard(isDark),
                AppSpacing.vLg,
                _buildActionsCard(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildExamDetailsCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Exam Details', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vLg,
          Row(
            children: [
              Expanded(child: AppTextField(controller: _examNameController, label: 'Exam Name *', hint: 'e.g., Mid-Term Examination')),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Exam Type *', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _examType,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'unit-test', child: Text('Unit Test')),
                        DropdownMenuItem(value: 'mid-term', child: Text('Mid-Term')),
                        DropdownMenuItem(value: 'final', child: Text('Final Exam')),
                        DropdownMenuItem(value: 'practical', child: Text('Practical')),
                        DropdownMenuItem(value: 'viva', child: Text('Viva/Oral')),
                      ],
                      onChanged: (v) => setState(() => _examType = v!),
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
                    _buildFieldLabel('Course *', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _course,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'cs', child: Text('Computer Science')),
                        DropdownMenuItem(value: 'science', child: Text('Science')),
                        DropdownMenuItem(value: 'commerce', child: Text('Commerce')),
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
                        DropdownMenuItem(value: '2024-a', child: Text('2024-A')),
                        DropdownMenuItem(value: '2024-b', child: Text('2024-B')),
                        DropdownMenuItem(value: '2024-c', child: Text('2024-C')),
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
              Expanded(child: AppTextField(controller: _examDateController, label: 'Exam Date *', hint: 'YYYY-MM-DD', suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18))),
              AppSpacing.hMd,
              Expanded(child: AppTextField(controller: _startTimeController, label: 'Start Time *', hint: '10:00 AM', suffixIcon: const Icon(Icons.access_time_rounded, size: 18))),
              AppSpacing.hMd,
              Expanded(child: AppTextField(controller: _durationController, label: 'Duration (minutes) *', hint: '120', keyboardType: TextInputType.number)),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(child: AppTextField(controller: _totalMarksController, label: 'Total Marks *', hint: '100', keyboardType: TextInputType.number)),
              AppSpacing.hMd,
              Expanded(child: AppTextField(controller: _passingMarksController, label: 'Passing Marks *', hint: '35', keyboardType: TextInputType.number)),
            ],
          ),
          AppSpacing.vMd,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel('Exam Instructions', isDark),
              AppSpacing.vXs,
              TextFormField(
                controller: _instructionsController,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Enter instructions for students...'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVenueCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Venue & Supervision', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vLg,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Exam Venue', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _venue,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'hall-a', child: Text('Examination Hall A')),
                        DropdownMenuItem(value: 'hall-b', child: Text('Examination Hall B')),
                        DropdownMenuItem(value: 'lab-1', child: Text('Computer Lab 1')),
                        DropdownMenuItem(value: 'classroom', child: Text('Classroom 101')),
                      ],
                      onChanged: (v) => setState(() => _venue = v!),
                    ),
                  ],
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Supervisor', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _supervisor,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'john', child: Text('John Smith')),
                        DropdownMenuItem(value: 'sarah', child: Text('Sarah Johnson')),
                        DropdownMenuItem(value: 'michael', child: Text('Michael Brown')),
                      ],
                      onChanged: (v) => setState(() => _supervisor = v!),
                    ),
                  ],
                ),
              ),
            ],
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
          Text('Settings', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vLg,
          _buildCheckboxRow('Generate Hall Tickets', _hallTicket, (v) => setState(() => _hallTicket = v ?? false)),
          AppSpacing.vSm,
          _buildCheckboxRow('Auto-generate Seating Plan', _seating, (v) => setState(() => _seating = v ?? false)),
          AppSpacing.vSm,
          _buildCheckboxRow('Notify Students via SMS/Email', _notify, (v) => setState(() => _notify = v ?? false)),
          AppSpacing.vSm,
          _buildCheckboxRow('Enable Grade Calculation', _grading, (v) => setState(() => _grading = v ?? false)),
        ],
      ),
    );
  }

  Widget _buildCheckboxRow(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
        AppSpacing.hXs,
        Expanded(
          child: Text(label, style: AppTypography.bodySmall),
        ),
      ],
    );
  }

  Widget _buildActionsCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Actions', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vLg,
          AppButton(
            text: 'Create Exam',
            icon: Icons.save_rounded,
            onPressed: _handleCreateExam,
          ),
          AppSpacing.vMd,
          AppButton(
            text: 'Reset Form',
            icon: Icons.refresh_rounded,
            variant: AppButtonVariant.outline,
            onPressed: _handleReset,
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
              onTap: () => context.go(RouteNames.examSchedulePath),
              child: Text(
                'Exam & Marks',
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
              'Create Exam',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Create Exam',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Schedule a new examination',
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
