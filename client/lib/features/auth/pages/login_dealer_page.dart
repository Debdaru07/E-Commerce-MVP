import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../../presentation/components/buttons/primary_button.dart';
import '../../../presentation/utils/ui_feedback.dart';
import '../providers/auth_provider.dart';

class LoginDealerPage extends StatelessWidget {
  const LoginDealerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailCtrl = TextEditingController();
    final TextEditingController passwordCtrl = TextEditingController();
    final auth = context.watch<AuthProvider>();
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
                        decoration: const InputDecoration(
                          labelText: 'Business email',
                          prefixIcon: Icon(Icons.mail_outline),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
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

                      // 🔑 Dealer Sign In
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

                                if (!context.mounted) return;

                                if (success) {
                                  UIFeedback.showToast('Login successful');
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.consumerApp,
                                  );
                                } else {
                                  UIFeedback.showSnackBar(
                                    context,
                                    auth.error ?? 'Login failed',
                                  );
                                }
                              },
                      ),

                      const SizedBox(height: 28),

                      // 🔁 Switch to consumer login
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
