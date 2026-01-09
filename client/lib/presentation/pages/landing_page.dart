import 'package:flutter/material.dart';
import '../sections/navbar_section.dart';
import '../sections/hero_section.dart';
import '../sections/social_proof_section.dart';
import '../sections/features_section.dart';
import '../sections/feature_spotlight_section.dart';
import '../sections/testimonials_section.dart';
import '../sections/cta_section.dart';
import '../sections/footer_section.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            NavbarSection(),
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
    );
  }
}
