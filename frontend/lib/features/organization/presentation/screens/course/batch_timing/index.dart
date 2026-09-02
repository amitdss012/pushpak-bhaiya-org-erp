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

class BatchTimingScreen extends StatefulWidget {
  const BatchTimingScreen({super.key});

  @override
  State<BatchTimingScreen> createState() => _BatchTimingScreenState();
}

class _BatchTimingScreenState extends State<BatchTimingScreen> {
  String _selectedBranch = 'main';
  String _selectedBatch = 'CS-2024-A';

  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  final List<Map<String, String>> _timeSlots = [
    {'start': '09:00', 'end': '10:30'},
    {'start': '10:45', 'end': '12:15'},
    {'start': '13:00', 'end': '14:30'},
    {'start': '14:45', 'end': '16:15'},
    {'start': '16:30', 'end': '18:00'},
  ];

  final List<Map<String, dynamic>> _timingData = [
    {'id': '1', 'batch': 'CS-2024-A', 'course': 'Computer Science', 'day': 'Monday', 'startTime': '09:00', 'endTime': '10:30', 'subject': 'Data Structures', 'instructor': 'Dr. Smith', 'room': 'Lab 101'},
    {'id': '2', 'batch': 'CS-2024-A', 'course': 'Computer Science', 'day': 'Monday', 'startTime': '10:45', 'endTime': '12:15', 'subject': 'Algorithms', 'instructor': 'Prof. Johnson', 'room': 'Room 202'},
    {'id': '3', 'batch': 'CS-2024-A', 'course': 'Computer Science', 'day': 'Tuesday', 'startTime': '09:00', 'endTime': '10:30', 'subject': 'Database Systems', 'instructor': 'Dr. Patel', 'room': 'Lab 102'},
    {'id': '4', 'batch': 'CS-2024-A', 'course': 'Computer Science', 'day': 'Tuesday', 'startTime': '10:45', 'endTime': '12:15', 'subject': 'Web Development', 'instructor': 'Prof. Kumar', 'room': 'Lab 103'},
    {'id': '5', 'batch': 'CS-2024-A', 'course': 'Computer Science', 'day': 'Wednesday', 'startTime': '09:00', 'endTime': '10:30', 'subject': 'Operating Systems', 'instructor': 'Dr. Smith', 'room': 'Room 201'},
    {'id': '6', 'batch': 'CS-2024-A', 'course': 'Computer Science', 'day': 'Wednesday', 'startTime': '10:45', 'endTime': '12:15', 'subject': 'Computer Networks', 'instructor': 'Prof. Johnson', 'room': 'Room 203'},
    {'id': '7', 'batch': 'CS-2024-A', 'course': 'Computer Science', 'day': 'Thursday', 'startTime': '09:00', 'endTime': '10:30', 'subject': 'Data Structures Lab', 'instructor': 'Dr. Smith', 'room': 'Lab 101'},
    {'id': '8', 'batch': 'CS-2024-A', 'course': 'Computer Science', 'day': 'Friday', 'startTime': '09:00', 'endTime': '10:30', 'subject': 'Project Work', 'instructor': 'Dr. Patel', 'room': 'Lab 104'},
  ];

  Map<String, dynamic>? _getSlotForDayTime(String day, String start, String end) {
    for (final slot in _timingData) {
      if (slot['batch'] == _selectedBatch && slot['day'] == day && slot['startTime'] == start && slot['endTime'] == end) {
        return slot;
      }
    }
    return null;
  }

