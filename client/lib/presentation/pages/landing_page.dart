import 'package:flutter/material.dart';
import '../sections/navbar_section.dart';
import '../sections/hero_section.dart';
import '../sections/social_proof_section.dart';
import '../sections/features_section.dart';
import '../sections/feature_spotlight_section.dart';
import '../sections/testimonials_section.dart';
import '../sections/cta_section.dart';
import '../sections/footer_section.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 10 && !_scrolled) {
        setState(() => _scrolled = true);
      } else if (_scrollController.offset <= 10 && _scrolled) {
        setState(() => _scrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: const Column(
              children: [
                SizedBox(height: 72), // space for sticky navbar
                HeroSection(),
                SocialProofSection(),
                FeaturesSection(),
                FeatureSpotlightSection(),
                TestimonialsSection(),
                CTASection(),
                FooterSection(),
              ],
            ),
          ),

          // Sticky navbar lives OUTSIDE scroll view
          NavbarSection(scrolled: _scrolled),
        ],
      ),
    );
  }
}
