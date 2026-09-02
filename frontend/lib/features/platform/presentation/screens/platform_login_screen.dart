import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

class PlatformLoginScreen extends StatefulWidget {
  const PlatformLoginScreen({super.key});

  @override
  State<PlatformLoginScreen> createState() => _PlatformLoginScreenState();
}

class _PlatformLoginScreenState extends State<PlatformLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate brief authentication network request
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    context.goNamed(RouteNames.platformDashboard);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: Row(
        children: [
          // Left Decorative / Platform Hero Panel (Desktop & UltraWide)
          if (context.isDesktop || context.isUltraWide)
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF030712), // Deep neutral
                      const Color(0xFF312E81).withAlpha(240), // Indigo 900
                      const Color(0xFF4C1D95).withAlpha(220), // Purple 900
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand Badge
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                            ),
                            borderRadius: AppRadius.sm,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8B5CF6).withAlpha(80),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.admin_panel_settings_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        AppSpacing.hSm,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppConstants.appName,
                              style: AppTypography.titleLarge.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Platform Owner Portal',
                              style: AppTypography.labelMedium.copyWith(
                                color: Colors.white.withAlpha(180),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Center Headline
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(25),
                            borderRadius: AppRadius.full,
                            border: Border.all(
                              color: Colors.white.withAlpha(40),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.shield_rounded,
                                size: 14,
                                color: Color(0xFFA78BFA),
                              ),
                              AppSpacing.hXs,
                              Text(
                                'Super-Admin Infrastructure Access',
                                style: AppTypography.labelMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.vMd,
                        Text(
                          'Centralized governance for all organizations and subscription plans.',
                          style: AppTypography.displayMedium.copyWith(
                            color: Colors.white,
                            height: 1.15,
                          ),
                        ),
                        AppSpacing.vMd,
                        Text(
                          'Oversee SaaS tenants, manage billing tiers, configure global RBAC permissions, and monitor system health.',
                          style: AppTypography.bodyLarge.copyWith(
                            color: Colors.white.withAlpha(200),
                          ),
                        ),
                      ],
                    ),

                    // Bottom info
                    Text(
                      '© ${AppConstants.currentYear} ${AppConstants.companyName}. Platform Operations.',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Right Form Panel
          Expanded(
            flex: 6,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.isMobile ? 24 : 48,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back to standard login button
                      TextButton.icon(
                        onPressed: () => context.goNamed(RouteNames.login),
                        icon: const Icon(Icons.arrow_back_rounded, size: 16),
                        label: const Text('Back to Organization Login'),
                        style: TextButton.styleFrom(
                          foregroundColor: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      AppSpacing.vLg,

                      // Header Badge & Title
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1).withAlpha(isDark ? 50 : 25),
                              borderRadius: AppRadius.sm,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.shield_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                          ),
                          AppSpacing.hSm,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: AppRadius.full,
                            ),
                            child: Text(
                              'Platform Owner',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.vSm,
                      Text(
                        'Platform Admin Sign In',
                        style: AppTypography.headlineLarge.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      AppSpacing.vXs,
                      Text(
                        'Enter your platform owner credentials to access the master control panel.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                      AppSpacing.vXl,

                      // Error banner if any
                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.error.withAlpha(isDark ? 30 : 20),
                            borderRadius: AppRadius.sm,
                            border: Border.all(
                              color: AppColors.error.withAlpha(100),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: AppColors.error,
                                size: 20,
                              ),
                              AppSpacing.hSm,
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isDark
                                        ? AppColors.errorLight
                                        : AppColors.error,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.vMd,
                      ],

                      // Login Form
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Email Input
                            AppTextField(
                              controller: _emailController,
                              label: 'Platform Admin Email',
                              hint: 'admin@platform.com',
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                size: 20,
                              ),
                              enabled: !_isLoading,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter your platform admin email.';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(val.trim())) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                            ),
                            AppSpacing.vMd,

                            // Password Input
                            AppTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hint: '••••••••',
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _handleSubmit(),
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                              enabled: !_isLoading,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please enter your password.';
                                }
                                if (val.length < 6) {
                                  return 'Password must be at least 6 characters.';
                                }
                                return null;
                              },
                            ),
                            AppSpacing.vSm,

                            // Remember Me & Security Notice
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: _rememberMe,
                                        onChanged: _isLoading
                                            ? null
                                            : (val) => setState(
                                                () => _rememberMe = val ?? false,
                                              ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    AppSpacing.hSm,
                                    GestureDetector(
                                      onTap: _isLoading
                                          ? null
                                          : () => setState(
                                              () => _rememberMe = !_rememberMe,
                                            ),
                                      child: Text(
                                        'Remember session',
                                        style: AppTypography.bodySmall.copyWith(
                                          color: isDark
                                              ? AppColors.textSecondaryDark
                                              : AppColors.textSecondaryLight,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Protected Area',
                                  style: AppTypography.labelMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            AppSpacing.vLg,

                            // Submit Button
                            AppButton(
                              text: 'Sign In to Platform Panel',
                              onPressed: _handleSubmit,
                              isLoading: _isLoading,
                              icon: Icons.login_rounded,
                              height: 48,
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.vXl,

                      // Footer security note
                      Center(
                        child: Text(
                          'Restricted access. All platform authentication attempts are logged and monitored.',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.textMutedLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