  void _showAddTimeSlotDialog() {
    final isDark = context.isDarkMode;
    final startTimeController = TextEditingController(text: '09:00');
    final endTimeController = TextEditingController(text: '10:30');

    String selectedDay = 'Monday';
    String selectedSubject = 'Data Structures';
    String selectedInstructor = 'Dr. Smith';
    String selectedRoom = 'Lab 101';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
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
                          'Add Time Slot',
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

                    // Day & Subject
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Day *',
                                style: AppTypography.labelMedium.copyWith(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: selectedDay,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: _days.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                                onChanged: (v) => setDialogState(() => selectedDay = v!),
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
                                'Subject *',
                                style: AppTypography.labelMedium.copyWith(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: selectedSubject,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'Data Structures', child: Text('Data Structures')),
                                  DropdownMenuItem(value: 'Algorithms', child: Text('Algorithms')),
                                  DropdownMenuItem(value: 'Database Systems', child: Text('Database Systems')),
                                  DropdownMenuItem(value: 'Web Development', child: Text('Web Development')),
                                  DropdownMenuItem(value: 'Operating Systems', child: Text('Operating Systems')),
                                ],
                                onChanged: (v) => setDialogState(() => selectedSubject = v!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,

                    // Start & End Time
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: startTimeController,
                            label: 'Start Time *',
                            hint: 'HH:MM (e.g. 09:00)',
                            suffixIcon: const Icon(Icons.access_time_rounded, size: 18),
                          ),
                        ),
                        AppSpacing.hMd,
                        Expanded(
                          child: AppTextField(
                            controller: endTimeController,
                            label: 'End Time *',
                            hint: 'HH:MM (e.g. 10:30)',
                            suffixIcon: const Icon(Icons.access_time_rounded, size: 18),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,

                    // Instructor & Room
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Instructor *',
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
                                  DropdownMenuItem(value: 'Dr. Smith', child: Text('Dr. Smith')),
                                  DropdownMenuItem(value: 'Prof. Johnson', child: Text('Prof. Johnson')),
                                  DropdownMenuItem(value: 'Dr. Patel', child: Text('Dr. Patel')),
                                  DropdownMenuItem(value: 'Prof. Kumar', child: Text('Prof. Kumar')),
                                ],
                                onChanged: (v) => setDialogState(() => selectedInstructor = v!),
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
                                'Room/Lab *',
                                style: AppTypography.labelMedium.copyWith(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: selectedRoom,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'Lab 101', child: Text('Lab 101')),
                                  DropdownMenuItem(value: 'Lab 102', child: Text('Lab 102')),
                                  DropdownMenuItem(value: 'Room 201', child: Text('Room 201')),
                                  DropdownMenuItem(value: 'Room 202', child: Text('Room 202')),
                                ],
                                onChanged: (v) => setDialogState(() => selectedRoom = v!),
                              ),
                            ],
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
                          text: 'Add Slot',
                          icon: Icons.check_rounded,
                          onPressed: () {
                            setState(() {
                              _timingData.add({
                                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                                'batch': _selectedBatch,
                                'course': 'Computer Science',
                                'day': selectedDay,
                                'startTime': startTimeController.text.trim(),
                                'endTime': endTimeController.text.trim(),
                                'subject': selectedSubject,
                                'instructor': selectedInstructor,
                                'room': selectedRoom,
                              });
                            });
                            Navigator.of(ctx).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Time slot added successfully!'),
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

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;

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

          // Filter Controls Card
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Branch',
                        style: AppTypography.labelMedium.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: _selectedBranch,
                        isExpanded: true,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: 'main', child: Text('Main Branch')),
                          DropdownMenuItem(value: 'north', child: Text('North Campus')),
                          DropdownMenuItem(value: 'south', child: Text('South Campus')),
                          DropdownMenuItem(value: 'east', child: Text('East Campus')),
                        ],
                        onChanged: (v) => setState(() => _selectedBranch = v!),
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
                        'Select Batch',
                        style: AppTypography.labelMedium.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AppSpacing.vXs,
                      DropdownButtonFormField<String>(
                        initialValue: _selectedBatch,
                        isExpanded: true,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: 'CS-2024-A', child: Text('CS-2024-A (Computer Science)')),
                          DropdownMenuItem(value: 'CS-2024-B', child: Text('CS-2024-B (Computer Science)')),
                          DropdownMenuItem(value: 'COM-2024-A', child: Text('COM-2024-A (Commerce)')),
                          DropdownMenuItem(value: 'ENG-2024-A', child: Text('ENG-2024-A (Engineering)')),
                        ],
                        onChanged: (v) => setState(() => _selectedBatch = v!),
                      ),
                    ],
                  ),
                ),
                AppSpacing.hMd,
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: AppButton(
                    text: 'Export Schedule',
                    icon: Icons.calendar_month_rounded,
                    variant: AppButtonVariant.outline,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Exporting schedule timetable...')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.vLg,

          // Weekly Timetable Matrix Card (Full Width)
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 20, color: AppColors.primary),
                      AppSpacing.hSm,
                      Text(
                        'Weekly Timetable - $_selectedBatch',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
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
                        child: Table(
                          border: TableBorder.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            width: 1,
                          ),
                          defaultColumnWidth: const IntrinsicColumnWidth(),
                          columnWidths: {
                            0: const FixedColumnWidth(140),
                            for (int i = 1; i <= _days.length; i++) i: const FlexColumnWidth(1),
                          },
                          children: [
                            // Table Header Row
                            TableRow(
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.backgroundDark.withAlpha(120) : AppColors.backgroundLight,
                              ),
                              children: [
                                _buildTableHeaderCell('TIME', isDark),
                                ..._days.map((d) => _buildTableHeaderCell(d.toUpperCase(), isDark)),
                              ],
                            ),

                            // Table Content Rows
                            ..._timeSlots.map((slot) {
                              final start = slot['start']!;
                              final end = slot['end']!;

                              return TableRow(
                                children: [
                                  // Time Slot Cell
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Container(
                                      color: isDark ? AppColors.backgroundDark.withAlpha(60) : AppColors.backgroundLight.withAlpha(80),
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            start,
                                            style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            'to $end',
                                            style: AppTypography.bodySmall.copyWith(
                                              fontSize: 10.5,
                                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Day Cells
                                  ..._days.map((day) {
                                    final item = _getSlotForDayTime(day, start, end);
                                    return TableCell(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        constraints: const BoxConstraints(minHeight: 80, minWidth: 150),
                                        child: item != null
                                            ? Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary.withAlpha(isDark ? 35 : 15),
                                                  borderRadius: AppRadius.sm,
                                                  border: Border.all(color: AppColors.primary.withAlpha(60)),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item['subject'] as String,
                                                      style: AppTypography.bodySmall.copyWith(
                                                        fontWeight: FontWeight.w700,
                                                        color: AppColors.primary,
                                                      ),
                                                    ),
                                                    AppSpacing.vXs,
                                                    Text(
                                                      item['instructor'] as String,
                                                      style: AppTypography.bodySmall.copyWith(
                                                        fontSize: 11,
                                                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                                      ),
                                                    ),
                                                    AppSpacing.vXs,
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                                                        borderRadius: AppRadius.full,
                                                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                                      ),
                                                      child: Text(
                                                        item['room'] as String,
                                                        style: AppTypography.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.w600),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Center(
                                                child: Text(
                                                  '—',
                                                  style: TextStyle(
                                                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    );
                                  }),
                                ],
                              );
                            }),
                          ],
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

  Widget _buildTableHeaderCell(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        title,
        style: AppTypography.labelMedium.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
        ),
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
              'Batch Timing',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Batch Timing',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Manage batch schedules and timetables',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'Add Time Slot',
      icon: Icons.add_rounded,
      onPressed: _showAddTimeSlotDialog,
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
