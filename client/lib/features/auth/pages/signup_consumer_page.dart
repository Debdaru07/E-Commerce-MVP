import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/routing/app_routes.dart';
import '../../../presentation/components/buttons/primary_button.dart';

class SignupConsumerPage extends StatefulWidget {
  const SignupConsumerPage({super.key});

  @override
  State<SignupConsumerPage> createState() => _SignupConsumerPageState();
}

class _SignupConsumerPageState extends State<SignupConsumerPage> {
  bool agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // 🌈 Ambient background glows
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
                        // 🔰 Logo
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
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: theme.hintColor),
                        ),

                        const SizedBox(height: 28),

                        // 👤 Full name
                        const _InputField(
                          label: 'Full name',
                          icon: Icons.person_outline,
                        ),

                        const SizedBox(height: 16),

                        // 📧 Email
                        const _InputField(
                          label: 'Email address',
                          icon: Icons.mail_outline,
                        ),

                        const SizedBox(height: 16),

                        // 🔒 Password
                        const _InputField(
                          label: 'Password',
                          icon: Icons.lock_outline,
                          obscure: true,
                        ),

                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Must be at least 8 characters',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: theme.hintColor),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 🔒 Confirm password
                        const _InputField(
                          label: 'Confirm password',
                          icon: Icons.lock_outline,
                          obscure: true,
                        ),

                        const SizedBox(height: 20),

                        // ☑️ Terms
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: agreeToTerms,
                              onChanged: (v) {
                                setState(() => agreeToTerms = v ?? false);
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  'I agree to the Terms of Service and Privacy Policy.',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // 🚀 Create account
                        PrimaryButton(
                          text: 'Create account',
                          onPressed: agreeToTerms
                              ? () {
                                  // TODO: signup logic
                                }
                              : null,
                        ),

                        const SizedBox(height: 28),

                        // ───── Divider ─────
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'Or sign up with',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // 🌐 Social signup
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.g_mobiledata),
                                label: const Text('Google'),
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.code),
                                label: const Text('GitHub'),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // 🔁 Login links
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 6,
                          children: [
                            const Text('Already have an account?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.loginConsumer,
                                );
                              },
                              child: const Text('Sign in'),
                            ),
                          ],
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.signupDealer,
                            );
                          },
                          child: const Text(
                            'Are you a business or dealer? Sign up here',
                          ),
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
}

/// 🔹 Reusable input
class _InputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool obscure;

  const _InputField({
    required this.label,
    required this.icon,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
