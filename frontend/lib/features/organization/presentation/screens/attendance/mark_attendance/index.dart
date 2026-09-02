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

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  bool _isCameraActive = false;
  String? _punchInTime;
  String? _punchOutTime;
  String _attendanceStatus = 'none'; // 'none', 'present', 'completed'
  bool _hasCapturedPhoto = false;

  void _handlePunchIn() {
    setState(() => _isCameraActive = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final now = DateTime.now();
      final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      setState(() {
        _punchInTime = timeStr;
        _attendanceStatus = 'present';
        _isCameraActive = false;
        _hasCapturedPhoto = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Punch In Successful at $timeStr'),
          backgroundColor: AppColors.success,
        ),
      );
    });
  }

  void _handlePunchOut() {
    setState(() => _isCameraActive = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final now = DateTime.now();
      final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      setState(() {
        _punchOutTime = timeStr;
        _attendanceStatus = 'completed';
        _isCameraActive = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Punch Out Successful at $timeStr'),
          backgroundColor: AppColors.primary,
        ),
      );
    });
  }

  void _resetAttendance() {
    setState(() {
      _punchInTime = null;
      _punchOutTime = null;
      _attendanceStatus = 'none';
      _hasCapturedPhoto = false;
      _isCameraActive = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Attendance reset for demo')),
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

          // 2 Columns: Live Camera & Today's Attendance
          if (isMobile) ...[
            _buildCameraCard(isDark),
            AppSpacing.vLg,
            _buildAttendanceStatusCard(isDark),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildCameraCard(isDark)),
                AppSpacing.hXl,
                Expanded(child: _buildAttendanceStatusCard(isDark)),
              ],
            ),
          ],

          AppSpacing.vXl,

          // Instructions Card
          _buildInstructionsCard(isDark),
        ],
      ),
    );
  }

  Widget _buildCameraCard(bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.camera_alt_outlined, size: 20, color: AppColors.primary),
              AppSpacing.hSm,
              Text(
                'Live Camera Preview',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          AppSpacing.vMd,
          Container(
            height: 240,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
              borderRadius: AppRadius.md,
              border: Border.all(
                color: _isCameraActive ? AppColors.success : (isDark ? AppColors.borderDark : AppColors.borderLight),
                width: _isCameraActive ? 2 : 1,
              ),
            ),
            child: Center(
              child: _isCameraActive
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        ),
                        AppSpacing.vMd,
                        Text('Capturing photo...', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    )
                  : _hasCapturedPhoto
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(20),
                                borderRadius: AppRadius.md,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withAlpha(30),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check_circle_rounded, size: 48, color: AppColors.success),
                                  ),
                                  AppSpacing.vSm,
                                  Text(
                                    'Face Verified & Captured',
                                    style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.success),
                                  ),
                                  AppSpacing.vXs,
                                  Text(
                                    'Timestamp: ${_punchOutTime ?? _punchInTime ?? ''}',
                                    style: AppTypography.bodySmall.copyWith(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.videocam_outlined, size: 48, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                            AppSpacing.vSm,
                            Text(
                              'Camera ready for verification',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
            ),
          ),
          AppSpacing.vMd,
          Text(
            'Your photo and timestamp will be verified automatically when marking attendance',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceStatusCard(bool isDark) {
    Color statusBg;
    Color statusText;
    String statusLabel;

    if (_attendanceStatus == 'present') {
      statusBg = AppColors.warning.withAlpha(20);
      statusText = AppColors.warning;
      statusLabel = 'Present (Punched In)';
    } else if (_attendanceStatus == 'completed') {
      statusBg = AppColors.success.withAlpha(20);
      statusText = AppColors.success;
      statusLabel = 'Completed (Punched Out)';
    } else {
      statusBg = isDark ? AppColors.surfaceDark : AppColors.backgroundLight;
      statusText = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
      statusLabel = 'Not Marked';
    }

    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 20, color: AppColors.primary),
              AppSpacing.hSm,
              Text(
                "Today's Attendance",
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          AppSpacing.vLg,

          // Punch In Block
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Punch In', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              _punchInTime != null
                  ? Text(_punchInTime!, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: AppColors.success))
                  : Text('Not marked', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
            ],
          ),
          AppSpacing.vSm,
          AppButton(
            text: 'Punch In',
            icon: Icons.check_circle_outline_rounded,
            onPressed: (_attendanceStatus == 'none' && !_isCameraActive) ? _handlePunchIn : null,
            height: 44,
          ),

          AppSpacing.vLg,
          const Divider(height: 1),
          AppSpacing.vLg,

          // Punch Out Block
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Punch Out', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              _punchOutTime != null
                  ? Text(_punchOutTime!, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: AppColors.error))
                  : Text('Not marked', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
            ],
          ),
          AppSpacing.vSm,
          AppButton(
            text: 'Punch Out',
            icon: Icons.logout_rounded,
            variant: AppButtonVariant.outline,
            onPressed: (_attendanceStatus == 'present' && !_isCameraActive) ? _handlePunchOut : null,
            height: 44,
          ),

          AppSpacing.vLg,
          const Divider(height: 1),
          AppSpacing.vMd,

          // Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Status', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: statusText.withAlpha(60)),
                ),
                child: Text(
                  statusLabel,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: statusText,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          if (_punchInTime != null || _punchOutTime != null) ...[
            AppSpacing.vMd,
            Center(
              child: TextButton(
                onPressed: _resetAttendance,
                child: const Text('Reset Attendance (Demo)', style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInstructionsCard(bool isDark) {
    final instructions = [
      'Click "Punch In" when you arrive to mark your arrival time',
      'Your photo will be automatically captured using the camera',
      'Click "Punch Out" when leaving to mark your departure time',
      'Both punch in and punch out photos are recorded for verification',
      'Ensure you have proper lighting for clear photo capture',
    ];

    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Instructions', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vMd,
          ...instructions.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 10),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
              onTap: () => context.go(RouteNames.attendanceMarkPath),
              child: Text(
                'Attendance',
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
              'Mark Attendance',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Mark Attendance',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Mark your daily attendance with live camera photo',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
