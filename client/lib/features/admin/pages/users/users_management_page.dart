import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/models/user_role.dart';
import '../../../../data/models/user_profile_model.dart';
import '../../../../presentation/utils/ui_feedback.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../../domain/repositories/user_repository.dart';

class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({super.key});

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  late Future<List<UserProfile>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    final auth = context.read<AuthProvider>();
    final repository = context.read<UserRepository>();
    _usersFuture = repository.fetchAllUsers(token: auth.token ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'User Management',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  setState(() => _loadUsers());
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          FutureBuilder<List<UserProfile>>(
            future: _usersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading users: ${snapshot.error}'),
                );
              }

              final users = snapshot.data ?? [];

              if (users.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'No users found',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Role')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: users
                      .map(
                        (user) => DataRow(
                          cells: [
                            DataCell(Text(user.fullName)),
                            DataCell(Text(user.email)),
                            DataCell(
                              Chip(
                                label: Text(user.role.name.toUpperCase()),
                                backgroundColor:
                                    _getRoleColor(user.role),
                              ),
                            ),
                            DataCell(
                              Chip(
                                label: Text(
                                  user.isActive ? 'Active' : 'Inactive',
                                ),
                                backgroundColor: user.isActive
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  if (!user.isActive)
                                    TextButton(
                                      onPressed: () {
                                        _activateUser(context, user.id);
                                      },
                                      child: const Text('Activate'),
                                    )
                                  else
                                    TextButton(
                                      onPressed: () {
                                        _suspendUser(context, user.id);
                                      },
                                      child: const Text('Suspend'),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red.withOpacity(0.2);
      case UserRole.dealer:
        return Colors.blue.withOpacity(0.2);
      case UserRole.consumer:
        return Colors.green.withOpacity(0.2);
    }
  }

  Future<void> _activateUser(BuildContext context, String userId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activate User'),
        content: const Text('Are you sure you want to activate this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Activate'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final auth = context.read<AuthProvider>();
        final repository = context.read<UserRepository>();
        await repository.activateUser(userId: userId, token: auth.token ?? '');
        UIFeedback.showSnackBar(context, 'User activated successfully');
        setState(() => _loadUsers());
      } catch (e) {
        UIFeedback.showSnackBar(context, 'Failed to activate user: $e');
      }
    }
  }

  Future<void> _suspendUser(BuildContext context, String userId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suspend User'),
        content: const Text('Are you sure you want to suspend this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Suspend'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final auth = context.read<AuthProvider>();
        final repository = context.read<UserRepository>();
        await repository.suspendUser(userId: userId, token: auth.token ?? '');
        UIFeedback.showSnackBar(context, 'User suspended successfully');
        setState(() => _loadUsers());
      } catch (e) {
        UIFeedback.showSnackBar(context, 'Failed to suspend user: $e');
      }
    }
  }
}
