import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/models/user_role.dart';
import '../../../../presentation/utils/ui_feedback.dart';
import '../../../../data/models/user_profile_model.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../../features/auth/providers/auth_provider.dart';

class DealerManagementPage extends StatelessWidget {
  const DealerManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final token = auth.token ?? '';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Dealer Management',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your dealer network, track performance, and verify dealers.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),

          // Table
          Expanded(
            child: FutureBuilder<List<UserProfile>>(
              future: context.read<UserRepository>().fetchAllUsers(token: token),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: ${snapshot.error}'),
                      ],
                    ),
                  );
                }

                final dealers = snapshot.data
                    ?.where((u) => u.role == UserRole.dealer)
                    .toList() ??
                    [];

                if (dealers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.store, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('No dealers found',
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: dealers
                        .map((dealer) => DataRow(cells: [
                              DataCell(Text(dealer.fullName)),
                              DataCell(Text(dealer.email)),
                              DataCell(
                                Chip(
                                  label: Text(dealer.isActive ? 'Active' : 'Inactive'),
                                  backgroundColor: dealer.isActive
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.orange.withOpacity(0.2),
                                  labelStyle: TextStyle(
                                    color: dealer.isActive
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    if (!dealer.isActive)
                                      TextButton.icon(
                                        onPressed: () => _verifyDealer(
                                          context,
                                          dealer,
                                          token,
                                        ),
                                        icon: const Icon(Icons.check),
                                        label: const Text('Verify'),
                                      ),
                                    if (dealer.isActive)
                                      TextButton.icon(
                                        onPressed: () => _suspendDealer(
                                          context,
                                          dealer,
                                          token,
                                        ),
                                        icon: const Icon(Icons.block),
                                        label: const Text('Suspend'),
                                      ),
                                    TextButton.icon(
                                      onPressed: () => _viewStats(context, dealer),
                                      icon: const Icon(Icons.analytics),
                                      label: const Text('Stats'),
                                    ),
                                  ],
                                ),
                              ),
                            ]))
                        .toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _verifyDealer(
    BuildContext context,
    UserProfile dealer,
    String token,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify Dealer'),
        content: Text('Activate "${dealer.fullName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Activate'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await context.read<UserRepository>().activateUser(userId: dealer.id, token: token);
      if (context.mounted) {
        UIFeedback.showSnackBar(context, 'Dealer verified successfully');
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DealerManagementPage()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        UIFeedback.showSnackBar(context, 'Failed to verify dealer: $e');
      }
    }
  }

  Future<void> _suspendDealer(
    BuildContext context,
    UserProfile dealer,
    String token,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suspend Dealer'),
        content: Text('Suspend "${dealer.fullName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Suspend'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await context.read<UserRepository>().suspendUser(userId: dealer.id, token: token);
      if (context.mounted) {
        UIFeedback.showSnackBar(context, 'Dealer suspended');
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DealerManagementPage()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        UIFeedback.showSnackBar(context, 'Failed to suspend dealer: $e');
      }
    }
  }

  void _viewStats(BuildContext context, UserProfile dealer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${dealer.fullName} - Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${dealer.email}'),
            const SizedBox(height: 12),
            Text('Phone: ${dealer.phoneNumber ?? 'N/A'}'),
            const SizedBox(height: 12),
            Text('Status: ${dealer.isActive ? 'Active' : 'Inactive'}'),
            const SizedBox(height: 12),
            Text('Joined: ${dealer.createdAt}'), 
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
