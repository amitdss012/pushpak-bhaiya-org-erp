import 'package:flutter/material.dart';

import '../utils/breakpoints.dart';

/// Convenient extension methods on BuildContext for Theme, Media, and Navigation.
extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  bool get isMobile => Breakpoints.isMobile(this);
  bool get isTablet => Breakpoints.isTablet(this);
  bool get isDesktop => Breakpoints.isDesktop(this);
  bool get isUltraWide => Breakpoints.isUltraWide(this);
  bool get isMobileOrTablet => Breakpoints.isMobileOrTablet(this);

  bool get isDarkMode => theme.brightness == Brightness.dark;
}
