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

class GenerateIDCardsScreen extends StatefulWidget {
  const GenerateIDCardsScreen({super.key});

  @override
  State<GenerateIDCardsScreen> createState() => _GenerateIDCardsScreenState();
}

class _GenerateIDCardsScreenState extends State<GenerateIDCardsScreen> {
  String _selectedTemplate = '1';
  String _selectedClass = 'all';
  String _selectedSection = 'all';
  String _selectedAcademicYear = '2024-25';
  String _searchQuery = '';

  final Set<String> _selectedStudentIds = {};

  final List<Map<String, dynamic>> _students = [
    {'id': 'STU001', 'name': 'Rahul Sharma', 'class': '10th', 'section': 'A', 'rollNo': '101', 'photo': true},
    {'id': 'STU002', 'name': 'Priya Patel', 'class': '10th', 'section': 'A', 'rollNo': '102', 'photo': true},
    {'id': 'STU003', 'name': 'Amit Kumar', 'class': '10th', 'section': 'B', 'rollNo': '103', 'photo': false},
    {'id': 'STU004', 'name': 'Sneha Gupta', 'class': '9th', 'section': 'A', 'rollNo': '201', 'photo': true},
    {'id': 'STU005', 'name': 'Vikram Singh', 'class': '9th', 'section': 'B', 'rollNo': '202', 'photo': true},
    {'id': 'STU006', 'name': 'Anita Desai', 'class': '8th', 'section': 'A', 'rollNo': '301', 'photo': true},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop || context.isUltraWide;

    final filteredStudents = _students.where((s) {
      if (_selectedClass != 'all' && s['class'] != _selectedClass) return false;
      if (_selectedSection != 'all' && s['section'] != _selectedSection) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = (s['name'] as String).toLowerCase();
        final id = (s['id'] as String).toLowerCase();
        return name.contains(q) || id.contains(q);
      }
      return true;
    }).toList();

    final isAllSelected = filteredStudents.isNotEmpty && _selectedStudentIds.length == filteredStudents.length;

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

