import 'cart_item.dart';

enum OrderStatus {
  confirmed,
  packing,
  outForDelivery,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.packing:
        return 'Packing Items';
      case OrderStatus.outForDelivery:
        return 'Out For Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// Order record capturing checkout snapshot.
class Order {
  final String id;
  final DateTime dateTime;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final OrderStatus status;
  final String deliveryAddress;
  final String paymentMethod;
  final int estimatedMinutes;

  const Order({
    required this.id,
    required this.dateTime,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.status,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.estimatedMinutes = 10,
  });
}
