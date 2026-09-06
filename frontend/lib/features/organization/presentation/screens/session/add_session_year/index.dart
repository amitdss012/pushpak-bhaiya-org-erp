import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../api/hooks/hooks.dart';
import '../../../../../../api/models/models.dart';
import '../../../../../../app/router/route_names.dart';
import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_radius.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/utils/use_app_mutation.dart';
import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/app_card.dart';
import '../../../../../../shared/widgets/app_text_field.dart';
import '../../../../../../shared/widgets/no_data_found_template.dart';

/// Screen for creating a new master Academic Session Year and configuring initial properties.
class AddSessionYearScreen extends HookWidget {
  const AddSessionYearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;

    final nameController = useTextEditingController(text: 'Session 2025-2026');
    final codeController = useTextEditingController(text: 'AY-2025-26');
    final startYearController = useTextEditingController(text: '2025');
    final endYearController = useTextEditingController(text: '2026');
    final descController = useTextEditingController();

    final startDateState = useState<DateTime>(DateTime(2025, 4, 1));
    final endDateState = useState<DateTime>(DateTime(2026, 3, 31));
    final isCurrentForBranches = useState<bool>(false);
    final errorMessage = useState<String?>(null);

    final sessionsQuery = useSessionsQuery(
      params: const GetSessionsParams(limit: 5),
    );

    final createMutation = useCreateSessionMutation(
      onSuccess: (_) {
        sessionsQuery.refetch();
        context.goNamed(RouteNames.sessionAll);
      },
      onError: (err) {
        errorMessage.value = err.toString();
      },
    );

    void updateSessionName() {
      final s = startYearController.text.trim();
      final e = endYearController.text.trim();
      if (s.isNotEmpty && e.isNotEmpty) {
        nameController.text = 'Session $s-$e';
        codeController.text = 'AY-$s-${e.length >= 2 ? e.substring(e.length - 2) : e}';
      }
    }

    void submitForm() {
      errorMessage.value = null;
      final name = nameController.text.trim();
      final startYear = int.tryParse(startYearController.text.trim());
      final endYear = int.tryParse(endYearController.text.trim());

      if (name.isEmpty) {
        errorMessage.value = 'Please enter a session name.';
        return;
      }
      if (startYear == null || startYear < 2000 || startYear > 2100) {
        errorMessage.value = 'Please enter a valid 4-digit start year (2000-2100).';
        return;
      }
      if (endYear == null || endYear < startYear) {
        errorMessage.value = 'End year must be greater than or equal to start year.';
        return;
      }
      if (endDateState.value.isBefore(startDateState.value)) {
        errorMessage.value = 'End date must be after start date.';
        return;
      }

      createMutation.mutate(
        CreateSessionInput(
          name: name,
          code: codeController.text.trim().isEmpty ? null : codeController.text.trim(),
          startYear: startYear,
          endYear: endYear,
          startDate: startDateState.value,
          endDate: endDateState.value,
          description: descController.text.trim().isEmpty ? null : descController.text.trim(),
          isCurrentForBranches: isCurrentForBranches.value,
        ),
      );
    }

