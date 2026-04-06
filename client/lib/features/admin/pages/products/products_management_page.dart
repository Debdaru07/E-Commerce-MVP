import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/models/product_model.dart';
import '../../../../domain/repositories/product_repository.dart';
import '../../../../features/auth/providers/auth_provider.dart';

class ProductsManagementPage extends StatefulWidget {
  const ProductsManagementPage({super.key});

  @override
  State<ProductsManagementPage> createState() => _ProductsManagementPageState();
}

class _ProductsManagementPageState extends State<ProductsManagementPage> {
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
          // Header
          Text(
            'Product Management',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your product catalog, inventory status, and dealer products.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),

          // Search bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by product name...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Table
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: context.read<ProductRepository>().fetchProducts(token: token),
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

                var products = snapshot.data ?? [];

                // Filter by search
                if (_searchController.text.isNotEmpty) {
                  products = products
                      .where((p) => p.title
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()))
                      .toList();
                }

                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('No products found',
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Product')),
                      DataColumn(label: Text('Dealer')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Stock')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: products
                        .map((product) => DataRow(cells: [
                              DataCell(Text(product.title)),
                              DataCell(Text(product.dealerId)),
                              DataCell(Text('\$${product.unitPrice.toStringAsFixed(2)}')),
                              DataCell(Text('${product.stock}')),
                              DataCell(
                                Chip(
                                  label: Text(product.isActive ? 'Active' : 'Inactive'),
                                  backgroundColor: product.isActive
                                      ? Colors.blue.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.2),
                                  labelStyle: TextStyle(
                                    color: product.isActive
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              DataCell(
                                TextButton.icon(
                                  onPressed: () => _viewDetails(context, product),
                                  icon: const Icon(Icons.info),
                                  label: const Text('Details'),
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

  void _viewDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description: ${product.description}'),
              const SizedBox(height: 12),
              Text('Price: \$${product.unitPrice.toStringAsFixed(2)}'),
              const SizedBox(height: 12),
              Text('Stock: ${product.stock}'),
              const SizedBox(height: 12),
              Text('Dealer: ${product.dealerId}'),
              const SizedBox(height: 12),
              Text('Rating: ${product.rating}/5 (${product.reviewCount} reviews)'),
              const SizedBox(height: 12),
              Text('Status: ${product.isActive ? 'Active' : 'Inactive'}'),
              const SizedBox(height: 12),
              Text('Created: ${product.createdAt}'),
            ],
          ),
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
