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

class BatchPaymentQRScreen extends StatefulWidget {
  const BatchPaymentQRScreen({super.key});

  @override
  State<BatchPaymentQRScreen> createState() => _BatchPaymentQRScreenState();
}

class _BatchPaymentQRScreenState extends State<BatchPaymentQRScreen> {
  String _selectedCourse = 'all';
  String _selectedFeeType = 'tuition';
  final _upiTemplateController = TextEditingController(text: 'school_{batch_id}@upi');

  bool _includeBatchName = true;
  bool _autoGenerateNewBatches = false;

  final Set<int> _selectedBatchIds = {};

  final List<Map<String, dynamic>> _batches = [
    {'id': 1, 'name': 'Class 10 - A', 'students': 45, 'course': 'CBSE', 'qrGenerated': true},
    {'id': 2, 'name': 'Class 10 - B', 'students': 42, 'course': 'CBSE', 'qrGenerated': true},
    {'id': 3, 'name': 'Class 11 - Science', 'students': 38, 'course': 'Science', 'qrGenerated': false},
    {'id': 4, 'name': 'Class 11 - Commerce', 'students': 35, 'course': 'Commerce', 'qrGenerated': false},
    {'id': 5, 'name': 'Class 12 - Science', 'students': 40, 'course': 'Science', 'qrGenerated': true},
  ];

