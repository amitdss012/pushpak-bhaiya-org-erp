import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../models/nav_item_model.dart';

class SidebarAccordionItem extends StatefulWidget {
  final NavItem item;
  final String currentPath;
  final ValueChanged<String> onNavigate;

  const SidebarAccordionItem({
    super.key,
    required this.item,
    required this.currentPath,
    required this.onNavigate,
  });

  @override
  State<SidebarAccordionItem> createState() => _SidebarAccordionItemState();
}

class _SidebarAccordionItemState extends State<SidebarAccordionItem>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _animController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.item.containsPath(widget.currentPath);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOutCubic,
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutCubic),
    );

    if (_isExpanded) {
      _animController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant SidebarAccordionItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    final shouldBeExpanded = widget.item.containsPath(widget.currentPath);
    if (shouldBeExpanded && !_isExpanded) {
      _toggleExpand(true);
    }
  }

  void _toggleExpand([bool? forceState]) {
    setState(() {
      _isExpanded = forceState ?? !_isExpanded;
      if (_isExpanded) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isSectionActive = widget.item.containsPath(widget.currentPath);

    final parentBgColor = isSectionActive
        ? (isDark
              ? AppColors.primary.withAlpha(25)
              : AppColors.primaryLight.withAlpha(80))
        : Colors.transparent;

    final parentTextColor = isSectionActive
        ? AppColors.primary
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Parent Header Button
        Material(
          color: parentBgColor,
          borderRadius: AppRadius.sm,
          child: InkWell(
            onTap: () => _toggleExpand(),
            borderRadius: AppRadius.sm,
            hoverColor: isDark
                ? Colors.white.withAlpha(10)
                : Colors.black.withAlpha(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    widget.item.icon,
                    size: 18,
                    color: isSectionActive
                        ? AppColors.primary
                        : (isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight),
                  ),
                  AppSpacing.hSm,
                  Expanded(
                    child: Text(
                      widget.item.title,
                      style: AppTypography.bodyMedium.copyWith(
                        color: parentTextColor,
                        fontWeight: isSectionActive
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 13.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.item.badge != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(isDark ? 50 : 25),
                        borderRadius: AppRadius.full,
                      ),
                      child: Text(
                        widget.item.badge!,
                        style: AppTypography.labelMedium.copyWith(
                          fontSize: 10,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    AppSpacing.hXs,
                  ],
                  RotationTransition(
                    turns: _rotateAnimation,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Submenu Animated Expansion Container
        SizeTransition(
          sizeFactor: _expandAnimation,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(left: 14, top: 2, bottom: 4),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                    width: 1.5,
                  ),
                ),
              ),
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.item.subItems.map((sub) {
                  final isChildActive = widget.currentPath == sub.path;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.5),
                    child: Material(
                      color: isChildActive
                          ? (isDark
                                ? AppColors.primary.withAlpha(45)
                                : AppColors.primary.withAlpha(20))
                          : Colors.transparent,
                      borderRadius: AppRadius.sm,
                      child: InkWell(
                        onTap: () => widget.onNavigate(sub.path),
                        borderRadius: AppRadius.sm,
                        hoverColor: isDark
                            ? Colors.white.withAlpha(8)
                            : Colors.black.withAlpha(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              if (sub.icon != null) ...[
                                Icon(
                                  sub.icon,
                                  size: 15,
                                  color: isChildActive
                                      ? AppColors.primary
                                      : (isDark
                                            ? AppColors.textMutedDark
                                            : AppColors.textMutedLight),
                                ),
                                AppSpacing.hSm,
                              ] else ...[
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isChildActive
                                        ? AppColors.primary
                                        : (isDark
                                              ? AppColors.textMutedDark
                                              : AppColors.textMutedLight),
                                  ),
                                ),
                                AppSpacing.hSm,
                              ],
                              Expanded(
                                child: Text(
                                  sub.title,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isChildActive
                                        ? AppColors.primary
                                        : (isDark
                                              ? AppColors.textSecondaryDark
                                              : AppColors.textSecondaryLight),
                                    fontWeight: isChildActive
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    fontSize: 12.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
