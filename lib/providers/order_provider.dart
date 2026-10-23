import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

/// Manages placed orders, active delivery status tracking, and order history.
class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];
  Order? _activeOrder;

  List<Order> get orders => List.unmodifiable(_orders);

  Order? get activeOrder => _activeOrder;

  bool get hasActiveOrder => _activeOrder != null;

  Order placeOrder({
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required double discount,
    required double total,
    required String deliveryAddress,
    required String paymentMethod,
  }) {
    final orderId = 'FK-${Random().nextInt(900000) + 100000}';

    final newOrder = Order(
      id: orderId,
      dateTime: DateTime.now(),
      items: List.from(items),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: discount,
      total: total,
      status: OrderStatus.confirmed,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
      estimatedMinutes: 10,
    );

    _orders.insert(0, newOrder);
    _activeOrder = newOrder;
    notifyListeners();

    // Simulate order progression
    _simulateDeliveryProgress(orderId);

    return newOrder;
  }

  void _simulateDeliveryProgress(String orderId) {
    Future.delayed(const Duration(seconds: 4), () {
      _updateStatus(orderId, OrderStatus.packing);
    });

    Future.delayed(const Duration(seconds: 8), () {
      _updateStatus(orderId, OrderStatus.outForDelivery);
    });
  }

  void _updateStatus(String orderId, OrderStatus newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final current = _orders[index];
      final updated = Order(
        id: current.id,
        dateTime: current.dateTime,
        items: current.items,
        subtotal: current.subtotal,
        deliveryFee: current.deliveryFee,
        discount: current.discount,
        total: current.total,
        status: newStatus,
        deliveryAddress: current.deliveryAddress,
        paymentMethod: current.paymentMethod,
        estimatedMinutes: newStatus == OrderStatus.outForDelivery ? 4 : 8,
      );
      _orders[index] = updated;
      if (_activeOrder?.id == orderId) {
        _activeOrder = updated;
      }
      notifyListeners();
    }
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return null;
    }
  }
}
