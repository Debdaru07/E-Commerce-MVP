import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/models/user_role.dart';
import '../../../shared/routing/app_routes.dart';
import '../../../presentation/components/buttons/primary_button.dart';
import '../../../presentation/utils/ui_feedback.dart';
import '../providers/auth_provider.dart';

class LoginDealerPage extends StatefulWidget {
  const LoginDealerPage({super.key});

  @override
  State<LoginDealerPage> createState() => _LoginDealerPageState();
}

class _LoginDealerPageState extends State<LoginDealerPage> {
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
    final auth = context.watch<AuthProvider>();
    print('Auth isLoading: ${auth.isLoading}'); // ADD THIS LINE
    final theme = Theme.of(context);

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
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.storefront_rounded,
                          color: theme.colorScheme.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Dealer Login',
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to manage your business account.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.hintColor),
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: emailCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Business email',
                          prefixIcon: Icon(Icons.mail_outline),
                        ),
                      ),
                      const SizedBox(height: 16),
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
                      PrimaryButton(
                        text: auth.isLoading ? 'Signing in...' : 'Sign In',
                        onPressed: auth.isLoading
                            ? null
                            : () async {
                                print('Sign In button pressed');
                                final success = await auth.login(
                                  role: UserRole.dealer,
                                  email: emailCtrl.text.trim(),
                                  password: passwordCtrl.text.trim(),
                                );
                                print('Login result: $success');

                                if (!context.mounted) {
                                  print('Context not mounted, aborting navigation.');
                                  return;
                                }

                                if (success) {
                                  print('Login success, navigating to dealer dashboard');
                                  UIFeedback.showToast('Login successful');
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.dealerDashboard,
                                  );
                                } else {
                                  print('Login failed: ${auth.error}');
                                  UIFeedback.showSnackBar(
                                    context,
                                    auth.error ?? 'Login failed',
                                  );
                                }
                              },
                      ),
                      const SizedBox(height: 28),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 6,
                        children: [
                          const Text('Not a dealer?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.loginConsumer,
                              );
                            },
                            child: const Text('Login as Consumer'),
                          ),
                        ],
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