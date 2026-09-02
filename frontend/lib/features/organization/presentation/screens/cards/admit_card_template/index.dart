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

class AdmitCardTemplateScreen extends StatefulWidget {
  const AdmitCardTemplateScreen({super.key});

  @override
  State<AdmitCardTemplateScreen> createState() => _AdmitCardTemplateScreenState();
}

class _AdmitCardTemplateScreenState extends State<AdmitCardTemplateScreen> {
  final _templateNameController = TextEditingController(text: 'Mid-Term Exam 2024');
  String _examType = 'midterm';
  String _pageSize = 'a4';

  bool _showQrCode = true;
  bool _showPhoto = true;
  bool _showSchedule = true;

  final List<Map<String, dynamic>> _savedTemplates = [
    {'id': '1', 'name': 'Mid-Term Exam 2024', 'exam': 'Mid-Term', 'status': 'active'},
    {'id': '2', 'name': 'Final Exam 2024', 'exam': 'Final', 'status': 'draft'},
    {'id': '3', 'name': 'Unit Test Template', 'exam': 'Unit Test', 'status': 'active'},
  ];

  @override
  void initState() {
    super.initState();
    _templateNameController.addListener(() {
      setState(() {});
    });
  }

  final List<Map<String, dynamic>> _elements = [
    {'label': 'Student Name', 'icon': Icons.title_rounded},
    {'label': 'Roll Number', 'icon': Icons.numbers_rounded},
    {'label': 'Class & Section', 'icon': Icons.class_outlined},
    {'label': 'Exam Name', 'icon': Icons.description_outlined},
    {'label': 'Exam Date', 'icon': Icons.calendar_today_rounded},
    {'label': 'Student Photo', 'icon': Icons.image_outlined},
    {'label': 'School Logo', 'icon': Icons.school_outlined},
    {'label': 'QR Code', 'icon': Icons.qr_code_rounded},
    {'label': 'Exam Schedule', 'icon': Icons.table_chart_outlined},
    {'label': 'Instructions', 'icon': Icons.notes_rounded},
  ];

  @override
  void dispose() {
    _templateNameController.dispose();
    super.dispose();
  }

