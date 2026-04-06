import '../../data/models/order_model.dart';

abstract class OrderRepository {
  Future<List<Order>> fetchMyOrders({
    required String token,
  });

  Future<Order> placeOrder({
    required String token,
    required List<Map<String, int>> items,
    required String shippingAddress,
  });

  Future<List<Order>> fetchAllOrders({
    required String token,
  });

  Future<Order> fetchOrderById({
    required String token,
    required String orderId,
  });

  Future<Order> updateOrder({
    required String token,
    required String orderId,
    required String status,
  });
}
