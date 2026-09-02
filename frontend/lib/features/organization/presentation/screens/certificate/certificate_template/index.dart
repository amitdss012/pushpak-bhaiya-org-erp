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

class CertificateTemplateScreen extends StatefulWidget {
  const CertificateTemplateScreen({super.key});

  @override
  State<CertificateTemplateScreen> createState() => _CertificateTemplateScreenState();
}

class _CertificateTemplateScreenState extends State<CertificateTemplateScreen> {
  final _templateNameController = TextEditingController(text: 'Character Certificate');
  String _certificateType = 'character';
  String _pageSize = 'a4';
  final _bodyController = TextEditingController(
    text:
        'This is to certify that {student_name}, Son/Daughter of {father_name}, Date of Birth {dob}, was a bonafide student of this institution. He/She was studying in {class_section} during the academic session {session} bearing Admission Number {admission_no}. During his/her stay, his/her character and conduct were found to be {conduct}. We wish him/her success in all future endeavors.',
  );

  bool _showQrCode = true;
  bool _showPhoto = false;
  bool _showSeal = true;
  bool _decorativeBorder = true;

  final List<Map<String, dynamic>> _savedTemplates = [
    {'id': '1', 'name': 'Character Certificate', 'type': 'Character', 'status': 'active'},
    {'id': '2', 'name': 'Transfer Certificate', 'type': 'Transfer', 'status': 'active'},
    {'id': '3', 'name': 'Bonafide Certificate', 'type': 'Bonafide', 'status': 'draft'},
    {'id': '4', 'name': 'Merit Certificate', 'type': 'Merit', 'status': 'active'},
  ];

