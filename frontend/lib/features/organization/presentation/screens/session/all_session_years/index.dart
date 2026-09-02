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

class AllSessionYearsScreen extends StatefulWidget {
  const AllSessionYearsScreen({super.key});

  @override
  State<AllSessionYearsScreen> createState() => _AllSessionYearsScreenState();
}

class _AllSessionYearsScreenState extends State<AllSessionYearsScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _sessionYears = [
    {
      'id': '1',
      'sessionName': 'Session 2024-2025',
      'startYear': '2024',
      'endYear': '2025',
      'startDate': '2024-04-01',
      'endDate': '2025-03-31',
      'status': 'active',
      'description': 'Current academic session for the year 2024-25',
      'createdDate': '2024-01-15',
    },
    {
      'id': '2',
      'sessionName': 'Session 2023-2024',
      'startYear': '2023',
      'endYear': '2024',
      'startDate': '2023-04-01',
      'endDate': '2024-03-31',
      'status': 'closed',
      'description': 'Previous academic session completed',
      'createdDate': '2023-01-10',
    },
  ];

  Widget _getStatusBadge(String status) {
    Color bg;
    Color fg;
    IconData icon;
    String label;

    switch (status) {
      case 'active':
        bg = AppColors.success.withAlpha(20);
        fg = AppColors.success;
        icon = Icons.check_circle_rounded;
        label = 'Active';
        break;
      case 'closed':
        bg = AppColors.error.withAlpha(20);
        fg = AppColors.error;
        icon = Icons.lock_clock_rounded;
        label = 'Closed';
        break;
      case 'upcoming':
        bg = AppColors.info.withAlpha(20);
        fg = AppColors.info;
        icon = Icons.event_rounded;
        label = 'Upcoming';
        break;
      default:
        bg = Colors.grey.withAlpha(20);
        fg = Colors.grey;
        icon = Icons.help_outline_rounded;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.sm,
        border: Border.all(color: fg.withAlpha(50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(label, style: AppTypography.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.w700, color: fg)),
        ],
      ),
    );
  }

  void _openViewDialog(Map<String, dynamic> session) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = ctx.isDarkMode;

        return AlertDialog(
          title: Text('Session Details', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(session['sessionName'] as String, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
                      _getStatusBadge(session['status'] as String),
                    ],
                  ),
                  AppSpacing.vLg,
                  const Divider(height: 1),
                  AppSpacing.vMd,
                  _buildDetailRow('Year Range:', '${session['startYear']} - ${session['endYear']}', isDark),
                  _buildDetailRow('Start Date:', session['startDate'] as String, isDark),
                  _buildDetailRow('End Date:', session['endDate'] as String, isDark),
                  _buildDetailRow('Created Date:', session['createdDate'] as String, isDark),
                  AppSpacing.vMd,
                  const Divider(height: 1),
                  AppSpacing.vMd,
                  Text('DESCRIPTION', style: AppTypography.labelMedium.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  AppSpacing.vXs,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                      borderRadius: AppRadius.sm,
                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                    child: Text(session['description'] ?? 'No description provided.', style: AppTypography.bodySmall),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close')),
            AppButton(
              text: 'Edit Session',
              icon: Icons.edit_outlined,
              onPressed: () {
                Navigator.of(ctx).pop();
                _openFormDialog(session: session);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          Text(value, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _openFormDialog({Map<String, dynamic>? session}) {
    final isEditing = session != null;
    final nameController = TextEditingController(text: session?['sessionName'] ?? 'Session 2024-2025');
    final startYearController = TextEditingController(text: session?['startYear'] ?? '2024');
    final endYearController = TextEditingController(text: session?['endYear'] ?? '2025');
    final startDateController = TextEditingController(text: session?['startDate'] ?? '2024-04-01');
    final endDateController = TextEditingController(text: session?['endDate'] ?? '2025-03-31');
    final descController = TextEditingController(text: session?['description'] ?? '');
    String status = session?['status'] ?? 'upcoming';

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: Text(
              isEditing ? 'Update Session' : 'New Session Year',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
            ),
            content: SizedBox(
              width: 520,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTextField(controller: nameController, label: 'Session Name *', hint: 'e.g. Session 2024-2025'),
                    AppSpacing.vMd,
                    Row(
                      children: [
                        Expanded(child: AppTextField(controller: startYearController, label: 'Start Year', hint: '2024')),
                        AppSpacing.hMd,
                        Expanded(child: AppTextField(controller: endYearController, label: 'End Year', hint: '2025')),
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
                          decoration: const InputDecoration(hintText: 'Academic details...'),
                        ),
                      ],
                    ),
                    if (status == 'active') ...[
                      AppSpacing.vMd,
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withAlpha(15),
                          borderRadius: AppRadius.sm,
                          border: Border.all(color: AppColors.warning.withAlpha(50)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.warning),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Note: Setting this as Active will automatically mark other active sessions as Closed.',
                                style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.warning),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                    if (status == 'active') {
                      for (var s in _sessionYears) {
                        if (s['status'] == 'active') s['status'] = 'closed';
                      }
                    }
                    if (isEditing) {
                      session['sessionName'] = nameController.text.trim();
                      session['startYear'] = startYearController.text.trim();
                      session['endYear'] = endYearController.text.trim();
                      session['startDate'] = startDateController.text.trim();
                      session['endDate'] = endDateController.text.trim();
                      session['status'] = status;
                      session['description'] = descController.text.trim();
                    } else {
                      _sessionYears.insert(0, {
                        'id': '${DateTime.now().millisecondsSinceEpoch}',
                        'sessionName': nameController.text.trim(),
                        'startYear': startYearController.text.trim(),
                        'endYear': endYearController.text.trim(),
                        'startDate': startDateController.text.trim(),
                        'endDate': endDateController.text.trim(),
                        'status': status,
                        'description': descController.text.trim(),
                        'createdDate': DateTime.now().toString().split(' ')[0],
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

  void _handleMakeCurrent(String id) {
    setState(() {
      for (var s in _sessionYears) {
        if (s['id'] == id) {
          s['status'] = 'active';
        } else if (s['status'] == 'active') {
          s['status'] = 'closed';
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selected session is now set as Active!'), backgroundColor: AppColors.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;

    final filtered = _sessionYears.where((s) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = (s['sessionName'] as String).toLowerCase();
        final sYear = (s['startYear'] as String).toLowerCase();
        final eYear = (s['endYear'] as String).toLowerCase();
        return name.contains(q) || sYear.contains(q) || eYear.contains(q);
      }
      return true;
    }).toList();

    final activeSession = _sessionYears.firstWhere(
      (s) => s['status'] == 'active',
      orElse: () => {'sessionName': 'None'},
    );

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

          // 2 Summary Cards
          Row(
            children: [
              Expanded(
                child: AppCard(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(20),
                          borderRadius: AppRadius.md,
                        ),
                        child: Icon(Icons.calendar_month_rounded, size: 24, color: AppColors.primary),
                      ),
                      AppSpacing.hMd,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Sessions', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                          Text('${_sessionYears.length}', style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    borderRadius: AppRadius.md,
                    border: Border.all(color: AppColors.success.withAlpha(80), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.success.withAlpha(20),
                          borderRadius: AppRadius.md,
                        ),
                        child: const Icon(Icons.check_circle_rounded, size: 24, color: AppColors.success),
                      ),
                      AppSpacing.hMd,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Active Session', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                          Text(activeSession['sessionName'] as String, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w900, color: AppColors.success)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                        'All Session Years',
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
                            _buildDataColumn('END DATE', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filtered.map((session) {
                            final name = session['sessionName'] as String;
                            final sYear = session['startYear'] as String;
                            final eYear = session['endYear'] as String;
                            final sDate = session['startDate'] as String;
                            final eDate = session['endDate'] as String;
                            final status = session['status'] as String;

                            return DataRow(
                              cells: [
                                DataCell(Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700))),
                                DataCell(Text('$sYear - $eYear', style: AppTypography.bodySmall.copyWith(fontFamily: 'monospace'))),
                                DataCell(Text(sDate, style: AppTypography.bodySmall)),
                                DataCell(Text(eDate, style: AppTypography.bodySmall)),
                                DataCell(_getStatusBadge(status)),
                                DataCell(
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert_rounded, size: 18, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                    onSelected: (val) {
                                      if (val == 'view') {
                                        _openViewDialog(session);
                                      } else if (val == 'edit') {
                                        _openFormDialog(session: session);
                                      } else if (val == 'make_current') {
                                        _handleMakeCurrent(session['id'] as String);
                                      } else if (val == 'delete') {
                                        setState(() => _sessionYears.remove(session));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Removed ${session['sessionName']}.'), backgroundColor: AppColors.error),
                                        );
                                      }
                                    },
                                    itemBuilder: (ctx) => [
                                      const PopupMenuItem(
                                        value: 'view',
                                        child: Row(
                                          children: [
                                            Icon(Icons.visibility_outlined, size: 16),
                                            SizedBox(width: 8),
                                            Text('View Details'),
                                          ],
                                        ),
                                      ),
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
                                      if (status != 'active')
                                        const PopupMenuItem(
                                          value: 'make_current',
                                          child: Row(
                                            children: [
                                              Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.success),
                                              SizedBox(width: 8),
                                              Text('Make Current', style: TextStyle(color: AppColors.success)),
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
              'All Sessions',
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
          'Manage and view academic session years',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionBtn = AppButton(
      text: 'Add New Session',
      icon: Icons.add_rounded,
      onPressed: () => _openFormDialog(),
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
