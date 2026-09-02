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

class GradeManagementScreen extends StatefulWidget {
  const GradeManagementScreen({super.key});

  @override
  State<GradeManagementScreen> createState() => _GradeManagementScreenState();
}

class _GradeManagementScreenState extends State<GradeManagementScreen> {
  final List<Map<String, dynamic>> _grades = [
    {'id': '1', 'grade': 'A+', 'minPercentage': 90, 'maxPercentage': 100, 'gradePoint': 10.0, 'remarks': 'Outstanding'},
    {'id': '2', 'grade': 'A', 'minPercentage': 80, 'maxPercentage': 89, 'gradePoint': 9.0, 'remarks': 'Excellent'},
    {'id': '3', 'grade': 'B+', 'minPercentage': 70, 'maxPercentage': 79, 'gradePoint': 8.0, 'remarks': 'Very Good'},
    {'id': '4', 'grade': 'B', 'minPercentage': 60, 'maxPercentage': 69, 'gradePoint': 7.0, 'remarks': 'Good'},
    {'id': '5', 'grade': 'C+', 'minPercentage': 50, 'maxPercentage': 59, 'gradePoint': 6.0, 'remarks': 'Above Average'},
    {'id': '6', 'grade': 'C', 'minPercentage': 40, 'maxPercentage': 49, 'gradePoint': 5.0, 'remarks': 'Average'},
    {'id': '7', 'grade': 'D', 'minPercentage': 35, 'maxPercentage': 39, 'gradePoint': 4.0, 'remarks': 'Below Average'},
    {'id': '8', 'grade': 'F', 'minPercentage': 0, 'maxPercentage': 34, 'gradePoint': 0.0, 'remarks': 'Fail'},
  ];

  final _passingGradeController = TextEditingController(text: 'D');
  final _minPassingController = TextEditingController(text: '35');
  final _maxGradePointController = TextEditingController(text: '10');

