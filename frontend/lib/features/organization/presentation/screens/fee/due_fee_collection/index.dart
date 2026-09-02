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
import '../../../widgets/org_stats_card.dart';

class DueFeeCollectionScreen extends StatefulWidget {
  const DueFeeCollectionScreen({super.key});

  @override
  State<DueFeeCollectionScreen> createState() => _DueFeeCollectionScreenState();
}

class _DueFeeCollectionScreenState extends State<DueFeeCollectionScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _dueFeesData = [
    {
      'id': '1',
      'studentId': 'STU001',
      'name': 'Rahul Sharma',
      'course': 'Computer Science',
      'batch': 'CS-2024-A',
      'phone': '+91 98765 43210',
      'totalDue': 25000,
      'dueDate': '2024-01-01',
      'daysOverdue': 14,
      'lastReminder': '2024-01-10',
      'status': 'overdue',
    },
    {
      'id': '2',
      'studentId': 'STU002',
      'name': 'Priya Patel',
      'course': 'Commerce',
      'batch': 'COM-2024-A',
      'phone': '+91 87654 32109',
      'totalDue': 15000,
      'dueDate': '2024-01-05',
      'daysOverdue': 10,
      'lastReminder': '2024-01-12',
      'status': 'overdue',
    },
    {
      'id': '3',
      'studentId': 'STU003',
      'name': 'Amit Kumar',
      'course': 'Engineering',
      'batch': 'ENG-2024-A',
      'phone': '+91 76543 21098',
      'totalDue': 35000,
      'dueDate': '2024-01-15',
      'daysOverdue': 0,
      'lastReminder': '-',
      'status': 'due_today',
    },
    {
      'id': '4',
      'studentId': 'STU004',
      'name': 'Sneha Gupta',
      'course': 'Science',
      'batch': 'SCI-2024-A',
      'phone': '+91 65432 10987',
      'totalDue': 12000,
      'dueDate': '2024-01-20',
      'daysOverdue': -5,
      'lastReminder': '-',
      'status': 'due_soon',
    },
    {
      'id': '5',
      'studentId': 'STU005',
      'name': 'Vikram Singh',
      'course': 'Arts',
      'batch': 'ART-2024-A',
      'phone': '+91 54321 09876',
      'totalDue': 8000,
      'dueDate': '2023-12-15',
      'daysOverdue': 31,
      'lastReminder': '2024-01-05',
      'status': 'overdue',
    },
    {
      'id': '6',
      'studentId': 'STU006',
      'name': 'Anita Reddy',
      'course': 'Computer Science',
      'batch': 'CS-2024-B',
      'phone': '+91 43210 98765',
      'totalDue': 20000,
      'dueDate': '2024-01-18',
      'daysOverdue': -3,
      'lastReminder': '-',
      'status': 'due_soon',
    },
  ];

  void _showCollectDueDialog(Map<String, dynamic> fee) {
    final isDark = context.isDarkMode;
    final amountCtrl = TextEditingController(text: fee['totalDue'].toString());
    final lateFeeCtrl = TextEditingController(text: '0');
    final refCtrl = TextEditingController();
    String method = 'cash';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Collect Due Payment',
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
                  AppSpacing.vMd,
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.backgroundDark.withAlpha(120) : AppColors.backgroundLight,
                      borderRadius: AppRadius.md,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Student:', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                            Text(fee['name'] as String, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                          ],
                        ),
                        AppSpacing.vXs,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Due:', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                            Text(
                              '₹${(fee['totalDue'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.error),
                            ),
                          ],
                        ),
                        AppSpacing.vXs,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Days Overdue:', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                            Text(
                              (fee['daysOverdue'] as int) > 0 ? '${fee['daysOverdue']} days' : 'Not overdue',
                              style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.vMd,
                  AppTextField(
                    controller: amountCtrl,
                    label: 'Amount to Collect *',
                    hint: 'Enter amount',
                    keyboardType: TextInputType.number,
                  ),
                  AppSpacing.vMd,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Payment Method *', isDark),
                            AppSpacing.vXs,
                            DropdownButtonFormField<String>(
                              initialValue: method,
                              isExpanded: true,
                              decoration: const InputDecoration(),
                              items: const [
                                DropdownMenuItem(value: 'cash', child: Text('Cash')),
                                DropdownMenuItem(value: 'card', child: Text('Card')),
                                DropdownMenuItem(value: 'upi', child: Text('UPI')),
                                DropdownMenuItem(value: 'bank', child: Text('Bank Transfer')),
                                DropdownMenuItem(value: 'cheque', child: Text('Cheque')),
                              ],
                              onChanged: (v) => setDialogState(() => method = v!),
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: AppTextField(
                          controller: lateFeeCtrl,
                          label: 'Late Fee',
                          hint: 'e.g., 500',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vMd,
                  AppTextField(
                    controller: refCtrl,
                    label: 'Reference Number',
                    hint: 'Transaction reference',
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
                        text: 'Collect Payment',
                        icon: Icons.currency_rupee_rounded,
                        onPressed: () {
                          final collected = int.tryParse(amountCtrl.text.trim()) ?? 0;
                          setState(() {
                            final currentDue = fee['totalDue'] as int;
                            final remaining = (currentDue - collected).clamp(0, currentDue);
                            if (remaining == 0) {
                              _dueFeesData.remove(fee);
                            } else {
                              fee['totalDue'] = remaining;
                            }
                          });
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Payment of ₹$collected recorded!'), backgroundColor: AppColors.success),
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

    final filteredData = _dueFeesData.where((f) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (f['name'] as String).toLowerCase();
      final sid = (f['studentId'] as String).toLowerCase();
      final course = (f['course'] as String).toLowerCase();
      return name.contains(q) || sid.contains(q) || course.contains(q);
    }).toList();

    final totalDue = _dueFeesData.fold<int>(0, (sum, f) => sum + (f['totalDue'] as int));
    final overdueCount = _dueFeesData.where((f) => f['status'] == 'overdue').length;
    final dueTodayCount = _dueFeesData.where((f) => f['status'] == 'due_today').length;

    // Stats Cards
    final card1 = OrgStatsCard(
      title: 'Total Due Amount',
      value: '₹${(totalDue / 1000).toStringAsFixed(0)}K',
      subtitle: 'From all students',
      icon: Icons.currency_rupee_rounded,
      variant: OrgStatsCardVariant.defaultVariant,
    );
    final card2 = OrgStatsCard(
      title: 'Students with Dues',
      value: _dueFeesData.length.toString(),
      subtitle: 'Need follow-up',
      icon: Icons.groups_outlined,
      variant: OrgStatsCardVariant.warning,
    );
    final card3 = OrgStatsCard(
      title: 'Overdue',
      value: overdueCount.toString(),
      subtitle: 'Past due date',
      icon: Icons.warning_amber_rounded,
      variant: OrgStatsCardVariant.primary,
    );
    final card4 = OrgStatsCard(
      title: 'Due Today',
      value: dueTodayCount.toString(),
      subtitle: 'Payment expected',
      icon: Icons.access_time_rounded,
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

          // Due Fee Table Card (Full Width)
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
                        'Students with Dues',
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
                              hintText: 'Search students with dues...',
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
                            _buildDataColumn('STUDENT', isDark),
                            _buildDataColumn('COURSE', isDark),
                            _buildDataColumn('AMOUNT DUE', isDark),
                            _buildDataColumn('DUE DATE', isDark),
                            _buildDataColumn('OVERDUE', isDark),
                            _buildDataColumn('LAST REMINDER', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredData.map((fee) {
                            final name = fee['name'] as String;
                            final studentId = fee['studentId'] as String;
                            final phone = fee['phone'] as String;
                            final course = fee['course'] as String;
                            final batch = fee['batch'] as String;
                            final totalDue = fee['totalDue'] as int;
                            final dueDate = fee['dueDate'] as String;
                            final daysOverdue = fee['daysOverdue'] as int;
                            final lastReminder = fee['lastReminder'] as String;
                            final status = fee['status'] as String;

                            return DataRow(
                              cells: [
                                // Student
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                      Text(
                                        '$studentId • $phone',
                                        style: AppTypography.bodySmall.copyWith(
                                          fontSize: 11,
                                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Course
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                          borderRadius: AppRadius.sm,
                                        ),
                                        child: Text(course, style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500)),
                                      ),
                                      Text(batch, style: AppTypography.bodySmall.copyWith(fontSize: 10.5, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                                    ],
                                  ),
                                ),

                                // Amount Due
                                DataCell(
                                  Text(
                                    '₹${totalDue.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.error),
                                  ),
                                ),

                                // Due Date
                                DataCell(Text(dueDate, style: AppTypography.bodySmall)),

                                // Overdue Pill
                                DataCell(
                                  daysOverdue > 0
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppColors.error.withAlpha(20),
                                            borderRadius: AppRadius.full,
                                          ),
                                          child: Text('$daysOverdue days', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.error, fontWeight: FontWeight.w600)),
                                        )
                                      : daysOverdue == 0
                                          ? Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary.withAlpha(20),
                                                borderRadius: AppRadius.full,
                                              ),
                                              child: Text('Today', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                                            )
                                          : Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                                borderRadius: AppRadius.full,
                                              ),
                                              child: Text('In ${daysOverdue.abs()} days', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                                            ),
                                ),

                                // Last Reminder
                                DataCell(
                                  Text(
                                    lastReminder != '-' ? lastReminder : 'Not sent',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: lastReminder == '-' ? (isDark ? AppColors.textMutedDark : AppColors.textMutedLight) : null,
                                    ),
                                  ),
                                ),

                                // Status
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: status == 'overdue'
                                          ? AppColors.error.withAlpha(20)
                                          : status == 'due_today'
                                              ? AppColors.primary.withAlpha(20)
                                              : (isDark ? AppColors.surfaceDark : AppColors.backgroundLight),
                                      borderRadius: AppRadius.full,
                                    ),
                                    child: Text(
                                      status == 'overdue'
                                          ? 'Overdue'
                                          : status == 'due_today'
                                              ? 'Due Today'
                                              : 'Due Soon',
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: status == 'overdue'
                                            ? AppColors.error
                                            : status == 'due_today'
                                                ? AppColors.primary
                                                : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                      ),
                                    ),
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
                                      if (action == 'collect') _showCollectDueDialog(fee);
                                      if (action == 'remind') {
                                        setState(() => fee['lastReminder'] = 'Today');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Payment reminder sent to $name.'), backgroundColor: AppColors.info),
                                        );
                                      }
                                      if (action == 'history') {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Viewing ledger history for $name...')));
                                      }
                                      if (action == 'penalty') {
                                        setState(() => fee['totalDue'] = (fee['totalDue'] as int) + 500);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('₹500 penalty added to $name.'), backgroundColor: AppColors.warning),
                                        );
                                      }
                                      if (action == 'waive') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Late fee waived for $name.'), backgroundColor: AppColors.success),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'collect',
                                        child: Row(children: [Icon(Icons.currency_rupee_rounded, size: 16), SizedBox(width: 8), Text('Collect Payment')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'remind',
                                        child: Row(children: [Icon(Icons.notifications_active_outlined, size: 16), SizedBox(width: 8), Text('Send Reminder')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'history',
                                        child: Row(children: [Icon(Icons.history_rounded, size: 16), SizedBox(width: 8), Text('View History')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'penalty',
                                        child: Row(children: [Icon(Icons.add_alert_outlined, size: 16), SizedBox(width: 8), Text('Add Penalty')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'waive',
                                        child: Row(children: [Icon(Icons.money_off_rounded, size: 16), SizedBox(width: 8), Text('Waive Late Fee')]),
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
              'Due Fee Collection',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Due Fee Collection',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Track and collect overdue fees from students',
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
          text: 'Send Bulk Reminder',
          icon: Icons.notifications_active_outlined,
          variant: AppButtonVariant.outline,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bulk reminders dispatched to all overdue students.'), backgroundColor: AppColors.info),
            );
          },
          height: 38,
        ),
        AppSpacing.hSm,
        AppButton(
          text: 'Export Report',
          icon: Icons.download_rounded,
          variant: AppButtonVariant.outline,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Exporting due fee report...')),
            );
          },
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: actionButtons,
          ),
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
