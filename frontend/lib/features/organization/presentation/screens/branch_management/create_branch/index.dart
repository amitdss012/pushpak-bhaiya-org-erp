import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/utils/image_picker_helper.dart';

import '../../../../../../api/models/models.dart';
import '../../../../../../api/repo/branch/branch_repo.dart';
import '../../../../../../app/router/route_names.dart';
import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_radius.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../app/theme/app_typography.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/app_card.dart';
import '../../../../../../shared/widgets/app_text_field.dart';
import '../../../../../../shared/widgets/upload_progress_overlay.dart';

class CreateBranchScreen extends StatefulWidget {
  const CreateBranchScreen({super.key});

  @override
  State<CreateBranchScreen> createState() => _CreateBranchScreenState();
}

class _CreateBranchScreenState extends State<CreateBranchScreen> {
  final _formKey = GlobalKey<FormState>();

  Uint8List? _logoBytes;
  String? _logoFileName;
  String? _logoSizeFormatted;
  final Map<String, CompressedImageResult> _uploadedDocuments = {};
  bool _isSubmitting = false;

  // Fullscreen Upload / Processing Overlay State
  bool _isOverlayVisible = false;
  double? _overlayProgress;
  String _overlayTitle = 'Uploading Image';
  String _overlayStatus = 'Compressing image under 100 KB...';

  // 1. Branch Info
  final _scrollController = ScrollController();
  final _branchNameController = TextEditingController();
  final _branchCodeController = TextEditingController();
  String? _branchType = 'main';
  String? _instituteType = 'computer';
  String? _academicYear = '2024-25';
  final _establishedYearController = TextEditingController();
  final _websiteController = TextEditingController();
  final _descriptionController = TextEditingController();

  // 2. Address Details
  final _streetAddressController = TextEditingController();
  String? _state = 'maharashtra';
  final _districtController = TextEditingController();
  final _blockController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  String? _country = 'india';

  // 3. Contact Info
  final _phoneController = TextEditingController();
  final _altPhoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _emailController = TextEditingController();

  // 4. Director Info
  final _directorNameController = TextEditingController();
  String? _directorGender = 'male';
  final _directorDobController = TextEditingController();
  String? _directorBloodGroup = 'b+';

  // 5. Space & Facilities
  final _numComputersController = TextEditingController(text: '0');
  final _numFacultyController = TextEditingController(text: '0');
  final _numRoomsController = TextEditingController(text: '0');
  final _numFeesController = TextEditingController(text: '0');
  final _registrationDateController = TextEditingController();
  final _validDateController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _renewalDateController = TextEditingController();
  final _referralCodeController = TextEditingController();

  // 6. Admin Credentials
  final _adminNameController = TextEditingController();
  final _adminUsernameController = TextEditingController();
  final _adminPasswordController = TextEditingController();
  final _adminEmailController = TextEditingController();
  final _adminPhoneController = TextEditingController();

  // 7. Settings Switches
  bool _activeStatus = true;
  bool _onlineEnrollment = true;
  bool _smsNotifications = false;
  bool _emailNotifications = true;

