import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/router/route_names.dart';
import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_radius.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/app_card.dart';
import '../../../../../../shared/widgets/app_text_field.dart';

class AddSessionYearScreen extends StatefulWidget {
  const AddSessionYearScreen({super.key});

  @override
  State<AddSessionYearScreen> createState() => _AddSessionYearScreenState();
}

class _AddSessionYearScreenState extends State<AddSessionYearScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _sessions = [
    {
      'id': '1',
      'sessionName': 'Session 2024-2025',
      'startYear': '2024',
      'endYear': '2025',
      'startDate': '2024-04-01',
      'endDate': '2025-03-31',
      'status': 'active',
      'description': 'Current active session',
    },
  ];

  void _openSessionDialog({Map<String, dynamic>? session}) {
    final isEditing = session != null;
    final nameController = TextEditingController(text: session?['sessionName'] ?? 'Session 2024-2025');
    final startYearController = TextEditingController(text: session?['startYear'] ?? '2024');
    final endYearController = TextEditingController(text: session?['endYear'] ?? '2025');
    final startDateController = TextEditingController(text: session?['startDate'] ?? '2024-04-01');
    final endDateController = TextEditingController(text: session?['endDate'] ?? '2025-03-31');
    final descController = TextEditingController(text: session?['description'] ?? '');
    String status = session?['status'] ?? 'active';

    void updateSessionName() {
      final s = startYearController.text.trim();
      final e = endYearController.text.trim();
      if (s.isNotEmpty && e.isNotEmpty) {
        nameController.text = 'Session $s-$e';
      }
    }

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: Text(
              isEditing ? 'Edit Session Year' : 'Create Session Year',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
            ),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTextField(controller: nameController, label: 'Session Name *', hint: 'e.g. Session 2024-2025'),
                    AppSpacing.vMd,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Start Year', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                              AppSpacing.vXs,
                              TextField(
                                controller: startYearController,
                                keyboardType: TextInputType.number,
                                onChanged: (v) {
                                  updateSessionName();
                                  setDialogState(() {});
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.hMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('End Year', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                              AppSpacing.vXs,
                              TextField(
                                controller: endYearController,
                                keyboardType: TextInputType.number,
                                onChanged: (v) {
                                  updateSessionName();
                                  setDialogState(() {});
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Start Date *', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                              AppSpacing.vXs,
                              TextField(
                                readOnly: true,
                                controller: startDateController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  suffixIcon: const Icon(Icons.calendar_today_rounded, size: 16),
                                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                                ),
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2035),
                                  );
                                  if (picked != null) {
                                    startDateController.text = picked.toString().split(' ')[0];
                                    setDialogState(() {});
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.hMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('End Date *', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                              AppSpacing.vXs,
                              TextField(
                                readOnly: true,
                                controller: endDateController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  suffixIcon: const Icon(Icons.calendar_today_rounded, size: 16),
                                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                                ),
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now().add(const Duration(days: 365)),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2035),
                                  );
                                  if (picked != null) {
                                    endDateController.text = picked.toString().split(' ')[0];
                                    setDialogState(() {});
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                        AppSpacing.vXs,
                        DropdownButtonFormField<String>(
                          initialValue: status,
                          isExpanded: true,
                          decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                          items: const [
                            DropdownMenuItem(value: 'active', child: Text('Active')),
                            DropdownMenuItem(value: 'upcoming', child: Text('Upcoming')),
                            DropdownMenuItem(value: 'closed', child: Text('Closed')),
                          ],
                          onChanged: (v) => setDialogState(() => status = v!),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                        AppSpacing.vXs,
                        TextFormField(
                          controller: descController,
                          maxLines: 2,
                          decoration: const InputDecoration(hintText: 'Academic session details...'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(dialogCtx).pop(), child: const Text('Cancel')),
              AppButton(
                text: isEditing ? 'Save Changes' : 'Create Session',
                icon: Icons.check_rounded,
                onPressed: () {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a session name.')));
                    return;
                  }
                  setState(() {
                    if (isEditing) {
                      session['sessionName'] = nameController.text.trim();
                      session['startYear'] = startYearController.text.trim();
                      session['endYear'] = endYearController.text.trim();
                      session['startDate'] = startDateController.text.trim();
                      session['endDate'] = endDateController.text.trim();
                      session['status'] = status;
                      session['description'] = descController.text.trim();
                    } else {
                      _sessions.insert(0, {
                        'id': '${DateTime.now().millisecondsSinceEpoch}',
                        'sessionName': nameController.text.trim(),
                        'startYear': startYearController.text.trim(),
                        'endYear': endYearController.text.trim(),
                        'startDate': startDateController.text.trim(),
                        'endDate': endDateController.text.trim(),
                        'status': status,
                        'description': descController.text.trim(),
                      });
                    }
                  });
                  Navigator.of(dialogCtx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEditing ? 'Session updated!' : 'New session created!'), backgroundColor: AppColors.success),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;

    final filtered = _sessions.where((s) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = (s['sessionName'] as String).toLowerCase();
        return name.contains(q);
      }
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 28,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          _buildHeader(isDark, isMobile),
          AppSpacing.vXl,

          // Full-width Table Card
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Academic Sessions',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 260),
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                            borderRadius: AppRadius.sm,
                            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                          ),
                          child: TextField(
                            onChanged: (val) => setState(() => _searchQuery = val.trim()),
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search sessions...',
                              hintStyle: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                fontSize: 12,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                size: 16,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 8),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          headingRowHeight: 44,
                          dataRowMinHeight: 56,
                          dataRowMaxHeight: 64,
                          horizontalMargin: 20,
                          columnSpacing: 20,
                          headingRowColor: WidgetStateProperty.all(
                            isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight.withAlpha(120),
                          ),
                          columns: [
                            _buildDataColumn('SESSION NAME', isDark),
                            _buildDataColumn('RANGE', isDark),
                            _buildDataColumn('START DATE', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filtered.map((session) {
                            final name = session['sessionName'] as String;
                            final sYear = session['startYear'] as String;
                            final eYear = session['endYear'] as String;
                            final sDate = session['startDate'] as String;
                            final status = session['status'] as String;

                            Color statusColor;
                            if (status == 'active') {
                              statusColor = AppColors.success;
                            } else if (status == 'upcoming') {
                              statusColor = AppColors.info;
                            } else {
                              statusColor = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
                            }

                            return DataRow(
                              cells: [
                                DataCell(Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700))),
                                DataCell(Text('$sYear - $eYear', style: AppTypography.bodySmall.copyWith(fontFamily: 'monospace'))),
                                DataCell(Text(sDate, style: AppTypography.bodySmall)),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: statusColor.withAlpha(20),
                                      borderRadius: AppRadius.sm,
                                      border: Border.all(color: statusColor.withAlpha(60)),
                                    ),
                                    child: Text(
                                      status.toUpperCase(),
                                      style: AppTypography.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert_rounded, size: 18, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                    onSelected: (val) {
                                      if (val == 'edit') {
                                        _openSessionDialog(session: session);
                                      } else if (val == 'delete') {
                                        setState(() => _sessions.remove(session));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Removed ${session['sessionName']}.'), backgroundColor: AppColors.error),
                                        );
                                      }
                                    },
                                    itemBuilder: (ctx) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit_outlined, size: 16),
                                            SizedBox(width: 8),
                                            Text('Edit Session'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                                            SizedBox(width: 8),
                                            Text('Delete', style: TextStyle(color: AppColors.error)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isMobile) {
    final headerTexts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => context.go(RouteNames.sessionAllPath),
              child: Text(
                'Session Year',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                '/',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                ),
              ),
            ),
            Text(
              'Add & Manage',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Session Management',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Create and manage academic session years',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionBtn = AppButton(
      text: 'New Session Year',
      icon: Icons.add_rounded,
      onPressed: () => _openSessionDialog(),
      height: 38,
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerTexts,
          AppSpacing.vMd,
          actionBtn,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: headerTexts),
        actionBtn,
      ],
    );
  }

  DataColumn _buildDataColumn(String title, bool isDark) {
    return DataColumn(
      label: Text(
        title,
        style: AppTypography.labelMedium.copyWith(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
        ),
      ),
    );
  }
}
