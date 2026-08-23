import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/login_portal_type.dart';
import '../controllers/auth_controller.dart';
import 'login_portal_selector.dart';

class LoginForm extends StatefulWidget {
  final AuthController controller;
  final void Function(LoginPortalType portal)? onLoginSuccess;

  const LoginForm({super.key, required this.controller, this.onLoginSuccess});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  LoginPortalType _selectedPortal = LoginPortalType.organization;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await widget.controller.login(
      email: _emailController.text,
      password: _passwordController.text,
      rememberMe: _rememberMe,
    );

    if (success && mounted) {
      widget.onLoginSuccess?.call(_selectedPortal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final state = widget.controller.state;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 3 Portal Switcher Options (Organization, Branch, Student)
              LoginPortalSelector(
                selectedPortal: _selectedPortal,
                onPortalChanged: (portal) {
                  setState(() {
                    _selectedPortal = portal;
                  });
                },
              ),
              AppSpacing.vLg,

              // Error banner if any
              if (state.isError && state.errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withAlpha(isDark ? 30 : 20),
                    borderRadius: AppRadius.sm,
                    border: Border.all(color: AppColors.error.withAlpha(100)),
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
                          state.errorMessage!,
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

              // Email / Username Input
              AppTextField(
                controller: _emailController,
                label: '${_selectedPortal.title} Email / ID',
                hint: _selectedPortal.emailHint,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: Icon(_selectedPortal.icon, size: 20),
                enabled: !state.isLoading,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your ${_selectedPortal.title.toLowerCase()} email or ID.';
                  }
                  if (_selectedPortal == LoginPortalType.organization &&
                      !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
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
                prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                enabled: !state.isLoading,
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

              // Remember Me & Forgot Password Row
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
                          onChanged: state.isLoading
                              ? null
                              : (val) =>
                                    setState(() => _rememberMe = val ?? false),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      AppSpacing.hSm,
                      GestureDetector(
                        onTap: state.isLoading
                            ? null
                            : () => setState(() => _rememberMe = !_rememberMe),
                        child: Text(
                          'Remember me',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: state.isLoading ? null : () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forgot password?',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.vLg,

              // Login Button
              AppButton(
                text: 'Sign In to ${_selectedPortal.title}',
                onPressed: _handleSubmit,
                isLoading: state.isLoading,
                height: 48,
              ),
            ],
          ),
        );
      },
    );
  }
}