  final Map<String, Map<String, TextEditingController>> _rowControllers = {};

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    for (final g in _grades) {
      final id = g['id'] as String;
      _rowControllers[id] = {
        'min': TextEditingController(text: g['minPercentage'].toString()),
        'max': TextEditingController(text: g['maxPercentage'].toString()),
        'point': TextEditingController(text: g['gradePoint'].toString()),
        'remarks': TextEditingController(text: g['remarks'].toString()),
      };
    }
  }

  @override
  void dispose() {
    for (final map in _rowControllers.values) {
      for (final c in map.values) {
        c.dispose();
      }
    }
    _passingGradeController.dispose();
    _minPassingController.dispose();
    _maxGradePointController.dispose();
    super.dispose();
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return AppColors.success;
      case 'B+':
      case 'B':
        return AppColors.info;
      case 'C+':
      case 'C':
        return AppColors.warning;
      case 'D':
        return Colors.orange;
      case 'F':
        return AppColors.error;
      default:
        return AppColors.textSecondaryLight;
    }
  }

  void _addNewGradeScale() {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      _grades.add({
        'id': newId,
        'grade': 'New',
        'minPercentage': 0,
        'maxPercentage': 100,
        'gradePoint': 5.0,
        'remarks': 'Standard',
      });
      _rowControllers[newId] = {
        'min': TextEditingController(text: '0'),
        'max': TextEditingController(text: '100'),
        'point': TextEditingController(text: '5.0'),
        'remarks': TextEditingController(text: 'Standard'),
      };
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added new grade scale row.')),
    );
  }

  void _handleSaveChanges() {
    for (final g in _grades) {
      final id = g['id'] as String;
      final map = _rowControllers[id];
      if (map != null) {
        g['minPercentage'] = int.tryParse(map['min']!.text) ?? g['minPercentage'];
        g['maxPercentage'] = int.tryParse(map['max']!.text) ?? g['maxPercentage'];
        g['gradePoint'] = double.tryParse(map['point']!.text) ?? g['gradePoint'];
        g['remarks'] = map['remarks']!.text;
      }
    }
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grade scale settings saved successfully!'), backgroundColor: AppColors.success),
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

          // Main Layout
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildConfigTableCard(isDark),
                ),
                AppSpacing.hLg,
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildPreviewCard(isDark),
                      AppSpacing.vLg,
                      _buildQuickSettingsCard(isDark),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildConfigTableCard(isDark),
                AppSpacing.vLg,
                _buildPreviewCard(isDark),
                AppSpacing.vLg,
                _buildQuickSettingsCard(isDark),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildConfigTableCard(bool isDark) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.settings_outlined, size: 20, color: AppColors.primary),
                AppSpacing.hSm,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Grade Scale Configuration', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                    Text(
                      'Define percentage ranges and corresponding grades',
                      style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    headingRowHeight: 44,
                    dataRowMinHeight: 56,
                    dataRowMaxHeight: 60,
                    horizontalMargin: 16,
                    columnSpacing: 16,
                    headingRowColor: WidgetStateProperty.all(
                      isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight.withAlpha(120),
                    ),
                    columns: [
                      _buildDataColumn('GRADE', isDark),
                      _buildDataColumn('MIN %', isDark),
                      _buildDataColumn('MAX %', isDark),
                      _buildDataColumn('GRADE POINT', isDark),
                      _buildDataColumn('REMARKS', isDark),
                      _buildDataColumn('ACTIONS', isDark),
                    ],
                    rows: _grades.map((grade) {
                      final id = grade['id'] as String;
                      final gradeName = grade['grade'] as String;
                      final color = _getGradeColor(gradeName);
                      final map = _rowControllers[id]!;

                      return DataRow(
                        cells: [
                          // Grade Badge
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: color.withAlpha(20),
                                borderRadius: AppRadius.sm,
                                border: Border.all(color: color.withAlpha(60)),
                              ),
                              child: Text(
                                gradeName,
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: color,
                                ),
                              ),
                            ),
                          ),

                          // Min %
                          DataCell(
                            SizedBox(
                              width: 70,
                              height: 36,
                              child: TextField(
                                controller: map['min'],
                                keyboardType: TextInputType.number,
                                style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  border: OutlineInputBorder(
                                    borderRadius: AppRadius.sm,
                                    borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Max %
                          DataCell(
                            SizedBox(
                              width: 70,
                              height: 36,
                              child: TextField(
                                controller: map['max'],
                                keyboardType: TextInputType.number,
                                style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  border: OutlineInputBorder(
                                    borderRadius: AppRadius.sm,
                                    borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Grade Point
                          DataCell(
                            SizedBox(
                              width: 70,
                              height: 36,
                              child: TextField(
                                controller: map['point'],
                                keyboardType: TextInputType.number,
                                style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  border: OutlineInputBorder(
                                    borderRadius: AppRadius.sm,
                                    borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Remarks
                          DataCell(
                            SizedBox(
                              width: 140,
                              height: 36,
                              child: TextField(
                                controller: map['remarks'],
                                style: AppTypography.bodySmall,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  border: OutlineInputBorder(
                                    borderRadius: AppRadius.sm,
                                    borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Action Delete
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                              onPressed: () {
                                setState(() {
                                  _grades.remove(grade);
                                  _rowControllers.remove(id);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Removed grade scale $gradeName.'), backgroundColor: AppColors.error),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  text: 'Save Changes',
                  icon: Icons.save_rounded,
                  onPressed: _handleSaveChanges,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Grade Scale Preview', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vMd,
          Column(
            children: _grades.map((grade) {
              final gradeName = grade['grade'] as String;
              final min = grade['minPercentage'];
              final max = grade['maxPercentage'];
              final color = _getGradeColor(gradeName);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withAlpha(20),
                        borderRadius: AppRadius.sm,
                      ),
                      child: Text(
                        gradeName,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ),
                    Text(
                      '$min% - $max%',
                      style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSettingsCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Settings', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vLg,
          AppTextField(controller: _passingGradeController, label: 'Passing Grade', hint: 'D'),
          AppSpacing.vMd,
          AppTextField(controller: _minPassingController, label: 'Minimum Passing Percentage', hint: '35', keyboardType: TextInputType.number),
          AppSpacing.vMd,
          AppTextField(controller: _maxGradePointController, label: 'Maximum Grade Point', hint: '10', keyboardType: TextInputType.number),
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
              'Grade Management',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Grade Management',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Configure grading scales and grade point systems',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'Add Grade Scale',
      icon: Icons.add_rounded,
      onPressed: _addNewGradeScale,
      height: 38,
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerTexts,
          AppSpacing.vMd,
          actionButton,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: headerTexts),
        actionButton,
      ],
    );
  }

  DataColumn _buildDataColumn(String title, bool isDark) {
    return DataColumn(
      label: Text(
        title,
        style: AppTypography.labelMedium.copyWith(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
        ),
      ),
    );
  }
}
