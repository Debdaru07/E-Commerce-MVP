import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/routing/app_routes.dart';
import '../../../presentation/components/buttons/primary_button.dart';
import '../../../presentation/utils/ui_feedback.dart';
import '../../../domain/repositories/order_repository.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/cart_provider.dart';

class ConsumerCartPage extends StatelessWidget {
  const ConsumerCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        centerTitle: true,
      ),
      body: cart.items.isEmpty
          ? _buildEmptyCart(context)
          : _buildCartContent(context, cart, theme),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Start shopping to add items to your cart',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: 'Continue Shopping',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.consumerApp);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(
      BuildContext context, CartProvider cart, ThemeData theme) {
    return Column(
      children: [
        // Cart Items
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              color: theme.colorScheme.outline.withOpacity(0.1),
                              child: Icon(
                                Icons.image_not_supported,
                                color: theme.colorScheme.outline,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productTitle,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${item.unitPrice.toStringAsFixed(2)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Quantity Controls
                            Row(
                              children: [
                                IconButton(
                                  onPressed: item.quantity > 1
                                      ? () => cart.updateQuantity(
                                            item.productId,
                                            item.quantity - 1,
                                          )
                                      : null,
                                  icon: const Icon(Icons.remove),
                                  iconSize: 20,
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: Text(
                                    '${item.quantity}',
                                    style:
                                        theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => cart.updateQuantity(
                                    item.productId,
                                    item.quantity + 1,
                                  ),
                                  icon: const Icon(Icons.add),
                                  iconSize: 20,
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Remove Button
                      IconButton(
                        onPressed: () {
                          cart.removeItem(item.productId);
                          UIFeedback.showToast(
                              '${item.productTitle} removed from cart');
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Summary and Checkout
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: theme.dividerColor),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal (${cart.itemCount} items)',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    '\$${cart.totalPrice.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shipping',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    '\$0.00',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${cart.totalPrice.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                text: 'Proceed to Checkout',
                onPressed: () {
                  _showCheckoutDialog(context, cart);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCheckoutDialog(BuildContext context, CartProvider cart) {
    final theme = Theme.of(context);
    final addressController = TextEditingController();
    final auth = context.read<AuthProvider>();
    bool isPlacingOrder = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Checkout'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Address',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your delivery address',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  'Order Summary',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...cart.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${item.productTitle} x${item.quantity}'),
                        Text('\$${item.subtotal.toStringAsFixed(2)}'),
                      ],
                    ),
                  );
                }),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${cart.totalPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isPlacingOrder
                  ? null
                  : () {
                      Navigator.pop(context);
                    },
              child: const Text('Cancel'),
            ),
            PrimaryButton(
              text: isPlacingOrder ? 'Placing Order...' : 'Place Order',
              onPressed: isPlacingOrder
                  ? null
                  : () async {
                      if (addressController.text.trim().isEmpty) {
                        UIFeedback.showSnackBar(
                          context,
                          'Please enter a delivery address',
                        );
                        return;
                      }

                      setState(() => isPlacingOrder = true);

                      try {
                          final orderRepository = context.read<OrderRepository>();

                          final items = cart.items
                              .map((item) => {
                                    'product_id': item.productId,
                                    'quantity': item.quantity,
                                  })
                              .cast<Map<String, int>>()
                              .toList();

                          await orderRepository.placeOrder(
                            token: auth.token ?? '',
                            items: items,
                            shippingAddress: addressController.text.trim(),
                          );
                        if (!context.mounted) return;

                        cart.clearCart();
                        Navigator.pop(context);
                        UIFeedback.showToast('Order placed successfully!');

                        // Navigate to orders page
                        Navigator.pushNamed(
                            context, AppRoutes.consumerApp);
                      } catch (e) {
                        UIFeedback.showSnackBar(
                          context,
                          'Failed to place order: $e',
                        );
                      } finally {
                        setState(() => isPlacingOrder = false);
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
