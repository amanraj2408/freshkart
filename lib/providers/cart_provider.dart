import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

/// Central state management for cart operations, totals, discounts, and item quantities.
class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  String? _appliedCoupon;
  double _discountAmount = 0.0;

  Map<String, CartItem> get items => {..._items};

  List<CartItem> get itemsList => _items.values.toList();

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

  int get totalItemCount {
    int count = 0;
    _items.forEach((key, item) {
      count += item.quantity;
    });
    return count;
  }

  int getProductQuantity(String productId) {
    return _items[productId]?.quantity ?? 0;
  }

  double get subtotal {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.totalPrice;
    });
    return total;
  }

  double get deliveryFee {
    if (subtotal == 0) return 0.0;
    if (subtotal >= AppConstants.freeDeliveryThreshold) {
      return 0.0;
    }
    return AppConstants.standardDeliveryFee;
  }

  double get freeDeliveryRemaining {
    if (subtotal >= AppConstants.freeDeliveryThreshold) return 0.0;
    return AppConstants.freeDeliveryThreshold - subtotal;
  }

  double get discount => _discountAmount;

  String? get appliedCoupon => _appliedCoupon;

  double get finalTotal {
    if (subtotal == 0) return 0.0;
    final total = subtotal + deliveryFee - _discountAmount;
    return total > 0 ? total : 0.0;
  }

  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItem(product: product, quantity: 1);
    }
    _recalculateDiscount();
    notifyListeners();
  }

  void incrementQuantity(String productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity += 1;
      _recalculateDiscount();
      notifyListeners();
    }
  }

  void decrementQuantity(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity -= 1;
    } else {
      _items.remove(productId);
    }

    if (_items.isEmpty) {
      _appliedCoupon = null;
      _discountAmount = 0.0;
    } else {
      _recalculateDiscount();
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    if (_items.containsKey(productId)) {
      _items.remove(productId);
      if (_items.isEmpty) {
        _appliedCoupon = null;
        _discountAmount = 0.0;
      } else {
        _recalculateDiscount();
      }
      notifyListeners();
    }
  }

  bool applyCoupon(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (AppConstants.validCoupons.containsKey(cleanCode)) {
      _appliedCoupon = cleanCode;
      _recalculateDiscount();
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _appliedCoupon = null;
    _discountAmount = 0.0;
    notifyListeners();
  }

  void _recalculateDiscount() {
    if (_appliedCoupon != null && AppConstants.validCoupons.containsKey(_appliedCoupon!)) {
      final couponVal = AppConstants.validCoupons[_appliedCoupon!]!;
      // Discount cannot exceed subtotal
      _discountAmount = couponVal > subtotal ? subtotal : couponVal;
    } else {
      _discountAmount = 0.0;
    }
  }

  void clearCart() {
    _items.clear();
    _appliedCoupon = null;
    _discountAmount = 0.0;
    notifyListeners();
  }
}
