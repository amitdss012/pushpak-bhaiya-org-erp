import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import 'platform_bottom_nav.dart';
import 'platform_header.dart';
import 'platform_sidebar.dart';

/// Responsive Platform Shell wrapping all Platform Management routes.
/// Displays a persistent Sidebar on desktop/laptop screens (>=800px)
/// and a Top Header + Bottom Navigation Bar on mobile/smaller screens (<800px).
class PlatformShell extends StatelessWidget {
  final String currentPath;
  final Widget child;

  const PlatformShell({
    super.key,
    required this.currentPath,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final showSidebar = context.screenWidth >= 800;
    final isDark = context.isDarkMode;

    if (showSidebar) {
      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        body: Row(
          children: [
            PlatformSidebar(currentPath: currentPath),
            Expanded(
              child: ColoredBox(
                color: isDark
                    ? AppColors.backgroundDark
                    : AppColors.backgroundLight,
                child: child,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: const PlatformHeader(),
      body: ColoredBox(
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        child: child,
      ),
      bottomNavigationBar: PlatformBottomNav(currentPath: currentPath),
    );
  }
}
