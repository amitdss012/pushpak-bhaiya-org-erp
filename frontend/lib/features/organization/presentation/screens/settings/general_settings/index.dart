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

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // General tab controllers
  final _schoolNameController = TextEditingController(text: 'ABC International School');
  final _schoolCodeController = TextEditingController(text: 'ABC2024');
  final _emailController = TextEditingController(text: 'info@abcschool.edu');
  final _phoneController = TextEditingController(text: '+91 1234567890');
  final _addressController = TextEditingController(text: '123 Education Street, Knowledge City');
  final _cityController = TextEditingController(text: 'Mumbai');
  final _stateController = TextEditingController(text: 'Maharashtra');
  final _countryController = TextEditingController(text: 'India');

  String _academicYear = '2024';
  String _timezone = 'ist';
  String _currency = 'inr';
  String _dateFormat = 'dd-mm-yyyy';

  // Notifications tab switches
  bool _emailNotify = true;
  bool _smsAlerts = true;
  bool _pushNotify = true;
  bool _feeReminders = true;
  bool _examNotify = true;
  bool _attendanceAlerts = true;

  // Security tab
  bool _twoFactor = false;
  String _sessionTimeout = '30';
  bool _passwordPolicy = true;

  // Appearance tab
  String _selectedTheme = 'System';
  bool _compactMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _schoolNameController.dispose();
    _schoolCodeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _handleSaveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully!'), backgroundColor: AppColors.success),
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
          _buildHeader(isDark),
          AppSpacing.vXl,

          // Tabs Header
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceCardDark : AppColors.surfaceLight,
              borderRadius: AppRadius.md,
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: isMobile,
              tabAlignment: isMobile ? TabAlignment.start : TabAlignment.fill,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              tabs: const [
                Tab(icon: Icon(Icons.settings_outlined, size: 18), text: 'General'),
                Tab(icon: Icon(Icons.notifications_none_rounded, size: 18), text: 'Notifications'),
                Tab(icon: Icon(Icons.security_rounded, size: 18), text: 'Security'),
                Tab(icon: Icon(Icons.palette_outlined, size: 18), text: 'Appearance'),
              ],
            ),
          ),
          AppSpacing.vLg,

          // Tab Views
          SizedBox(
            height: 750,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGeneralTab(isDark),
                _buildNotificationsTab(isDark),
                _buildSecurityTab(isDark),
                _buildAppearanceTab(isDark),
              ],
            ),
          ),

          AppSpacing.vLg,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                text: 'Save Changes',
                icon: Icons.save_rounded,
                onPressed: _handleSaveChanges,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralTab(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // School Info
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('School Information', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                AppSpacing.vLg,
                Row(
                  children: [
                    Expanded(child: AppTextField(controller: _schoolNameController, label: 'School Name', hint: 'ABC International School')),
                    AppSpacing.hMd,
                    Expanded(child: AppTextField(controller: _schoolCodeController, label: 'School Code', hint: 'ABC2024')),
                  ],
                ),
                AppSpacing.vMd,
                Row(
                  children: [
                    Expanded(child: AppTextField(controller: _emailController, label: 'Email', hint: 'info@abcschool.edu')),
                    AppSpacing.hMd,
                    Expanded(child: AppTextField(controller: _phoneController, label: 'Phone', hint: '+91 1234567890')),
                  ],
                ),
                AppSpacing.vMd,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Address', isDark),
                    AppSpacing.vXs,
                    TextFormField(
                      controller: _addressController,
                      maxLines: 2,
                      decoration: const InputDecoration(hintText: '123 Education Street, Knowledge City'),
                    ),
                  ],
                ),
                AppSpacing.vMd,
                Row(
                  children: [
                    Expanded(child: AppTextField(controller: _cityController, label: 'City', hint: 'Mumbai')),
                    AppSpacing.hMd,
                    Expanded(child: AppTextField(controller: _stateController, label: 'State', hint: 'Maharashtra')),
                    AppSpacing.hMd,
                    Expanded(child: AppTextField(controller: _countryController, label: 'Country', hint: 'India')),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.vLg,

          // Academic Settings
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Academic Settings', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                AppSpacing.vLg,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Current Academic Year', isDark),
                          AppSpacing.vXs,
                          DropdownButtonFormField<String>(
                            initialValue: _academicYear,
                            isExpanded: true,
                            decoration: const InputDecoration(),
                            items: const [
                              DropdownMenuItem(value: '2023', child: Text('2023-24')),
                              DropdownMenuItem(value: '2024', child: Text('2024-25')),
                              DropdownMenuItem(value: '2025', child: Text('2025-26')),
                            ],
                            onChanged: (v) => setState(() => _academicYear = v!),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.hMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Timezone', isDark),
                          AppSpacing.vXs,
                          DropdownButtonFormField<String>(
                            initialValue: _timezone,
                            isExpanded: true,
                            decoration: const InputDecoration(),
                            items: const [
                              DropdownMenuItem(value: 'ist', child: Text('IST (UTC+5:30)')),
                              DropdownMenuItem(value: 'utc', child: Text('UTC')),
                              DropdownMenuItem(value: 'pst', child: Text('PST (UTC-8)')),
                            ],
                            onChanged: (v) => setState(() => _timezone = v!),
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
                          _buildFieldLabel('Currency', isDark),
                          AppSpacing.vXs,
                          DropdownButtonFormField<String>(
                            initialValue: _currency,
                            isExpanded: true,
                            decoration: const InputDecoration(),
                            items: const [
                              DropdownMenuItem(value: 'inr', child: Text('INR (₹)')),
                              DropdownMenuItem(value: 'usd', child: Text('USD (\$)')),
                              DropdownMenuItem(value: 'eur', child: Text('EUR (€)')),
                            ],
                            onChanged: (v) => setState(() => _currency = v!),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.hMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Date Format', isDark),
                          AppSpacing.vXs,
                          DropdownButtonFormField<String>(
                            initialValue: _dateFormat,
                            isExpanded: true,
                            decoration: const InputDecoration(),
                            items: const [
                              DropdownMenuItem(value: 'dd-mm-yyyy', child: Text('DD-MM-YYYY')),
                              DropdownMenuItem(value: 'mm-dd-yyyy', child: Text('MM-DD-YYYY')),
                              DropdownMenuItem(value: 'yyyy-mm-dd', child: Text('YYYY-MM-DD')),
                            ],
                            onChanged: (v) => setState(() => _dateFormat = v!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab(bool isDark) {
    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notification Preferences', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.vLg,
            _buildSwitchTile('Email Notifications', 'Receive email notifications for important updates', _emailNotify, (v) => setState(() => _emailNotify = v), isDark),
            const Divider(height: 1),
            _buildSwitchTile('SMS Alerts', 'Get SMS alerts for fee reminders and announcements', _smsAlerts, (v) => setState(() => _smsAlerts = v), isDark),
            const Divider(height: 1),
            _buildSwitchTile('Push Notifications', 'Browser push notifications for real-time updates', _pushNotify, (v) => setState(() => _pushNotify = v), isDark),
            const Divider(height: 1),
            _buildSwitchTile('Fee Reminders', 'Automatic reminders for pending fee payments', _feeReminders, (v) => setState(() => _feeReminders = v), isDark),
            const Divider(height: 1),
            _buildSwitchTile('Exam Notifications', 'Alerts for upcoming exams and results', _examNotify, (v) => setState(() => _examNotify = v), isDark),
            const Divider(height: 1),
            _buildSwitchTile('Attendance Alerts', 'Notifications for low attendance', _attendanceAlerts, (v) => setState(() => _attendanceAlerts = v), isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityTab(bool isDark) {
    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Security Settings', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.vLg,
            _buildSwitchTile('Two-Factor Authentication', 'Add an extra layer of security', _twoFactor, (v) => setState(() => _twoFactor = v), isDark),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Session Timeout', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                      Text('Automatically log out after inactivity', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                    ],
                  ),
                  SizedBox(
                    width: 140,
                    child: DropdownButtonFormField<String>(
                      initialValue: _sessionTimeout,
                      isExpanded: true,
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                      items: const [
                        DropdownMenuItem(value: '15', child: Text('15 minutes')),
                        DropdownMenuItem(value: '30', child: Text('30 minutes')),
                        DropdownMenuItem(value: '60', child: Text('1 hour')),
                      ],
                      onChanged: (v) => setState(() => _sessionTimeout = v!),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            _buildSwitchTile('Password Policy', 'Require strong passwords with special characters & numbers', _passwordPolicy, (v) => setState(() => _passwordPolicy = v), isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceTab(bool isDark) {
    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appearance Settings', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.vLg,
            _buildFieldLabel('Theme', isDark),
            AppSpacing.vSm,
            Row(
              children: ['Light', 'Dark', 'System'].map((theme) {
                final isSelected = _selectedTheme == theme;
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: AppButton(
                      text: theme,
                      variant: isSelected ? AppButtonVariant.primary : AppButtonVariant.outline,
                      onPressed: () => setState(() => _selectedTheme = theme),
                    ),
                  ),
                );
              }).toList(),
            ),
            AppSpacing.vLg,
            _buildFieldLabel('Primary Color', isDark),
            AppSpacing.vSm,
            Row(
              children: [
                _buildColorCircle(const Color(0xFF3B82F6), true),
                _buildColorCircle(const Color(0xFF6366F1), false),
                _buildColorCircle(const Color(0xFFA855F7), false),
                _buildColorCircle(const Color(0xFF22C55E), false),
                _buildColorCircle(const Color(0xFFF97316), false),
              ],
            ),
            AppSpacing.vLg,
            const Divider(height: 1),
            _buildSwitchTile('Compact Mode', 'Reduce spacing for more screen content', _compactMode, (v) => setState(() => _compactMode = v), isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCircle(Color color, bool isSelected) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        boxShadow: isSelected ? [const BoxShadow(color: Colors.black26, blurRadius: 4)] : null,
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
          Switch(value: value, onChanged: onChanged, activeTrackColor: AppColors.primary),
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
              onTap: () => context.go(RouteNames.settingsGeneralPath),
              child: Text(
                'System Settings',
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
              'General Settings',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'General Settings',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Configure your school ERP system settings',
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
