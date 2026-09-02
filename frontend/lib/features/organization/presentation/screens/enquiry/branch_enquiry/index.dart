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

class BranchEnquiryScreen extends StatefulWidget {
  const BranchEnquiryScreen({super.key});

  @override
  State<BranchEnquiryScreen> createState() => _BranchEnquiryScreenState();
}

class _BranchEnquiryScreenState extends State<BranchEnquiryScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _enquiriesData = [
    {
      'id': '1',
      'date': '2024-01-15',
      'name': 'Rahul Sharma',
      'phone': '+91 98765 43210',
      'email': 'rahul@example.com',
      'course': 'Computer Science',
      'source': 'Walk-in',
      'assignedTo': 'John Doe',
      'followUpDate': '2024-01-18',
      'status': 'new',
      'priority': 'high',
      'notes': 'Looking for immediate batch admission in CS.',
    },
    {
      'id': '2',
      'date': '2024-01-15',
      'name': 'Priya Patel',
      'phone': '+91 87654 32109',
      'email': 'priya@example.com',
      'course': 'Commerce',
      'source': 'Website',
      'assignedTo': 'Jane Smith',
      'followUpDate': '2024-01-17',
      'status': 'contacted',
      'priority': 'medium',
      'notes': 'Requested fee details via email.',
    },
    {
      'id': '3',
      'date': '2024-01-14',
      'name': 'Amit Kumar',
      'phone': '+91 76543 21098',
      'email': 'amit@example.com',
      'course': 'Engineering',
      'source': 'Referral',
      'assignedTo': 'John Doe',
      'followUpDate': '2024-01-16',
      'status': 'interested',
      'priority': 'high',
      'notes': 'Visited campus with parents. Very interested.',
    },
    {
      'id': '4',
      'date': '2024-01-14',
      'name': 'Sneha Gupta',
      'phone': '+91 65432 10987',
      'email': 'sneha@example.com',
      'course': 'Medical',
      'source': 'Social Media',
      'assignedTo': 'Mike Johnson',
      'followUpDate': '2024-01-19',
      'status': 'converted',
      'priority': 'medium',
      'notes': 'Admission form submitted. Fee paid.',
    },
    {
      'id': '5',
      'date': '2024-01-13',
      'name': 'Vikram Singh',
      'phone': '+91 54321 09876',
      'email': 'vikram@example.com',
      'course': 'Arts',
      'source': 'Walk-in',
      'assignedTo': 'Jane Smith',
      'followUpDate': '2024-01-15',
      'status': 'closed',
      'priority': 'low',
      'notes': 'Relocated to another city.',
    },
  ];

  void _showNewEnquiryDialog() {
    final isDark = context.isDarkMode;
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final notesController = TextEditingController();

    String selectedCourse = 'Computer Science';
    String selectedSource = 'Walk-in';
    String selectedAssigned = 'John Doe';
    String selectedPriority = 'high';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add New Enquiry',
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

                    // Name & Phone
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: nameController,
                            label: 'Full Name *',
                            hint: 'Enter full name',
                          ),
                        ),
                        AppSpacing.hMd,
                        Expanded(
                          child: AppTextField(
                            controller: phoneController,
                            label: 'Phone Number *',
                            hint: '+91 XXXXX XXXXX',
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,

                    // Email & Course Interest
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: emailController,
                            label: 'Email Address',
                            hint: 'email@example.com',
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        AppSpacing.hMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Course Interest *',
                                style: AppTypography.labelMedium.copyWith(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: selectedCourse,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'Computer Science', child: Text('Computer Science')),
                                  DropdownMenuItem(value: 'Commerce', child: Text('Commerce')),
                                  DropdownMenuItem(value: 'Engineering', child: Text('Engineering')),
                                  DropdownMenuItem(value: 'Medical', child: Text('Medical')),
                                  DropdownMenuItem(value: 'Arts', child: Text('Arts')),
                                ],
                                onChanged: (v) => setDialogState(() => selectedCourse = v!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,

                    // Source, Assigned To, Priority
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Source',
                                style: AppTypography.labelMedium.copyWith(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: selectedSource,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'Walk-in', child: Text('Walk-in')),
                                  DropdownMenuItem(value: 'Phone Call', child: Text('Phone Call')),
                                  DropdownMenuItem(value: 'Referral', child: Text('Referral')),
                                  DropdownMenuItem(value: 'Website', child: Text('Website')),
                                  DropdownMenuItem(value: 'Social Media', child: Text('Social Media')),
                                ],
                                onChanged: (v) => setDialogState(() => selectedSource = v!),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.hSm,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assigned To',
                                style: AppTypography.labelMedium.copyWith(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: selectedAssigned,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'John Doe', child: Text('John Doe')),
                                  DropdownMenuItem(value: 'Jane Smith', child: Text('Jane Smith')),
                                  DropdownMenuItem(value: 'Mike Johnson', child: Text('Mike Johnson')),
                                ],
                                onChanged: (v) => setDialogState(() => selectedAssigned = v!),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.hSm,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Priority',
                                style: AppTypography.labelMedium.copyWith(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: selectedPriority,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'high', child: Text('High')),
                                  DropdownMenuItem(value: 'medium', child: Text('Medium')),
                                  DropdownMenuItem(value: 'low', child: Text('Low')),
                                ],
                                onChanged: (v) => setDialogState(() => selectedPriority = v!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,

                    // Notes
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notes',
                          style: AppTypography.labelMedium.copyWith(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AppSpacing.vXs,
                        TextFormField(
                          controller: notesController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Add any additional notes...',
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vLg,

                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton(
                          text: 'Cancel',
                          variant: AppButtonVariant.outline,
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                        AppSpacing.hMd,
                        AppButton(
                          text: 'Save Enquiry',
                          icon: Icons.check_rounded,
                          onPressed: () {
                            if (nameController.text.trim().isEmpty || phoneController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill required fields (Name and Phone).'),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                              return;
                            }
                            setState(() {
                              _enquiriesData.insert(0, {
                                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                                'date': '2024-01-15',
                                'name': nameController.text.trim(),
                                'phone': phoneController.text.trim(),
                                'email': emailController.text.trim(),
                                'course': selectedCourse,
                                'source': selectedSource,
                                'assignedTo': selectedAssigned,
                                'followUpDate': '2024-01-20',
                                'status': 'new',
                                'priority': selectedPriority,
                                'notes': notesController.text.trim(),
                              });
                            });
                            Navigator.of(ctx).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Enquiry saved successfully!'),
                                backgroundColor: AppColors.success,
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

  void _showEnquiryDetails(Map<String, dynamic> enquiry) {
    final isDark = context.isDarkMode;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
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
                      'Enquiry Details',
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
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primary.withAlpha(30),
                        child: Text(
                          (enquiry['name'] as String).substring(0, 2).toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              enquiry['name'] as String,
                              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '${enquiry['phone']} • ${enquiry['email']}',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildPriorityBadge(enquiry['priority'] as String, isDark),
                    ],
                  ),
                ),
                AppSpacing.vLg,
                Row(
                  children: [
                    Expanded(child: _buildDetailField('Course Interest', enquiry['course'] as String, isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildDetailField('Source', enquiry['source'] as String, isDark)),
                  ],
                ),
                AppSpacing.vMd,
                Row(
                  children: [
                    Expanded(child: _buildDetailField('Assigned To', enquiry['assignedTo'] as String, isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildDetailField('Follow-Up Date', enquiry['followUpDate'] as String, isDark)),
                  ],
                ),
                AppSpacing.vMd,
                _buildDetailField('Notes', (enquiry['notes'] as String?) ?? 'No notes available', isDark),
                AppSpacing.vLg,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: 'Add Follow-up',
                      variant: AppButtonVariant.outline,
                      icon: Icons.calendar_today_rounded,
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Follow-up scheduled for ${enquiry['name']}')),
                        );
                      },
                    ),
                    AppSpacing.hSm,
                    AppButton(
                      text: 'Convert to Admission',
                      icon: Icons.check_circle_outline_rounded,
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        setState(() => enquiry['status'] = 'converted');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${enquiry['name']} converted to admission!'),
                            backgroundColor: AppColors.success,
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
    );
  }

  Widget _buildDetailField(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelMedium.copyWith(
            fontSize: 10,
            letterSpacing: 0.5,
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            fontWeight: FontWeight.w700,
          ),
        ),
        AppSpacing.vXs,
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isTablet = context.isTablet;

    final filteredEnquiries = _enquiriesData.where((e) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (e['name'] as String).toLowerCase();
      final phone = (e['phone'] as String).toLowerCase();
      final course = (e['course'] as String).toLowerCase();
      final source = (e['source'] as String).toLowerCase();
      final assigned = (e['assignedTo'] as String).toLowerCase();
      return name.contains(q) || phone.contains(q) || course.contains(q) || source.contains(q) || assigned.contains(q);
    }).toList();

    // Stats Cards
    final card1 = OrgStatsCard(
      title: 'Total Enquiries',
      value: _enquiriesData.length.toString(),
      subtitle: 'This month',
      icon: Icons.chat_bubble_outline_rounded,
      trend: const OrgStatsCardTrend(value: 15, isPositive: true),
      variant: OrgStatsCardVariant.primary,
    );
    final card2 = OrgStatsCard(
      title: 'New Enquiries',
      value: _enquiriesData.where((e) => e['status'] == 'new').length.toString(),
      subtitle: 'Pending contact',
      icon: Icons.person_add_outlined,
      variant: OrgStatsCardVariant.info,
    );
    final card3 = const OrgStatsCard(
      title: 'Follow-ups Due',
      value: '2',
      subtitle: 'Today',
      icon: Icons.access_time_rounded,
      variant: OrgStatsCardVariant.warning,
    );
    final card4 = OrgStatsCard(
      title: 'Converted',
      value: _enquiriesData.where((e) => e['status'] == 'converted').length.toString(),
      subtitle: 'This month',
      icon: Icons.check_circle_outline_rounded,
      trend: const OrgStatsCardTrend(value: 25, isPositive: true),
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

          // Enquiries Data Table Card (Full Width)
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
                        'Enquiries List',
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
                              hintText: 'Search enquiries...',
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
                            _buildDataColumn('DATE', isDark),
                            _buildDataColumn('ENQUIRER', isDark),
                            _buildDataColumn('COURSE INTEREST', isDark),
                            _buildDataColumn('SOURCE', isDark),
                            _buildDataColumn('ASSIGNED TO', isDark),
                            _buildDataColumn('FOLLOW-UP', isDark),
                            _buildDataColumn('PRIORITY', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredEnquiries.map((enquiry) {
                            final date = enquiry['date'] as String;
                            final name = enquiry['name'] as String;
                            final phone = enquiry['phone'] as String;
                            final course = enquiry['course'] as String;
                            final source = enquiry['source'] as String;
                            final assigned = enquiry['assignedTo'] as String;
                            final followUp = enquiry['followUpDate'] as String;
                            final priority = enquiry['priority'] as String;
                            final status = enquiry['status'] as String;

                            AppBadgeStatus badgeStatus;
                            switch (status) {
                              case 'new':
                                badgeStatus = AppBadgeStatus.info;
                                break;
                              case 'contacted':
                                badgeStatus = AppBadgeStatus.pending;
                                break;
                              case 'interested':
                                badgeStatus = AppBadgeStatus.active;
                                break;
                              case 'converted':
                                badgeStatus = AppBadgeStatus.completed;
                                break;
                              default:
                                badgeStatus = AppBadgeStatus.info;
                            }

                            return DataRow(
                              cells: [
                                // Date
                                DataCell(Text(date, style: AppTypography.bodySmall)),

                                // Enquirer (Name + Phone with Icon)
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                      Row(
                                        children: [
                                          Icon(Icons.phone_outlined, size: 12, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                          AppSpacing.hXs,
                                          Text(
                                            phone,
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

                                // Course Interest
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                      borderRadius: AppRadius.full,
                                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                    ),
                                    child: Text(
                                      course,
                                      style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),

                                // Source
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withAlpha(20),
                                      borderRadius: AppRadius.full,
                                    ),
                                    child: Text(
                                      source,
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),

                                // Assigned To
                                DataCell(Text(assigned, style: AppTypography.bodySmall)),

                                // Follow-Up
                                DataCell(
                                  Text(
                                    followUp,
                                    style: AppTypography.bodySmall.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: followUp.compareTo('2024-01-16') <= 0 ? AppColors.error : null,
                                    ),
                                  ),
                                ),

                                // Priority
                                DataCell(_buildPriorityBadge(priority, isDark)),

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
                                      if (action == 'view') _showEnquiryDetails(enquiry);
                                      if (action == 'followup') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Adding follow-up for $name...')),
                                        );
                                      }
                                      if (action == 'convert') {
                                        setState(() => enquiry['status'] = 'converted');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('$name converted to admission!'),
                                            backgroundColor: AppColors.success,
                                          ),
                                        );
                                      }
                                      if (action == 'close') {
                                        setState(() => enquiry['status'] = 'closed');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Enquiry for $name marked as closed.')),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'view',
                                        child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text('View Details')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'followup',
                                        child: Row(children: [Icon(Icons.calendar_today_outlined, size: 16), SizedBox(width: 8), Text('Add Follow-up')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'convert',
                                        child: Row(children: [Icon(Icons.check_circle_outline_rounded, size: 16), SizedBox(width: 8), Text('Convert to Admission')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'close',
                                        child: Row(children: [Icon(Icons.close_rounded, size: 16, color: AppColors.error), SizedBox(width: 8), Text('Mark as Closed', style: TextStyle(color: AppColors.error))]),
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
              onTap: () => context.go(RouteNames.enquiryBranchPath),
              child: Text(
                'Enquiry Management',
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
              'Branch Enquiry',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Branch Enquiries',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Manage all walk-in and phone enquiries',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'New Enquiry',
      icon: Icons.add_rounded,
      onPressed: _showNewEnquiryDialog,
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

  Widget _buildPriorityBadge(String priority, bool isDark) {
    Color color;
    Color bg;
    switch (priority.toLowerCase()) {
      case 'high':
        color = AppColors.error;
        bg = AppColors.error.withAlpha(25);
        break;
      case 'medium':
        color = AppColors.primary;
        bg = AppColors.primary.withAlpha(25);
        break;
      default:
        color = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
        bg = isDark ? AppColors.surfaceDark : AppColors.backgroundLight;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.full,
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(
        priority.toUpperCase(),
        style: AppTypography.bodySmall.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: color,
        ),
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
