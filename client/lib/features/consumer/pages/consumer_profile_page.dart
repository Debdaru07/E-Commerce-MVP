import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/routing/app_routes.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../presentation/components/buttons/primary_button.dart';
import '../../../presentation/utils/ui_feedback.dart';
import '../../auth/providers/auth_provider.dart';

class ConsumerProfilePage extends StatefulWidget {
  const ConsumerProfilePage({super.key});

  @override
  State<ConsumerProfilePage> createState() => _ConsumerProfilePageState();
}

class _ConsumerProfilePageState extends State<ConsumerProfilePage> {
  late Future<UserProfile> _profileFuture;
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final auth = context.read<AuthProvider>();
    final userRepository = context.read<UserRepository>();
    _profileFuture = userRepository.fetchProfile(token: auth.token ?? '');
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context, auth);
            },
          ),
        ],
      ),
      body: FutureBuilder<UserProfile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text('Error loading profile'),
                ],
              ),
            );
          }

          final profile = snapshot.data;
          if (profile == null) {
            return const Center(child: Text('Profile not found'));
          }

          fullNameController.text = profile.fullName;
          phoneController.text = profile.phoneNumber ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: profile.avatarUrl != null
                          ? ClipOval(
                              child: Image.network(
                                profile.avatarUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 60,
                              color:
                                  theme.colorScheme.primary,
                            ),
                    ),
                    const SizedBox(height: 24),
                    // Profile Info
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal Information',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Email (read-only)
                            _buildInfoField(
                              label: 'Email',
                              value: profile.email,
                              readOnly: true,
                            ),
                            const SizedBox(height: 12),
                            // Full Name
                            TextField(
                              controller: fullNameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Phone Number
                            TextField(
                              controller: phoneController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 20),
                            PrimaryButton(
                              text: 'Update Profile',
                              onPressed: () {
                                _updateProfile(context, auth);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Quick Actions
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Actions',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildActionTile(
                              context,
                              icon: Icons.shopping_bag_outlined,
                              label: 'Order History',
                              onTap: () {
                                // Navigate to order history
                              },
                            ),
                            _buildActionTile(
                              context,
                              icon: Icons.favorite_outline,
                              label: 'Wishlist',
                              onTap: () {
                                // Navigate to wishlist
                              },
                            ),
                            _buildActionTile(
                              context,
                              icon: Icons.location_on_outlined,
                              label: 'Addresses',
                              onTap: () {
                                // Navigate to addresses
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Future<void> _updateProfile(BuildContext context, AuthProvider auth) async {
    try {
      final userRepository = context.read<UserRepository>();
      await userRepository.updateProfile(
        token: auth.token ?? '',
        fullName: fullNameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
      );

      if (!context.mounted) return;

      UIFeedback.showToast('Profile updated successfully');
      _loadProfile();
    } catch (e) {
      UIFeedback.showSnackBar(context, 'Failed to update profile: $e');
    }
  }

  void _showLogoutDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await auth.logout();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.landing,
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
