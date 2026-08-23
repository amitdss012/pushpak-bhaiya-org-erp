import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../sidebar/app_sidebar.dart';
import 'app_header.dart';

class AppShell extends StatefulWidget {
  final String currentPath;
  final Widget child;

  const AppShell({super.key, required this.currentPath, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _closeDrawer() {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _scaffoldKey.currentState?.closeDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isDark = context.isDarkMode;

    if (isDesktop) {
      // Desktop permanent 2-column layout
      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        body: SafeArea(
          child: Row(
            children: [
              // Permanent Sidebar
              AppSidebar(currentPath: widget.currentPath),

              // Main Area (Header + Scrollable Child Content)
              Expanded(
                child: Column(
                  children: [
                    AppHeader(currentPath: widget.currentPath),
                    Expanded(child: widget.child),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Mobile & Tablet Drawer Layout
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth:
          32, // Left-edge swipe support without interfering with content
      drawer: Drawer(
        elevation: 16,
        child: AppSidebar(
          currentPath: widget.currentPath,
          onCloseDrawer: _closeDrawer,
        ),
      ),
      appBar: AppHeader(
        currentPath: widget.currentPath,
        onOpenDrawer: _openDrawer,
      ),
      body: SafeArea(child: widget.child),
    );
  }
}