          // Main 1/3 + 2/3 Grid
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildFiltersCard(isDark),
                ),
                AppSpacing.hLg,
                Expanded(
                  flex: 2,
                  child: _buildStudentSelectionCard(filteredStudents, isAllSelected, isDark),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildFiltersCard(isDark),
                AppSpacing.vLg,
                _buildStudentSelectionCard(filteredStudents, isAllSelected, isDark),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFiltersCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filters & Options', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vLg,
          _buildFieldLabel('Select Template', isDark),
          AppSpacing.vXs,
          DropdownButtonFormField<String>(
            initialValue: _selectedTemplate,
            isExpanded: true,
            decoration: const InputDecoration(),
            items: const [
              DropdownMenuItem(value: '1', child: Text('Standard Blue Template (Portrait)')),
              DropdownMenuItem(value: '2', child: Text('Modern Green Template (Landscape)')),
              DropdownMenuItem(value: '3', child: Text('Classic Red Template (Portrait)')),
            ],
            onChanged: (v) => setState(() => _selectedTemplate = v!),
          ),
          AppSpacing.vMd,
          _buildFieldLabel('Class', isDark),
          AppSpacing.vXs,
          DropdownButtonFormField<String>(
            initialValue: _selectedClass,
            isExpanded: true,
            decoration: const InputDecoration(),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All Classes')),
              DropdownMenuItem(value: '8th', child: Text('8th')),
              DropdownMenuItem(value: '9th', child: Text('9th')),
              DropdownMenuItem(value: '10th', child: Text('10th')),
            ],
            onChanged: (v) => setState(() => _selectedClass = v!),
          ),
          AppSpacing.vMd,
          _buildFieldLabel('Section', isDark),
          AppSpacing.vXs,
          DropdownButtonFormField<String>(
            initialValue: _selectedSection,
            isExpanded: true,
            decoration: const InputDecoration(),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All Sections')),
              DropdownMenuItem(value: 'A', child: Text('Section A')),
              DropdownMenuItem(value: 'B', child: Text('Section B')),
            ],
            onChanged: (v) => setState(() => _selectedSection = v!),
          ),
          AppSpacing.vMd,
          _buildFieldLabel('Academic Year', isDark),
          AppSpacing.vXs,
          DropdownButtonFormField<String>(
            initialValue: _selectedAcademicYear,
            isExpanded: true,
            decoration: const InputDecoration(),
            items: const [
              DropdownMenuItem(value: '2024-25', child: Text('2024-25')),
              DropdownMenuItem(value: '2023-24', child: Text('2023-24')),
            ],
            onChanged: (v) => setState(() => _selectedAcademicYear = v!),
          ),
          AppSpacing.vLg,
          const Divider(height: 1),
          AppSpacing.vMd,
          Row(
            children: [
              Icon(Icons.people_outline_rounded, size: 16, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              AppSpacing.hSm,
              Text('Selected: ${_selectedStudentIds.length} students', style: AppTypography.bodySmall),
            ],
          ),
          AppSpacing.vSm,
          Row(
            children: [
              Icon(Icons.credit_card_rounded, size: 16, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              AppSpacing.hSm,
              Text('Cards to generate: ${_selectedStudentIds.length}', style: AppTypography.bodySmall),
            ],
          ),
          AppSpacing.vLg,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                text: 'Preview Cards',
                icon: Icons.visibility_outlined,
                onPressed: _selectedStudentIds.isEmpty
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Previewing ${_selectedStudentIds.length} ID cards...')),
                        );
                      },
              ),
              AppSpacing.vSm,
              AppButton(
                text: 'Print Cards',
                icon: Icons.print_outlined,
                variant: AppButtonVariant.outline,
                onPressed: _selectedStudentIds.isEmpty
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Printing ${_selectedStudentIds.length} ID cards...')),
                        );
                      },
              ),
              AppSpacing.vSm,
              AppButton(
                text: 'Download PDF',
                icon: Icons.download_rounded,
                variant: AppButtonVariant.outline,
                onPressed: _selectedStudentIds.isEmpty
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Generating and downloading ID cards PDF...')),
                        );
                      },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentSelectionCard(List<Map<String, dynamic>> filteredStudents, bool isAllSelected, bool isDark) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Students',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 240),
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                      borderRadius: AppRadius.sm,
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val.trim()),
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search students...',
                        hintStyle: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          fontSize: 12,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 16,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
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
                    horizontalMargin: 20,
                    columnSpacing: 20,
                    headingRowColor: WidgetStateProperty.all(
                      isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight.withAlpha(120),
                    ),
                    columns: [
                      DataColumn(
                        label: Checkbox(
                          value: isAllSelected,
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedStudentIds.addAll(filteredStudents.map((s) => s['id'] as String));
                              } else {
                                _selectedStudentIds.clear();
                              }
                            });
                          },
                          activeColor: AppColors.primary,
                        ),
                      ),
                      _buildDataColumn('STUDENT ID', isDark),
                      _buildDataColumn('NAME', isDark),
                      _buildDataColumn('CLASS', isDark),
                      _buildDataColumn('ROLL NO', isDark),
                      _buildDataColumn('PHOTO', isDark),
                    ],
                    rows: filteredStudents.map((student) {
                      final id = student['id'] as String;
                      final name = student['name'] as String;
                      final sClass = student['class'] as String;
                      final section = student['section'] as String;
                      final rollNo = student['rollNo'] as String;
                      final photo = student['photo'] as bool;
                      final isSelected = _selectedStudentIds.contains(id);

                      return DataRow(
                        cells: [
                          DataCell(
                            Checkbox(
                              value: isSelected,
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    _selectedStudentIds.add(id);
                                  } else {
                                    _selectedStudentIds.remove(id);
                                  }
                                });
                              },
                              activeColor: AppColors.primary,
                            ),
                          ),
                          DataCell(Text(id, style: AppTypography.bodySmall.copyWith(fontFamily: 'monospace', fontWeight: FontWeight.w600))),
                          DataCell(Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600))),
                          DataCell(Text('$sClass - $section', style: AppTypography.bodySmall)),
                          DataCell(Text(rollNo, style: AppTypography.bodySmall)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: photo ? AppColors.success.withAlpha(20) : AppColors.error.withAlpha(20),
                                borderRadius: AppRadius.sm,
                              ),
                              child: Text(
                                photo ? 'Available' : 'Missing',
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: photo ? AppColors.success : AppColors.error,
                                ),
                              ),
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
              'Generate ID Cards',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Generate ID Cards',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Select students and generate ID cards in bulk',
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
