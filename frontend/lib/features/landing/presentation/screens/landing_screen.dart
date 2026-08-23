import 'package:flutter/material.dart';

import '../widgets/feature_section.dart';
import '../widgets/final_cta_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/landing_footer.dart';
import '../widgets/landing_navbar.dart';
import '../widgets/org_structure_section.dart';
import '../widgets/value_prop_section.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _scrollController = ScrollController();
  final _featuresKey = GlobalKey();
  final _structureKey = GlobalKey();
  final _platformKey = GlobalKey();

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Sticky Top Navigation Bar
          LandingNavbar(
            onFeaturesClick: () => _scrollToKey(_featuresKey),
            onStructureClick: () => _scrollToKey(_structureKey),
            onPlatformClick: () => _scrollToKey(_platformKey),
          ),

          // Scrollable Landing Page Content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const HeroSection(),
                  OrgStructureSection(key: _structureKey),
                  FeatureSection(key: _featuresKey),
                  ValuePropSection(key: _platformKey),
                  const FinalCtaSection(),
                  const LandingFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
