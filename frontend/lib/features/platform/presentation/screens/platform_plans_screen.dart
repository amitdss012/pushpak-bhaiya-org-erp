import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../api/hooks/platfrom/use_subscription_plans.dart';
import '../../../../api/models/models.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/provider/app_query_client.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';

/// Platform Subscription Plans Management Screen.
/// Fully responsive across Mobile, Tablet, Desktop, and Ultra-wide resolutions.
class PlatformPlansScreen extends HookWidget {
  const PlatformPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.screenWidth < 700;

    final plansQuery = useSubscriptionPlansQuery();
    final deleteMutation = useDeleteSubscriptionPlanMutation(
      onSuccess: (_) {
        AppQueryClient.instance
            .invalidateQueries(queryKey: const ['platform', 'plans']);
      },
    );

    final plans = plansQuery.dataOrNull ?? [];

    void showCreateOrEditPlanDialog([SubscriptionPlanModel? existingPlan]) {
      showDialog(
        context: context,
        builder: (dialogContext) => _PlanFormDialog(
          existingPlan: existingPlan,
          onSuccess: () {
            AppQueryClient.instance
                .invalidateQueries(queryKey: const ['platform', 'plans']);
          },
        ),
      );
    }

    return SelectionArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Action Bar
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Subscription Plans',
                      style: AppTypography.headlineMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    AppSpacing.vXs,
                    Text(
                      'Create, configure and manage SaaS monetization tiers.',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    AppSpacing.vMd,
                    AppButton(
                      text: 'Create Plan',
                      icon: Icons.add_rounded,
                      onPressed: () => showCreateOrEditPlanDialog(),
                      height: 42,
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Subscription Plans',
                            style: AppTypography.headlineMedium.copyWith(
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                          AppSpacing.vXs,
                          Text(
                            'Create, configure and manage SaaS monetization tiers.',
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.hMd,
                    AppButton(
                      text: 'Create Plan',
                      icon: Icons.add_rounded,
                      onPressed: () => showCreateOrEditPlanDialog(),
                      height: 44,
                    ),
                  ],
                ),
              AppSpacing.vLg,

              // Content Area
              if (plansQuery.isPending)
                const Padding(
                  padding: EdgeInsets.all(64),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (plans.isEmpty)
                _buildEmptyState(
                  context,
                  isDark,
                  () => showCreateOrEditPlanDialog(),
                )
              else
                _buildPlansGrid(
                  context,
                  isDark,
                  plans,
                  onEdit: (plan) => showCreateOrEditPlanDialog(plan),
                  onDelete: (planId) {
                    showDialog(
                      context: context,
                      builder: (dialogCtx) => AlertDialog(
                        title: const Text('Delete Plan'),
                        content: const Text(
                          'Are you sure you want to delete this subscription plan?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogCtx).pop(),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.error,
                            ),
                            onPressed: () {
                              Navigator.of(dialogCtx).pop();
                              deleteMutation.mutate(planId);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    bool isDark,
    VoidCallback onCreate,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: AppCard(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(isDark ? 40 : 20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.loyalty_rounded,
                  size: 36,
                  color: AppColors.primary,
                ),
              ),
              AppSpacing.vMd,
              Text(
                'No Subscription Plans Found',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              AppSpacing.vXs,
              Text(
                'Get started by provisioning the first subscription plan tier.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              AppSpacing.vLg,
              AppButton(
                text: 'Create First Plan',
                icon: Icons.add_rounded,
                onPressed: onCreate,
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlansGrid(
    BuildContext context,
    bool isDark,
    List<SubscriptionPlanModel> plans, {
    required void Function(SubscriptionPlanModel) onEdit,
    required void Function(String) onDelete,
  }) {
    final width = context.screenWidth;
    final int columns;
    if (width < 700) {
      columns = 1;
    } else if (width < 1150) {
      columns = 2;
    } else {
      columns = 3;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 16.0;
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: plans.map((plan) {
            return SizedBox(
              width: itemWidth,
              child: _buildPlanCard(context, isDark, plan, onEdit, onDelete),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    bool isDark,
    SubscriptionPlanModel plan,
    void Function(SubscriptionPlanModel) onEdit,
    void Function(String) onDelete,
  ) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  plan.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: plan.isActive
                      ? AppColors.success.withAlpha(isDark ? 40 : 20)
                      : AppColors.textMutedLight.withAlpha(40),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  plan.isActive ? 'Active' : 'Archived',
                  style: AppTypography.labelSmall.copyWith(
                    color: plan.isActive
                        ? AppColors.success
                        : AppColors.textMutedLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (plan.description != null && plan.description!.isNotEmpty) ...[
            AppSpacing.vXs,
            Text(
              plan.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
          AppSpacing.vMd,

          // Pricing
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '₹${plan.priceMonthly.toInt()}',
                style: AppTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              Text(
                ' / month',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.textMutedDark
                      : AppColors.textMutedLight,
                ),
              ),
            ],
          ),
          Text(
            '₹${plan.priceYearly.toInt()} billed annually',
            style: AppTypography.labelSmall.copyWith(
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          AppSpacing.vMd,
          const Divider(height: 1),
          AppSpacing.vMd,

          // Quotas
          _buildFeatureRow(
            Icons.domain_rounded,
            'Up to ${plan.maxBranches} Branches',
            isDark,
          ),
          AppSpacing.vSm,
          _buildFeatureRow(
            Icons.school_rounded,
            '${plan.maxStudentsPerBranch > 0 ? plan.maxStudentsPerBranch : 'Unlimited'} Students / Branch',
            isDark,
          ),
          AppSpacing.vSm,
          _buildFeatureRow(
            Icons.badge_rounded,
            '${plan.maxTeachersPerBranch > 0 ? plan.maxTeachersPerBranch : 'Unlimited'} Teachers / Branch',
            isDark,
          ),
          AppSpacing.vLg,

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit'),
                  onPressed: () => onEdit(plan),
                ),
              ),
              AppSpacing.hSm,
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
                color: AppColors.error,
                tooltip: 'Delete Plan',
                onPressed: () => onDelete(plan.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        AppSpacing.hSm,
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// Create or Edit Subscription Plan Form Dialog.
class _PlanFormDialog extends HookWidget {
  final SubscriptionPlanModel? existingPlan;
  final VoidCallback onSuccess;

  const _PlanFormDialog({
    this.existingPlan,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.screenWidth < 600;
    final isEditing = existingPlan != null;
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final nameController =
        useTextEditingController(text: existingPlan?.name ?? '');
    final descController =
        useTextEditingController(text: existingPlan?.description ?? '');
    final priceMonthlyController = useTextEditingController(
      text: existingPlan != null ? '${existingPlan!.priceMonthly.toInt()}' : '',
    );
    final priceYearlyController = useTextEditingController(
      text: existingPlan != null ? '${existingPlan!.priceYearly.toInt()}' : '',
    );
    final maxBranchesController = useTextEditingController(
      text: existingPlan != null ? '${existingPlan!.maxBranches}' : '1',
    );
    final maxStudentsController = useTextEditingController(
      text: existingPlan != null
          ? '${existingPlan!.maxStudentsPerBranch}'
          : '500',
    );
    final maxTeachersController = useTextEditingController(
      text:
          existingPlan != null ? '${existingPlan!.maxTeachersPerBranch}' : '50',
    );

    final createMutation = useCreateSubscriptionPlanMutation(
      onSuccess: (_) {
        onSuccess();
        Navigator.of(context).pop();
      },
    );

    final updateMutation = useUpdateSubscriptionPlanMutation(
      onSuccess: (_) {
        onSuccess();
        Navigator.of(context).pop();
      },
    );

    final isLoading = createMutation.isPending || updateMutation.isPending;

    void handleSubmit() {
      if (!formKey.currentState!.validate()) return;

      final name = nameController.text.trim();
      final desc = descController.text.trim();
      final priceMonthly = double.tryParse(priceMonthlyController.text) ?? 0.0;
      final priceYearly = double.tryParse(priceYearlyController.text) ?? 0.0;
      final maxBranches = int.tryParse(maxBranchesController.text) ?? 1;
      final maxStudents = int.tryParse(maxStudentsController.text) ?? 0;
      final maxTeachers = int.tryParse(maxTeachersController.text) ?? 0;

      if (isEditing) {
        updateMutation.mutate(
          UpdatePlanParams(
            id: existingPlan!.id,
            data: UpdatePlanRequest(
              name: name,
              description: desc,
              priceMonthly: priceMonthly,
              priceYearly: priceYearly,
              maxBranches: maxBranches,
              maxStudentsPerBranch: maxStudents,
              maxTeachersPerBranch: maxTeachers,
            ),
          ),
        );
      } else {
        createMutation.mutate(
          CreatePlanRequest(
            name: name,
            description: desc,
            priceMonthly: priceMonthly,
            priceYearly: priceYearly,
            maxBranches: maxBranches,
            maxStudentsPerBranch: maxStudents,
            maxTeachersPerBranch: maxTeachers,
          ),
        );
      }
    }

    final pricingFields = [
      if (isMobile) ...[
        AppTextField(
          controller: priceMonthlyController,
          label: 'Monthly Price (₹) *',
          hint: '2999',
          keyboardType: TextInputType.number,
          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
        ),
        AppSpacing.vSm,
        AppTextField(
          controller: priceYearlyController,
          label: 'Yearly Price (₹) *',
          hint: '29990',
          keyboardType: TextInputType.number,
          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
        ),
      ] else
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: priceMonthlyController,
                label: 'Monthly Price (₹) *',
                hint: '2999',
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
            ),
            AppSpacing.hMd,
            Expanded(
              child: AppTextField(
                controller: priceYearlyController,
                label: 'Yearly Price (₹) *',
                hint: '29990',
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
            ),
          ],
        ),
    ];

    final quotaFields = [
      if (isMobile) ...[
        AppTextField(
          controller: maxBranchesController,
          label: 'Max Branches *',
          hint: '3',
          keyboardType: TextInputType.number,
          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
        ),
        AppSpacing.vSm,
        AppTextField(
          controller: maxStudentsController,
          label: 'Max Students / Branch',
          hint: '500',
          keyboardType: TextInputType.number,
        ),
        AppSpacing.vSm,
        AppTextField(
          controller: maxTeachersController,
          label: 'Max Teachers / Branch',
          hint: '50',
          keyboardType: TextInputType.number,
        ),
      ] else ...[
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: maxBranchesController,
                label: 'Max Branches *',
                hint: '3',
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
            ),
            AppSpacing.hMd,
            Expanded(
              child: AppTextField(
                controller: maxStudentsController,
                label: 'Max Students / Branch',
                hint: '500',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        AppTextField(
          controller: maxTeachersController,
          label: 'Max Teachers / Branch',
          hint: '50',
          keyboardType: TextInputType.number,
        ),
      ],
    ];

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: isMobile ? 16 : 24,
      ),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 520,
          maxHeight: MediaQuery.sizeOf(context).height * 0.90,
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        isEditing
                            ? 'Edit Subscription Plan'
                            : 'Create New Plan',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: (isMobile
                                ? AppTypography.titleMedium
                                : AppTypography.titleLarge)
                            .copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                AppSpacing.vMd,
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AppTextField(
                          controller: nameController,
                          label: 'Plan Name *',
                          hint: 'e.g. Standard Growth Tier',
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        AppSpacing.vSm,
                        AppTextField(
                          controller: descController,
                          label: 'Description',
                          hint: 'Short description of this tier',
                          maxLines: 2,
                        ),
                        AppSpacing.vSm,
                        ...pricingFields,
                        AppSpacing.vSm,
                        ...quotaFields,
                      ],
                    ),
                  ),
                ),
                AppSpacing.vLg,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    AppSpacing.hSm,
                    AppButton(
                      text: isEditing ? 'Save Changes' : 'Create Plan',
                      isLoading: isLoading,
                      onPressed: handleSubmit,
                      height: 42,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
