import 'package:flutter/widgets.dart';

/// Represents a single clickable destination in a submenu.
class NavSubItem {
  final String title;
  final String path;
  final IconData? icon;

  const NavSubItem({required this.title, required this.path, this.icon});
}

/// Represents a top-level parent menu section with expandable children.
class NavItem {
  final String title;
  final IconData icon;
  final List<NavSubItem> subItems;
  final String? badge;

  const NavItem({
    required this.title,
    required this.icon,
    required this.subItems,
    this.badge,
  });

  /// Check if this section contains the given route location.
  bool containsPath(String currentPath) {
    return subItems.any((sub) => currentPath.startsWith(sub.path));
  }
}
