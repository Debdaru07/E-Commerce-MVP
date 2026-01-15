import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../../presentation/components/buttons/primary_button.dart';
import '../../../presentation/utils/ui_feedback.dart';
import '../providers/auth_provider.dart';

class SignupConsumerPage extends StatefulWidget {
  const SignupConsumerPage({super.key});

  @override
  State<SignupConsumerPage> createState() => _SignupConsumerPageState();
}

class _SignupConsumerPageState extends State<SignupConsumerPage> {
  bool agreeToTerms = false;

  // ✅ Controllers (NON-NULL)
  late final TextEditingController fullNameCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController passwordCtrl;
  late final TextEditingController confirmPasswordCtrl;

  @override
  void initState() {
    super.initState();
    fullNameCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
    confirmPasswordCtrl = TextEditingController();
  }

  @override
  void dispose() {
    fullNameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -120,
            left: -120,
            child: _Glow(color: theme.colorScheme.primary.withOpacity(0.15)),
          ),
          Positioned(
            bottom: -150,
            right: -150,
            child: _Glow(color: Colors.indigo.withOpacity(0.08)),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    width: 480,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: theme.cardColor.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: theme.dividerColor.withOpacity(0.15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 40,
                          color: Colors.black.withOpacity(0.15),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(theme),
                        const SizedBox(height: 28),
                        _InputField(
                          controller: fullNameCtrl,
                          label: 'Full name',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        _InputField(
                          controller: emailCtrl,
                          label: 'Email address',
                          icon: Icons.mail_outline,
                        ),
                        const SizedBox(height: 16),
                        _InputField(
                          controller: passwordCtrl,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          obscure: true,
                        ),
                        const SizedBox(height: 16),
                        _InputField(
                          controller: confirmPasswordCtrl,
                          label: 'Confirm password',
                          icon: Icons.lock_outline,
                          obscure: true,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: agreeToTerms,
                              onChanged: (v) {
                                setState(() => agreeToTerms = v ?? false);
                              },
                            ),
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Text(
                                  'I agree to the Terms of Service and Privacy Policy.',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(
                          text:
                              auth.isLoading ? 'Creating...' : 'Create account',
                          onPressed: agreeToTerms
                              ? () async {
                                  if (passwordCtrl.text !=
                                      confirmPasswordCtrl.text) {
                                    UIFeedback.showSnackBar(
                                      context,
                                      'Passwords do not match',
                                    );
                                    return;
                                  }

                                  final success = await auth.signup(
                                    role: UserRole.consumer,
                                    email: emailCtrl.text.trim(),
                                    password: passwordCtrl.text.trim(),
                                    fullName: fullNameCtrl.text.trim(),
                                  );

                                  if (!context.mounted) return;

                                  if (success) {
                                    UIFeedback.showToast(
                                        'Account created successfully');
                                    Navigator.pushReplacementNamed(
                                      context,
                                      AppRoutes.loginConsumer,
                                    );
                                  } else {
                                    UIFeedback.showSnackBar(
                                      context,
                                      auth.error ?? 'Signup failed',
                                    );
                                  }
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.layers_rounded,
            color: theme.colorScheme.primary,
            size: 32,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Create an account',
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Start your 14-day free trial. No credit card required.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        ),
      ],
    );
  }
}

/// ✅ Controller-based InputField (SAFE)
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

/// ✨ Ambient glow
class _Glow extends StatelessWidget {
  final Color color;

  const _Glow({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480,
      height: 480,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
