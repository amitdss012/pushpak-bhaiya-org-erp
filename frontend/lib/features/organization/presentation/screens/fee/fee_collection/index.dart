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

class FeeCollectionScreen extends StatefulWidget {
  const FeeCollectionScreen({super.key});

  @override
  State<FeeCollectionScreen> createState() => _FeeCollectionScreenState();
}

class _FeeCollectionScreenState extends State<FeeCollectionScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _feeRecordsData = [
    {
      'id': '1',
      'studentName': 'John Doe',
      'rollNo': 'STU001',
      'course': 'Computer Science',
      'feeType': 'Tuition Fee',
      'totalAmount': 50000,
      'paidAmount': 50000,
      'dueAmount': 0,
      'dueDate': '2024-01-15',
      'status': 'paid',
    },
    {
      'id': '2',
      'studentName': 'Sarah Smith',
      'rollNo': 'STU002',
      'course': 'Commerce',
      'feeType': 'Tuition Fee',
      'totalAmount': 45000,
      'paidAmount': 25000,
      'dueAmount': 20000,
      'dueDate': '2024-01-20',
      'status': 'partial',
    },
    {
      'id': '3',
      'studentName': 'Mike Johnson',
      'rollNo': 'STU003',
      'course': 'Arts',
      'feeType': 'Exam Fee',
      'totalAmount': 5000,
      'paidAmount': 0,
      'dueAmount': 5000,
      'dueDate': '2024-01-10',
      'status': 'due',
    },
    {
      'id': '4',
      'studentName': 'Emily Brown',
      'rollNo': 'STU004',
      'course': 'Science',
      'feeType': 'Lab Fee',
      'totalAmount': 15000,
      'paidAmount': 15000,
      'dueAmount': 0,
      'dueDate': '2024-01-25',
      'status': 'paid',
    },
    {
      'id': '5',
      'studentName': 'David Wilson',
      'rollNo': 'STU005',
      'course': 'Engineering',
      'feeType': 'Tuition Fee',
      'totalAmount': 75000,
      'paidAmount': 50000,
      'dueAmount': 25000,
      'dueDate': '2024-01-18',
      'status': 'partial',
    },
    {
      'id': '6',
      'studentName': 'Lisa Anderson',
      'rollNo': 'STU006',
      'course': 'Medical',
      'feeType': 'Tuition Fee',
      'totalAmount': 100000,
      'paidAmount': 0,
      'dueAmount': 100000,
      'dueDate': '2024-01-12',
      'status': 'due',
    },
  ];

  void _showCollectPaymentDialog(Map<String, dynamic> record) {
    final isDark = context.isDarkMode;
    final amountCtrl = TextEditingController(text: record['dueAmount'].toString());
    final remarksCtrl = TextEditingController();
    String paymentMethod = 'cash';

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
                        'Collect Fee Payment',
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
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.primary.withAlpha(25),
                              child: Text(
                                (record['studentName'] as String).substring(0, 1),
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                            AppSpacing.hMd,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(record['studentName'] as String, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                                  Text(
                                    '${record['rollNo']} • ${record['course']}',
                                    style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.vMd,
                        const Divider(height: 1),
                        AppSpacing.vSm,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Due Amount:', style: AppTypography.bodySmall),
                            Text(
                              '₹${(record['dueAmount'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.error),
                            ),
                          ],
                        ),
                        AppSpacing.vXs,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Fee Type:', style: AppTypography.bodySmall),
                            Text(record['feeType'] as String, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.vMd,
                  AppTextField(
                    controller: amountCtrl,
                    label: 'Payment Amount *',
                    hint: 'Enter amount',
                    keyboardType: TextInputType.number,
                  ),
                  AppSpacing.vMd,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('Payment Method', isDark),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: paymentMethod,
                        isExpanded: true,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: 'cash', child: Text('Cash')),
                          DropdownMenuItem(value: 'card', child: Text('Card')),
                          DropdownMenuItem(value: 'upi', child: Text('UPI')),
                          DropdownMenuItem(value: 'bank', child: Text('Bank Transfer')),
                          DropdownMenuItem(value: 'cheque', child: Text('Cheque')),
                        ],
                        onChanged: (v) => setDialogState(() => paymentMethod = v!),
                      ),
                    ],
                  ),
                  AppSpacing.vMd,
                  AppTextField(
                    controller: remarksCtrl,
                    label: 'Remarks',
                    hint: 'Optional remarks or transaction ID',
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
                        text: 'Print Receipt',
                        variant: AppButtonVariant.outline,
                        icon: Icons.print_outlined,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Printing receipt for ${record['studentName']}...')),
                          );
                        },
                      ),
                      AppSpacing.hSm,
                      AppButton(
                        text: 'Collect Payment',
                        onPressed: () {
                          final collected = int.tryParse(amountCtrl.text.trim()) ?? 0;
                          setState(() {
                            final prevDue = record['dueAmount'] as int;
                            final newDue = (prevDue - collected).clamp(0, record['totalAmount'] as int);
                            final prevPaid = record['paidAmount'] as int;
                            record['paidAmount'] = prevPaid + collected;
                            record['dueAmount'] = newDue;
                            record['status'] = newDue == 0 ? 'paid' : 'partial';
                          });
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Payment of ₹$collected collected!'), backgroundColor: AppColors.success),
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

    final filteredRecords = _feeRecordsData.where((r) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (r['studentName'] as String).toLowerCase();
      final roll = (r['rollNo'] as String).toLowerCase();
      final course = (r['course'] as String).toLowerCase();
      final feeType = (r['feeType'] as String).toLowerCase();
      return name.contains(q) || roll.contains(q) || course.contains(q) || feeType.contains(q);
    }).toList();

    final totalCollected = _feeRecordsData.fold<int>(0, (sum, r) => sum + (r['paidAmount'] as int));
    final totalPending = _feeRecordsData.fold<int>(0, (sum, r) => sum + (r['dueAmount'] as int));
    final paidCount = _feeRecordsData.where((r) => r['status'] == 'paid').length;
    final dueCount = _feeRecordsData.where((r) => r['status'] == 'due').length;

    // Stats Cards
    final card1 = OrgStatsCard(
      title: 'Total Collected',
      value: '₹${(totalCollected / 100000).toStringAsFixed(1)}L',
      subtitle: 'This session',
      icon: Icons.credit_card_rounded,
      variant: OrgStatsCardVariant.success,
    );
    final card2 = OrgStatsCard(
      title: 'Pending Amount',
      value: '₹${(totalPending / 100000).toStringAsFixed(1)}L',
      subtitle: '${dueCount + _feeRecordsData.where((r) => r['status'] == 'partial').length} students',
      icon: Icons.error_outline_rounded,
      variant: OrgStatsCardVariant.warning,
    );
    final card3 = OrgStatsCard(
      title: 'Fully Paid',
      value: paidCount.toString(),
      subtitle: 'Students with no dues',
      icon: Icons.check_circle_outline_rounded,
      variant: OrgStatsCardVariant.primary,
    );
    final card4 = OrgStatsCard(
      title: 'Overdue',
      value: dueCount.toString(),
      subtitle: 'Requires follow-up',
      icon: Icons.receipt_long_rounded,
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

          // Fee Records Table Card (Full Width)
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
                        'Fee Records',
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
                              hintText: 'Search by student name, roll no, course...',
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
                            _buildDataColumn('FEE TYPE', isDark),
                            _buildDataColumn('TOTAL', isDark),
                            _buildDataColumn('PAID', isDark),
                            _buildDataColumn('DUE', isDark),
                            _buildDataColumn('DUE DATE', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredRecords.map((record) {
                            final name = record['studentName'] as String;
                            final rollNo = record['rollNo'] as String;
                            final course = record['course'] as String;
                            final feeType = record['feeType'] as String;
                            final total = record['totalAmount'] as int;
                            final paid = record['paidAmount'] as int;
                            final due = record['dueAmount'] as int;
                            final dueDate = record['dueDate'] as String;
                            final status = record['status'] as String;

                            AppBadgeStatus badgeStatus;
                            switch (status) {
                              case 'paid':
                                badgeStatus = AppBadgeStatus.completed;
                                break;
                              case 'partial':
                                badgeStatus = AppBadgeStatus.warning;
                                break;
                              default:
                                badgeStatus = AppBadgeStatus.danger;
                            }

                            return DataRow(
                              cells: [
                                // Student
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: AppColors.primary.withAlpha(25),
                                        child: Text(
                                          name.substring(0, 1),
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13),
                                        ),
                                      ),
                                      AppSpacing.hSm,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                          Text(
                                            rollNo,
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

                                // Course
                                DataCell(Text(course, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500))),

                                // Fee Type
                                DataCell(Text(feeType, style: AppTypography.bodySmall)),

                                // Total
                                DataCell(
                                  Text(
                                    '₹${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),

                                // Paid
                                DataCell(
                                  Text(
                                    '₹${paid.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.success),
                                  ),
                                ),

                                // Due
                                DataCell(
                                  Text(
                                    '₹${due.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                    style: AppTypography.bodySmall.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: due > 0 ? AppColors.error : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                    ),
                                  ),
                                ),

                                // Due Date
                                DataCell(Text(dueDate, style: AppTypography.bodySmall)),

                                // Status
                                DataCell(AppStatusBadge(status: badgeStatus, customLabel: status)),

                                // Actions
                                DataCell(
                                  PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_horiz_rounded,
                                      size: 18,
                                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                    ),
                                    onSelected: (action) {
                                      if (action == 'collect') _showCollectPaymentDialog(record);
                                      if (action == 'history') {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment history for $name...')));
                                      }
                                      if (action == 'receipt') {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Printing receipt for $name...')));
                                      }
                                      if (action == 'remind') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Reminder sent to $name.'), backgroundColor: AppColors.info),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'collect',
                                        child: Row(children: [Icon(Icons.payment_rounded, size: 16), SizedBox(width: 8), Text('Collect Payment')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'history',
                                        child: Row(children: [Icon(Icons.history_rounded, size: 16), SizedBox(width: 8), Text('View History')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'receipt',
                                        child: Row(children: [Icon(Icons.print_outlined, size: 16), SizedBox(width: 8), Text('Print Receipt')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'remind',
                                        child: Row(children: [Icon(Icons.notifications_active_outlined, size: 16), SizedBox(width: 8), Text('Send Reminder')]),
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
              'Fee Collection',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Fee Collection',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Manage student fee payments and collections',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'New Collection',
      icon: Icons.add_rounded,
      onPressed: () {
        if (_feeRecordsData.isNotEmpty) {
          _showCollectPaymentDialog(_feeRecordsData.first);
        }
      },
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
