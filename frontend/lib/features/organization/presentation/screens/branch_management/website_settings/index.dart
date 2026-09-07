import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/utils/image_picker_helper.dart';

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

class BranchWebsiteSettingsScreen extends StatefulWidget {
  const BranchWebsiteSettingsScreen({super.key});

  @override
  State<BranchWebsiteSettingsScreen> createState() => _BranchWebsiteSettingsScreenState();
}

class _BranchWebsiteSettingsScreenState extends State<BranchWebsiteSettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, CompressedImageResult> _uploadedFiles = {};

  // Fullscreen Upload / Processing Overlay State
  bool _isOverlayVisible = false;
  double? _overlayProgress;
  String _overlayTitle = 'Uploading Image';
  String _overlayStatus = 'Compressing image under 100 KB...';

  // General Tab Controllers
  final _siteNameController = TextEditingController(text: 'ABC School - Main Campus');
  final _taglineController = TextEditingController(text: 'Excellence in Education Since 1990');
  final _metaDescriptionController = TextEditingController(text: 'Leading educational institution providing quality education...');
  final _metaKeywordsController = TextEditingController(text: 'school, education, learning, courses');

  final _domainController = TextEditingController(text: 'https://abcschool.edu');
  final _subdomainController = TextEditingController(text: 'main');
  bool _sslCertificate = true;
  bool _wwwRedirect = true;

  final _contactEmailController = TextEditingController(text: 'info@abcschool.edu');
  final _contactPhoneController = TextEditingController(text: '+91 98765 43210');
  final _contactAddressController = TextEditingController(text: '123 Education Street, Mumbai, Maharashtra 400001');

  bool _onlineAdmissions = true;
  bool _onlineFeePayment = true;
  bool _studentPortal = true;
  bool _parentPortal = false;

  final _registrationDateController = TextEditingController(text: '2024-01-01');
  final _expiryDateController = TextEditingController(text: '2025-01-01');
  final _renewalDateController = TextEditingController(text: '2024-12-25');

  // Media Tab Controllers
  final _heroTitleController = TextEditingController(text: 'Welcome to ABC School');
  final _heroSubtitleController = TextEditingController(text: "Shaping Tomorrow's Leaders Today");

  // Social Tab Controllers
  final _facebookController = TextEditingController(text: 'https://facebook.com/yourpage');
  final _twitterController = TextEditingController(text: 'https://twitter.com/yourhandle');
  final _instagramController = TextEditingController(text: 'https://instagram.com/yourprofile');
  final _linkedinController = TextEditingController(text: 'https://linkedin.com/company/yourcompany');
  final _youtubeController = TextEditingController(text: 'https://youtube.com/yourchannel');
  final _whatsappController = TextEditingController(text: '+91 98765 43210');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _siteNameController.dispose();
    _taglineController.dispose();
    _metaDescriptionController.dispose();
    _metaKeywordsController.dispose();
    _domainController.dispose();
    _subdomainController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    _contactAddressController.dispose();
    _registrationDateController.dispose();
    _expiryDateController.dispose();
    _renewalDateController.dispose();
    _heroTitleController.dispose();
    _heroSubtitleController.dispose();
    _facebookController.dispose();
    _twitterController.dispose();
    _instagramController.dispose();
    _linkedinController.dispose();
    _youtubeController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  void _handleSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Website settings saved successfully!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isMobile = context.isMobile;

    return UploadProgressOverlay(
      isVisible: _isOverlayVisible,
      progress: _overlayProgress,
      title: _overlayTitle,
      status: _overlayStatus,
      child: SingleChildScrollView(
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

          // Tab Bar
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                borderRadius: AppRadius.md,
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                labelColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                unselectedLabelColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.language_rounded, size: 16),
                        SizedBox(width: 6),
                        Text('General'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined, size: 16),
                        SizedBox(width: 6),
                        Text('Media'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.share_outlined, size: 16),
                        SizedBox(width: 6),
                        Text('Social'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.vLg,

          // Tab Contents
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, child) {
              if (_tabController.index == 0) {
                return _buildGeneralTab(isDark);
              } else if (_tabController.index == 1) {
                return _buildMediaTab(isDark);
              } else {
                return _buildSocialTab(isDark);
              }
            },
          ),
        ],
      ),
    ));
  }

  // 1. General Tab
  Widget _buildGeneralTab(bool isDark) {
    final isDesktop = context.isDesktop || context.isUltraWide;

    final basicInfoCard = AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(Icons.info_outline_rounded, 'Basic Information', isDark),
          AppSpacing.vXs,
          Text("Configure your website's basic details", style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          AppSpacing.vLg,
          AppTextField(controller: _siteNameController, label: 'Website Name', hint: 'ABC School - Main Campus'),
          AppSpacing.vMd,
          AppTextField(controller: _taglineController, label: 'Tagline', hint: 'Excellence in Education Since 1990'),
          AppSpacing.vMd,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel('Meta Description', isDark),
              AppSpacing.vXs,
              TextFormField(controller: _metaDescriptionController, maxLines: 3, decoration: const InputDecoration()),
            ],
          ),
          AppSpacing.vMd,
          AppTextField(controller: _metaKeywordsController, label: 'Meta Keywords', hint: 'school, education, learning'),
        ],
      ),
    );

    final domainCard = AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(Icons.public_rounded, 'Domain & URL Settings', isDark),
          AppSpacing.vXs,
          Text('Configure your website URL settings', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          AppSpacing.vLg,
          AppTextField(controller: _domainController, label: 'Primary Domain', hint: 'https://abcschool.edu'),
          AppSpacing.vMd,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel('Branch Subdomain', isDark),
              AppSpacing.vXs,
              Row(
                children: [
                  Expanded(child: AppTextField(controller: _subdomainController, hint: 'main')),
                  AppSpacing.hSm,
                  Text('.abcschool.edu', style: AppTypography.bodyMedium.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                ],
              ),
            ],
          ),
          AppSpacing.vMd,
          _buildSwitchTile('SSL Certificate', 'Enable HTTPS for your website', _sslCertificate, (v) => setState(() => _sslCertificate = v), isDark),
          const Divider(height: 1),
          _buildSwitchTile('WWW Redirect', 'Redirect www to non-www', _wwwRedirect, (v) => setState(() => _wwwRedirect = v), isDark),
        ],
      ),
    );

    final contactCard = AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(Icons.contacts_outlined, 'Contact Information', isDark),
          AppSpacing.vXs,
          Text('Display contact details on your website', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          AppSpacing.vLg,
          AppTextField(controller: _contactEmailController, label: 'Contact Email', hint: 'info@abcschool.edu'),
          AppSpacing.vMd,
          AppTextField(controller: _contactPhoneController, label: 'Contact Phone', hint: '+91 98765 43210'),
          AppSpacing.vMd,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel('Address', isDark),
              AppSpacing.vXs,
              TextFormField(controller: _contactAddressController, maxLines: 2, decoration: const InputDecoration()),
            ],
          ),
        ],
      ),
    );

    final featuresCard = AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(Icons.toggle_on_outlined, 'Website Features', isDark),
          AppSpacing.vXs,
          Text('Enable or disable website features', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          AppSpacing.vLg,
          _buildSwitchTile('Online Admissions', 'Allow online admission applications', _onlineAdmissions, (v) => setState(() => _onlineAdmissions = v), isDark),
          const Divider(height: 1),
          _buildSwitchTile('Online Fee Payment', 'Enable online fee collection', _onlineFeePayment, (v) => setState(() => _onlineFeePayment = v), isDark),
          const Divider(height: 1),
          _buildSwitchTile('Student Portal', 'Access to student dashboard', _studentPortal, (v) => setState(() => _studentPortal = v), isDark),
          const Divider(height: 1),
          _buildSwitchTile('Parent Portal', 'Access to parent dashboard', _parentPortal, (v) => setState(() => _parentPortal = v), isDark),
        ],
      ),
    );

    final accountCard = AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(Icons.calendar_today_rounded, 'Account Details', isDark),
          AppSpacing.vXs,
          Text('View your registration and validity information', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          AppSpacing.vLg,
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _registrationDateController,
                  label: 'Registration Date',
                  hint: 'YYYY-MM-DD',
                  suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _expiryDateController,
                  label: 'Expiry Date',
                  hint: 'YYYY-MM-DD',
                  suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: AppTextField(
                  controller: _renewalDateController,
                  label: 'Renewal Date',
                  hint: 'YYYY-MM-DD',
                  suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (isDesktop) {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: basicInfoCard),
              AppSpacing.hLg,
              Expanded(child: domainCard),
            ],
          ),
          AppSpacing.vLg,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: contactCard),
              AppSpacing.hLg,
              Expanded(child: featuresCard),
            ],
          ),
          AppSpacing.vLg,
          accountCard,
        ],
      );
    }

    return Column(
      children: [
        basicInfoCard,
        AppSpacing.vLg,
        domainCard,
        AppSpacing.vLg,
        contactCard,
        AppSpacing.vLg,
        featuresCard,
        AppSpacing.vLg,
        accountCard,
      ],
    );
  }

  // 2. Media Tab
  Widget _buildMediaTab(bool isDark) {
    final isDesktop = context.isDesktop || context.isUltraWide;

    final logoCard = AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(Icons.image_rounded, 'Logo & Favicon', isDark),
          AppSpacing.vXs,
          Text('Upload your brand assets', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          AppSpacing.vLg,
          _buildUploadBox('Website Logo', 'Upload logo (PNG, SVG)', isDark),
          AppSpacing.vLg,
          _buildUploadBox('Favicon', 'Upload favicon (ICO, PNG)', isDark),
        ],
      ),
    );

    final heroCard = AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(Icons.view_carousel_rounded, 'Hero Banner', isDark),
          AppSpacing.vXs,
          Text('Configure homepage hero section', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          AppSpacing.vLg,
          _buildUploadBox('Banner Image', 'Upload banner (1920x600)', isDark),
          AppSpacing.vLg,
          AppTextField(controller: _heroTitleController, label: 'Banner Title', hint: 'Welcome to ABC School'),
          AppSpacing.vMd,
          AppTextField(controller: _heroSubtitleController, label: 'Banner Subtitle', hint: "Shaping Tomorrow's Leaders Today"),
        ],
      ),
    );

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: logoCard),
          AppSpacing.hLg,
          Expanded(child: heroCard),
        ],
      );
    }

    return Column(
      children: [
        logoCard,
        AppSpacing.vLg,
        heroCard,
      ],
    );
  }

  // 3. Social Tab
  Widget _buildSocialTab(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(Icons.share_rounded, 'Social Media Links', isDark),
          AppSpacing.vXs,
          Text('Connect your social media profiles', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          AppSpacing.vLg,
          Row(
            children: [
              Expanded(child: AppTextField(controller: _facebookController, label: 'Facebook', hint: 'https://facebook.com/yourpage')),
              AppSpacing.hMd,
              Expanded(child: AppTextField(controller: _twitterController, label: 'Twitter / X', hint: 'https://twitter.com/yourhandle')),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(child: AppTextField(controller: _instagramController, label: 'Instagram', hint: 'https://instagram.com/yourprofile')),
              AppSpacing.hMd,
              Expanded(child: AppTextField(controller: _linkedinController, label: 'LinkedIn', hint: 'https://linkedin.com/company/yourcompany')),
            ],
          ),
          AppSpacing.vMd,
          Row(
            children: [
              Expanded(child: AppTextField(controller: _youtubeController, label: 'YouTube', hint: 'https://youtube.com/yourchannel')),
              AppSpacing.hMd,
              Expanded(child: AppTextField(controller: _whatsappController, label: 'WhatsApp', hint: '+91 98765 43210')),
            ],
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
              'Website Settings',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Text(
          'Website Settings',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AppSpacing.vXs,
        Text(
          'Configure your branch website appearance and content',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );

    final actionButton = AppButton(
      text: 'Save Changes',
      icon: Icons.save_rounded,
      onPressed: _handleSave,
      height: 38,
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerTexts,
          AppSpacing.vMd,
          actionButton,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: headerTexts),
        actionButton,
      ],
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

  Future<void> _pickFile(String label) async {
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
          _uploadedFiles[label] = result;
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

  Widget _buildUploadBox(String label, String hint, bool isDark) {
    final uploaded = _uploadedFiles[label];

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
                          onPressed: () => _pickFile(label),
                        ),
                        AppSpacing.hSm,
                        AppButton(
                          text: 'Remove',
                          variant: AppButtonVariant.text,
                          height: 26,
                          onPressed: () => setState(() => _uploadedFiles.remove(label)),
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
                      onPressed: () => _pickFile(label),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
