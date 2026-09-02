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
import '../../../../../../shared/widgets/app_status_badge.dart';
import '../../../../../../shared/widgets/app_text_field.dart';
import '../../../widgets/org_stats_card.dart';

class FeeTypesScreen extends StatefulWidget {
  const FeeTypesScreen({super.key});

  @override
  State<FeeTypesScreen> createState() => _FeeTypesScreenState();
}

class _FeeTypesScreenState extends State<FeeTypesScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _feeTypesData = [
    {
      'id': '1',
      'name': 'Tuition Fee',
      'code': 'TF001',
      'category': 'Academic',
      'defaultAmount': 50000,
      'frequency': 'Yearly',
      'applicableTo': ['All Courses'],
      'description': 'Main academic tuition fee',
      'status': 'active',
    },
    {
      'id': '2',
      'name': 'Admission Fee',
      'code': 'AF001',
      'category': 'One-time',
      'defaultAmount': 5000,
      'frequency': 'One-time',
      'applicableTo': ['All Courses'],
      'description': 'One-time admission processing fee',
      'status': 'active',
    },
    {
      'id': '3',
      'name': 'Exam Fee',
      'code': 'EF001',
      'category': 'Academic',
      'defaultAmount': 2000,
      'frequency': 'Per Semester',
      'applicableTo': ['All Courses'],
      'description': 'Examination and assessment fee',
      'status': 'active',
    },
    {
      'id': '4',
      'name': 'Lab Fee',
      'code': 'LF001',
      'category': 'Academic',
      'defaultAmount': 3000,
      'frequency': 'Yearly',
      'applicableTo': ['Computer Science', 'Engineering', 'Science'],
      'description': 'Laboratory equipment and materials',
      'status': 'active',
    },
    {
      'id': '5',
      'name': 'Library Fee',
      'code': 'LIB001',
      'category': 'Facility',
      'defaultAmount': 2000,
      'frequency': 'Yearly',
      'applicableTo': ['All Courses'],
      'description': 'Library access and resources',
      'status': 'active',
    },
    {
      'id': '6',
      'name': 'Sports Fee',
      'code': 'SF001',
      'category': 'Facility',
      'defaultAmount': 1500,
      'frequency': 'Yearly',
      'applicableTo': ['All Courses'],
      'description': 'Sports facilities and activities',
      'status': 'active',
    },
    {
      'id': '7',
      'name': 'Transport Fee',
      'code': 'TRF001',
      'category': 'Optional',
      'defaultAmount': 12000,
      'frequency': 'Yearly',
      'applicableTo': ['All Courses'],
      'description': 'School bus transportation',
      'status': 'active',
    },
    {
      'id': '8',
      'name': 'Hostel Fee',
      'code': 'HF001',
      'category': 'Optional',
      'defaultAmount': 60000,
      'frequency': 'Yearly',
      'applicableTo': ['All Courses'],
      'description': 'Hostel accommodation charges',
      'status': 'inactive',
    },
    {
      'id': '9',
      'name': 'Re-Exam Fee',
      'code': 'REF001',
      'category': 'Academic',
      'defaultAmount': 500,
      'frequency': 'Per Exam',
      'applicableTo': ['All Courses'],
      'description': 'Fee for re-examination attempts',
      'status': 'active',
    },
    {
      'id': '10',
      'name': 'Re-Admission Fee',
      'code': 'RAF001',
      'category': 'One-time',
      'defaultAmount': 2500,
      'frequency': 'One-time',
      'applicableTo': ['All Courses'],
      'description': 'Fee for re-admission after discontinuation',
      'status': 'active',
    },
  ];

  void _showAddFeeTypeDialog() {
    final isDark = context.isDarkMode;
    final nameCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String category = 'Academic';
    String frequency = 'Yearly';
    String applicableTo = 'all';
    bool isActive = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add New Fee Type',
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  AppSpacing.vLg,
                  Row(
                    children: [
                      Expanded(child: AppTextField(controller: nameCtrl, label: 'Fee Name *', hint: 'e.g., Tuition Fee')),
                      AppSpacing.hMd,
                      Expanded(child: AppTextField(controller: codeCtrl, label: 'Fee Code *', hint: 'e.g., TF001')),
                    ],
                  ),
                  AppSpacing.vMd,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Category', isDark),
                            AppSpacing.vXs,
                            DropdownButtonFormField<String>(
                              initialValue: category,
                              isExpanded: true,
                              decoration: const InputDecoration(),
                              items: const [
                                DropdownMenuItem(value: 'Academic', child: Text('Academic')),
                                DropdownMenuItem(value: 'Facility', child: Text('Facility')),
                                DropdownMenuItem(value: 'One-time', child: Text('One-time')),
                                DropdownMenuItem(value: 'Optional', child: Text('Optional')),
                              ],
                              onChanged: (v) => setDialogState(() => category = v!),
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(child: AppTextField(controller: amountCtrl, label: 'Default Amount (₹) *', hint: 'e.g., 5000', keyboardType: TextInputType.number)),
                    ],
                  ),
                  AppSpacing.vMd,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Frequency', isDark),
                            AppSpacing.vXs,
                            DropdownButtonFormField<String>(
                              initialValue: frequency,
                              isExpanded: true,
                              decoration: const InputDecoration(),
                              items: const [
                                DropdownMenuItem(value: 'One-time', child: Text('One-time')),
                                DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                                DropdownMenuItem(value: 'Quarterly', child: Text('Quarterly')),
                                DropdownMenuItem(value: 'Per Semester', child: Text('Per Semester')),
                                DropdownMenuItem(value: 'Yearly', child: Text('Yearly')),
                              ],
                              onChanged: (v) => setDialogState(() => frequency = v!),
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Applicable To', isDark),
                            AppSpacing.vXs,
                            DropdownButtonFormField<String>(
                              initialValue: applicableTo,
                              isExpanded: true,
                              decoration: const InputDecoration(),
                              items: const [
                                DropdownMenuItem(value: 'all', child: Text('All Courses')),
                                DropdownMenuItem(value: 'cs', child: Text('Computer Science')),
                                DropdownMenuItem(value: 'engineering', child: Text('Engineering')),
                                DropdownMenuItem(value: 'commerce', child: Text('Commerce')),
                              ],
                              onChanged: (v) => setDialogState(() => applicableTo = v!),
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
                        controller: descCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(hintText: 'Brief description of the fee type...'),
                      ),
                    ],
                  ),
                  AppSpacing.vMd,
                  Row(
                    children: [
                      Switch(
                        value: isActive,
                        onChanged: (v) => setDialogState(() => isActive = v),
                        activeTrackColor: AppColors.primary,
                      ),
                      AppSpacing.hXs,
                      Text('Active', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  AppSpacing.vLg,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton(
                        text: 'Cancel',
                        variant: AppButtonVariant.outline,
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                      AppSpacing.hSm,
                      AppButton(
                        text: 'Add Fee Type',
                        onPressed: () {
                          if (nameCtrl.text.trim().isEmpty || amountCtrl.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter fee name and amount.'), backgroundColor: AppColors.warning),
                            );
                            return;
                          }
                          setState(() {
                            _feeTypesData.add({
                              'id': DateTime.now().millisecondsSinceEpoch.toString(),
                              'name': nameCtrl.text.trim(),
                              'code': codeCtrl.text.trim().isNotEmpty ? codeCtrl.text.trim() : 'FT00${_feeTypesData.length + 1}',
                              'category': category,
                              'defaultAmount': int.tryParse(amountCtrl.text.trim()) ?? 0,
                              'frequency': frequency,
                              'applicableTo': applicableTo == 'all' ? ['All Courses'] : ['Computer Science'],
                              'description': descCtrl.text.trim(),
                              'status': isActive ? 'active' : 'inactive',
                            });
                          });
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Fee type added successfully!'), backgroundColor: AppColors.success),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isTablet = context.isTablet;

    final filteredData = _feeTypesData.where((f) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (f['name'] as String).toLowerCase();
      final code = (f['code'] as String).toLowerCase();
      final cat = (f['category'] as String).toLowerCase();
      return name.contains(q) || code.contains(q) || cat.contains(q);
    }).toList();

    // Stats Cards
    final card1 = OrgStatsCard(
      title: 'Total Fee Types',
      value: _feeTypesData.length.toString(),
      subtitle: 'Configured types',
      icon: Icons.label_outline_rounded,
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = OrgStatsCard(
      title: 'Active Types',
      value: _feeTypesData.where((f) => f['status'] == 'active').length.toString(),
      subtitle: 'In active billing',
      icon: Icons.currency_rupee_rounded,
      variant: OrgStatsCardVariant.success,
    );
    final card3 = OrgStatsCard(
      title: 'Academic Fees',
      value: _feeTypesData.where((f) => f['category'] == 'Academic').length.toString(),
      subtitle: 'Tuition & exam fees',
      icon: Icons.edit_note_rounded,
      variant: OrgStatsCardVariant.warning,
    );
    final card4 = OrgStatsCard(
      title: 'Optional Fees',
      value: _feeTypesData.where((f) => f['category'] == 'Optional').length.toString(),
      subtitle: 'Transport & hostel',
      icon: Icons.bookmark_border_rounded,
      variant: OrgStatsCardVariant.info,
    );

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

          // Stats Grid
          if (isDesktop)
            Row(
              children: [
                Expanded(child: card1),
                AppSpacing.hLg,
                Expanded(child: card2),
                AppSpacing.hLg,
                Expanded(child: card3),
                AppSpacing.hLg,
                Expanded(child: card4),
              ],
            )
          else if (isTablet)
            Column(
              children: [
                Row(children: [Expanded(child: card1), AppSpacing.hMd, Expanded(child: card2)]),
                AppSpacing.vMd,
                Row(children: [Expanded(child: card3), AppSpacing.hMd, Expanded(child: card4)]),
              ],
            )
          else
            Column(
              children: [
                card1,
                AppSpacing.vMd,
                card2,
                AppSpacing.vMd,
                card3,
                AppSpacing.vMd,
                card4,
              ],
            ),

          AppSpacing.vXl,

          // Fee Types Table Card (Full Width)
          AppCard(
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
                        'Fee Types List',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
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
                              hintText: 'Search fee types...',
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
                          dataRowMinHeight: 60,
                          dataRowMaxHeight: 64,
                          horizontalMargin: 20,
                          columnSpacing: 24,
                          headingRowColor: WidgetStateProperty.all(
                            isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight.withAlpha(120),
                          ),
                          columns: [
                            _buildDataColumn('FEE TYPE', isDark),
                            _buildDataColumn('CATEGORY', isDark),
                            _buildDataColumn('DEFAULT AMOUNT', isDark),
                            _buildDataColumn('FREQUENCY', isDark),
                            _buildDataColumn('APPLICABLE TO', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredData.map((fee) {
                            final name = fee['name'] as String;
                            final code = fee['code'] as String;
                            final category = fee['category'] as String;
                            final amount = fee['defaultAmount'] as int;
                            final frequency = fee['frequency'] as String;
                            final applicable = (fee['applicableTo'] as List).cast<String>();
                            final status = fee['status'] as String;

                            return DataRow(
                              cells: [
                                // Fee Type (Icon + Name + Code)
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withAlpha(25),
                                          borderRadius: AppRadius.sm,
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.currency_rupee_rounded, color: AppColors.primary, size: 18),
                                        ),
                                      ),
                                      AppSpacing.hSm,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                          Text(
                                            code,
                                            style: AppTypography.bodySmall.copyWith(
                                              fontSize: 11,
                                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Category
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                      borderRadius: AppRadius.full,
                                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                    ),
                                    child: Text(
                                      category,
                                      style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),

                                // Default Amount
                                DataCell(
                                  Text(
                                    '₹${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),

                                // Frequency
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                      borderRadius: AppRadius.sm,
                                    ),
                                    child: Text(
                                      frequency,
                                      style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),

                                // Applicable To
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withAlpha(20),
                                          borderRadius: AppRadius.sm,
                                        ),
                                        child: Text(
                                          applicable[0],
                                          style: AppTypography.bodySmall.copyWith(
                                            fontSize: 11,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      if (applicable.length > 1) ...[
                                        AppSpacing.hXs,
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                            borderRadius: AppRadius.sm,
                                          ),
                                          child: Text(
                                            '+${applicable.length - 1}',
                                            style: AppTypography.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                // Status
                                DataCell(
                                  AppStatusBadge(
                                    status: status == 'active' ? AppBadgeStatus.active : AppBadgeStatus.danger,
                                    customLabel: status,
                                  ),
                                ),

                                // Actions
                                DataCell(
                                  PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_horiz_rounded,
                                      size: 18,
                                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                    ),
                                    onSelected: (action) {
                                      if (action == 'edit') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Editing $name...')),
                                        );
                                      }
                                      if (action == 'usage') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Viewing student allocations for $name...')),
                                        );
                                      }
                                      if (action == 'duplicate') {
                                        setState(() {
                                          _feeTypesData.add({
                                            ...fee,
                                            'id': DateTime.now().millisecondsSinceEpoch.toString(),
                                            'name': '$name (Copy)',
                                            'code': '${code}_COPY',
                                          });
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Duplicated $name.')),
                                        );
                                      }
                                      if (action == 'delete') {
                                        setState(() => _feeTypesData.remove(fee));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Deleted $name.'),
                                            backgroundColor: AppColors.error,
                                          ),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Row(children: [Icon(Icons.edit_outlined, size: 16), SizedBox(width: 8), Text('Edit Fee Type')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'usage',
                                        child: Row(children: [Icon(Icons.bar_chart_rounded, size: 16), SizedBox(width: 8), Text('View Usage')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'duplicate',
                                        child: Row(children: [Icon(Icons.copy_rounded, size: 16), SizedBox(width: 8), Text('Duplicate')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Row(children: [Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error), SizedBox(width: 8), Text('Delete', style: TextStyle(color: AppColors.error))]),
                                      ),
                                    ],
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
              onTap: () => context.go(RouteNames.feeCollectionPath),
              child: Text(
                'Fee Management',
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
              'Fee Types',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Fee Types',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Manage different types of fees',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'Add Fee Type',
      icon: Icons.add_rounded,
      onPressed: _showAddFeeTypeDialog,
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
