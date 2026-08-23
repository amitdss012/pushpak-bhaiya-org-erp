import 'package:flutter/widgets.dart';

import 'breakpoints.dart';

/// Helper widget to build different layouts based on active device breakpoint.
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (Breakpoints.isDesktop(context) || Breakpoints.isUltraWide(context)) {
      if (desktop != null) return desktop!(context);
      if (tablet != null) return tablet!(context);
    } else if (Breakpoints.isTablet(context)) {
      if (tablet != null) return tablet!(context);
    }

    return mobile(context);
  }
}
