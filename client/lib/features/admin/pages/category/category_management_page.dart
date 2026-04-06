import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../presentation/utils/ui_feedback.dart';
import '../../../../data/models/category_model.dart';
import '../../../../domain/repositories/category_repository.dart';
import '../../../../features/auth/providers/auth_provider.dart';

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({super.key});

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final token = auth.token ?? '';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Add button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage and organize your product taxonomy.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddCategoryDialog(context, token),
                icon: const Icon(Icons.add),
                label: const Text('Add Category'),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search categories...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 24),

          // Table
          Expanded(
            child: FutureBuilder<List<Category>>(
              future: context.read<CategoryRepository>().fetchCategories(token: token),
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

                var categories = snapshot.data ?? [];

                // Filter by search
                if (_searchController.text.isNotEmpty) {
                  categories = categories
                      .where((c) => c.name
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()))
                      .toList();
                }

                if (categories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.category, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('No categories found',
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Products')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: categories
                        .map((category) => DataRow(cells: [
                              DataCell(Text(category.name)),
                              DataCell(
                                Text(
                                  (category.description ?? 'N/A').length > 50
                                      ? '${(category.description ?? 'N/A').substring(0, 50)}...'
                                      : (category.description ?? 'N/A'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              DataCell(
                                Text('${category.productCount}'),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    TextButton.icon(
                                      onPressed: () => _showEditCategoryDialog(
                                        context,
                                        category,
                                        token,
                                      ),
                                      icon: const Icon(Icons.edit),
                                      label: const Text('Edit'),
                                    ),
                                    TextButton.icon(
                                      onPressed: () => _deleteCategory(
                                        context,
                                        category,
                                        token,
                                      ),
                                      icon: const Icon(Icons.delete),
                                      label: const Text('Delete'),
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

  Future<void> _showAddCategoryDialog(BuildContext context, String token) async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Category'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                UIFeedback.showSnackBar(context, 'Category name is required');
                return;
              }

              try {
                final repository = context.read<CategoryRepository>();
                await repository.createCategory(
                  token: token,
                  name: nameController.text,
                );

                if (mounted) {
                  Navigator.pop(context);
                  UIFeedback.showSnackBar(context, 'Category created');
                  setState(() {});
                }
              } catch (e) {
                if (mounted) {
                  UIFeedback.showSnackBar(context, 'Failed to create category: $e');
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditCategoryDialog(
    BuildContext context,
    Category category,
    String token,
  ) async {
    final nameController = TextEditingController(text: category.name);
    final descriptionController =
        TextEditingController(text: category.description);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Category'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                UIFeedback.showSnackBar(context, 'Category name is required');
                return;
              }

              try {
                final repository = context.read<CategoryRepository>();
                await repository.updateCategory(
                  token: token,
                  categoryId: category.id,
                  name: nameController.text,
                );

                if (mounted) {
                  Navigator.pop(context);
                  UIFeedback.showSnackBar(context, 'Category updated');
                  setState(() {});
                }
              } catch (e) {
                if (mounted) {
                  UIFeedback.showSnackBar(context, 'Failed to update category: $e');
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCategory(
    BuildContext context,
    Category category,
    String token,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Delete "${category.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final repository = context.read<CategoryRepository>();
      await repository.deleteCategory(
        token: token,
        categoryId: category.id,
      );

      if (mounted) {
        UIFeedback.showSnackBar(context, 'Category deleted');
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        UIFeedback.showSnackBar(context, 'Failed to delete category: $e');
      }
    }
  }
}