  void _handleSaveTemplate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Admit card template saved successfully!'), backgroundColor: AppColors.success),
    );
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
          _buildHeader(isDark, isMobile),
          AppSpacing.vXl,

          // 3 Column Grid
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildElementsCard(isDark),
                ),
                AppSpacing.hLg,
                Expanded(
                  flex: 2,
                  child: _buildCanvasCard(isDark),
                ),
                AppSpacing.hLg,
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildPropertiesCard(isDark),
                      AppSpacing.vLg,
                      _buildSavedTemplatesCard(isDark),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildCanvasCard(isDark),
                AppSpacing.vLg,
                _buildPropertiesCard(isDark),
                AppSpacing.vLg,
                _buildElementsCard(isDark),
                AppSpacing.vLg,
                _buildSavedTemplatesCard(isDark),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildElementsCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Elements', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vLg,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _elements.length,
            separatorBuilder: (ctx, i) => AppSpacing.vSm,
            itemBuilder: (ctx, index) {
              final elem = _elements[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    Icon(Icons.drag_indicator_rounded, size: 16, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    AppSpacing.hSm,
                    Icon(elem['icon'] as IconData, size: 16, color: AppColors.primary),
                    AppSpacing.hSm,
                    Expanded(
                      child: Text(elem['label'] as String, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              );
            },
          ),
          AppSpacing.vMd,
          Text(
            'Drag elements to the canvas to add them to your template',
            style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvasCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Template Canvas', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
              SizedBox(
                width: 120,
                child: DropdownButtonFormField<String>(
                  initialValue: _pageSize,
                  isExpanded: true,
                  decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                  items: const [
                    DropdownMenuItem(value: 'a4', child: Text('A4 Size')),
                    DropdownMenuItem(value: 'a5', child: Text('A5 Size')),
                    DropdownMenuItem(value: 'letter', child: Text('Letter')),
                  ],
                  onChanged: (v) => setState(() => _pageSize = v!),
                ),
              ),
            ],
          ),
          AppSpacing.vLg,

          // Dashed Canvas Area
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                style: BorderStyle.solid,
              ),
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 50 : 10),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // School Header
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary.withAlpha(20),
                      child: const Icon(Icons.school_rounded, color: AppColors.primary, size: 20),
                    ),
                    AppSpacing.vSm,
                    Text('Pushpak Model Academy', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
                    Text('123 Education Lane, New Delhi - 110001', style: AppTypography.bodySmall.copyWith(fontSize: 10, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                    AppSpacing.vMd,
                    const Divider(height: 1),
                    AppSpacing.vMd,

                    // Badge & Exam Title
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        borderRadius: AppRadius.full,
                        border: Border.all(color: AppColors.primary.withAlpha(60)),
                      ),
                      child: Text('ADMIT CARD', style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ),
                    AppSpacing.vXs,
                    Text(_templateNameController.text, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                    AppSpacing.vMd,

                    // Student Photo & Details Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_showPhoto) ...[
                          Container(
                            width: 70,
                            height: 85,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceCardDark : AppColors.backgroundLight,
                              borderRadius: AppRadius.sm,
                              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                            ),
                            child: Icon(Icons.person_outline_rounded, size: 36, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                          ),
                          AppSpacing.hMd,
                        ],
                        Expanded(
                          child: Column(
                            children: [
                              _buildCardDetailRow('Name:', 'Rahul Sharma', isDark),
                              _buildCardDetailRow('Roll No:', '101', isDark),
                              _buildCardDetailRow('Class:', '10th - A', isDark),
                              _buildCardDetailRow('DOB:', '15/08/2008', isDark),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,

                    // Exam Schedule Section
                    if (_showSchedule) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceCardDark : AppColors.backgroundLight,
                          borderRadius: AppRadius.sm,
                          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('EXAM SCHEDULE', style: AppTypography.labelMedium.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                            AppSpacing.vXs,
                            _buildScheduleRow('Mathematics', '15 Jan, 9:00 AM', isDark),
                            _buildScheduleRow('Science', '16 Jan, 9:00 AM', isDark),
                            _buildScheduleRow('English', '17 Jan, 9:00 AM', isDark),
                          ],
                        ),
                      ),
                      AppSpacing.vMd,
                    ],

                    // Footer with QR Code & Signature
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (_showQrCode)
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceCardDark : AppColors.backgroundLight,
                              borderRadius: AppRadius.sm,
                              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                            ),
                            child: const Icon(Icons.qr_code_2_rounded, size: 32),
                          )
                        else
                          const SizedBox.shrink(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(width: 80, height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                            AppSpacing.vXs,
                            Text("Principal's Signature", style: AppTypography.bodySmall.copyWith(fontSize: 9, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          Text(value, style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(String subject, String timing, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(subject, style: AppTypography.bodySmall.copyWith(fontSize: 10)),
          Text(timing, style: AppTypography.bodySmall.copyWith(fontSize: 10, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
        ],
      ),
    );
  }

  Widget _buildPropertiesCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Properties', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vLg,
          AppTextField(controller: _templateNameController, label: 'Template Name', hint: 'Enter template name'),
          AppSpacing.vMd,
          _buildFieldLabel('Exam Type', isDark),
          AppSpacing.vXs,
          DropdownButtonFormField<String>(
            initialValue: _examType,
            isExpanded: true,
            decoration: const InputDecoration(),
            items: const [
              DropdownMenuItem(value: 'midterm', child: Text('Mid-Term Exam')),
              DropdownMenuItem(value: 'final', child: Text('Final Exam')),
              DropdownMenuItem(value: 'unit', child: Text('Unit Test')),
            ],
            onChanged: (v) => setState(() => _examType = v!),
          ),
          AppSpacing.vMd,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Show QR Code'),
              Switch(value: _showQrCode, onChanged: (v) => setState(() => _showQrCode = v), activeTrackColor: AppColors.primary),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Show Photo'),
              Switch(value: _showPhoto, onChanged: (v) => setState(() => _showPhoto = v), activeTrackColor: AppColors.primary),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Show Schedule'),
              Switch(value: _showSchedule, onChanged: (v) => setState(() => _showSchedule = v), activeTrackColor: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavedTemplatesCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Saved Templates', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
              IconButton(
                icon: const Icon(Icons.add_rounded, size: 18),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Creating new admit card template...')));
                },
              ),
            ],
          ),
          AppSpacing.vMd,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _savedTemplates.length,
            separatorBuilder: (ctx, i) => AppSpacing.vSm,
            itemBuilder: (ctx, index) {
              final t = _savedTemplates[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t['name'] as String, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                        Text(t['exam'] as String, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 16),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Duplicated ${t['name']}.')));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                          onPressed: () {
                            setState(() => _savedTemplates.removeAt(index));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Removed ${t['name']}.'), backgroundColor: AppColors.error));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isMobile) {
    final headerTexts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => context.go(RouteNames.cardsIdTemplatePath),
              child: Text(
                'ID & Admit Card',
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
              'Admit Card Template',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Admit Card Template',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Design admit card templates for examinations',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButtons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton(
          text: 'Preview',
          icon: Icons.visibility_outlined,
          variant: AppButtonVariant.outline,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Previewing template...')));
          },
          height: 38,
        ),
        AppSpacing.hSm,
        AppButton(
          text: 'Save Template',
          icon: Icons.save_rounded,
          onPressed: _handleSaveTemplate,
          height: 38,
        ),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerTexts,
          AppSpacing.vMd,
          actionButtons,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: headerTexts),
        actionButtons,
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
