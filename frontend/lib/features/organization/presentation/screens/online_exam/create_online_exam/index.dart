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

class CreateOnlineExamScreen extends StatefulWidget {
  const CreateOnlineExamScreen({super.key});

  @override
  State<CreateOnlineExamScreen> createState() => _CreateOnlineExamScreenState();
}

class _CreateOnlineExamScreenState extends State<CreateOnlineExamScreen> {
  final _examTitleController = TextEditingController();
  final _examCodeController = TextEditingController();
  String _course = 'cs';
  String _batch = '2024-a';
  final _descriptionController = TextEditingController();

  final _startDateTimeController = TextEditingController(text: '2024-02-15 10:00 AM');
  final _endDateTimeController = TextEditingController(text: '2024-02-15 11:00 AM');
  final _durationController = TextEditingController(text: '60');
  final _totalQuestionsController = TextEditingController(text: '50');
  final _totalMarksController = TextEditingController(text: '100');
  final _passingMarksController = TextEditingController(text: '35');
  final _negativeMarkingController = TextEditingController(text: '0.25');

  bool _shuffleQuestions = true;
  bool _shuffleOptions = true;
  bool _preventTabSwitch = false;
  bool _fullScreen = false;
  bool _proctoring = false;

  String _questionPaper = 'qp1';

  bool _showResult = true;
  bool _showAnswers = false;
  bool _allowReview = true;
  bool _autoSubmit = true;

  @override
  void dispose() {
    _examTitleController.dispose();
    _examCodeController.dispose();
    _descriptionController.dispose();
    _startDateTimeController.dispose();
    _endDateTimeController.dispose();
    _durationController.dispose();
    _totalQuestionsController.dispose();
    _totalMarksController.dispose();
    _passingMarksController.dispose();
    _negativeMarkingController.dispose();
    super.dispose();
  }