  @override
  void dispose() {
    _upiTemplateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop || context.isUltraWide;

    final filteredBatches = _batches.where((b) {
      if (_selectedCourse != 'all' && (b['course'] as String).toLowerCase() != _selectedCourse) {
        return false;
      }
      return true;
    }).toList();

    final isAllSelected = filteredBatches.isNotEmpty && _selectedBatchIds.length == filteredBatches.length;

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

          // 2/3 + 1/3 Grid
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildConfigurationCard(filteredBatches, isAllSelected, isDark),
                ),
                AppSpacing.hLg,
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildQuickStatsCard(isDark),
                      AppSpacing.vLg,
                      _buildBulkActionsCard(isDark),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildConfigurationCard(filteredBatches, isAllSelected, isDark),
                AppSpacing.vLg,
                _buildQuickStatsCard(isDark),
                AppSpacing.vLg,
                _buildBulkActionsCard(isDark),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildConfigurationCard(List<Map<String, dynamic>> filteredBatches, bool isAllSelected, bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.school_outlined, color: AppColors.primary),
              AppSpacing.hSm,
              Text('Batch QR Configuration', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          AppSpacing.vXs,
          Text('Configure QR codes for specific batches or generate in bulk', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
          AppSpacing.vLg,

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Select Course', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCourse,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All Courses')),
                        DropdownMenuItem(value: 'cbse', child: Text('CBSE')),
                        DropdownMenuItem(value: 'science', child: Text('Science')),
                        DropdownMenuItem(value: 'commerce', child: Text('Commerce')),
                      ],
                      onChanged: (v) => setState(() => _selectedCourse = v!),
                    ),
                  ],
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Fee Type', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _selectedFeeType,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'tuition', child: Text('Tuition Fee')),
                        DropdownMenuItem(value: 'exam', child: Text('Exam Fee')),
                        DropdownMenuItem(value: 'transport', child: Text('Transport Fee')),
                        DropdownMenuItem(value: 'library', child: Text('Library Fee')),
                      ],
                      onChanged: (v) => setState(() => _selectedFeeType = v!),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.vMd,

          AppTextField(controller: _upiTemplateController, label: 'UPI ID Template', hint: 'school_{batch_id}@upi'),
          AppSpacing.vXs,
          Text('Use {batch_id} as placeholder for batch identifier', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          AppSpacing.vLg,

          Container(
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
                    Text('Include Batch Name in QR', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                    Text('Add batch name as payment reference', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                  ],
                ),
                Switch(value: _includeBatchName, onChanged: (v) => setState(() => _includeBatchName = v), activeTrackColor: AppColors.primary),
              ],
            ),
          ),
          AppSpacing.vMd,

          Container(
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
                    Text('Auto-generate for New Batches', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                    Text('Automatically create QR when new batch is added', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                  ],
                ),
                Switch(value: _autoGenerateNewBatches, onChanged: (v) => setState(() => _autoGenerateNewBatches = v), activeTrackColor: AppColors.primary),
              ],
            ),
          ),
          AppSpacing.vLg,

          // Batches Table
          Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.sm,
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isAllSelected,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _selectedBatchIds.addAll(filteredBatches.map((b) => b['id'] as int));
                                } else {
                                  _selectedBatchIds.clear();
                                }
                              });
                            },
                            activeColor: AppColors.primary,
                          ),
                          Text('Select All Batches', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                          borderRadius: AppRadius.sm,
                        ),
                        child: Text('${filteredBatches.length} Batches', style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredBatches.length,
                  separatorBuilder: (ctx, i) => const Divider(height: 1),
                  itemBuilder: (ctx, index) {
                    final batch = filteredBatches[index];
                    final id = batch['id'] as int;
                    final isSelected = _selectedBatchIds.contains(id);
                    final qrGenerated = batch['qrGenerated'] as bool;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: isSelected,
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      _selectedBatchIds.add(id);
                                    } else {
                                      _selectedBatchIds.remove(id);
                                    }
                                  });
                                },
                                activeColor: AppColors.primary,
                              ),
                              AppSpacing.hSm,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(batch['name'] as String, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                                  Text('${batch['course']} • ${batch['students']} students', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: qrGenerated ? AppColors.success.withAlpha(20) : AppColors.borderLight.withAlpha(50),
                                  borderRadius: AppRadius.sm,
                                  border: Border.all(color: qrGenerated ? AppColors.success.withAlpha(60) : AppColors.borderLight),
                                ),
                                child: Text(
                                  qrGenerated ? 'Generated' : 'Pending',
                                  style: AppTypography.bodySmall.copyWith(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: qrGenerated ? AppColors.success : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                  ),
                                ),
                              ),
                              if (qrGenerated) ...[
                                AppSpacing.hSm,
                                IconButton(
                                  icon: const Icon(Icons.download_rounded, size: 18),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloading QR for ${batch['name']}...')));
                                  },
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          AppSpacing.vLg,

          Row(
            children: [
              AppButton(
                text: 'Generate Selected',
                icon: Icons.qr_code_2_rounded,
                onPressed: _selectedBatchIds.isEmpty
                    ? null
                    : () {
                        setState(() {
                          for (final b in _batches) {
                            if (_selectedBatchIds.contains(b['id'])) {
                              b['qrGenerated'] = true;
                            }
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Generated ${_selectedBatchIds.length} batch QR codes!'), backgroundColor: AppColors.success),
                        );
                      },
              ),
              AppSpacing.hSm,
              AppButton(
                text: 'Print All QR Codes',
                icon: Icons.print_outlined,
                variant: AppButtonVariant.outline,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Printing all batch QR codes...')));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsCard(bool isDark) {
    final totalBatches = _batches.length;
    final generated = _batches.where((b) => b['qrGenerated'] == true).length;
    final pending = totalBatches - generated;
    final totalStudents = _batches.fold<int>(0, (sum, b) => sum + (b['students'] as int));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people_outline_rounded, color: AppColors.primary, size: 20),
              AppSpacing.hSm,
              Text('Quick Stats', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          AppSpacing.vLg,
          _buildStatRow('Total Batches', '$totalBatches', isDark),
          _buildStatRow('QR Generated', '$generated', isDark, valueColor: AppColors.primary),
          _buildStatRow('Pending', '$pending', isDark, valueColor: AppColors.warning),
          _buildStatRow('Total Students', '$totalStudents', isDark),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, bool isDark, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
          Text(value, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildBulkActionsCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bulk Actions', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vLg,
          AppButton(
            text: 'Download All as ZIP',
            icon: Icons.download_rounded,
            variant: AppButtonVariant.outline,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloading batch QR codes ZIP package...')));
            },
          ),
          AppSpacing.vSm,
          AppButton(
            text: 'Print Batch Labels',
            icon: Icons.print_outlined,
            variant: AppButtonVariant.outline,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Printing batch labels...')));
            },
          ),
          AppSpacing.vSm,
          AppButton(
            text: 'Reset All QR Codes',
            icon: Icons.refresh_rounded,
            variant: AppButtonVariant.outline,
            onPressed: () {
              setState(() {
                for (final b in _batches) {
                  b['qrGenerated'] = false;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reset all batch QR codes.'), backgroundColor: AppColors.error));
            },
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
              onTap: () => context.go(RouteNames.settingsGeneralPath),
              child: Text(
                'Settings',
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
              'Batch Payment QR',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Batch Payment QR',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Generate batch-specific payment QR codes for fee collection',
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
