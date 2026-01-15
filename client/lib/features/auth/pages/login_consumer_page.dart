import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../presentation/components/buttons/primary_button.dart';
import '../../../core/services/auth_service.dart';
import '../providers/auth_provider.dart';

class LoginConsumerPage extends StatefulWidget {
  const LoginConsumerPage({super.key});

  @override
  State<LoginConsumerPage> createState() => _LoginConsumerPageState();
}

class _LoginConsumerPageState extends State<LoginConsumerPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: Stack(
        children: [
          // 🌈 Ambient background glow
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: 440,
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
                        'Welcome back',
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Please enter your details to sign in.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.hintColor),
                      ),

                      const SizedBox(height: 28),

                      // 📧 Email
                      TextFormField(
                        controller: emailCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Email address',
                          prefixIcon: Icon(Icons.mail_outline),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 🔒 Password
                      TextFormField(
                        controller: passwordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Forgot password?'),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 🔑 Sign In
                      PrimaryButton(
                        text: auth.isLoading ? 'Signing in...' : 'Sign In',
                        onPressed: auth.isLoading
                            ? null
                            : () async {
                                final success = await auth.login(
                                  role: UserRole.consumer,
                                  email: emailCtrl.text.trim(),
                                  password: passwordCtrl.text.trim(),
                                );

                                if (!mounted) return;

                                if (success) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.consumerApp,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        auth.error ?? 'Login failed',
                                      ),
                                    ),
                                  );
                                }
                              },
                      ),

                      const SizedBox(height: 24),

                      // ───── Divider ─────
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Or continue with',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 🌐 Social buttons
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

                      // 🔁 Switch actions
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 6,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.signupConsumer,
                              );
                            },
                            child: const Text('Sign up for free'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.loginDealer,
                          );
                        },
                        child: const Text('Login as Dealer'),
                      ),
                    ],
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

/// ✨ Ambient blur circle
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
