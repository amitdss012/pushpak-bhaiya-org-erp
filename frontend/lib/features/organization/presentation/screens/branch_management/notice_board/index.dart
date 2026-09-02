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

class BranchNoticeBoardScreen extends StatefulWidget {
  const BranchNoticeBoardScreen({super.key});

  @override
  State<BranchNoticeBoardScreen> createState() => _BranchNoticeBoardScreenState();
}

class _BranchNoticeBoardScreenState extends State<BranchNoticeBoardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _noticesData = [
    {
      'id': '1',
      'title': 'Annual Examination Schedule Released',
      'content': 'The annual examination schedule for all courses has been released. Please check the exam portal for detailed timetable.',
      'branch': 'All Branches',
      'priority': 'high',
      'date': '2024-01-15',
      'expiryDate': '2024-02-15',
      'isPinned': true,
      'views': 1250,
      'type': 'branch',
    },
    {
      'id': '2',
      'title': 'Fee Payment Deadline Extended',
      'content': 'The last date for fee payment has been extended to January 31st. Late fee will be applicable after this date.',
      'branch': 'Main Campus',
      'priority': 'high',
      'date': '2024-01-14',
      'expiryDate': '2024-01-31',
      'isPinned': true,
      'views': 890,
      'type': 'branch',
    },
    {
      'id': '3',
      'title': 'Republic Day Celebration',
      'content': 'All students and staff are invited to attend the Republic Day celebration on January 26th at 8:00 AM in the main auditorium.',
      'branch': 'All Branches',
      'priority': 'medium',
      'date': '2024-01-13',
      'expiryDate': '2024-01-26',
      'isPinned': false,
      'views': 560,
      'type': 'branch',
    },
    {
      'id': '4',
      'title': 'Library Timings Changed',
      'content': 'The library will remain open from 8:00 AM to 8:00 PM starting from February 1st.',
      'branch': 'North Campus',
      'priority': 'low',
      'date': '2024-01-12',
      'expiryDate': '2024-03-01',
      'isPinned': false,
      'views': 320,
      'type': 'branch',
    },
    {
      'id': '5',
      'title': 'Practical Lab Session - Batch A',
      'content': 'All students of Batch A are required to attend the practical lab session on Monday at 10:00 AM.',
      'branch': 'Main Campus',
      'batch': 'Batch A - Morning',
      'priority': 'high',
      'date': '2024-01-16',
      'expiryDate': '2024-01-20',
      'isPinned': true,
      'views': 180,
      'type': 'batch',
    },
    {
      'id': '6',
      'title': 'Project Submission Deadline - Batch B',
      'content': 'Final project submission for Batch B is due on January 25th. No extensions will be granted.',
      'branch': 'Main Campus',
      'batch': 'Batch B - Evening',
      'priority': 'high',
      'date': '2024-01-15',
      'expiryDate': '2024-01-25',
      'isPinned': false,
      'views': 145,
      'type': 'batch',
    },
    {
      'id': '7',
      'title': 'Extra Classes Scheduled - Batch C',
      'content': 'Extra doubt clearing classes scheduled for Batch C on weekends.',
      'branch': 'North Campus',
      'batch': 'Batch C - Weekend',
      'priority': 'medium',
      'date': '2024-01-14',
      'expiryDate': '2024-02-28',
      'isPinned': false,
      'views': 95,
      'type': 'batch',
    },
  ];

  static const List<String> _batches = [
    'All Batches',
    'Batch A - Morning',
    'Batch B - Evening',
    'Batch C - Weekend',
    'Batch D - Online',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCreateNoticeDialog() {
    final isDark = context.isDarkMode;
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final publishDateController = TextEditingController(text: '2024-01-16');
    final expiryDateController = TextEditingController(text: '2024-02-16');
    String selectedType = 'branch';
    String selectedTarget = 'All Branches';
    String selectedPriority = 'high';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Create New Notice',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextField(
                              controller: titleController,
                              label: 'Notice Title *',
                              hint: 'Enter notice title',
                              validator: (v) => v == null || v.trim().isEmpty ? 'Title required.' : null,
                            ),
                            AppSpacing.vMd,
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Notice Type', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                                      AppSpacing.vXs,
                                      DropdownButtonFormField<String>(
                                        initialValue: selectedType,
                                        decoration: const InputDecoration(),
                                        items: const [
                                          DropdownMenuItem(value: 'branch', child: Text('Branch Notice')),
                                          DropdownMenuItem(value: 'batch', child: Text('Batch Notice')),
                                        ],
                                        onChanged: (v) {
                                          setDialogState(() {
                                            selectedType = v ?? 'branch';
                                            selectedTarget = selectedType == 'branch' ? 'All Branches' : 'Batch A - Morning';
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                AppSpacing.hMd,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Target ${selectedType == 'branch' ? 'Branch' : 'Batch'}', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                                      AppSpacing.vXs,
                                      DropdownButtonFormField<String>(
                                        initialValue: selectedTarget,
                                        decoration: const InputDecoration(),
                                        items: selectedType == 'branch'
                                            ? const [
                                                DropdownMenuItem(value: 'All Branches', child: Text('All Branches')),
                                                DropdownMenuItem(value: 'Main Campus', child: Text('Main Campus')),
                                                DropdownMenuItem(value: 'North Campus', child: Text('North Campus')),
                                                DropdownMenuItem(value: 'South Campus', child: Text('South Campus')),
                                              ]
                                            : _batches.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                                        onChanged: (v) => setDialogState(() => selectedTarget = v ?? 'All Branches'),
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
                                Text('Priority', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                                AppSpacing.vXs,
                                DropdownButtonFormField<String>(
                                  initialValue: selectedPriority,
                                  decoration: const InputDecoration(),
                                  items: const [
                                    DropdownMenuItem(value: 'high', child: Text('High Priority')),
                                    DropdownMenuItem(value: 'medium', child: Text('Medium Priority')),
                                    DropdownMenuItem(value: 'low', child: Text('Low Priority')),
                                  ],
                                  onChanged: (v) => setDialogState(() => selectedPriority = v ?? 'high'),
                                ),
                              ],
                            ),
                            AppSpacing.vMd,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Notice Content *', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                                AppSpacing.vXs,
                                TextFormField(
                                  controller: contentController,
                                  maxLines: 4,
                                  validator: (v) => v == null || v.trim().isEmpty ? 'Content required.' : null,
                                  decoration: const InputDecoration(hintText: 'Enter notice content...'),
                                ),
                              ],
                            ),
                            AppSpacing.vMd,
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: publishDateController,
                                    label: 'Publish Date',
                                    hint: 'YYYY-MM-DD',
                                  ),
                                ),
                                AppSpacing.hMd,
                                Expanded(
                                  child: AppTextField(
                                    controller: expiryDateController,
                                    label: 'Expiry Date',
                                    hint: 'YYYY-MM-DD',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSpacing.vLg,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton(
                          text: 'Cancel',
                          variant: AppButtonVariant.outline,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        AppSpacing.hSm,
                        AppButton(
                          text: 'Publish Notice',
                          icon: Icons.send_rounded,
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;
                            setState(() {
                              _noticesData.insert(0, {
                                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                                'title': titleController.text.trim(),
                                'content': contentController.text.trim(),
                                'branch': selectedType == 'branch' ? selectedTarget : 'Main Campus',
                                if (selectedType == 'batch') 'batch': selectedTarget,
                                'priority': selectedPriority,
                                'date': publishDateController.text.trim(),
                                'expiryDate': expiryDateController.text.trim(),
                                'isPinned': false,
                                'views': 0,
                                'type': selectedType,
                              });
                            });
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Notice published successfully!'),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                              ),
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
      ),
    );
  }

  void _handleDelete(Map<String, dynamic> notice) {
    setState(() {
      _noticesData.removeWhere((n) => n['id'] == notice['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notice "${notice['title']}" deleted.'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _togglePin(Map<String, dynamic> notice) {
    setState(() {
      notice['isPinned'] = !(notice['isPinned'] as bool);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isTablet = context.isTablet;

    final branchNotices = _noticesData.where((n) => n['type'] == 'branch').toList();
    final batchNotices = _noticesData.where((n) => n['type'] == 'batch').toList();

    final pinnedCount = _noticesData.where((n) => n['isPinned'] as bool).length;
    final totalViews = _noticesData.fold<int>(0, (sum, n) => sum + (n['views'] as int));

    // Stats Cards
    final card1 = OrgStatsCard(
      title: 'Active Notices',
      value: _noticesData.length.toString(),
      subtitle: 'Published',
      icon: Icons.notifications_active_rounded,
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = OrgStatsCard(
      title: 'Pinned Notices',
      value: pinnedCount.toString(),
      subtitle: 'Top priority',
      icon: Icons.push_pin_rounded,
      variant: OrgStatsCardVariant.warning,
    );
    final card3 = const OrgStatsCard(
      title: 'Expiring Soon',
      value: '2',
      subtitle: 'Within 7 days',
      icon: Icons.schedule_rounded,
      variant: OrgStatsCardVariant.info,
    );
    final card4 = OrgStatsCard(
      title: 'Total Views',
      value: totalViews.toLocaleString(),
      subtitle: 'Across all notices',
      icon: Icons.visibility_rounded,
      variant: OrgStatsCardVariant.success,
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

          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
              borderRadius: AppRadius.md,
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              unselectedLabelColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.business_rounded, size: 16),
                      AppSpacing.hSm,
                      Text('Branch Notices (${branchNotices.length})'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.group_rounded, size: 16),
                      AppSpacing.hSm,
                      Text('Batch Notices (${batchNotices.length})'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.vLg,

          // Notice Cards List
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, child) {
              final activeList = _tabController.index == 0 ? branchNotices : batchNotices;
              if (activeList.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      'No notices available in this tab.',
                      style: AppTypography.bodyMedium.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    ),
                  ),
                );
              }

              return Column(
                children: activeList.map((notice) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildNoticeCard(notice, isDark),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeCard(Map<String, dynamic> notice, bool isDark) {
    final title = notice['title'] as String;
    final content = notice['content'] as String;
    final branch = notice['branch'] as String;
    final batch = notice['batch'] as String?;
    final priority = notice['priority'] as String;
    final date = notice['date'] as String;
    final expiryDate = notice['expiryDate'] as String;
    final isPinned = notice['isPinned'] as bool;
    final views = notice['views'] as int;

    AppBadgeStatus badgeStatus;
    switch (priority) {
      case 'high':
        badgeStatus = AppBadgeStatus.danger;
        break;
      case 'medium':
        badgeStatus = AppBadgeStatus.warning;
        break;
      default:
        badgeStatus = AppBadgeStatus.info;
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (isPinned) ...[
                      const Icon(Icons.push_pin_rounded, size: 16, color: AppColors.primary),
                      AppSpacing.hSm,
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.hSm,
              Wrap(
                spacing: 6,
                children: [
                  AppStatusBadge(status: badgeStatus, customLabel: '$priority priority'.toUpperCase()),
                  if (batch != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                        borderRadius: AppRadius.full,
                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      child: Text(batch, style: AppTypography.bodySmall.copyWith(fontSize: 10.5, fontWeight: FontWeight.w600)),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                      borderRadius: AppRadius.full,
                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                    child: Text(branch, style: AppTypography.bodySmall.copyWith(fontSize: 10.5, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.vMd,

          // Body Content
          Text(
            content,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              height: 1.5,
            ),
          ),
          AppSpacing.vLg,

          // Footer info & actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                spacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 13, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                      AppSpacing.hXs,
                      Text(
                        'Published: $date',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11.5,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Expires: $expiryDate',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11.5,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.visibility_outlined, size: 14, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                      AppSpacing.hXs,
                      Text(
                        '$views views',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11.5,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                      size: 18,
                      color: isPinned ? AppColors.primary : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    ),
                    tooltip: isPinned ? 'Unpin notice' : 'Pin notice',
                    onPressed: () => _togglePin(notice),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                    tooltip: 'Delete notice',
                    onPressed: () => _handleDelete(notice),
                  ),
                ],
              ),
            ],
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
              onTap: () => context.go(RouteNames.branchViewPath),
              child: Text(
                'Branch Management',
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
              'Notice Board',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Notice Board',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Manage and publish notices across branches',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'Create Notice',
      icon: Icons.add_rounded,
      onPressed: _showCreateNoticeDialog,
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
}

extension IntExt on int {
  String toLocaleString() {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
