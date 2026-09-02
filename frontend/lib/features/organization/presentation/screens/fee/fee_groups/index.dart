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

class FeeGroupsScreen extends StatefulWidget {
  const FeeGroupsScreen({super.key});

  @override
  State<FeeGroupsScreen> createState() => _FeeGroupsScreenState();
}

class _FeeGroupsScreenState extends State<FeeGroupsScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _feeGroupsData = [
    {
      'id': '1',
      'name': 'Standard Fee Package',
      'description': 'Regular student fee structure',
      'feeTypes': ['Tuition Fee', 'Admission Fee', 'Exam Fee', 'Library Fee'],
      'totalAmount': 59000,
      'courses': ['All Courses'],
      'studentsCount': 450,
      'status': 'active',
    },
    {
      'id': '2',
      'name': 'Science Stream Package',
      'description': 'Fee structure for science students',
      'feeTypes': ['Tuition Fee', 'Admission Fee', 'Exam Fee', 'Library Fee', 'Lab Fee'],
      'totalAmount': 62000,
      'courses': ['Computer Science', 'Engineering', 'Science'],
      'studentsCount': 280,
      'status': 'active',
    },
    {
      'id': '3',
      'name': 'Hostel Student Package',
      'description': 'Complete package with hostel',
      'feeTypes': ['Tuition Fee', 'Admission Fee', 'Exam Fee', 'Library Fee', 'Hostel Fee'],
      'totalAmount': 119000,
      'courses': ['All Courses'],
      'studentsCount': 85,
      'status': 'active',
    },
    {
      'id': '4',
      'name': 'Day Scholar with Transport',
      'description': 'Day scholar with bus facility',
      'feeTypes': ['Tuition Fee', 'Admission Fee', 'Exam Fee', 'Library Fee', 'Transport Fee'],
      'totalAmount': 71000,
      'courses': ['All Courses'],
      'studentsCount': 120,
      'status': 'active',
    },
    {
      'id': '5',
      'name': 'Merit Scholarship Package',
      'description': 'Reduced fee for merit students',
      'feeTypes': ['Tuition Fee (50%)', 'Exam Fee', 'Library Fee'],
      'totalAmount': 29000,
      'courses': ['All Courses'],
      'studentsCount': 25,
      'status': 'active',
    },
  ];

  final List<Map<String, dynamic>> _availableFeeTypes = [
    {'id': 'tf', 'name': 'Tuition Fee', 'amount': 50000},
    {'id': 'af', 'name': 'Admission Fee', 'amount': 5000},
    {'id': 'ef', 'name': 'Exam Fee', 'amount': 2000},
    {'id': 'lf', 'name': 'Lab Fee', 'amount': 3000},
    {'id': 'lib', 'name': 'Library Fee', 'amount': 2000},
    {'id': 'sf', 'name': 'Sports Fee', 'amount': 1500},
    {'id': 'trf', 'name': 'Transport Fee', 'amount': 12000},
    {'id': 'hf', 'name': 'Hostel Fee', 'amount': 60000},
  ];

  void _showCreateGroupDialog() {
    final isDark = context.isDarkMode;
    final nameCtrl = TextEditingController();
    final coursesCtrl = TextEditingController(text: 'All Courses');
    final descCtrl = TextEditingController();
    final List<String> selectedTypes = ['tf', 'af', 'ef', 'lib'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final totalSelected = selectedTypes.fold<int>(
            0,
            (sum, id) {
              final fee = _availableFeeTypes.firstWhere((f) => f['id'] == id);
              return sum + (fee['amount'] as int);
            },
          );

          return Dialog(
            backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
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
                          'Create New Fee Group',
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
                        Expanded(child: AppTextField(controller: nameCtrl, label: 'Group Name *', hint: 'e.g., Standard Fee Package')),
                        AppSpacing.hMd,
                        Expanded(child: AppTextField(controller: coursesCtrl, label: 'Applicable Courses', hint: 'All Courses or specific')),
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
                          decoration: const InputDecoration(hintText: 'Brief description of the fee group...'),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,
                    _buildFieldLabel('Select Fee Types', isDark),
                    AppSpacing.vXs,
                    Container(
                      constraints: const BoxConstraints(maxHeight: 220),
                      decoration: BoxDecoration(
                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                        borderRadius: AppRadius.md,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _availableFeeTypes.length,
                        separatorBuilder: (ctx, i) => const Divider(height: 1),
                        itemBuilder: (ctx, i) {
                          final fee = _availableFeeTypes[i];
                          final id = fee['id'] as String;
                          final isSelected = selectedTypes.contains(id);

                          return InkWell(
                            onTap: () {
                              setDialogState(() {
                                if (isSelected) {
                                  selectedTypes.remove(id);
                                } else {
                                  selectedTypes.add(id);
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isSelected,
                                        onChanged: (v) {
                                          setDialogState(() {
                                            if (v == true) {
                                              selectedTypes.add(id);
                                            } else {
                                              selectedTypes.remove(id);
                                            }
                                          });
                                        },
                                        activeColor: AppColors.primary,
                                      ),
                                      Text(fee['name'] as String, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  Text(
                                    '₹${(fee['amount'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                    style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    AppSpacing.vMd,
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                        borderRadius: AppRadius.sm,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Amount:', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                          Text(
                            '₹${totalSelected.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800, color: AppColors.primary),
                          ),
                        ],
                      ),
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
                          text: 'Create Group',
                          onPressed: () {
                            if (nameCtrl.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter a group name.'), backgroundColor: AppColors.warning),
                              );
                              return;
                            }
                            final selectedNames = selectedTypes.map((id) {
                              return _availableFeeTypes.firstWhere((f) => f['id'] == id)['name'] as String;
                            }).toList();

                            setState(() {
                              _feeGroupsData.add({
                                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                                'name': nameCtrl.text.trim(),
                                'description': descCtrl.text.trim(),
                                'feeTypes': selectedNames,
                                'totalAmount': totalSelected,
                                'courses': [coursesCtrl.text.trim().isNotEmpty ? coursesCtrl.text.trim() : 'All Courses'],
                                'studentsCount': 0,
                                'status': 'active',
                              });
                            });
                            Navigator.of(ctx).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fee group created successfully!'), backgroundColor: AppColors.success),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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

    final filteredData = _feeGroupsData.where((g) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (g['name'] as String).toLowerCase();
      final desc = (g['description'] as String).toLowerCase();
      return name.contains(q) || desc.contains(q);
    }).toList();

    final totalStudentsAssigned = _feeGroupsData.fold<int>(0, (sum, g) => sum + (g['studentsCount'] as int));
    final avgAmount = (_feeGroupsData.fold<int>(0, (sum, g) => sum + (g['totalAmount'] as int)) / _feeGroupsData.length / 1000).round();

    // Stats Cards
    final card1 = OrgStatsCard(
      title: 'Fee Groups',
      value: _feeGroupsData.length.toString(),
      subtitle: 'Configured groups',
      icon: Icons.layers_outlined,
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = OrgStatsCard(
      title: 'Students Assigned',
      value: totalStudentsAssigned.toString(),
      subtitle: 'Across all groups',
      icon: Icons.groups_outlined,
      variant: OrgStatsCardVariant.success,
    );
    final card3 = OrgStatsCard(
      title: 'Avg. Group Amount',
      value: '₹${avgAmount}K',
      subtitle: 'Average package',
      icon: Icons.currency_rupee_rounded,
      variant: OrgStatsCardVariant.warning,
    );
    final card4 = OrgStatsCard(
      title: 'Fee Types Available',
      value: _availableFeeTypes.length.toString(),
      subtitle: 'For group creation',
      icon: Icons.menu_book_rounded,
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

          // Fee Groups Table Card (Full Width)
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
                        'Fee Groups',
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
                              hintText: 'Search fee groups...',
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
                            _buildDataColumn('FEE GROUP', isDark),
                            _buildDataColumn('FEE TYPES', isDark),
                            _buildDataColumn('TOTAL AMOUNT', isDark),
                            _buildDataColumn('COURSES', isDark),
                            _buildDataColumn('STUDENTS', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredData.map((group) {
                            final name = group['name'] as String;
                            final desc = group['description'] as String;
                            final feeTypes = (group['feeTypes'] as List).cast<String>();
                            final total = group['totalAmount'] as int;
                            final courses = (group['courses'] as List).cast<String>();
                            final studentsCount = group['studentsCount'] as int;
                            final status = group['status'] as String;

                            return DataRow(
                              cells: [
                                // Fee Group (Icon + Name + Desc)
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
                                          child: Icon(Icons.layers_outlined, color: AppColors.primary, size: 18),
                                        ),
                                      ),
                                      AppSpacing.hSm,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                          Text(
                                            desc,
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

                                // Fee Types chips
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ...feeTypes.take(2).map(
                                            (t) => Container(
                                              margin: const EdgeInsets.only(right: 4),
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                                borderRadius: AppRadius.sm,
                                                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                              ),
                                              child: Text(t, style: AppTypography.bodySmall.copyWith(fontSize: 10.5)),
                                            ),
                                          ),
                                      if (feeTypes.length > 2)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                            borderRadius: AppRadius.sm,
                                          ),
                                          child: Text('+${feeTypes.length - 2}', style: AppTypography.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                    ],
                                  ),
                                ),

                                // Total Amount
                                DataCell(
                                  Text(
                                    '₹${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.success),
                                  ),
                                ),

                                // Courses
                                DataCell(
                                  courses[0] == 'All Courses'
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withAlpha(20),
                                            borderRadius: AppRadius.sm,
                                          ),
                                          child: Text(
                                            'All Courses',
                                            style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                            borderRadius: AppRadius.full,
                                            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                          ),
                                          child: Text(
                                            '${courses.length} courses',
                                            style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                ),

                                // Students Count
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.person_outline_rounded, size: 15, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                      AppSpacing.hXs,
                                      Text(studentsCount.toString(), style: AppTypography.bodySmall),
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
                                      if (action == 'view') {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Viewing $name details...')));
                                      }
                                      if (action == 'edit') {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Editing $name...')));
                                      }
                                      if (action == 'assign') {
                                        context.go(RouteNames.feeAllocationPath);
                                      }
                                      if (action == 'duplicate') {
                                        setState(() {
                                          _feeGroupsData.add({
                                            ...group,
                                            'id': DateTime.now().millisecondsSinceEpoch.toString(),
                                            'name': '$name (Copy)',
                                            'studentsCount': 0,
                                          });
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Duplicated $name.')));
                                      }
                                      if (action == 'delete') {
                                        setState(() => _feeGroupsData.remove(group));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Deleted $name.'), backgroundColor: AppColors.error),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'view',
                                        child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text('View Details')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Row(children: [Icon(Icons.edit_outlined, size: 16), SizedBox(width: 8), Text('Edit Group')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'assign',
                                        child: Row(children: [Icon(Icons.link_rounded, size: 16), SizedBox(width: 8), Text('Assign to Students')]),
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
              'Fee Groups',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Fee Groups',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Create and manage fee group packages',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'Create Fee Group',
      icon: Icons.add_rounded,
      onPressed: _showCreateGroupDialog,
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
