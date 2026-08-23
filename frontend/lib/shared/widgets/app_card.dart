import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../core/extensions/context_extensions.dart';

class AppCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool enableHover;
  final Color? color;
  final BorderSide? borderSide;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.onTap,
    this.enableHover = false,
    this.color,
    this.borderSide,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final defaultBg = isDark
        ? AppColors.surfaceCardDark
        : AppColors.surfaceCardLight;
    final defaultBorderColor = isDark
        ? AppColors.borderDark
        : AppColors.borderLight;

    return MouseRegion(
      onEnter: widget.enableHover
          ? (_) => setState(() => _isHovered = true)
          : null,
      onExit: widget.enableHover
          ? (_) => setState(() => _isHovered = false)
          : null,
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: _isHovered
              ? Matrix4.translationValues(0, -4, 0)
              : Matrix4.identity(),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.color ?? defaultBg,
            borderRadius: AppRadius.md,
            border: Border.fromBorderSide(
              widget.borderSide ??
                  BorderSide(
                    color: _isHovered
                        ? AppColors.primary.withAlpha(150)
                        : defaultBorderColor,
                    width: 1,
                  ),
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(20),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
