import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/login_portal_type.dart';
import '../../domain/usecases/login_usecase.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_header.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    final dataSource = MockAuthRemoteDataSource();
    final repository = AuthRepositoryImpl(remoteDataSource: dataSource);
    final loginUseCase = LoginUseCase(repository);
    _authController = AuthController(loginUseCase: loginUseCase);
  }

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
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
          // Left Decorative/Marketing Panel (Desktop & Tablet Large only)
          if (context.isDesktop || context.isUltraWide)
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0F172A),
                      AppColors.primaryDark.withAlpha(220),
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
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                            ),
                            borderRadius: AppRadius.sm,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.hub_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        AppSpacing.hSm,
                        Text(
                          AppConstants.appName,
                          style: AppTypography.titleLarge.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    // Center Headline
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(20),
                            borderRadius: AppRadius.full,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.verified_user_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                              AppSpacing.hXs,
                              Text(
                                'Enterprise Multi-Branch SaaS',
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
                          'One platform for your entire organization structure.',
                          style: AppTypography.displayMedium.copyWith(
                            color: Colors.white,
                            height: 1.15,
                          ),
                        ),
                        AppSpacing.vMd,
                        Text(
                          'Centralized control from the head organization panel down to branch-level operations, students, staff, and analytics.',
                          style: AppTypography.bodyLarge.copyWith(
                            color: Colors.white.withAlpha(200),
                          ),
                        ),
                      ],
                    ),

                    // Bottom info
                    Text(
                      '© ${AppConstants.currentYear} ${AppConstants.companyName}. All rights reserved.',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Right Form Panel (Universal & Responsive)
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
                      // Back to home button
                      TextButton.icon(
                        onPressed: () => context.goNamed(RouteNames.landing),
                        icon: const Icon(Icons.arrow_back_rounded, size: 16),
                        label: const Text('Back to Home'),
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

                      // Header
                      const AuthHeader(),
                      AppSpacing.vXl,

                      // Login Form
                      LoginForm(
                        controller: _authController,
                        onLoginSuccess: (portal) {
                          switch (portal) {
                            case LoginPortalType.organization:
                              context.goNamed(RouteNames.dashboard);
                              break;
                            case LoginPortalType.branch:
                              context.goNamed(RouteNames.branchDashboard);
                              break;
                            case LoginPortalType.student:
                              context.goNamed(RouteNames.studentDashboard);
                              break;
                          }
                        },
                      ),
                      AppSpacing.vXl,

                      // Footer note
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Need access for your branch or organization? Contact your admin.',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.textMutedDark
                                    : AppColors.textMutedLight,
                              ),
                            ),
                            AppSpacing.vSm,
                            TextButton.icon(
                              onPressed: () =>
                                  context.goNamed(RouteNames.platformLogin),
                              icon: const Icon(
                                Icons.admin_panel_settings_outlined,
                                size: 16,
                              ),
                              label: const Text('Login as Platform Owner'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                textStyle: AppTypography.labelMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
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
