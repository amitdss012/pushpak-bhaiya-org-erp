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

/// Luxury, fully responsive Subscription Plans Management Catalog.
/// Adapts gracefully across Mobile, Tablet, Desktop, and Ultra-wide screens.
class PlatformPlansScreen extends HookWidget {
  const PlatformPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final screenWidth = context.screenWidth;
    final isMobile = screenWidth < 700;

    // Monthly vs Yearly billing cycle toggle
    final isAnnualBilling = useState<bool>(false);

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
        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 28,
                vertical: isMobile ? 16 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header & Billing Switcher
                  _buildCatalogHeader(
                    context,
                    isDark,
                    isMobile,
                    isAnnualBilling,
                    () => showCreateOrEditPlanDialog(),
                  ),
                  AppSpacing.vLg,

                  // 2. Content Area
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
                      isAnnualBilling.value,
                      onEdit: (plan) => showCreateOrEditPlanDialog(plan),
                      onDelete: (planId) {
                        showDialog(
                          context: context,
                          builder: (dialogCtx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.lg,
                            ),
                            title: const Text('Delete Subscription Plan'),
                            content: const Text(
                              'Are you sure you want to delete this subscription plan tier? Organizations currently on this plan may require reassignment.',
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
                                child: const Text('Delete Tier'),
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
        ),
      ),
    );
  }

  // ===========================================================================
  // 1. Catalog Header & Billing Toggle Switch
  // ===========================================================================
  Widget _buildCatalogHeader(
    BuildContext context,
    bool isDark,
    bool isMobile,
    ValueNotifier<bool> isAnnualBilling,
    VoidCallback onCreatePlan,
  ) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subscription Plans',
          style: (isMobile
                  ? AppTypography.titleLarge
                  : AppTypography.headlineMedium)
              .copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Configure SaaS pricing tiers, campus quotas, and feature entitlements.',
          style: AppTypography.bodySmall.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final billingToggle = Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        borderRadius: AppRadius.full,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => isAnnualBilling.value = false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: !isAnnualBilling.value
                    ? (isDark ? const Color(0xFF0F172A) : Colors.white)
                    : Colors.transparent,
                borderRadius: AppRadius.full,
                boxShadow: !isAnnualBilling.value
                    ? [
                        BoxShadow(
                          color: Colors.black.withAlpha(isDark ? 50 : 15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: Text(
                'Monthly',
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: !isAnnualBilling.value
                      ? FontWeight.w800
                      : FontWeight.w600,
                  color: !isAnnualBilling.value
                      ? AppColors.primary
                      : (isDark
                          ? AppColors.textMutedDark
                          : AppColors.textSecondaryLight),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => isAnnualBilling.value = true,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isAnnualBilling.value
                    ? (isDark ? const Color(0xFF0F172A) : Colors.white)
                    : Colors.transparent,
                borderRadius: AppRadius.full,
                boxShadow: isAnnualBilling.value
                    ? [
                        BoxShadow(
                          color: Colors.black.withAlpha(isDark ? 50 : 15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Yearly',
                    style: AppTypography.labelSmall.copyWith(
                      fontWeight: isAnnualBilling.value
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color: isAnnualBilling.value
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.textMutedDark
                              : AppColors.textSecondaryLight),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.success.withAlpha(isDark ? 35 : 20),
                      borderRadius: AppRadius.full,
                    ),
                    child: Text(
                      'SAVE 20%',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w900,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          titleBlock,
          AppSpacing.vMd,
          Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              billingToggle,
              AppButton(
                text: 'New Tier',
                icon: Icons.add_rounded,
                onPressed: onCreatePlan,
                height: 40,
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: titleBlock),
        AppSpacing.hMd,
        billingToggle,
        AppSpacing.hMd,
        AppButton(
          text: 'Create Plan',
          icon: Icons.add_rounded,
          onPressed: onCreatePlan,
          height: 42,
        ),
      ],
    );
  }

  // ===========================================================================
  // 2. Plans Grid (Adaptive 1 / 2 / 3 Columns)
  // ===========================================================================
  Widget _buildPlansGrid(
    BuildContext context,
    bool isDark,
    List<SubscriptionPlanModel> plans,
    bool isAnnual, {
    required void Function(SubscriptionPlanModel) onEdit,
    required void Function(String) onDelete,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final int columns;
        if (width < 680) {
          columns = 1;
        } else if (width < 1120) {
          columns = 2;
        } else {
          columns = 3;
        }

        final spacing = 18.0;
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: plans.map((plan) {
            final isPopular = plan.name.toLowerCase().contains('growth') ||
                plan.name.toLowerCase().contains('popular') ||
                plan.name.toLowerCase().contains('standard');

            return SizedBox(
              width: itemWidth,
              child: _buildLuxuryPlanCard(
                context,
                isDark,
                plan,
                isAnnual,
                isPopular,
                onEdit,
                onDelete,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildLuxuryPlanCard(
    BuildContext context,
    bool isDark,
    SubscriptionPlanModel plan,
    bool isAnnual,
    bool isPopular,
    void Function(SubscriptionPlanModel) onEdit,
    void Function(String) onDelete,
  ) {
    final price = isAnnual
        ? (plan.priceYearly > 0
            ? plan.priceYearly.toInt()
            : (plan.priceMonthly * 10).toInt())
        : plan.priceMonthly.toInt();

    final cadenceText = isAnnual ? '/ year' : '/ month';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isPopular
              ? AppColors.primary
              : (isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
          width: isPopular ? 2.0 : 1.0,
        ),
        boxShadow: [
          if (isPopular)
            BoxShadow(
              color: AppColors.primary.withAlpha(isDark ? 40 : 25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          else
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 40 : 6),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPopular) const SizedBox(height: 8),

                // Tier Name & Status Pill
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: plan.isActive
                            ? AppColors.success.withAlpha(isDark ? 35 : 20)
                            : AppColors.textMutedLight.withAlpha(30),
                        borderRadius: AppRadius.full,
                      ),
                      child: Text(
                        plan.isActive ? 'Active' : 'Archived',
                        style: AppTypography.labelSmall.copyWith(
                          color: plan.isActive
                              ? AppColors.success
                              : AppColors.textMutedLight,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),

                if (plan.description != null &&
                    plan.description!.isNotEmpty) ...[
                  AppSpacing.vXs,
                  Text(
                    plan.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontSize: 12,
                    ),
                  ),
                ],
                AppSpacing.vMd,

                // Price Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '₹$price',
                      style: AppTypography.headlineMedium.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        color: isPopular
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      cadenceText,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (isAnnual) ...[
                  AppSpacing.vXs,
                  Text(
                    '₹${(price / 12).toStringAsFixed(0)} / mo equivalent',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                AppSpacing.vMd,
                const Divider(height: 1),
                AppSpacing.vMd,

                // Quota Entitlements
                Text(
                  'QUOTA ENTITLEMENTS',
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                    fontSize: 10,
                  ),
                ),
                AppSpacing.vSm,
                _buildEntitlementRow(
                  icon: Icons.domain_rounded,
                  text: '${plan.maxBranches} Campus Branches Included',
                  isDark: isDark,
                ),
                AppSpacing.vSm,
                _buildEntitlementRow(
                  icon: Icons.school_rounded,
                  text:
                      '${plan.maxStudentsPerBranch > 0 ? plan.maxStudentsPerBranch : 'Unlimited'} Students / Branch',
                  isDark: isDark,
                ),
                AppSpacing.vSm,
                _buildEntitlementRow(
                  icon: Icons.badge_rounded,
                  text:
                      '${plan.maxTeachersPerBranch > 0 ? plan.maxTeachersPerBranch : 'Unlimited'} Staff / Branch',
                  isDark: isDark,
                ),
                AppSpacing.vSm,
                _buildEntitlementRow(
                  icon: Icons.security_rounded,
                  text: 'Role-Based Access Control & Audit Log',
                  isDark: isDark,
                ),
                AppSpacing.vLg,

                // Actions Footer
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Edit Tier'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.md,
                          ),
                        ),
                        onPressed: () => onEdit(plan),
                      ),
                    ),
                    AppSpacing.hSm,
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      color: AppColors.error,
                      tooltip: 'Delete Plan',
                      onPressed: () => onDelete(plan.id),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Most Popular Banner Tag
          if (isPopular)
            Positioned(
              top: -11,
              left: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: AppRadius.full,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(80),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'MOST POPULAR',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 9,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEntitlementRow({
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_rounded,
          size: 16,
          color: AppColors.success,
        ),
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
              fontSize: 12,
            ),
          ),
        ),
      ],
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
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(isDark ? 40 : 20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.loyalty_rounded,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              AppSpacing.vMd,
              Text(
                'No Subscription Plans Found',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              AppSpacing.vXs,
              Text(
                'Get started by creating your foundational SaaS subscription tiers.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              AppSpacing.vLg,
              AppButton(
                text: 'Create First Plan Tier',
                icon: Icons.add_rounded,
                onPressed: onCreate,
                height: 42,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Create or Edit Subscription Plan Form Dialog.
/// Fully responsive across mobile, tablet, and desktop viewports.
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
