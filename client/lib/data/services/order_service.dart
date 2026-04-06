import 'dart:convert';

import '../../shared/network/api_client.dart';
import '../../shared/network/api_exceptions.dart';
import '../models/order_model.dart';

class OrderService {
  static const _ordersEndpoint = '/orders';

  /// Create a new order
  static Future<Order> placeOrder({
    required String token,
    required List<Map<String, int>> items, // {productId, quantity}
    required String shippingAddress,
  }) async {
    try {
      final body = {
        'items': items,
        'shipping_address': shippingAddress,
      };

      final response = await ApiClient.post(
        _ordersEndpoint,
        body: body,
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return Order.fromJson(json as Map<String, dynamic>);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(error['message'] ?? 'Failed to place order');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error placing order: $e');
    }
  }

  /// Get all orders for logged-in consumer
  static Future<List<Order>> getMyOrders({required String token}) async {
    try {
      final response = await ApiClient.get('$_ordersEndpoint/my', token: token);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => Order.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
            'Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error loading orders: $e');
    }
  }

  /// Get order by ID
  static Future<Order> getOrderById({
    required String token,
    required String orderId,
  }) async {
    try {
      final response = await ApiClient.get(
        '$_ordersEndpoint/$orderId',
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return Order.fromJson(json as Map<String, dynamic>);
      } else {
        throw ApiException('Failed to load order: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error loading order: $e');
    }
  }

  /// Cancel order (consumer only, if order is still pending)
  static Future<Order> cancelOrder({
    required String token,
    required String orderId,
  }) async {
    try {
      final response = await ApiClient.post(
        '$_ordersEndpoint/$orderId/cancel',
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return Order.fromJson(json as Map<String, dynamic>);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
            error['message'] ?? 'Failed to cancel order');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error canceling order: $e');
    }
  }

  /// Get orders for a dealer (dealer only)
  static Future<List<Order>> getDealerOrders({required String token}) async {
    try {
      final response = await ApiClient.get(
        '$_ordersEndpoint/dealer/my-orders',
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => Order.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
            'Failed to load dealer orders: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error loading dealer orders: $e');
    }
  }

  /// Update order status (dealer only)
  static Future<Order> updateOrderStatus({
    required String token,
    required String orderId,
    required String status,
    String? trackingNumber,
  }) async {
    try {
      final body = {
        'status': status,
        if (trackingNumber != null) 'tracking_number': trackingNumber,
      };

      final response = await ApiClient.put(
        '$_ordersEndpoint/$orderId/status',
        body: body,
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return Order.fromJson(json as Map<String, dynamic>);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
            error['message'] ?? 'Failed to update order');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error updating order: $e');
    }
  }
}
