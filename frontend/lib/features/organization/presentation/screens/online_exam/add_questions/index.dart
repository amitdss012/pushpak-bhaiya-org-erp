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

class AddQuestionsScreen extends StatefulWidget {
  const AddQuestionsScreen({super.key});

  @override
  State<AddQuestionsScreen> createState() => _AddQuestionsScreenState();
}

class _AddQuestionsScreenState extends State<AddQuestionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // MCQ
  String _mcqSubject = 'math';
  String _mcqTopic = 'algebra';
  final _mcqQuestionController = TextEditingController();
  final _mcqMarksController = TextEditingController(text: '1');
  final _mcqNegativeController = TextEditingController(text: '0.25');
  final _mcqTimeLimitController = TextEditingController(text: '60');
  final _mcqExplanationController = TextEditingController();
  String _mcqDifficulty = 'medium';

  int _selectedCorrectOption = 0;
  final List<TextEditingController> _optionControllers = [
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: ''),
  ];

  // True/False
  final _tfQuestionController = TextEditingController();
  bool _tfCorrectAnswer = true;

  // Short Answer
  final _shortQuestionController = TextEditingController();
  final _shortKeywordsController = TextEditingController();
  final _shortWordLimitController = TextEditingController(text: '50');

  // Long Answer
  final _longQuestionController = TextEditingController();
  final _longModelAnswerController = TextEditingController();
  final _longMinWordsController = TextEditingController(text: '100');
  final _longMaxWordsController = TextEditingController(text: '500');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mcqQuestionController.dispose();
    _mcqMarksController.dispose();
    _mcqNegativeController.dispose();
    _mcqTimeLimitController.dispose();
    _mcqExplanationController.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    _tfQuestionController.dispose();
    _shortQuestionController.dispose();
    _shortKeywordsController.dispose();
    _shortWordLimitController.dispose();
    _longQuestionController.dispose();
    _longModelAnswerController.dispose();
    _longMinWordsController.dispose();
    _longMaxWordsController.dispose();
    super.dispose();
  }

  void _handleSaveQuestion() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Question saved to Question Bank!'), backgroundColor: AppColors.success),
    );
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
                Tab(text: 'MCQ'),
                Tab(text: 'True / False'),
                Tab(text: 'Short Answer'),
                Tab(text: 'Long Answer'),
              ],
            ),
          ),
          AppSpacing.vLg,

          // Tab Views
          SizedBox(
            height: 900,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMcqTab(isDark),
                _buildTrueFalseTab(isDark),
                _buildShortAnswerTab(isDark),
                _buildLongAnswerTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMcqTab(bool isDark) {
    final isDesktop = context.isDesktop || context.isUltraWide;

    final leftCol = Column(
      children: [
        // Question Details Card
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Question Details', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
              AppSpacing.vLg,
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Subject *', isDark),
                        AppSpacing.vXs,
                        DropdownButtonFormField<String>(
                          initialValue: _mcqSubject,
                          isExpanded: true,
                          decoration: const InputDecoration(),
                          items: const [
                            DropdownMenuItem(value: 'math', child: Text('Mathematics')),
                            DropdownMenuItem(value: 'physics', child: Text('Physics')),
                            DropdownMenuItem(value: 'chemistry', child: Text('Chemistry')),
                            DropdownMenuItem(value: 'english', child: Text('English')),
                          ],
                          onChanged: (v) => setState(() => _mcqSubject = v!),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.hMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Topic/Chapter', isDark),
                        AppSpacing.vXs,
                        DropdownButtonFormField<String>(
                          initialValue: _mcqTopic,
                          isExpanded: true,
                          decoration: const InputDecoration(),
                          items: const [
                            DropdownMenuItem(value: 'algebra', child: Text('Algebra')),
                            DropdownMenuItem(value: 'geometry', child: Text('Geometry')),
                            DropdownMenuItem(value: 'calculus', child: Text('Calculus')),
                          ],
                          onChanged: (v) => setState(() => _mcqTopic = v!),
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
                  _buildFieldLabel('Question Text *', isDark),
                  AppSpacing.vXs,
                  TextFormField(
                    controller: _mcqQuestionController,
                    maxLines: 4,
                    decoration: const InputDecoration(hintText: 'Enter your question here...'),
                  ),
                ],
              ),
              AppSpacing.vMd,
              Row(
                children: [
                  AppButton(
                    text: 'Add Image',
                    icon: Icons.image_outlined,
                    variant: AppButtonVariant.outline,
                    height: 32,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecting image...')));
                    },
                  ),
                  AppSpacing.hMd,
                  Text(
                    'Optional: Add an image to the question',
                    style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
        AppSpacing.vLg,

        // Answer Options Card
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Answer Options', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
              AppSpacing.vLg,
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _optionControllers.length,
                separatorBuilder: (ctx, i) => AppSpacing.vMd,
                itemBuilder: (ctx, index) {
                  final letter = String.fromCharCode(65 + index);
                  final isSelected = _selectedCorrectOption == index;

                  return Row(
                    children: [
                      InkWell(
                        borderRadius: AppRadius.full,
                        onTap: () => setState(() => _selectedCorrectOption = index),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: isSelected
                              ? Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      AppSpacing.hSm,
                      Expanded(
                        child: AppTextField(
                          controller: _optionControllers[index],
                          label: 'Option $letter',
                          hint: 'Enter option $letter text',
                        ),
                      ),
                      if (_optionControllers.length > 2) ...[
                        AppSpacing.hSm,
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.error),
                          onPressed: () {
                            setState(() {
                              _optionControllers[index].dispose();
                              _optionControllers.removeAt(index);
                              if (_selectedCorrectOption >= _optionControllers.length) {
                                _selectedCorrectOption = 0;
                              }
                            });
                          },
                        ),
                      ],
                    ],
                  );
                },
              ),
              AppSpacing.vMd,
              AppButton(
                text: 'Add Option',
                icon: Icons.add_rounded,
                variant: AppButtonVariant.outline,
                height: 32,
                onPressed: () {
                  setState(() {
                    _optionControllers.add(TextEditingController());
                  });
                },
              ),
              AppSpacing.vSm,
              Text(
                'Select the radio button next to the correct answer.',
                style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
            ],
          ),
        ),
      ],
    );

    final rightCol = Column(
      children: [
        // Question Settings Card
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Question Settings', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
              AppSpacing.vLg,
              _buildFieldLabel('Difficulty Level *', isDark),
              AppSpacing.vXs,
              DropdownButtonFormField<String>(
                initialValue: _mcqDifficulty,
                isExpanded: true,
                decoration: const InputDecoration(),
                items: const [
                  DropdownMenuItem(value: 'easy', child: Text('Easy')),
                  DropdownMenuItem(value: 'medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'hard', child: Text('Hard')),
                ],
                onChanged: (v) => setState(() => _mcqDifficulty = v!),
              ),
              AppSpacing.vMd,
              AppTextField(controller: _mcqMarksController, label: 'Marks *', hint: '1', keyboardType: TextInputType.number),
              AppSpacing.vMd,
              AppTextField(controller: _mcqNegativeController, label: 'Negative Marks', hint: '0.25', keyboardType: TextInputType.number),
              AppSpacing.vMd,
              AppTextField(controller: _mcqTimeLimitController, label: 'Time Limit (seconds)', hint: '60', keyboardType: TextInputType.number),
            ],
          ),
        ),
        AppSpacing.vLg,

        // Explanation Card
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Explanation', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
              AppSpacing.vMd,
              TextFormField(
                controller: _mcqExplanationController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Add explanation for the correct answer (shown after submission)...',
                ),
              ),
            ],
          ),
        ),
        AppSpacing.vLg,

        // Actions Card
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Actions', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
              AppSpacing.vLg,
              AppButton(
                text: 'Save Question',
                icon: Icons.save_rounded,
                onPressed: _handleSaveQuestion,
              ),
              AppSpacing.vMd,
              AppButton(
                text: 'Save & Add Another',
                icon: Icons.add_rounded,
                variant: AppButtonVariant.outline,
                onPressed: () {
                  _handleSaveQuestion();
                  setState(() {
                    _mcqQuestionController.clear();
                    for (final c in _optionControllers) {
                      c.clear();
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );

    return SingleChildScrollView(
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: leftCol),
                AppSpacing.hLg,
                Expanded(flex: 1, child: rightCol),
              ],
            )
          : Column(children: [leftCol, AppSpacing.vLg, rightCol]),
    );
  }

  Widget _buildTrueFalseTab(bool isDark) {
    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('True / False Question', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.vLg,
            _buildFieldLabel('Question Text *', isDark),
            AppSpacing.vXs,
            TextFormField(
              controller: _tfQuestionController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Enter your true/false question...'),
            ),
            AppSpacing.vLg,
            _buildFieldLabel('Correct Answer *', isDark),
            AppSpacing.vSm,
            Row(
              children: [
                InkWell(
                  onTap: () => setState(() => _tfCorrectAnswer = true),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _tfCorrectAnswer ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: _tfCorrectAnswer
                            ? Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary,
                                ),
                              )
                            : null,
                      ),
                      AppSpacing.hSm,
                      const Text('True'),
                    ],
                  ),
                ),
                AppSpacing.hXl,
                InkWell(
                  onTap: () => setState(() => _tfCorrectAnswer = false),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: !_tfCorrectAnswer ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: !_tfCorrectAnswer
                            ? Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary,
                                ),
                              )
                            : null,
                      ),
                      AppSpacing.hSm,
                      const Text('False'),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.vXl,
            AppButton(
              text: 'Save Question',
              icon: Icons.save_rounded,
              onPressed: _handleSaveQuestion,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortAnswerTab(bool isDark) {
    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Short Answer Question', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.vLg,
            _buildFieldLabel('Question Text *', isDark),
            AppSpacing.vXs,
            TextFormField(
              controller: _shortQuestionController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Enter your short answer question...'),
            ),
            AppSpacing.vLg,
            AppTextField(
              controller: _shortKeywordsController,
              label: 'Expected Answer (Keywords)',
              hint: 'Enter keywords separated by commas',
            ),
            AppSpacing.vMd,
            AppTextField(
              controller: _shortWordLimitController,
              label: 'Word Limit',
              hint: '50',
              keyboardType: TextInputType.number,
            ),
            AppSpacing.vXl,
            AppButton(
              text: 'Save Question',
              icon: Icons.save_rounded,
              onPressed: _handleSaveQuestion,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLongAnswerTab(bool isDark) {
    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Long Answer Question', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.vLg,
            _buildFieldLabel('Question Text *', isDark),
            AppSpacing.vXs,
            TextFormField(
              controller: _longQuestionController,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Enter your long answer question...'),
            ),
            AppSpacing.vLg,
            _buildFieldLabel('Model Answer', isDark),
            AppSpacing.vXs,
            TextFormField(
              controller: _longModelAnswerController,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Enter the model answer for reference...'),
            ),
            AppSpacing.vMd,
            Row(
              children: [
                Expanded(child: AppTextField(controller: _longMinWordsController, label: 'Minimum Words', hint: '100', keyboardType: TextInputType.number)),
                AppSpacing.hMd,
                Expanded(child: AppTextField(controller: _longMaxWordsController, label: 'Maximum Words', hint: '500', keyboardType: TextInputType.number)),
              ],
            ),
            AppSpacing.vXl,
            AppButton(
              text: 'Save Question',
              icon: Icons.save_rounded,
              onPressed: _handleSaveQuestion,
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
              'Add Questions',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Add Questions',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Add questions to question bank',
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
