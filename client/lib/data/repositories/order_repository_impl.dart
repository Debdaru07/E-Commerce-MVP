import '../../data/models/order_model.dart';
import '../../data/services/order_service.dart';
import '../../domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  @override
  Future<List<Order>> fetchMyOrders({required String token}) {
    return OrderService.getMyOrders(token: token);
  }

  @override
  Future<Order> fetchOrderById({
    required String token,
    required String orderId,
  }) {
    return OrderService.getOrderById(token: token, orderId: orderId);
  }

  @override
  Future<List<Order>> fetchAllOrders({required String token}) {
    return OrderService.getDealerOrders(token: token);
  }

  @override
  Future<Order> placeOrder({
    required String token,
    required List<Map<String, int>> items,
    required String shippingAddress,
  }) {
    return OrderService.placeOrder(
      token: token,
      items: items,
      shippingAddress: shippingAddress,
    );
  }

  @override
  Future<Order> updateOrder({
    required String token,
    required String orderId,
    String? status,
  }) {
    if (status == null) {
      throw ArgumentError('Status is required when updating an order');
    }
    return OrderService.updateOrderStatus(
      token: token,
      orderId: orderId,
      status: status,
    );
  }
}
