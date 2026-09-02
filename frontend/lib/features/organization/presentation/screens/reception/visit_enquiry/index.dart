import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import 'follow_up_details_card.dart';
import 'id_document_card.dart';
import 'quick_actions_card.dart';
import 'visit_details_card.dart';
import 'visit_enquiry_actions.dart';
import 'visit_enquiry_header.dart';
import 'visitor_information_card.dart';
import 'visitor_photo_card.dart';

class VisitEnquiryScreen extends StatefulWidget {
  const VisitEnquiryScreen({super.key});

  @override
  State<VisitEnquiryScreen> createState() => _VisitEnquiryScreenState();
}

class _VisitEnquiryScreenState extends State<VisitEnquiryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Visitor Information Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedIdType;
  final _idNumberController = TextEditingController();
  final _companyController = TextEditingController();
  final _addressController = TextEditingController();

  // Visit Details Controllers
  late final TextEditingController _visitDateController;
  late final TextEditingController _visitTimeController;
  String? _selectedPurpose;
  String? _selectedPersonToMeet;
  String? _selectedDepartment;
  final _noOfPersonsController = TextEditingController(text: '1');
  final _enquiryReasonController = TextEditingController();
  final _locationController = TextEditingController();
  final _remarksController = TextEditingController();

  // Follow-up Details Controllers
  final _followUpDateController = TextEditingController();
  final _followUpTimeController = TextEditingController();
  final _followUpNotesController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visitDateController = TextEditingController(
      text:
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
    );
    _visitTimeController = TextEditingController(
      text:
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _idNumberController.dispose();
    _companyController.dispose();
    _addressController.dispose();

    _visitDateController.dispose();
    _visitTimeController.dispose();
    _noOfPersonsController.dispose();
    _enquiryReasonController.dispose();
    _locationController.dispose();
    _remarksController.dispose();

    _followUpDateController.dispose();
    _followUpTimeController.dispose();
    _followUpNotesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API registration call
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visitor Registered',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Visit enquiry has been successfully recorded.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCancel() {
    context.go('/reception/visitors');
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isMobile = context.isMobile;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 28,
        vertical: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Page Header
            const VisitEnquiryHeader(),
            AppSpacing.vXl,

            // Main Grid Section (2:1 split on Desktop, Stacked on Mobile/Tablet)
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Main Form Cards (flex: 2)
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        VisitorInformationCard(
                          nameController: _nameController,
                          phoneController: _phoneController,
                          emailController: _emailController,
                          selectedIdType: _selectedIdType,
                          onIdTypeChanged: (val) =>
                              setState(() => _selectedIdType = val),
                          idNumberController: _idNumberController,
                          companyController: _companyController,
                          addressController: _addressController,
                        ),
                        AppSpacing.vXl,
                        VisitDetailsCard(
                          visitDateController: _visitDateController,
                          visitTimeController: _visitTimeController,
                          selectedPurpose: _selectedPurpose,
                          onPurposeChanged: (val) =>
                              setState(() => _selectedPurpose = val),
                          selectedPersonToMeet: _selectedPersonToMeet,
                          onPersonToMeetChanged: (val) =>
                              setState(() => _selectedPersonToMeet = val),
                          selectedDepartment: _selectedDepartment,
                          onDepartmentChanged: (val) =>
                              setState(() => _selectedDepartment = val),
                          noOfPersonsController: _noOfPersonsController,
                          enquiryReasonController: _enquiryReasonController,
                          locationController: _locationController,
                          remarksController: _remarksController,
                        ),
                        AppSpacing.vXl,
                        FollowUpDetailsCard(
                          followUpDateController: _followUpDateController,
                          followUpTimeController: _followUpTimeController,
                          followUpNotesController: _followUpNotesController,
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.hXl,

                  // Right Column: Side Utility Cards (flex: 1)
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        const VisitorPhotoCard(),
                        AppSpacing.vXl,
                        const QuickActionsCard(),
                        AppSpacing.vXl,
                        const IdDocumentCard(),
                      ],
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  VisitorInformationCard(
                    nameController: _nameController,
                    phoneController: _phoneController,
                    emailController: _emailController,
                    selectedIdType: _selectedIdType,
                    onIdTypeChanged: (val) =>
                        setState(() => _selectedIdType = val),
                    idNumberController: _idNumberController,
                    companyController: _companyController,
                    addressController: _addressController,
                  ),
                  AppSpacing.vLg,
                  VisitDetailsCard(
                    visitDateController: _visitDateController,
                    visitTimeController: _visitTimeController,
                    selectedPurpose: _selectedPurpose,
                    onPurposeChanged: (val) =>
                        setState(() => _selectedPurpose = val),
                    selectedPersonToMeet: _selectedPersonToMeet,
                    onPersonToMeetChanged: (val) =>
                        setState(() => _selectedPersonToMeet = val),
                    selectedDepartment: _selectedDepartment,
                    onDepartmentChanged: (val) =>
                        setState(() => _selectedDepartment = val),
                    noOfPersonsController: _noOfPersonsController,
                    enquiryReasonController: _enquiryReasonController,
                    locationController: _locationController,
                    remarksController: _remarksController,
                  ),
                  AppSpacing.vLg,
                  FollowUpDetailsCard(
                    followUpDateController: _followUpDateController,
                    followUpTimeController: _followUpTimeController,
                    followUpNotesController: _followUpNotesController,
                  ),
                  AppSpacing.vLg,
                  const VisitorPhotoCard(),
                  AppSpacing.vLg,
                  const QuickActionsCard(),
                  AppSpacing.vLg,
                  const IdDocumentCard(),
                ],
              ),
            AppSpacing.vLg,

            // Bottom Actions Bar
            VisitEnquiryActions(
              isSubmitting: _isSubmitting,
              onCancel: _handleCancel,
              onSubmit: _handleSubmit,
            ),
            AppSpacing.vXl,
          ],
        ),
      ),
    );
  }
}
