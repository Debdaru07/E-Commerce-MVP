import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/routing/app_routes.dart';
import '../../../data/models/product_model.dart';
import '../../../domain/repositories/product_repository.dart';
import '../../../presentation/components/buttons/primary_button.dart';
import '../../../presentation/utils/ui_feedback.dart';
import '../../auth/providers/auth_provider.dart';

class DealerDashboardPage extends StatefulWidget {
  const DealerDashboardPage({super.key});

  @override
  State<DealerDashboardPage> createState() => _DealerDashboardPageState();
}

class _DealerDashboardPageState extends State<DealerDashboardPage> {
  int _selectedTab = 0;
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    final auth = context.read<AuthProvider>();
    final repository = context.read<ProductRepository>();
    _productsFuture = repository.fetchDealerProducts(token: auth.token ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dealer Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _loadProducts());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              final auth = context.read<AuthProvider>();
              auth.logout().then((_) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.landing,
                  (route) => false,
                );
              });
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          NavigationRail(
            selectedIndex: _selectedTab,
            onDestinationSelected: (int index) {
              setState(() => _selectedTab = index);
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Overview'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.inventory),
                label: Text('Products'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.receipt),
                label: Text('Orders'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.analytics),
                label: Text('Analytics'),
              ),
            ],
          ),
          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedTab) {
      case 0:
        return _buildOverview();
      case 1:
        return _buildProducts();
      case 2:
        return _buildOrders();
      case 3:
        return _buildAnalytics();
      default:
        return _buildOverview();
    }
  }

  Widget _buildOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data ?? [];
          final totalProducts = products.length;
          final totalStock = products.fold<int>(
              0, (sum, p) => sum + p.stock);
          final activeProducts = products.where((p) => p.isActive).length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              // KPI Cards
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildKPICard(
                    'Total Products',
                    totalProducts.toString(),
                    Icons.inventory,
                  ),
                  _buildKPICard(
                    'Active Products',
                    activeProducts.toString(),
                    Icons.check_circle,
                  ),
                  _buildKPICard(
                    'Total Stock',
                    totalStock.toString(),
                    Icons.warehouse,
                  ),
                  _buildKPICard(
                    'Revenue',
                    '\$0.00',
                    Icons.trending_up,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Quick Actions
              Row(
                children: [
                  PrimaryButton(
                    text: 'Add New Product',
                    onPressed: () {
                      _showAddProductDialog(context);
                    },
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () {
                      setState(() => _selectedTab = 1);
                    },
                    child: const Text('Manage Products'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProducts() {
    final auth = context.read<AuthProvider>();
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final products = snapshot.data ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Products',
                    style:
                        Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PrimaryButton(
                    text: 'Add Product',
                    onPressed: () {
                      _showAddProductDialog(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (products.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 80,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text('No products yet. Add your first product!'),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Product Image
                            if (product.imageUrls.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product.imageUrls[0],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withOpacity(0.1),
                                      child: const Icon(Icons.image),
                                    );
                                  },
                                ),
                              )
                            else
                              Container(
                                width: 100,
                                height: 100,
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withOpacity(0.1),
                                child: const Icon(Icons.image),
                              ),
                            const SizedBox(width: 16),
                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        '\$${product.unitPrice}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        'Stock: ${product.stock}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Actions
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: const Text('Edit'),
                                  onTap: () {
                                    _showEditProductDialog(
                                        context, product, auth.token);
                                  },
                                ),
                                PopupMenuItem(
                                  child: const Text('Delete'),
                                  onTap: () {
                                    _deleteProduct(
                                        context, product.id, auth.token);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrders() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Orders',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Order management coming soon',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalytics() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Analytics dashboard coming soon',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final stockCtrl = TextEditingController();
    final auth = context.read<AuthProvider>();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Product Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Unit Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stockCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            PrimaryButton(
              text: isLoading ? 'Adding...' : 'Add',
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() => isLoading = true);
                      try {
                        final repository = context.read<ProductRepository>();
                        await repository.createProduct(
                          token: auth.token ?? '',
                          title: titleCtrl.text,
                          description: descCtrl.text,
                          unitPrice: double.parse(priceCtrl.text),
                          stock: int.parse(stockCtrl.text),
                          categoryId: 'general',
                          imageUrls: [],
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        UIFeedback.showToast('Product added successfully');
                        setState(() => _loadProducts());
                      } catch (e) {
                        UIFeedback.showSnackBar(
                          context,
                          'Failed to add product',
                        );
                      } finally {
                        setState(() => isLoading = false);
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProductDialog(
      BuildContext context, Product product, String? token) {
    final titleCtrl = TextEditingController(text: product.title);
    final descCtrl = TextEditingController(text: product.description);
    final priceCtrl =
        TextEditingController(text: product.unitPrice.toString());
    final stockCtrl =
        TextEditingController(text: product.stock.toString());
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Product Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Unit Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stockCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            PrimaryButton(
              text: isLoading ? 'Updating...' : 'Update',
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() => isLoading = true);
                      try {
                        final repository = context.read<ProductRepository>();
                        await repository.updateProduct(
                          token: token ?? '',
                          productId: product.id,
                          title: titleCtrl.text,
                          description: descCtrl.text,
                          unitPrice: double.parse(priceCtrl.text),
                          stock: int.parse(stockCtrl.text),
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        UIFeedback.showToast('Product updated successfully');
                        setState(() => _loadProducts());
                      } catch (e) {
                        UIFeedback.showSnackBar(
                          context,
                          'Failed to update product',
                        );
                      } finally {
                        setState(() => isLoading = false);
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteProduct(
      BuildContext context, String productId, String? token) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
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
      final repository = context.read<ProductRepository>();
      await repository.deleteProduct(
        token: token ?? '',
        productId: productId,
      );
      if (!mounted) return;
      UIFeedback.showToast('Product deleted successfully');
      setState(() => _loadProducts());
    } catch (e) {
      UIFeedback.showSnackBar(context, 'Failed to delete product');
    }
  }
}
