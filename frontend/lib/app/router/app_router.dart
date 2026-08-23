import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/branch/presentation/screens/branch_dashboard_screen.dart';
import '../../features/organization/presentation/screens/dashboard_screen.dart';
import '../../features/landing/presentation/screens/landing_screen.dart';
import '../../features/navigation/presentation/widgets/app_shell.dart';
import '../../features/student/presentation/screens/student_dashboard_screen.dart';
import 'route_names.dart';

/// Central GoRouter configuration for the SaaS web application.
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.landingPath,
    debugLogDiagnostics: false,
    routes: [
      // Public Unauthenticated Routes
      GoRoute(
        path: RouteNames.landingPath,
        name: RouteNames.landing,
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: RouteNames.loginPath,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // Branch Panel Route (Standalone)
      GoRoute(
        path: RouteNames.branchDashboardPath,
        name: RouteNames.branchDashboard,
        builder: (context, state) => const BranchDashboardScreen(),
      ),

      // Student Portal Route (Standalone)
      GoRoute(
        path: RouteNames.studentDashboardPath,
        name: RouteNames.studentDashboard,
        builder: (context, state) => const StudentDashboardScreen(),
      ),

      // Organization Authenticated Shell Routes
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) =>
            AppShell(currentPath: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: RouteNames.dashboardPath,
            name: RouteNames.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
        ],
      ),
    ],
  );
}
