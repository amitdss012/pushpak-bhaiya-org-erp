import 'package:flutter/widgets.dart';

/// Screen width breakpoints for responsive UI layout adaptation.
class Breakpoints {
  Breakpoints._();

  static const double mobile = 640;
  static const double tablet = 1024;
  static const double desktop = 1440;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobile && width < tablet;
  }

  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= tablet && width < desktop;
  }

  static bool isUltraWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktop;

  static bool isMobileOrTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width < tablet;
}
