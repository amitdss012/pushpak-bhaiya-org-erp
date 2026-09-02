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
import '../../../widgets/org_stats_card.dart';

class AllPartnersScreen extends StatefulWidget {
  const AllPartnersScreen({super.key});

  @override
  State<AllPartnersScreen> createState() => _AllPartnersScreenState();
}

class _AllPartnersScreenState extends State<AllPartnersScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _partners = [
    {
      'id': '1',
      'partnerName': 'John Education Services',
      'partnerType': 'organization',
      'email': 'john@edu.com',
      'phone': '+91 9876543210',
      'city': 'Mumbai',
      'state': 'Maharashtra',
      'commissionRate': '10',
      'status': 'active',
      'joinedDate': '2024-01-15',
      'contactPerson': 'John Doe',
      'address': '123 Education Lane',
      'gstNumber': '27ABCDE1234F1Z5',
      'panNumber': 'ABCDE1234F',
      'bankName': 'HDFC Bank',
      'accountNumber': '50100234567890',
      'ifscCode': 'HDFC0001234',
      'notes': 'Preferred partner for West Region student admissions.',
    },
    {
      'id': '2',
      'partnerName': 'Sarah Learning Hub',
      'partnerType': 'individual',
      'email': 'sarah@learning.com',
      'phone': '+91 9876543211',
      'city': 'Delhi',
      'state': 'Delhi',
      'commissionRate': '8',
      'status': 'active',
      'joinedDate': '2024-02-20',
      'contactPerson': 'Sarah Smith',
      'address': '45 Knowledge Park, Connaught Place',
      'gstNumber': '07FGHIJ5678K2Z9',
      'panNumber': 'FGHIJ5678K',
      'bankName': 'ICICI Bank',
      'accountNumber': '10200345678912',
      'ifscCode': 'ICIC0005678',
      'notes': 'Specializes in online courses and counseling.',
    },
  ];

  void _openViewDialog(Map<String, dynamic> partner) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = ctx.isDarkMode;
        return AlertDialog(
          title: Text(
            'Partner Profile',
            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: 580,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(partner['partnerName'] as String, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
                            Text('Contact: ${partner['contactPerson'] ?? 'N/A'}', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                            Text('Type: ${(partner['partnerType'] as String).toUpperCase()}', style: AppTypography.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                            Text('Joined: ${partner['joinedDate']}', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(15),
                          borderRadius: AppRadius.md,
                          border: Border.all(color: AppColors.primary.withAlpha(40)),
                        ),
                        child: Column(
                          children: [
                            Text('COMMISSION', style: AppTypography.labelMedium.copyWith(fontSize: 10, fontWeight: FontWeight.w700)),
                            Text('${partner['commissionRate']}%', style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w900, color: AppColors.primary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vLg,
                  const Divider(height: 1),
                  AppSpacing.vMd,

                  // Contact & Location
                  Text('CONTACT & LOCATION', style: AppTypography.labelMedium.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  AppSpacing.vSm,
                  _buildDetailRow('Email:', partner['email'] as String, isDark),
                  _buildDetailRow('Phone:', partner['phone'] as String, isDark),
                  _buildDetailRow('Address:', partner['address'] ?? 'N/A', isDark),
                  _buildDetailRow('City / State:', '${partner['city'] ?? ''}, ${partner['state'] ?? ''}', isDark),

                  AppSpacing.vMd,
                  const Divider(height: 1),
                  AppSpacing.vMd,

                  // Tax & Banking Info
                  Text('TAX & BANKING INFO', style: AppTypography.labelMedium.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  AppSpacing.vSm,
                  _buildDetailRow('GST Number:', partner['gstNumber'] ?? 'N/A', isDark),
                  _buildDetailRow('PAN Number:', partner['panNumber'] ?? 'N/A', isDark),
                  _buildDetailRow('Bank Name:', partner['bankName'] ?? 'N/A', isDark),
                  _buildDetailRow('Account No:', partner['accountNumber'] ?? 'N/A', isDark),
                  _buildDetailRow('IFSC Code:', partner['ifscCode'] ?? 'N/A', isDark),

                  if (partner['notes'] != null) ...[
                    AppSpacing.vMd,
                    const Divider(height: 1),
                    AppSpacing.vMd,
                    Text('INTERNAL NOTES', style: AppTypography.labelMedium.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                    AppSpacing.vXs,
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                        borderRadius: AppRadius.sm,
                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      child: Text(partner['notes'] as String, style: AppTypography.bodySmall.copyWith(fontStyle: FontStyle.italic)),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
            AppButton(
              text: 'Edit Profile',
              icon: Icons.edit_outlined,
              onPressed: () {
                Navigator.of(ctx).pop();
                _openPartnerFormDialog(partner: partner);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          Text(value, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _openPartnerFormDialog({Map<String, dynamic>? partner}) {
    final isEditing = partner != null;
    final nameController = TextEditingController(text: partner?['partnerName'] ?? '');
    final emailController = TextEditingController(text: partner?['email'] ?? '');
    final phoneController = TextEditingController(text: partner?['phone'] ?? '');
    final commController = TextEditingController(text: partner?['commissionRate'] ?? '10');
    final contactController = TextEditingController(text: partner?['contactPerson'] ?? '');
    final cityController = TextEditingController(text: partner?['city'] ?? '');
    final gstController = TextEditingController(text: partner?['gstNumber'] ?? '');
    final bankController = TextEditingController(text: partner?['bankName'] ?? '');
    final accController = TextEditingController(text: partner?['accountNumber'] ?? '');
    final ifscController = TextEditingController(text: partner?['ifscCode'] ?? '');
    final notesController = TextEditingController(text: partner?['notes'] ?? '');
    String partnerType = partner?['partnerType'] ?? 'individual';

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: Text(
              isEditing ? 'Update Partner Profile' : 'Register New Partner',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
            ),
            content: SizedBox(
              width: 650,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 2, child: AppTextField(controller: nameController, label: 'Partner Name *', hint: 'Enter partner name')),
                        AppSpacing.hMd,
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Type', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                              AppSpacing.vXs,
                              DropdownButtonFormField<String>(
                                initialValue: partnerType,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'individual', child: Text('Individual')),
                                  DropdownMenuItem(value: 'organization', child: Text('Organization')),
                                  DropdownMenuItem(value: 'institution', child: Text('Institution')),
                                ],
                                onChanged: (v) => setDialogState(() => partnerType = v!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vMd,
                    Row(
                      children: [
                        Expanded(child: AppTextField(controller: emailController, label: 'Email *', hint: 'partner@example.com')),
                        AppSpacing.hMd,
                        Expanded(child: AppTextField(controller: phoneController, label: 'Phone *', hint: '+91 9876543210')),
                      ],
                    ),
                    AppSpacing.vMd,
                    Row(
                      children: [
                        Expanded(child: AppTextField(controller: commController, label: 'Commission Rate (%)', hint: '10')),
                        AppSpacing.hMd,
                        Expanded(child: AppTextField(controller: contactController, label: 'Contact Person', hint: 'John Doe')),
                      ],
                    ),
                    AppSpacing.vMd,
                    Row(
                      children: [
                        Expanded(child: AppTextField(controller: cityController, label: 'City', hint: 'Mumbai')),
                        AppSpacing.hMd,
                        Expanded(child: AppTextField(controller: gstController, label: 'GST Number', hint: '27ABCDE1234F1Z5')),
                      ],
                    ),
                    AppSpacing.vLg,
                    Text('Bank Information', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                    AppSpacing.vSm,
                    Row(
                      children: [
                        Expanded(child: AppTextField(controller: bankController, label: 'Bank Name', hint: 'HDFC Bank')),
                        AppSpacing.hMd,
                        Expanded(child: AppTextField(controller: accController, label: 'Account Number', hint: '50100234567890')),
                        AppSpacing.hMd,
                        Expanded(child: AppTextField(controller: ifscController, label: 'IFSC Code', hint: 'HDFC0001234')),
                      ],
                    ),
                    AppSpacing.vMd,
                    Text('Notes', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                    AppSpacing.vXs,
                    TextFormField(
                      controller: notesController,
                      maxLines: 2,
                      decoration: const InputDecoration(hintText: 'Internal partner notes...'),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: const Text('Cancel'),
              ),
              AppButton(
                text: isEditing ? 'Update Profile' : 'Register Partner',
                icon: Icons.person_add_rounded,
                onPressed: () {
                  if (nameController.text.trim().isEmpty || emailController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all required fields.')),
                    );
                    return;
                  }
                  setState(() {
                    if (isEditing) {
                      partner['partnerName'] = nameController.text.trim();
                      partner['partnerType'] = partnerType;
                      partner['email'] = emailController.text.trim();
                      partner['phone'] = phoneController.text.trim();
                      partner['commissionRate'] = commController.text.trim();
                      partner['contactPerson'] = contactController.text.trim();
                      partner['city'] = cityController.text.trim();
                      partner['gstNumber'] = gstController.text.trim();
                      partner['bankName'] = bankController.text.trim();
                      partner['accountNumber'] = accController.text.trim();
                      partner['ifscCode'] = ifscController.text.trim();
                      partner['notes'] = notesController.text.trim();
                    } else {
                      _partners.add({
                        'id': '${DateTime.now().millisecondsSinceEpoch}',
                        'partnerName': nameController.text.trim(),
                        'partnerType': partnerType,
                        'email': emailController.text.trim(),
                        'phone': phoneController.text.trim(),
                        'city': cityController.text.trim(),
                        'commissionRate': commController.text.trim(),
                        'contactPerson': contactController.text.trim(),
                        'gstNumber': gstController.text.trim(),
                        'bankName': bankController.text.trim(),
                        'accountNumber': accController.text.trim(),
                        'ifscCode': ifscController.text.trim(),
                        'notes': notesController.text.trim(),
                        'status': 'active',
                        'joinedDate': DateTime.now().toString().split(' ')[0],
                      });
                    }
                  });
                  Navigator.of(dialogCtx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEditing ? 'Partner updated successfully!' : 'Partner registered successfully!'),
                      backgroundColor: AppColors.success,
                    ),
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

    final filteredPartners = _partners.where((p) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = (p['partnerName'] as String).toLowerCase();
        final email = (p['email'] as String).toLowerCase();
        final phone = (p['phone'] as String).toLowerCase();
        final city = (p['city'] as String? ?? '').toLowerCase();
        return name.contains(q) || email.contains(q) || phone.contains(q) || city.contains(q);
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

          // 4 Stats Cards
          _buildStatsCards(isMobile),
          AppSpacing.vXl,

          // Main Card with Search & Full-width DataTable
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
                        'Partners List',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 280),
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
                              hintText: 'Search by name, email, city...',
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
                            _buildDataColumn('PARTNER NAME', isDark),
                            _buildDataColumn('TYPE', isDark),
                            _buildDataColumn('EMAIL', isDark),
                            _buildDataColumn('PHONE', isDark),
                            _buildDataColumn('CITY', isDark),
                            _buildDataColumn('COMM.', isDark),
                            _buildDataColumn('STATUS', isDark),
                            _buildDataColumn('ACTIONS', isDark),
                          ],
                          rows: filteredPartners.map((partner) {
                            final name = partner['partnerName'] as String;
                            final type = partner['partnerType'] as String;
                            final email = partner['email'] as String;
                            final phone = partner['phone'] as String;
                            final city = partner['city'] as String? ?? 'N/A';
                            final comm = partner['commissionRate'] as String;
                            final status = partner['status'] as String;
                            final isOrg = type == 'organization';

                            return DataRow(
                              cells: [
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                                      if (partner['contactPerson'] != null)
                                        Text(partner['contactPerson'] as String, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                      borderRadius: AppRadius.sm,
                                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(isOrg ? Icons.apartment_rounded : Icons.person_outline_rounded, size: 13, color: AppColors.primary),
                                        AppSpacing.hXs,
                                        Text(type.toUpperCase(), style: AppTypography.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(Text(email, style: AppTypography.bodySmall)),
                                DataCell(Text(phone, style: AppTypography.bodySmall)),
                                DataCell(Text(city, style: AppTypography.bodySmall)),
                                DataCell(Text('$comm%', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary))),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: status == 'active' ? AppColors.success.withAlpha(20) : AppColors.borderLight.withAlpha(50),
                                      borderRadius: AppRadius.sm,
                                      border: Border.all(color: status == 'active' ? AppColors.success.withAlpha(60) : AppColors.borderLight),
                                    ),
                                    child: Text(
                                      status.toUpperCase(),
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: status == 'active' ? AppColors.success : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert_rounded, size: 18, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                    onSelected: (val) {
                                      if (val == 'view') {
                                        _openViewDialog(partner);
                                      } else if (val == 'edit') {
                                        _openPartnerFormDialog(partner: partner);
                                      } else if (val == 'transactions') {
                                        context.go(RouteNames.partnersTransactionsPath);
                                      } else if (val == 'delete') {
                                        setState(() => _partners.remove(partner));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Removed ${partner['partnerName']}.'), backgroundColor: AppColors.error),
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
                                            Text('Edit Partner'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'transactions',
                                        child: Row(
                                          children: [
                                            Icon(Icons.receipt_long_rounded, size: 16),
                                            SizedBox(width: 8),
                                            Text('Transactions'),
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

  Widget _buildStatsCards(bool isMobile) {
    final totalPartners = _partners.length;
    final activePartners = _partners.where((p) => p['status'] == 'active').length;

    final cards = [
      OrgStatsCard(
        title: 'Total Partners',
        value: '$totalPartners',
        subtitle: 'All registered affiliates',
        icon: Icons.handshake_outlined,
        variant: OrgStatsCardVariant.primary,
      ),
      OrgStatsCard(
        title: 'Active Partners',
        value: '$activePartners',
        subtitle: 'Active accounts',
        icon: Icons.check_circle_outline_rounded,
        variant: OrgStatsCardVariant.success,
      ),
      const OrgStatsCard(
        title: 'Avg. Commission',
        value: '9%',
        subtitle: 'Standard payout rate',
        icon: Icons.percent_rounded,
        variant: OrgStatsCardVariant.warning,
      ),
      const OrgStatsCard(
        title: 'Active Cities',
        value: '2',
        subtitle: 'Regional presence',
        icon: Icons.location_city_rounded,
        variant: OrgStatsCardVariant.info,
      ),
    ];

    if (isMobile) {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList(),
      );
    }

    return Row(
      children: cards
          .map(
            (c) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: c,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildHeader(bool isDark, bool isMobile) {
    final headerTexts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => context.go(RouteNames.partnersAllPath),
              child: Text(
                'Partners',
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
              'All Partners',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'All Partners',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Manage and view all registered partners',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionBtn = AppButton(
      text: 'Add New Partner',
      icon: Icons.add_rounded,
      onPressed: () => _openPartnerFormDialog(),
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
