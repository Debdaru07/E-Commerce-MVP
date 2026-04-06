enum OrderStatus {
  pending,
  confirmed,
  shipped,
  delivered,
  cancelled,
}

class OrderItem {
  final String productId;
  final String productTitle;
  final double unitPrice;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.productTitle,
    required this.unitPrice,
    required this.quantity,
  });

  double get subtotal => unitPrice * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'] as String,
      productTitle: json['product_title'] as String,
      unitPrice: (json['unit_price'] as num).toDouble(),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_title': productTitle,
      'unit_price': unitPrice,
      'quantity': quantity,
    };
  }
}

class Order {
  final String id;
  final String consumerId;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final String? shippingAddress;
  final String? trackingNumber;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Order({
    required this.id,
    required this.consumerId,
    required this.items,
    required this.totalAmount,
    required this.status,
    this.shippingAddress,
    this.trackingNumber,
    required this.createdAt,
    this.updatedAt,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  factory Order.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List? ?? [];
    return Order(
      id: json['id'] as String,
      consumerId: json['consumer_id'] as String,
      items: itemsList
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      shippingAddress: json['shipping_address'] as String?,
      trackingNumber: json['tracking_number'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consumer_id': consumerId,
      'items': items.map((item) => item.toJson()).toList(),
      'total_amount': totalAmount,
      'status': status.name,
      'shipping_address': shippingAddress,
      'tracking_number': trackingNumber,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
