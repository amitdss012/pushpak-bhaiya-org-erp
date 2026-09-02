import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/router/route_names.dart';
import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/app_card.dart';
import '../../../../../../shared/widgets/app_text_field.dart';

class LiveClassSetupScreen extends StatefulWidget {
  const LiveClassSetupScreen({super.key});

  @override
  State<LiveClassSetupScreen> createState() => _LiveClassSetupScreenState();
}

class _LiveClassSetupScreenState extends State<LiveClassSetupScreen> {
  final _titleController = TextEditingController();
  String _subject = 'cs';
  String _course = 'cs';
  String _batch = '2024-a';
  String _instructor = 'john';
  final _descriptionController = TextEditingController();

  final _dateController = TextEditingController(text: '2024-02-15');
  final _timeController = TextEditingController(text: '10:00 AM');
  String _duration = '60';
  String _platform = 'zoom';
  final _meetingLinkController = TextEditingController();
  final _meetingIdController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _waitingRoom = false;
  bool _muteOnEntry = true;
  bool _screenSharing = false;
  bool _recording = true;
  bool _chat = true;

  bool _emailNotify = true;
  bool _smsNotify = false;
  bool _pushNotify = true;
  String _reminderBefore = '30';

  bool _isRecurring = false;
  String _repeatFrequency = 'weekly';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _meetingLinkController.dispose();
    _meetingIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleReset() {
    setState(() {
      _titleController.clear();
      _subject = 'cs';
      _course = 'cs';
      _batch = '2024-a';
      _instructor = 'john';
      _descriptionController.clear();
      _dateController.text = '2024-02-15';
      _timeController.text = '10:00 AM';
      _duration = '60';
      _platform = 'zoom';
      _meetingLinkController.clear();
      _meetingIdController.clear();
      _passwordController.clear();
      _waitingRoom = false;
      _muteOnEntry = true;
      _screenSharing = false;
      _recording = true;
      _chat = true;
      _emailNotify = true;
      _smsNotify = false;
      _pushNotify = true;
      _reminderBefore = '30';
      _isRecurring = false;
      _repeatFrequency = 'weekly';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form reset to default values.')),
    );
  }

  void _handleScheduleClass() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a class title.'), backgroundColor: AppColors.warning),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Live class "${_titleController.text}" scheduled successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
    context.go(RouteNames.liveClassViewPath);
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
          _buildHeader(isDark),
          AppSpacing.vXl,

          // Main Layout
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildClassDetailsCard(isDark),
                      AppSpacing.vLg,
                      _buildScheduleCard(isDark),
                      AppSpacing.vLg,
                      _buildParticipantCard(isDark),
                    ],
                  ),
                ),
                AppSpacing.hLg,
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildNotificationsCard(isDark),
                      AppSpacing.vLg,
                      _buildRecurringCard(isDark),
                      AppSpacing.vLg,
                      _buildActionsCard(),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildClassDetailsCard(isDark),
                AppSpacing.vLg,
                _buildScheduleCard(isDark),
                AppSpacing.vLg,
                _buildParticipantCard(isDark),
                AppSpacing.vLg,
                _buildNotificationsCard(isDark),
                AppSpacing.vLg,
                _buildRecurringCard(isDark),
                AppSpacing.vLg,
                _buildActionsCard(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildClassDetailsCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.video_call_rounded, size: 20, color: AppColors.primary),
              AppSpacing.hSm,
              Text('Class Details', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          AppSpacing.vLg,
          Row(
            children: [
              Expanded(child: AppTextField(controller: _titleController, label: 'Class Title *', hint: 'e.g., Introduction to Algorithms')),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Subject *', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _subject,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'math', child: Text('Mathematics')),
                        DropdownMenuItem(value: 'physics', child: Text('Physics')),
                        DropdownMenuItem(value: 'chemistry', child: Text('Chemistry')),
                        DropdownMenuItem(value: 'cs', child: Text('Computer Science')),
                        DropdownMenuItem(value: 'english', child: Text('English')),
                      ],
                      onChanged: (v) => setState(() => _subject = v!),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Course *', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _course,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'cs', child: Text('Computer Science')),
                        DropdownMenuItem(value: 'science', child: Text('Science')),
                        DropdownMenuItem(value: 'commerce', child: Text('Commerce')),
                        DropdownMenuItem(value: 'arts', child: Text('Arts')),
                      ],
                      onChanged: (v) => setState(() => _course = v!),
                    ),
                  ],
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Batch *', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _batch,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: '2024-a', child: Text('2024-A')),
                        DropdownMenuItem(value: '2024-b', child: Text('2024-B')),
                        DropdownMenuItem(value: '2024-c', child: Text('2024-C')),
                      ],
                      onChanged: (v) => setState(() => _batch = v!),
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
              _buildFieldLabel('Instructor *', isDark),
              AppSpacing.vXs,
              DropdownButtonFormField<String>(
                initialValue: _instructor,
                isExpanded: true,
                decoration: const InputDecoration(),
                items: const [
                  DropdownMenuItem(value: 'john', child: Text('Dr. John Smith')),
                  DropdownMenuItem(value: 'sarah', child: Text('Prof. Sarah Johnson')),
                  DropdownMenuItem(value: 'michael', child: Text('Mr. Michael Brown')),
                  DropdownMenuItem(value: 'emily', child: Text('Ms. Emily Davis')),
                ],
                onChanged: (v) => setState(() => _instructor = v!),
              ),
            ],
          ),
          AppSpacing.vMd,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel('Class Description', isDark),
              AppSpacing.vXs,
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Enter class description and agenda...'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.settings_outlined, size: 20, color: AppColors.primary),
              AppSpacing.hSm,
              Text('Schedule & Platform', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          AppSpacing.vLg,
          Row(
            children: [
              Expanded(child: AppTextField(controller: _dateController, label: 'Date *', hint: 'YYYY-MM-DD', suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18))),
              AppSpacing.hMd,
              Expanded(child: AppTextField(controller: _timeController, label: 'Start Time *', hint: '10:00 AM', suffixIcon: const Icon(Icons.access_time_rounded, size: 18))),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Duration *', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _duration,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: '30', child: Text('30 minutes')),
                        DropdownMenuItem(value: '45', child: Text('45 minutes')),
                        DropdownMenuItem(value: '60', child: Text('1 hour')),
                        DropdownMenuItem(value: '90', child: Text('1.5 hours')),
                        DropdownMenuItem(value: '120', child: Text('2 hours')),
                      ],
                      onChanged: (v) => setState(() => _duration = v!),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Platform *', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _platform,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'zoom', child: Text('Zoom')),
                        DropdownMenuItem(value: 'google-meet', child: Text('Google Meet')),
                        DropdownMenuItem(value: 'teams', child: Text('Microsoft Teams')),
                        DropdownMenuItem(value: 'webex', child: Text('Cisco Webex')),
                        DropdownMenuItem(value: 'custom', child: Text('Custom Link')),
                      ],
                      onChanged: (v) => setState(() => _platform = v!),
                    ),
                  ],
                ),
              ),
              AppSpacing.hMd,
              Expanded(child: AppTextField(controller: _meetingLinkController, label: 'Meeting Link', hint: 'Auto-generated or paste custom link')),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(child: AppTextField(controller: _meetingIdController, label: 'Meeting ID', hint: 'Optional')),
              AppSpacing.hMd,
              Expanded(child: AppTextField(controller: _passwordController, label: 'Meeting Password', hint: 'Optional', obscureText: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people_outline_rounded, size: 20, color: AppColors.primary),
              AppSpacing.hSm,
              Text('Participant Settings', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          AppSpacing.vLg,
          _buildSwitchRow('Waiting Room', 'Admit participants manually', _waitingRoom, (v) => setState(() => _waitingRoom = v), isDark),
          const Divider(height: 1),
          _buildSwitchRow('Mute on Entry', 'Mute participants when they join', _muteOnEntry, (v) => setState(() => _muteOnEntry = v), isDark),
          const Divider(height: 1),
          _buildSwitchRow('Allow Screen Sharing', 'Participants can share their screen', _screenSharing, (v) => setState(() => _screenSharing = v), isDark),
          const Divider(height: 1),
          _buildSwitchRow('Enable Recording', 'Record the session automatically', _recording, (v) => setState(() => _recording = v), isDark),
          const Divider(height: 1),
          _buildSwitchRow('Enable Chat', 'Allow participants to chat', _chat, (v) => setState(() => _chat = v), isDark),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String title, String subtitle, bool value, ValueChanged<bool> onChanged, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications_none_rounded, size: 20, color: AppColors.primary),
              AppSpacing.hSm,
              Text('Notifications', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          AppSpacing.vLg,
          _buildCheckboxRow('Send email invitation', _emailNotify, (v) => setState(() => _emailNotify = v ?? false)),
          AppSpacing.vSm,
          _buildCheckboxRow('Send SMS reminder', _smsNotify, (v) => setState(() => _smsNotify = v ?? false)),
          AppSpacing.vSm,
          _buildCheckboxRow('Push notification', _pushNotify, (v) => setState(() => _pushNotify = v ?? false)),
          AppSpacing.vMd,
          _buildFieldLabel('Reminder Before', isDark),
          AppSpacing.vXs,
          DropdownButtonFormField<String>(
            initialValue: _reminderBefore,
            isExpanded: true,
            decoration: const InputDecoration(),
            items: const [
              DropdownMenuItem(value: '15', child: Text('15 minutes')),
              DropdownMenuItem(value: '30', child: Text('30 minutes')),
              DropdownMenuItem(value: '60', child: Text('1 hour')),
              DropdownMenuItem(value: '1440', child: Text('1 day')),
            ],
            onChanged: (v) => setState(() => _reminderBefore = v!),
          ),
        ],
      ),
    );
  }

  Widget _buildRecurringCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recurring Class', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vMd,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Make Recurring', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
              Switch(
                value: _isRecurring,
                onChanged: (v) => setState(() => _isRecurring = v),
                activeTrackColor: AppColors.primary,
              ),
            ],
          ),
          if (_isRecurring) ...[
            AppSpacing.vMd,
            _buildFieldLabel('Repeat', isDark),
            AppSpacing.vXs,
            DropdownButtonFormField<String>(
              initialValue: _repeatFrequency,
              isExpanded: true,
              decoration: const InputDecoration(),
              items: const [
                DropdownMenuItem(value: 'daily', child: Text('Daily')),
                DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                DropdownMenuItem(value: 'biweekly', child: Text('Bi-weekly')),
                DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
              ],
              onChanged: (v) => setState(() => _repeatFrequency = v!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckboxRow(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
        AppSpacing.hXs,
        Expanded(
          child: Text(label, style: AppTypography.bodySmall),
        ),
      ],
    );
  }

  Widget _buildActionsCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Actions', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vLg,
          AppButton(
            text: 'Schedule Class',
            icon: Icons.save_rounded,
            onPressed: _handleScheduleClass,
          ),
          AppSpacing.vMd,
          AppButton(
            text: 'Reset Form',
            icon: Icons.refresh_rounded,
            variant: AppButtonVariant.outline,
            onPressed: _handleReset,
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
              onTap: () => context.go(RouteNames.liveClassViewPath),
              child: Text(
                'Live Class',
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
              'Setup',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Live Class Setup',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Schedule and configure a new live class session',
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
}