  void _handleReset() {
    setState(() {
      _examTitleController.clear();
      _examCodeController.clear();
      _course = 'cs';
      _batch = '2024-a';
      _descriptionController.clear();
      _startDateTimeController.text = '2024-02-15 10:00 AM';
      _endDateTimeController.text = '2024-02-15 11:00 AM';
      _durationController.text = '60';
      _totalQuestionsController.text = '50';
      _totalMarksController.text = '100';
      _passingMarksController.text = '35';
      _negativeMarkingController.text = '0.25';
      _shuffleQuestions = true;
      _shuffleOptions = true;
      _preventTabSwitch = false;
      _fullScreen = false;
      _proctoring = false;
      _questionPaper = 'qp1';
      _showResult = true;
      _showAnswers = false;
      _allowReview = true;
      _autoSubmit = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form reset to default values.')),
    );
  }

  void _handleCreateExam() {
    if (_examTitleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an exam title.'), backgroundColor: AppColors.warning),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Online Exam "${_examTitleController.text}" created successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
    context.go(RouteNames.onlineExamQuestionPaperBuilderPath);
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

          // Form Layout
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
                      _buildScheduleCard(isDark),
                      AppSpacing.vLg,
                      _buildSecurityCard(isDark),
                    ],
                  ),
                ),
                AppSpacing.hLg,
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildQuestionPaperCard(isDark),
                      AppSpacing.vLg,
                      _buildOptionsCard(isDark),
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
                _buildScheduleCard(isDark),
                AppSpacing.vLg,
                _buildSecurityCard(isDark),
                AppSpacing.vLg,
                _buildQuestionPaperCard(isDark),
                AppSpacing.vLg,
                _buildOptionsCard(isDark),
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
          Row(
            children: [
              const Icon(Icons.computer_rounded, size: 20, color: AppColors.primary),
              AppSpacing.hSm,
              Text('Exam Details', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          AppSpacing.vLg,
          Row(
            children: [
              Expanded(child: AppTextField(controller: _examTitleController, label: 'Exam Title *', hint: 'e.g., Online Mid-Term Test')),
              AppSpacing.hMd,
              Expanded(child: AppTextField(controller: _examCodeController, label: 'Exam Code *', hint: 'e.g., OMT-2024-001')),
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
                      ],
                      onChanged: (v) => setState(() => _batch = v!),
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
              _buildFieldLabel('Description', isDark),
              AppSpacing.vXs,
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Enter exam description and instructions...'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 20, color: AppColors.primary),
              AppSpacing.hSm,
              Text('Schedule & Duration', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          AppSpacing.vLg,
          Row(
            children: [
              Expanded(child: AppTextField(controller: _startDateTimeController, label: 'Start Date & Time *', hint: 'YYYY-MM-DD HH:MM', suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18))),
              AppSpacing.hMd,
              Expanded(child: AppTextField(controller: _endDateTimeController, label: 'End Date & Time *', hint: 'YYYY-MM-DD HH:MM', suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18))),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(child: AppTextField(controller: _durationController, label: 'Duration (minutes) *', hint: '60', keyboardType: TextInputType.number)),
              AppSpacing.hMd,
              Expanded(child: AppTextField(controller: _totalQuestionsController, label: 'Total Questions *', hint: '50', keyboardType: TextInputType.number)),
              AppSpacing.hMd,
              Expanded(child: AppTextField(controller: _totalMarksController, label: 'Total Marks *', hint: '100', keyboardType: TextInputType.number)),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(child: AppTextField(controller: _passingMarksController, label: 'Passing Marks *', hint: '35', keyboardType: TextInputType.number)),
              AppSpacing.hMd,
              Expanded(child: AppTextField(controller: _negativeMarkingController, label: 'Negative Marking', hint: '0.25', keyboardType: TextInputType.number)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security_rounded, size: 20, color: AppColors.primary),
              AppSpacing.hSm,
              Text('Security Settings', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          AppSpacing.vLg,
          _buildSwitchRow('Shuffle Questions', 'Randomize question order for each student', _shuffleQuestions, (v) => setState(() => _shuffleQuestions = v), isDark),
          const Divider(height: 1),
          _buildSwitchRow('Shuffle Options', 'Randomize answer options', _shuffleOptions, (v) => setState(() => _shuffleOptions = v), isDark),
          const Divider(height: 1),
          _buildSwitchRow('Prevent Tab Switch', 'Warn or submit if student switches tabs', _preventTabSwitch, (v) => setState(() => _preventTabSwitch = v), isDark),
          const Divider(height: 1),
          _buildSwitchRow('Full Screen Mode', 'Force full screen during exam', _fullScreen, (v) => setState(() => _fullScreen = v), isDark),
          const Divider(height: 1),
          _buildSwitchRow('Webcam Proctoring', 'Enable webcam monitoring', _proctoring, (v) => setState(() => _proctoring = v), isDark),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String title, String subtitle, bool value, ValueChanged<bool> onChanged, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
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

  Widget _buildQuestionPaperCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Question Paper', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vMd,
          _buildFieldLabel('Question Paper', isDark),
          AppSpacing.vXs,
          DropdownButtonFormField<String>(
            initialValue: _questionPaper,
            isExpanded: true,
            decoration: const InputDecoration(),
            items: const [
              DropdownMenuItem(value: 'qp1', child: Text('QP-2024-CS-001')),
              DropdownMenuItem(value: 'qp2', child: Text('QP-2024-CS-002')),
              DropdownMenuItem(value: 'new', child: Text('Create New')),
            ],
            onChanged: (v) => setState(() => _questionPaper = v!),
          ),
          AppSpacing.vLg,
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: 'Build Question Paper',
              variant: AppButtonVariant.outline,
              onPressed: () => context.go(RouteNames.onlineExamQuestionPaperBuilderPath),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Exam Options', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vLg,
          _buildCheckboxRow('Show result after submission', _showResult, (v) => setState(() => _showResult = v ?? false)),
          AppSpacing.vSm,
          _buildCheckboxRow('Show correct answers', _showAnswers, (v) => setState(() => _showAnswers = v ?? false)),
          AppSpacing.vSm,
          _buildCheckboxRow('Allow question review', _allowReview, (v) => setState(() => _allowReview = v ?? false)),
          AppSpacing.vSm,
          _buildCheckboxRow('Auto-submit on timeout', _autoSubmit, (v) => setState(() => _autoSubmit = v ?? false)),
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
              onTap: () => context.go(RouteNames.onlineExamCreatePath),
              child: Text(
                'Online Exam',
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
          'Create Online Exam',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Set up a new online examination',
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