  @override
  void dispose() {
    _branchNameController.dispose();
    _branchCodeController.dispose();
    _establishedYearController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    _streetAddressController.dispose();
    _districtController.dispose();
    _blockController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _directorNameController.dispose();
    _directorDobController.dispose();
    _numComputersController.dispose();
    _numFacultyController.dispose();
    _numRoomsController.dispose();
    _numFeesController.dispose();
    _registrationDateController.dispose();
    _validDateController.dispose();
    _expiryDateController.dispose();
    _renewalDateController.dispose();
    _referralCodeController.dispose();
    _adminNameController.dispose();
    _adminUsernameController.dispose();
    _adminPasswordController.dispose();
    _adminEmailController.dispose();
    _adminPhoneController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2040),
    );
    if (picked != null) {
      controller.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _pickLogo() async {
    try {
      final result = await ImagePickerHelper.pickAndCompressImage(
        onProgress: (progress, status) {
          if (mounted) {
            setState(() {
              _isOverlayVisible = progress < 1.0;
              _overlayTitle = 'Optimizing Branch Logo';
              _overlayProgress = progress;
              _overlayStatus = status;
            });
          }
        },
      );
      if (result != null) {
        setState(() {
          _logoBytes = result.bytes;
          _logoFileName = result.fileName;
          _logoSizeFormatted = result.formattedSize;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logo compressed to ${result.formattedSize} (under 100 KB limit)'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick logo file: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isOverlayVisible = false;
          _overlayProgress = null;
        });
      }
    }
  }

  Future<void> _pickDocument(String label) async {
    try {
      final result = await ImagePickerHelper.pickAndCompressImage(
        onProgress: (progress, status) {
          if (mounted) {
            setState(() {
              _isOverlayVisible = progress < 1.0;
              _overlayTitle = 'Optimizing $label';
              _overlayProgress = progress;
              _overlayStatus = status;
            });
          }
        },
      );
      if (result != null) {
        setState(() {
          _uploadedDocuments[label] = result;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label uploaded (${result.formattedSize}, under 100 KB)'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick file: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isOverlayVisible = false;
          _overlayProgress = null;
        });
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _isOverlayVisible = true;
      _overlayTitle = _logoBytes != null ? 'Creating Branch & Uploading Logo' : 'Creating Branch';
      _overlayProgress = 0.05;
      _overlayStatus = 'Uploading data to server...';
    });
    try {
      final req = CreateBranchRequest(
        name: _branchNameController.text.trim(),
        code: _branchCodeController.text.trim(),
        branchType: _branchType ?? 'main',
        instituteType: _instituteType ?? 'computer',
        establishedYear: _establishedYearController.text.trim(),
        website: _websiteController.text.trim(),
        description: _descriptionController.text.trim(),
        address: _streetAddressController.text.trim(),
        city: _cityController.text.trim(),
        district: _districtController.text.trim(),
        block: _blockController.text.trim(),
        state: _state,
        country: _country ?? 'IN',
        pincode: _pincodeController.text.trim(),
        latitude: double.tryParse(_latitudeController.text.trim()),
        longitude: double.tryParse(_longitudeController.text.trim()),
        phone: _phoneController.text.trim(),
        altPhone: _altPhoneController.text.trim(),
        whatsapp: _whatsappController.text.trim(),
        email: _emailController.text.trim(),
        directorName: _directorNameController.text.trim(),
        directorGender: _directorGender,
        directorDob: _directorDobController.text.trim(),
        directorBloodGroup: _directorBloodGroup,
        numComputers: int.tryParse(_numComputersController.text.trim()) ?? 0,
        numFaculty: int.tryParse(_numFacultyController.text.trim()) ?? 0,
        numRooms: int.tryParse(_numRoomsController.text.trim()) ?? 0,
        numFees: double.tryParse(_numFeesController.text.trim()),
        registrationDate: _registrationDateController.text.trim(),
        validDate: _validDateController.text.trim(),
        expiryDate: _expiryDateController.text.trim(),
        renewalDate: _renewalDateController.text.trim(),
        referralCode: _referralCodeController.text.trim(),
        activeStatus: _activeStatus,
        onlineEnrollment: _onlineEnrollment,
        smsNotifications: _smsNotifications,
        emailNotifications: _emailNotifications,
        adminName: _adminNameController.text.trim(),
        adminUsername: _adminUsernameController.text.trim(),
        adminPassword: _adminPasswordController.text.trim(),
        adminEmail: _adminEmailController.text.trim(),
        adminPhone: _adminPhoneController.text.trim(),
      );

      final newBranch = await BranchRepo.createBranch(
        req,
        logoBytes: _logoBytes,
        logoFileName: _logoFileName,
        onSendProgress: (sent, total) {
          if (total > 0 && mounted) {
            setState(() {
              _overlayProgress = (sent / total).clamp(0.0, 1.0);
              _overlayStatus = 'Uploading: ${((sent / total) * 100).toInt()}% (${(sent / 1024).toStringAsFixed(0)} / ${(total / 1024).toStringAsFixed(0)} KB)';
            });
          }
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Branch "${newBranch.name}" created successfully!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go(RouteNames.branchViewPath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception:', '').trim()),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _isOverlayVisible = false;
          _overlayProgress = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isDesktop = context.isDesktop || context.isUltraWide;
    final isMobile = context.isMobile;

    return UploadProgressOverlay(
      isVisible: _isOverlayVisible,
      progress: _overlayProgress,
      title: _overlayTitle,
      status: _overlayStatus,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
            _buildPageHeader(isDark),
            AppSpacing.vXl,

            // Main 2-column or 1-column layout
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Main Form Sections
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildBranchInfoCard(isDark),
                        AppSpacing.vLg,
                        _buildAddressCard(isDark),
                        AppSpacing.vLg,
                        _buildContactCard(isDark),
                        AppSpacing.vLg,
                        _buildDirectorCard(isDark),
                        AppSpacing.vLg,
                        _buildSpaceFacilitiesCard(isDark),
                        AppSpacing.vLg,
                        _buildDocumentsCard(isDark),
                      ],
                    ),
                  ),
                  AppSpacing.hLg,

                  // Right Column: Logo, Admin, Settings
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildLogoCard(isDark),
                        AppSpacing.vLg,
                        _buildAdminCredentialsCard(isDark),
                        AppSpacing.vLg,
                        _buildSettingsCard(isDark),
                      ],
                    ),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBranchInfoCard(isDark),
                  AppSpacing.vLg,
                  _buildAddressCard(isDark),
                  AppSpacing.vLg,
                  _buildContactCard(isDark),
                  AppSpacing.vLg,
                  _buildDirectorCard(isDark),
                  AppSpacing.vLg,
                  _buildSpaceFacilitiesCard(isDark),
                  AppSpacing.vLg,
                  _buildDocumentsCard(isDark),
                  AppSpacing.vLg,
                  _buildLogoCard(isDark),
                  AppSpacing.vLg,
                  _buildAdminCredentialsCard(isDark),
                  AppSpacing.vLg,
                  _buildSettingsCard(isDark),
                ],
              ),

            AppSpacing.vXl,

            // Bottom Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  text: 'Cancel',
                  variant: AppButtonVariant.outline,
                  onPressed: () => context.go(RouteNames.branchViewPath),
                ),
                AppSpacing.hMd,
                AppButton(
                  text: 'Create Branch',
                  icon: Icons.add_business_rounded,
                  isLoading: _isSubmitting,
                  onPressed: _isSubmitting ? null : _handleSubmit,
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildPageHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => context.go(RouteNames.branchViewPath),
              child: Text(
                'Branch Management',
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
              'Create Branch',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Create Branch',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Add a new branch to your institution',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  // 1. Branch Information
  Widget _buildBranchInfoCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(Icons.business_rounded, 'Branch Information', isDark),
          AppSpacing.vLg,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  controller: _branchNameController,
                  label: 'Branch Name *',
                  hint: 'Enter branch name',
                  validator: (v) => v == null || v.trim().isEmpty ? 'Branch name is required.' : null,
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _branchCodeController,
                  label: 'Branch Code *',
                  hint: 'e.g., BR001',
                  validator: (v) => v == null || v.trim().isEmpty ? 'Branch code is required.' : null,
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Branch Type', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _branchType,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'main', child: Text('Main Branch')),
                        DropdownMenuItem(value: 'sub', child: Text('Sub Branch')),
                        DropdownMenuItem(value: 'franchise', child: Text('Franchise')),
                      ],
                      onChanged: (v) => setState(() => _branchType = v),
                    ),
                  ],
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Institute Type *', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _instituteType,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'computer', child: Text('Computer Institute')),
                        DropdownMenuItem(value: 'typing', child: Text('Typing Institute')),
                        DropdownMenuItem(value: 'paramedical', child: Text('Paramedical Institute')),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (v) => setState(() => _instituteType = v),
                    ),
                  ],
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Academic Year *', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _academicYear,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: '2024-25', child: Text('2024-25')),
                        DropdownMenuItem(value: '2025-26', child: Text('2025-26')),
                        DropdownMenuItem(value: '2026-27', child: Text('2026-27')),
                        DropdownMenuItem(value: '2027-28', child: Text('2027-28')),
                      ],
                      onChanged: (v) => setState(() => _academicYear = v),
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
                child: AppTextField(
                  controller: _establishedYearController,
                  label: 'Established Year',
                  hint: 'e.g., 2020',
                  keyboardType: TextInputType.number,
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _websiteController,
                  label: 'Website',
                  hint: 'https://branch.example.com',
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel('Description', isDark),
              AppSpacing.vXs,
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Brief description of the branch',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. Address Details
  Widget _buildAddressCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(Icons.location_on_outlined, 'Address Details', isDark),
          AppSpacing.vLg,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel('Street Address *', isDark),
              AppSpacing.vXs,
              TextFormField(
                controller: _streetAddressController,
                maxLines: 2,
                validator: (v) => v == null || v.trim().isEmpty ? 'Address is required.' : null,
                decoration: const InputDecoration(hintText: 'Enter full address'),
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
                    _buildFieldLabel('State *', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _state,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'andhra-pradesh', child: Text('Andhra Pradesh')),
                        DropdownMenuItem(value: 'bihar', child: Text('Bihar')),
                        DropdownMenuItem(value: 'delhi', child: Text('Delhi')),
                        DropdownMenuItem(value: 'gujarat', child: Text('Gujarat')),
                        DropdownMenuItem(value: 'karnataka', child: Text('Karnataka')),
                        DropdownMenuItem(value: 'maharashtra', child: Text('Maharashtra')),
                        DropdownMenuItem(value: 'punjab', child: Text('Punjab')),
                        DropdownMenuItem(value: 'rajasthan', child: Text('Rajasthan')),
                        DropdownMenuItem(value: 'tamil-nadu', child: Text('Tamil Nadu')),
                        DropdownMenuItem(value: 'uttar-pradesh', child: Text('Uttar Pradesh')),
                        DropdownMenuItem(value: 'west-bengal', child: Text('West Bengal')),
                      ],
                      onChanged: (v) => setState(() => _state = v),
                    ),
                  ],
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _districtController,
                  label: 'District *',
                  hint: 'Enter district',
                  validator: (v) => v == null || v.trim().isEmpty ? 'District required.' : null,
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _blockController,
                  label: 'Block',
                  hint: 'Enter block',
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _cityController,
                  label: 'City *',
                  hint: 'City',
                  validator: (v) => v == null || v.trim().isEmpty ? 'City required.' : null,
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _pincodeController,
                  label: 'Pincode *',
                  hint: 'Pincode',
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Pincode required.' : null,
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _latitudeController,
                  label: 'Latitude',
                  hint: 'e.g., 28.6139',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _longitudeController,
                  label: 'Longitude',
                  hint: 'e.g., 77.2090',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel('Country', isDark),
              AppSpacing.vXs,
              DropdownButtonFormField<String>(
                initialValue: _country,
                decoration: const InputDecoration(),
                items: const [
                  DropdownMenuItem(value: 'india', child: Text('India')),
                  DropdownMenuItem(value: 'usa', child: Text('United States')),
                  DropdownMenuItem(value: 'uk', child: Text('United Kingdom')),
                  DropdownMenuItem(value: 'canada', child: Text('Canada')),
                ],
                onChanged: (v) => setState(() => _country = v),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. Contact Information
  Widget _buildContactCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(Icons.phone_outlined, 'Contact Information', isDark),
          AppSpacing.vLg,
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _phoneController,
                  label: 'Phone Number *',
                  hint: '+91 XXXXX XXXXX',
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Phone is required.' : null,
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _altPhoneController,
                  label: 'Alternate Phone',
                  hint: '+91 XXXXX XXXXX',
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _whatsappController,
                  label: 'WhatsApp Number',
                  hint: '+91 XXXXX XXXXX',
                  keyboardType: TextInputType.phone,
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _emailController,
                  label: 'Email Address *',
                  hint: 'branch@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Email is required.' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 4. Director Information
  Widget _buildDirectorCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(Icons.person_outline_rounded, 'Director Information', isDark),
          AppSpacing.vLg,
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _directorNameController,
                  label: 'Director Name *',
                  hint: 'Enter director name',
                  validator: (v) => v == null || v.trim().isEmpty ? 'Director name required.' : null,
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Gender *', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _directorGender,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('Male')),
                        DropdownMenuItem(value: 'female', child: Text('Female')),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (v) => setState(() => _directorGender = v),
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
                child: InkWell(
                  onTap: () => _pickDate(_directorDobController),
                  child: IgnorePointer(
                    child: AppTextField(
                      controller: _directorDobController,
                      label: 'Date of Birth *',
                      hint: 'YYYY-MM-DD',
                      suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                      validator: (v) => v == null || v.trim().isEmpty ? 'DOB required.' : null,
                    ),
                  ),
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Blood Group', isDark),
                    AppSpacing.vXs,
                    DropdownButtonFormField<String>(
                      initialValue: _directorBloodGroup,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'a+', child: Text('A+')),
                        DropdownMenuItem(value: 'a-', child: Text('A-')),
                        DropdownMenuItem(value: 'b+', child: Text('B+')),
                        DropdownMenuItem(value: 'b-', child: Text('B-')),
                        DropdownMenuItem(value: 'ab+', child: Text('AB+')),
                        DropdownMenuItem(value: 'ab-', child: Text('AB-')),
                        DropdownMenuItem(value: 'o+', child: Text('O+')),
                        DropdownMenuItem(value: 'o-', child: Text('O-')),
                      ],
                      onChanged: (v) => setState(() => _directorBloodGroup = v),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.vLg,
          Row(
            children: [
              Expanded(child: _buildUploadBox('Director Photo', 'Upload photo', isDark)),
              AppSpacing.hMd,
              Expanded(child: _buildUploadBox('Director Signature', 'Upload signature', isDark)),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(child: _buildUploadBox('Aadhar Card (Front)', 'Upload front side', isDark)),
              AppSpacing.hMd,
              Expanded(child: _buildUploadBox('Aadhar Card (Back)', 'Upload back side', isDark)),
            ],
          ),
        ],
      ),
    );
  }

  // 5. Space & Facilities
  Widget _buildSpaceFacilitiesCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(Icons.grid_view_rounded, 'Space & Facilities', isDark),
          AppSpacing.vLg,
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _numComputersController,
                  label: 'Computers',
                  hint: '0',
                  keyboardType: TextInputType.number,
                ),
              ),
              AppSpacing.hSm,
              Expanded(
                child: AppTextField(
                  controller: _numFacultyController,
                  label: 'Faculty',
                  hint: '0',
                  keyboardType: TextInputType.number,
                ),
              ),
              AppSpacing.hSm,
              Expanded(
                child: AppTextField(
                  controller: _numRoomsController,
                  label: 'Rooms',
                  hint: '0',
                  keyboardType: TextInputType.number,
                ),
              ),
              AppSpacing.hSm,
              Expanded(
                child: AppTextField(
                  controller: _numFeesController,
                  label: 'Fee Types',
                  hint: '0',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          AppSpacing.vLg,
          const Divider(height: 1),
          AppSpacing.vMd,
          Row(
            children: [
              const Icon(Icons.event_note_rounded, size: 16, color: AppColors.primary),
              AppSpacing.hXs,
              Text(
                'Registration & Validity',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _pickDate(_registrationDateController),
                  child: IgnorePointer(
                    child: AppTextField(
                      controller: _registrationDateController,
                      label: 'Registration Date *',
                      hint: 'YYYY-MM-DD',
                      suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required.' : null,
                    ),
                  ),
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: InkWell(
                  onTap: () => _pickDate(_validDateController),
                  child: IgnorePointer(
                    child: AppTextField(
                      controller: _validDateController,
                      label: 'Valid From',
                      hint: 'YYYY-MM-DD',
                      suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                    ),
                  ),
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: InkWell(
                  onTap: () => _pickDate(_expiryDateController),
                  child: IgnorePointer(
                    child: AppTextField(
                      controller: _expiryDateController,
                      label: 'Expiry Date *',
                      hint: 'YYYY-MM-DD',
                      suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required.' : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _pickDate(_renewalDateController),
                  child: IgnorePointer(
                    child: AppTextField(
                      controller: _renewalDateController,
                      label: 'Renewal Date',
                      hint: 'YYYY-MM-DD',
                      suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                    ),
                  ),
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _referralCodeController,
                  label: 'Referral Code',
                  hint: 'Enter referral code',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 6. Branch Documents
  Widget _buildDocumentsCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(Icons.description_outlined, 'Branch Documents', isDark),
          AppSpacing.vLg,
          Row(
            children: [
              Expanded(child: _buildUploadBox('Branch Mohar (Stamp)', 'Upload mohar/stamp', isDark)),
              AppSpacing.hMd,
              Expanded(child: _buildUploadBox('Branch Photo', 'Upload branch photo', isDark)),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(child: _buildUploadBox('Lab Photo', 'Upload lab photo', isDark)),
              AppSpacing.hMd,
              Expanded(child: _buildUploadBox('Status Document', 'Upload status document', isDark)),
            ],
          ),
        ],
      ),
    );
  }

  // 7. Right Side: Logo Card
  Widget _buildLogoCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Branch Logo',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          AppSpacing.vMd,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight,
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                style: BorderStyle.solid,
              ),
            ),
            child: _logoBytes != null
                ? Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          _logoBytes!,
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                          cacheWidth: 192,
                          cacheHeight: 192,
                          gaplessPlayback: true,
                          filterQuality: FilterQuality.low,
                        ),
                      ),
                      AppSpacing.vSm,
                      Text(
                        _logoFileName ?? 'Selected Logo',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      if (_logoSizeFormatted != null)
                        Text(
                          'Size: $_logoSizeFormatted (under 100 KB)',
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      AppSpacing.vSm,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppButton(
                            text: 'Change',
                            variant: AppButtonVariant.outline,
                            height: 30,
                            onPressed: _pickLogo,
                          ),
                          AppSpacing.hSm,
                          AppButton(
                            text: 'Remove',
                            variant: AppButtonVariant.text,
                            height: 30,
                            onPressed: () {
                              setState(() {
                                _logoBytes = null;
                                _logoFileName = null;
                                _logoSizeFormatted = null;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Icon(Icons.cloud_upload_outlined, size: 36, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                      AppSpacing.vSm,
                      Text(
                        'Upload branch logo',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      AppSpacing.vSm,
                      AppButton(
                        text: 'Choose File',
                        variant: AppButtonVariant.outline,
                        height: 32,
                        onPressed: _pickLogo,
                      ),
                      AppSpacing.vXs,
                      Text(
                        'PNG, JPG up to 5MB (auto-compressed <100KB)',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 10.5,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // 8. Right Side: Admin Credentials
  Widget _buildAdminCredentialsCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(Icons.verified_user_outlined, 'Branch Admin Credentials', isDark),
          AppSpacing.vLg,
          AppTextField(
            controller: _adminNameController,
            label: 'Admin Name *',
            hint: 'Branch admin name',
            validator: (v) => v == null || v.trim().isEmpty ? 'Admin name is required.' : null,
          ),
          AppSpacing.vMd,
          AppTextField(
            controller: _adminUsernameController,
            label: 'Admin Username *',
            hint: 'admin_username',
            validator: (v) => v == null || v.trim().isEmpty ? 'Username required.' : null,
          ),
          AppSpacing.vMd,
          AppTextField(
            controller: _adminPasswordController,
            label: 'Admin Password *',
            hint: '••••••••',
            obscureText: true,
            validator: (v) => v == null || v.trim().isEmpty ? 'Password required.' : null,
          ),
          AppSpacing.vMd,
          AppTextField(
            controller: _adminEmailController,
            label: 'Admin Email',
            hint: 'admin@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          AppSpacing.vMd,
          AppTextField(
            controller: _adminPhoneController,
            label: 'Admin Phone',
            hint: '+91 XXXXX XXXXX',
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  // 9. Right Side: Settings Switches
  Widget _buildSettingsCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Branch Settings',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          AppSpacing.vMd,
          _buildSwitchTile('Active Status', 'Enable/disable branch', _activeStatus, (v) => setState(() => _activeStatus = v), isDark),
          const Divider(height: 1),
          _buildSwitchTile('Online Enrollment', 'Accept online admissions', _onlineEnrollment, (v) => setState(() => _onlineEnrollment = v), isDark),
          const Divider(height: 1),
          _buildSwitchTile('SMS Notifications', 'Send SMS alerts', _smsNotifications, (v) => setState(() => _smsNotifications = v), isDark),
          const Divider(height: 1),
          _buildSwitchTile('Email Notifications', 'Send email updates', _emailNotifications, (v) => setState(() => _emailNotifications = v), isDark),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildCardTitle(IconData icon, String title, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        AppSpacing.hSm,
        Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label, bool isDark) {
    return Text(
      label,
      style: AppTypography.labelMedium.copyWith(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildUploadBox(String label, String hint, bool isDark) {
    final uploaded = _uploadedDocuments[label];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(label, isDark),
        AppSpacing.vXs,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: uploaded != null
                ? AppColors.success.withAlpha(isDark ? 30 : 15)
                : (isDark ? AppColors.backgroundDark.withAlpha(80) : AppColors.backgroundLight),
            borderRadius: AppRadius.md,
            border: Border.all(
              color: uploaded != null
                  ? AppColors.success
                  : (isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
          ),
          child: uploaded != null
              ? Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        uploaded.bytes,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        cacheWidth: 112,
                        cacheHeight: 112,
                        gaplessPlayback: true,
                        filterQuality: FilterQuality.low,
                      ),
                    ),
                    AppSpacing.vXs,
                    Text(
                      uploaded.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      '${uploaded.formattedSize} (under 100 KB)',
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 10,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppSpacing.vSm,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton(
                          text: 'Change',
                          variant: AppButtonVariant.outline,
                          height: 26,
                          onPressed: () => _pickDocument(label),
                        ),
                        AppSpacing.hSm,
                        AppButton(
                          text: 'Remove',
                          variant: AppButtonVariant.text,
                          height: 26,
                          onPressed: () => setState(() => _uploadedDocuments.remove(label)),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    Icon(Icons.cloud_upload_outlined,
                        size: 28,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    AppSpacing.vXs,
                    Text(
                      hint,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 11,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    AppSpacing.vSm,
                    AppButton(
                      text: 'Choose File',
                      variant: AppButtonVariant.outline,
                      height: 28,
                      onPressed: () => _pickDocument(label),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
