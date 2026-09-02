import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Mobile & Tablet Bottom Navigation Bar for Platform Control Panel.
class PlatformBottomNav extends StatelessWidget {
  final String currentPath;

  const PlatformBottomNav({
    super.key,
    required this.currentPath,
  });

  int _calculateSelectedIndex() {
    if (currentPath.startsWith(RouteNames.platformOrganizationsPath)) {
      return 2;
    }
    if (currentPath.startsWith(RouteNames.platformPlansPath)) {
      return 1;
    }
    return 0; // Default dashboard
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.platformDashboardPath);
        break;
      case 1:
        context.go(RouteNames.platformPlansPath);
        break;
      case 2:
        context.go(RouteNames.platformOrganizationsPath);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final selectedIndex = _calculateSelectedIndex();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : AppColors.borderLight,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 15),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(context, index),
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: AppColors.primary.withAlpha(isDark ? 60 : 30),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded, color: AppColors.primary),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.loyalty_outlined),
            selectedIcon: Icon(Icons.loyalty_rounded, color: AppColors.primary),
            label: 'Plans',
          ),
          NavigationDestination(
            icon: Icon(Icons.corporate_fare_outlined),
            selectedIcon:
                Icon(Icons.corporate_fare_rounded, color: AppColors.primary),
            label: 'Organizations',
          ),
        ],
      ),
    );
  }
}