    final recentSessions = sessionsQuery.dataOrNull?.sessions ?? [];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Navigation & Title
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => context.goNamed(RouteNames.sessionAll),
                ),
                AppSpacing.hSm,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Academic Session',
                        style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w800),
                      ),
                      AppSpacing.vXs,
                      Text(
                        'Configure master academic session year duration and date parameters.',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.vLg,

            if (errorMessage.value != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.error.withAlpha(25),
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: AppColors.error.withAlpha(70)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: AppColors.error),
                    AppSpacing.hSm,
                    Expanded(
                      child: Text(
                        errorMessage.value!,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.vLg,
            ],

            // Main Two-Column Layout
            Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Form
                Expanded(
                  flex: isMobile ? 0 : 3,
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Session Details',
                          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                        ),
                        AppSpacing.vSm,
                        Text(
                          'Master academic session metadata inherited across branches.',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                        AppSpacing.vLg,

                        // Name & Code
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: AppTextField(
                                controller: nameController,
                                label: 'Session Name *',
                                hint: 'e.g. Session 2025-2026',
                              ),
                            ),
                            AppSpacing.hMd,
                            Expanded(
                              child: AppTextField(
                                controller: codeController,
                                label: 'Code',
                                hint: 'e.g. AY-2025-26',
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.vLg,

                        // Years
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: startYearController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Start Year *',
                                  hintText: '2025',
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                                ),
                                onChanged: (_) => updateSessionName(),
                              ),
                            ),
                            AppSpacing.hMd,
                            Expanded(
                              child: TextField(
                                controller: endYearController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'End Year *',
                                  hintText: '2026',
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                                ),
                                onChanged: (_) => updateSessionName(),
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.vLg,

                        // Dates Pickers
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Start Date *',
                                    style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  AppSpacing.vXs,
                                  InkWell(
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: startDateState.value,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null) {
                                        startDateState.value = picked;
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                        ),
                                        borderRadius: AppRadius.sm,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            startDateState.value.toLocal().toString().split(' ')[0],
                                            style: AppTypography.bodySmall,
                                          ),
                                          const Icon(Icons.calendar_today_rounded, size: 16),
                                        ],
                                      ),
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
                                  Text(
                                    'End Date *',
                                    style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  AppSpacing.vXs,
                                  InkWell(
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: endDateState.value,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null) {
                                        endDateState.value = picked;
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                        ),
                                        borderRadius: AppRadius.sm,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            endDateState.value.toLocal().toString().split(' ')[0],
                                            style: AppTypography.bodySmall,
                                          ),
                                          const Icon(Icons.calendar_today_rounded, size: 16),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.vLg,

                        // Description
                        AppTextField(
                          controller: descController,
                          label: 'Description',
                          hint: 'Optional notes or guidelines for this academic session...',
                          maxLines: 3,
                        ),
                        AppSpacing.vLg,

                        // Make Current Toggle
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Set as Active Session Immediately',
                            style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'If enabled, this session will become the active session for mapped branches.',
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                          value: isCurrentForBranches.value,
                          onChanged: (val) => isCurrentForBranches.value = val,
                        ),
                        AppSpacing.vXl,

                        // Submit Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppButton(
                              text: 'Cancel',
                              variant: AppButtonVariant.secondary,
                              onPressed: () => context.goNamed(RouteNames.sessionAll),
                            ),
                            AppSpacing.hMd,
                            AppButton(
                              text: 'Create Session',
                              icon: Icons.check_circle_outline_rounded,
                              isLoading: createMutation.isLoading,
                              onPressed: submitForm,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                if (!isMobile) AppSpacing.hLg,

                // Right Column: Recent Sessions Preview
                Expanded(
                  flex: isMobile ? 0 : 2,
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Existing Sessions',
                              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () => context.goNamed(RouteNames.sessionAll),
                              child: const Text('View All'),
                            ),
                          ],
                        ),
                        AppSpacing.vMd,
                        if (sessionsQuery.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(AppSpacing.lg),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (recentSessions.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(AppSpacing.md),
                            child: NoDataFoundTemplate(
                              title: 'No Sessions Configured',
                              message: 'This will be the first academic session in the organization.',
                              cardWrapper: false,
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: recentSessions.length,
                            separatorBuilder: (_, _) => Divider(
                              height: 1,
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                            itemBuilder: (ctx, i) {
                              final s = recentSessions[i];
                              final isCurrent = s.branchMappings.any((m) => m.isCurrent);

                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                leading: Icon(
                                  isCurrent ? Icons.check_circle : Icons.calendar_today_outlined,
                                  color: isCurrent ? AppColors.success : AppColors.primary,
                                  size: 18,
                                ),
                                title: Text(s.name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                                subtitle: Text(
                                  '${s.startYear} - ${s.endYear}  •  ${s.branchMappings.length} branch(es)',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