  final List<Map<String, dynamic>> _elements = [
    {'label': 'Student Name', 'icon': Icons.title_rounded},
    {'label': "Father's Name", 'icon': Icons.person_outline_rounded},
    {'label': 'Date of Birth', 'icon': Icons.cake_outlined},
    {'label': 'Class & Section', 'icon': Icons.class_outlined},
    {'label': 'Admission No', 'icon': Icons.numbers_rounded},
    {'label': 'Issue Date', 'icon': Icons.calendar_today_rounded},
    {'label': 'Certificate No', 'icon': Icons.confirmation_number_outlined},
    {'label': 'Student Photo', 'icon': Icons.image_outlined},
    {'label': 'School Logo', 'icon': Icons.school_outlined},
    {'label': 'QR Code', 'icon': Icons.qr_code_rounded},
    {'label': 'School Seal', 'icon': Icons.verified_outlined},
    {'label': 'Certificate Body', 'icon': Icons.notes_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _templateNameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _templateNameController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _handleSaveTemplate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Certificate template saved successfully!'), backgroundColor: AppColors.success),
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

          // 3-Column Layout
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
                    DropdownMenuItem(value: 'letter', child: Text('Letter')),
                    DropdownMenuItem(value: 'legal', child: Text('Legal')),
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
                constraints: const BoxConstraints(maxWidth: 480),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: AppRadius.md,
                  border: _decorativeBorder
                      ? Border.all(color: AppColors.primary.withAlpha(120), width: 3)
                      : Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
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
                    // Institution Header
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary.withAlpha(20),
                      child: const Icon(Icons.emoji_events_rounded, color: AppColors.primary, size: 24),
                    ),
                    AppSpacing.vSm,
                    Text('PUSHPAK MODEL ACADEMY', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w900, letterSpacing: 0.5, color: AppColors.primary)),
                    Text('School Address, City, State - PIN', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                    Text('Phone: +91 XXXXXXXXXX | Email: school@example.com', style: AppTypography.bodySmall.copyWith(fontSize: 10, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                    AppSpacing.vLg,

                    // Certificate Title & Number
                    Container(
                      padding: const EdgeInsets.only(bottom: 4),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
                      ),
                      child: Text(
                        _templateNameController.text.toUpperCase(),
                        style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800, letterSpacing: 1.5),
                      ),
                    ),
                    AppSpacing.vXs,
                    Text('Certificate No: CC/2024/001', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                    AppSpacing.vLg,

                    // Optional Student Photo
                    if (_showPhoto) ...[
                      Container(
                        width: 64,
                        height: 76,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceCardDark : AppColors.backgroundLight,
                          borderRadius: AppRadius.sm,
                          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                        ),
                        child: Icon(Icons.person_outline_rounded, size: 32, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                      ),
                      AppSpacing.vMd,
                    ],

                    // Certificate Body Paragraph
                    Text(
                      'This is to certify that Rahul Sharma, Son/Daughter of Father\'s Name, Date of Birth 01/01/2010, was a bonafide student of this institution.\n\nHe/She was studying in Class 10th, Section A during the academic session 2023-24 bearing Admission Number ADM/2020/001.\n\nDuring his/her stay in this institution, his/her character and conduct were found to be Good. We wish him/her success in all future endeavors.',
                      textAlign: TextAlign.justify,
                      style: AppTypography.bodySmall.copyWith(height: 1.6),
                    ),
                    AppSpacing.vXl,

                    // Footer with QR Code, Issue Date, and School Seal & Signature
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (_showQrCode)
                          Column(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.surfaceCardDark : AppColors.backgroundLight,
                                  borderRadius: AppRadius.sm,
                                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                ),
                                child: const Icon(Icons.qr_code_2_rounded, size: 38),
                              ),
                              AppSpacing.vXs,
                              Text('Scan to verify', style: AppTypography.bodySmall.copyWith(fontSize: 9, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                            ],
                          )
                        else
                          const SizedBox.shrink(),
                        Column(
                          children: [
                            Text('Date: 15/02/2024', style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w600)),
                            Text('Issue Date', style: AppTypography.bodySmall.copyWith(fontSize: 9, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                          ],
                        ),
                        Column(
                          children: [
                            if (_showSeal)
                              Container(
                                width: 44,
                                height: 44,
                                margin: const EdgeInsets.only(bottom: 6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                ),
                                child: const Icon(Icons.verified_outlined, size: 22, color: AppColors.primary),
                              ),
                            Container(width: 90, height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
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

  Widget _buildPropertiesCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Properties', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vLg,
          AppTextField(controller: _templateNameController, label: 'Template Name', hint: 'Enter template name'),
          AppSpacing.vMd,
          _buildFieldLabel('Certificate Type', isDark),
          AppSpacing.vXs,
          DropdownButtonFormField<String>(
            initialValue: _certificateType,
            isExpanded: true,
            decoration: const InputDecoration(),
            items: const [
              DropdownMenuItem(value: 'character', child: Text('Character Certificate')),
              DropdownMenuItem(value: 'transfer', child: Text('Transfer Certificate (TC)')),
              DropdownMenuItem(value: 'bonafide', child: Text('Bonafide Certificate')),
              DropdownMenuItem(value: 'merit', child: Text('Merit Certificate')),
              DropdownMenuItem(value: 'participation', child: Text('Participation Certificate')),
              DropdownMenuItem(value: 'achievement', child: Text('Achievement Certificate')),
              DropdownMenuItem(value: 'sports', child: Text('Sports Certificate')),
            ],
            onChanged: (v) => setState(() => _certificateType = v!),
          ),
          AppSpacing.vMd,
          _buildFieldLabel('Certificate Body', isDark),
          AppSpacing.vXs,
          TextFormField(
            controller: _bodyController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Enter certificate text with placeholders like {student_name}, {father_name}, etc.',
            ),
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
              const Text('Show School Seal'),
              Switch(value: _showSeal, onChanged: (v) => setState(() => _showSeal = v), activeTrackColor: AppColors.primary),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Decorative Border'),
              Switch(value: _decorativeBorder, onChanged: (v) => setState(() => _decorativeBorder = v), activeTrackColor: AppColors.primary),
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Creating new certificate template...')));
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
                        Text(t['type'] as String, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
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
              onTap: () => context.go(RouteNames.certificateTemplatePath),
              child: Text(
                'Certificate & Marksheet',
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
              'Certificate Template',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Certificate Template',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Design and customize certificate templates',
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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Previewing certificate template...')));
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
