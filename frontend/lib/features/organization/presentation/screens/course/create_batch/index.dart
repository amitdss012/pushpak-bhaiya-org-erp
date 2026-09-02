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

class CreateBatchScreen extends StatefulWidget {
  const CreateBatchScreen({super.key});

  @override
  State<CreateBatchScreen> createState() => _CreateBatchScreenState();
}

class _CreateBatchScreenState extends State<CreateBatchScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _batchesData = [
    {
      'id': '1',
      'name': 'CS-2024-A',
      'course': 'Computer Science',
      'branch': 'Main Campus',
      'startDate': '2024-01-15',
      'endDate': '2025-01-14',
      'capacity': 60,
      'enrolled': 45,
      'timing': 'Morning (8AM - 12PM)',
      'instructor': 'Dr. Smith',
      'status': 'active',
      'department': 'Science',
    },
    {
      'id': '2',
      'name': 'CS-2024-B',
      'course': 'Computer Science',
      'branch': 'North Campus',
      'startDate': '2024-01-15',
      'endDate': '2025-01-14',
      'capacity': 60,
      'enrolled': 58,
      'timing': 'Evening (4PM - 8PM)',
      'instructor': 'Prof. Johnson',
      'status': 'active',
      'department': 'Science',
    },
    {
      'id': '3',
      'name': 'COM-2024-A',
      'course': 'Commerce',
      'branch': 'South Campus',
      'startDate': '2024-02-01',
      'endDate': '2025-01-31',
      'capacity': 50,
      'enrolled': 32,
      'timing': 'Morning (8AM - 12PM)',
      'instructor': 'Dr. Patel',
      'status': 'upcoming',
      'department': 'Commerce',
    },
    {
      'id': '4',
      'name': 'ENG-2024-A',
      'course': 'Engineering',
      'branch': 'Main Campus',
      'startDate': '2024-03-01',
      'endDate': '2028-02-28',
      'capacity': 80,
      'enrolled': 0,
      'timing': 'Full Day',
      'instructor': 'Prof. Kumar',
      'status': 'upcoming',
      'department': 'Engineering',
    },
    {
      'id': '5',
      'name': 'CS-2023-A',
      'course': 'Computer Science',
      'branch': 'East Campus',
      'startDate': '2023-01-15',
      'endDate': '2024-01-14',
      'capacity': 60,
      'enrolled': 55,
      'timing': 'Morning (8AM - 12PM)',
      'instructor': 'Dr. Smith',
      'status': 'completed',
      'department': 'Science',
    },
  ];

  void _showNewBatchDialog() {
    final isDark = context.isDarkMode;
    final batchNameController = TextEditingController();
    final capacityController = TextEditingController(text: '60');
    final startDateController = TextEditingController(text: '2024-02-01');
    final endDateController = TextEditingController(text: '2025-01-31');
    final descController = TextEditingController();

    String selectedBranch = 'main';
    String selectedCourse = 'cs';
    String selectedDept = 'science';
    String selectedTiming = 'morning';
    String selectedInstructor = 'smith';

    final subjects = {
      'Mathematics': true,
      'Physics': true,
      'Chemistry': true,
      'Biology': false,
      'English': true,
      'CS': true,
    };

    bool active = true;
    bool allowEnrollment = true;

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
                          'Create New Batch',
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

                    // Batch Name & Branch
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: batchNameController,
                            label: 'Batch Name *',
                            hint: 'e.g., CS-2024-A',
                          ),
                        ),
                        AppSpacing.hMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Branch *',
                                style: AppTypography.labelMedium.copyWith(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: selectedBranch,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'main', child: Text('Main Branch')),
                                  DropdownMenuItem(value: 'north', child: Text('North Campus')),
                                  DropdownMenuItem(value: 'south', child: Text('South Campus')),
                                  DropdownMenuItem(value: 'east', child: Text('East Campus')),
                                ],
                                onChanged: (v) => setDialogState(() => selectedBranch = v!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,

                    // Course & Department
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Course *',
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
                                  DropdownMenuItem(value: 'cs', child: Text('Computer Science')),
                                  DropdownMenuItem(value: 'commerce', child: Text('Commerce')),
                                  DropdownMenuItem(value: 'engineering', child: Text('Engineering')),
                                  DropdownMenuItem(value: 'arts', child: Text('Arts')),
                                ],
                                onChanged: (v) => setDialogState(() => selectedCourse = v!),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.hMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Department *',
                                style: AppTypography.labelMedium.copyWith(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: selectedDept,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'science', child: Text('Science')),
                                  DropdownMenuItem(value: 'commerce', child: Text('Commerce')),
                                  DropdownMenuItem(value: 'arts', child: Text('Arts')),
                                  DropdownMenuItem(value: 'engineering', child: Text('Engineering')),
                                  DropdownMenuItem(value: 'medical', child: Text('Medical')),
                                ],
                                onChanged: (v) => setDialogState(() => selectedDept = v!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,

                    // Dates
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: startDateController,
                            label: 'Start Date *',
                            hint: 'YYYY-MM-DD',
                            suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                          ),
                        ),
                        AppSpacing.hMd,
                        Expanded(
                          child: AppTextField(
                            controller: endDateController,
                            label: 'End Date *',
                            hint: 'YYYY-MM-DD',
                            suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,

                    // Subjects
                    Text(
                      'Batch Subjects',
                      style: AppTypography.labelMedium.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppSpacing.vXs,
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight,
                        borderRadius: AppRadius.sm,
                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: subjects.keys.map((sub) {
                          return FilterChip(
                            selected: subjects[sub]!,
                            label: Text(sub, style: const TextStyle(fontSize: 12)),
                            onSelected: (val) => setDialogState(() => subjects[sub] = val),
                          );
                        }).toList(),
                      ),
                    ),
                    AppSpacing.vMd,

                    // Capacity, Timing, Instructor
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: capacityController,
                            label: 'Capacity *',
                            hint: 'e.g., 60',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        AppSpacing.hSm,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Timing',
                                style: AppTypography.labelMedium.copyWith(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: selectedTiming,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'morning', child: Text('Morning (8AM-12PM)')),
                                  DropdownMenuItem(value: 'afternoon', child: Text('Afternoon (12PM-4PM)')),
                                  DropdownMenuItem(value: 'evening', child: Text('Evening (4PM-8PM)')),
                                  DropdownMenuItem(value: 'fullday', child: Text('Full Day')),
                                ],
                                onChanged: (v) => setDialogState(() => selectedTiming = v!),
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
                                'Instructor',
                                style: AppTypography.labelMedium.copyWith(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: selectedInstructor,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'smith', child: Text('Dr. Smith')),
                                  DropdownMenuItem(value: 'johnson', child: Text('Prof. Johnson')),
                                  DropdownMenuItem(value: 'patel', child: Text('Dr. Patel')),
                                  DropdownMenuItem(value: 'kumar', child: Text('Prof. Kumar')),
                                ],
                                onChanged: (v) => setDialogState(() => selectedInstructor = v!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,

                    // Description
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: AppTypography.labelMedium.copyWith(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AppSpacing.vXs,
                        TextFormField(
                          controller: descController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            hintText: 'Brief description of the batch...',
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,

                    // Switches
                    Row(
                      children: [
                        Row(
                          children: [
                            Switch(
                              value: active,
                              onChanged: (v) => setDialogState(() => active = v),
                              activeTrackColor: AppColors.primary,
                            ),
                            AppSpacing.hXs,
                            const Text('Active', style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                        AppSpacing.hLg,
                        Row(
                          children: [
                            Switch(
                              value: allowEnrollment,
                              onChanged: (v) => setDialogState(() => allowEnrollment = v),
                              activeTrackColor: AppColors.primary,
                            ),
                            AppSpacing.hXs,
                            const Text('Allow Enrollment', style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
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
                          text: 'Create Batch',
                          icon: Icons.check_rounded,
                          onPressed: () {
                            if (batchNameController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter batch name.')),
                              );
                              return;
                            }
                            setState(() {
                              _batchesData.insert(0, {
                                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                                'name': batchNameController.text.trim(),
                                'course': selectedCourse == 'cs' ? 'Computer Science' : selectedCourse.toUpperCase(),
                                'branch': 'Main Branch',
                                'startDate': startDateController.text,
                                'endDate': endDateController.text,
                                'capacity': int.tryParse(capacityController.text) ?? 60,
                                'enrolled': 0,
                                'timing': selectedTiming == 'morning' ? 'Morning' : 'Evening',
                                'instructor': 'Dr. Smith',
                                'status': 'active',
                                'department': selectedDept,
                              });
                            });
                            Navigator.of(ctx).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Batch created successfully!'),
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

  void _showBatchDetails(Map<String, dynamic> batch) {
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
                      'Batch Details',
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
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(25),
                          borderRadius: AppRadius.sm,
                        ),
                        child: const Center(
                          child: Icon(Icons.groups_rounded, color: AppColors.primary),
                        ),
                      ),
                      AppSpacing.hMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              batch['name'] as String,
                              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '${batch['course']} • ${batch['branch']}',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.vLg,
                Row(
                  children: [
                    Expanded(child: _buildDetailField('Start Date', batch['startDate'] as String, isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildDetailField('End Date', batch['endDate'] as String, isDark)),
                  ],
                ),
                AppSpacing.vMd,
                Row(
                  children: [
                    Expanded(child: _buildDetailField('Enrolled / Capacity', '${batch['enrolled']} / ${batch['capacity']} students', isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildDetailField('Timing', batch['timing'] as String, isDark)),
                  ],
                ),
                AppSpacing.vMd,
                _buildDetailField('Instructor', batch['instructor'] as String, isDark),
                AppSpacing.vLg,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: 'Set Timetable',
                      variant: AppButtonVariant.outline,
                      icon: Icons.calendar_today_outlined,
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.go(RouteNames.courseBatchTimingPath);
                      },
                    ),
                    AppSpacing.hSm,
                    AppButton(
                      text: 'Assign Courses',
                      icon: Icons.link_rounded,
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.go(RouteNames.courseBatchAssignPath);
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

    final filteredBatches = _batchesData.where((b) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (b['name'] as String).toLowerCase();
      final course = (b['course'] as String).toLowerCase();
      final instructor = (b['instructor'] as String).toLowerCase();
      return name.contains(q) || course.contains(q) || instructor.contains(q);
    }).toList();

    final totalEnrolled = _batchesData.fold<int>(0, (sum, b) => sum + (b['enrolled'] as int));

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

          // 6 Mini Metric Cards Grid
          if (isDesktop)
            Row(
              children: [
                Expanded(child: _buildMetricCard('Total Batches', _batchesData.length.toString(), Icons.groups_rounded, AppColors.primary, isDark)),
                AppSpacing.hMd,
                Expanded(child: _buildMetricCard('Total Branches', '4', Icons.business_rounded, AppColors.info, isDark)),
                AppSpacing.hMd,
                Expanded(child: _buildMetricCard('Assigned Batches', '3', Icons.assignment_turned_in_outlined, AppColors.secondary, isDark)),
                AppSpacing.hMd,
                Expanded(child: _buildMetricCard('Active Batches', _batchesData.where((b) => b['status'] == 'active').length.toString(), Icons.access_time_rounded, AppColors.success, isDark)),
                AppSpacing.hMd,
                Expanded(child: _buildMetricCard('Upcoming', _batchesData.where((b) => b['status'] == 'upcoming').length.toString(), Icons.calendar_month_outlined, AppColors.warning, isDark)),
                AppSpacing.hMd,
                Expanded(child: _buildMetricCard('Total Enrolled', totalEnrolled.toString(), Icons.school_rounded, AppColors.primary, isDark)),
              ],
            )
          else if (isTablet)
            Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildMetricCard('Total Batches', _batchesData.length.toString(), Icons.groups_rounded, AppColors.primary, isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildMetricCard('Total Branches', '4', Icons.business_rounded, AppColors.info, isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildMetricCard('Assigned Batches', '3', Icons.assignment_turned_in_outlined, AppColors.secondary, isDark)),
                  ],
                ),
                AppSpacing.vMd,
                Row(
                  children: [
                    Expanded(child: _buildMetricCard('Active Batches', _batchesData.where((b) => b['status'] == 'active').length.toString(), Icons.access_time_rounded, AppColors.success, isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildMetricCard('Upcoming', _batchesData.where((b) => b['status'] == 'upcoming').length.toString(), Icons.calendar_month_outlined, AppColors.warning, isDark)),
                    AppSpacing.hMd,
                    Expanded(child: _buildMetricCard('Total Enrolled', totalEnrolled.toString(), Icons.school_rounded, AppColors.primary, isDark)),
                  ],
                ),
              ],
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildMetricCard('Total Batches', _batchesData.length.toString(), Icons.groups_rounded, AppColors.primary, isDark, width: 140),
                  AppSpacing.hMd,
                  _buildMetricCard('Total Branches', '4', Icons.business_rounded, AppColors.info, isDark, width: 140),
                  AppSpacing.hMd,
                  _buildMetricCard('Assigned Batches', '3', Icons.assignment_turned_in_outlined, AppColors.secondary, isDark, width: 140),
                  AppSpacing.hMd,
                  _buildMetricCard('Active Batches', _batchesData.where((b) => b['status'] == 'active').length.toString(), Icons.access_time_rounded, AppColors.success, isDark, width: 140),
                  AppSpacing.hMd,
                  _buildMetricCard('Upcoming', _batchesData.where((b) => b['status'] == 'upcoming').length.toString(), Icons.calendar_month_outlined, AppColors.warning, isDark, width: 140),
                  AppSpacing.hMd,
                  _buildMetricCard('Total Enrolled', totalEnrolled.toString(), Icons.school_rounded, AppColors.primary, isDark, width: 140),
                ],
              ),
            ),

          AppSpacing.vXl,

          // Batches Table Card (Full Width)
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
                        'Batches List',
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
                              hintText: 'Search batches...',
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
                            _buildDataColumn('BATCH', isDark),
                            _buildDataColumn('DURATION', isDark),
                            _buildDataColumn('TIMING', isDark),
                            _buildDataColumn('CAPACITY', isDark),
                            _buildDataColumn('INSTRUCTOR', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredBatches.map((batch) {
                            final name = batch['name'] as String;
                            final course = batch['course'] as String;
                            final startDate = batch['startDate'] as String;
                            final endDate = batch['endDate'] as String;
                            final timing = batch['timing'] as String;
                            final capacity = batch['capacity'] as int;
                            final enrolled = batch['enrolled'] as int;
                            final instructor = batch['instructor'] as String;
                            final status = batch['status'] as String;

                            final pct = capacity > 0 ? (enrolled / capacity).clamp(0.0, 1.0) : 0.0;

                            AppBadgeStatus badgeStatus;
                            switch (status) {
                              case 'active':
                                badgeStatus = AppBadgeStatus.active;
                                break;
                              case 'upcoming':
                                badgeStatus = AppBadgeStatus.warning;
                                break;
                              case 'completed':
                                badgeStatus = AppBadgeStatus.completed;
                                break;
                              default:
                                badgeStatus = AppBadgeStatus.info;
                            }

                            return DataRow(
                              cells: [
                                // Batch
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
                                          child: Icon(Icons.groups_rounded, size: 18, color: AppColors.primary),
                                        ),
                                      ),
                                      AppSpacing.hSm,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                          Text(
                                            course,
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

                                // Duration
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(startDate, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500)),
                                      Text(
                                        'to $endDate',
                                        style: AppTypography.bodySmall.copyWith(
                                          fontSize: 10.5,
                                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Timing
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                      borderRadius: AppRadius.full,
                                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                    ),
                                    child: Text(
                                      timing,
                                      style: AppTypography.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),

                                // Capacity with visual bar
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 120),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('$enrolled/$capacity', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                        AppSpacing.vXs,
                                        ClipRRect(
                                          borderRadius: AppRadius.full,
                                          child: LinearProgressIndicator(
                                            value: pct,
                                            minHeight: 5,
                                            backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Instructor
                                DataCell(Text(instructor, style: AppTypography.bodySmall)),

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
                                      if (action == 'view') _showBatchDetails(batch);
                                      if (action == 'edit') _showNewBatchDialog();
                                      if (action == 'students') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Managing students for $name...')),
                                        );
                                      }
                                      if (action == 'timetable') context.go(RouteNames.courseBatchTimingPath);
                                      if (action == 'delete') {
                                        setState(() => _batchesData.remove(batch));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Batch "$name" deleted.'),
                                            backgroundColor: AppColors.error,
                                          ),
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
                                        child: Row(children: [Icon(Icons.edit_outlined, size: 16), SizedBox(width: 8), Text('Edit Batch')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'students',
                                        child: Row(children: [Icon(Icons.people_outline, size: 16), SizedBox(width: 8), Text('Manage Students')]),
                                      ),
                                      PopupMenuItem(
                                        value: 'timetable',
                                        child: Row(children: [Icon(Icons.schedule_rounded, size: 16), SizedBox(width: 8), Text('Set Timetable')]),
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

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, bool isDark, {double? width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: AppRadius.sm,
            ),
            child: Center(
              child: Icon(icon, size: 20, color: color),
            ),
          ),
          AppSpacing.hSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800),
                ),
                Text(
                  title,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
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
              onTap: () => context.go(RouteNames.courseViewPath),
              child: Text(
                'Course Management',
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
              'Create Batch',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Create Batch',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Manage course batches and enrollments',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'New Batch',
      icon: Icons.add_rounded,
      onPressed: _showNewBatchDialog,
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
