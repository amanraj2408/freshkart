import 'package:flutter_test/flutter_test.dart';
import 'package:freshkart/models/product.dart';
import 'package:freshkart/providers/cart_provider.dart';

void main() {
  group('CartProvider Unit Tests', () {
    late CartProvider cartProvider;
    const testProduct1 = Product(
      id: 'p1',
      name: 'Shimla Apples',
      categoryId: 'fruits_veg',
      unit: '500g',
      price: 100.0,
      imageUrl: 'https://example.com/apple.jpg',
      description: 'Fresh apples',
    );

    const testProduct2 = Product(
      id: 'p2',
      name: 'Organic Milk',
      categoryId: 'dairy_bakery',
      unit: '1L',
      price: 60.0,
      imageUrl: 'https://example.com/milk.jpg',
      description: 'Fresh toned milk',
    );

    setUp(() {
      cartProvider = CartProvider();
    });

    test('Initial cart is empty', () {
      expect(cartProvider.isEmpty, true);
      expect(cartProvider.totalItemCount, 0);
      expect(cartProvider.subtotal, 0.0);
      expect(cartProvider.deliveryFee, 0.0);
      expect(cartProvider.finalTotal, 0.0);
    });

    test('Adding product increases item count and updates subtotal', () {
      cartProvider.addToCart(testProduct1);

      expect(cartProvider.totalItemCount, 1);
      expect(cartProvider.getProductQuantity('p1'), 1);
      expect(cartProvider.subtotal, 100.0);
    });

    test('Incrementing quantity updates item count and subtotal', () {
      cartProvider.addToCart(testProduct1);
      cartProvider.incrementQuantity('p1');

      expect(cartProvider.totalItemCount, 2);
      expect(cartProvider.getProductQuantity('p1'), 2);
      expect(cartProvider.subtotal, 200.0);
    });

    test('Decrementing quantity reduces count and removes at 0', () {
      cartProvider.addToCart(testProduct1);
      cartProvider.incrementQuantity('p1');
      expect(cartProvider.getProductQuantity('p1'), 2);

      cartProvider.decrementQuantity('p1');
      expect(cartProvider.getProductQuantity('p1'), 1);
      expect(cartProvider.subtotal, 100.0);

      cartProvider.decrementQuantity('p1');
      expect(cartProvider.getProductQuantity('p1'), 0);
      expect(cartProvider.isEmpty, true);
    });

    test('Delivery fee applies when subtotal is below ₹299 threshold', () {
      cartProvider.addToCart(testProduct1); // Subtotal = 100
      expect(cartProvider.deliveryFee, 25.0);
      expect(cartProvider.finalTotal, 125.0);
    });

    test('Free delivery applies when subtotal is ₹299 or above', () {
      // Add 3 apples = ₹300
      cartProvider.addToCart(testProduct1);
      cartProvider.incrementQuantity('p1');
      cartProvider.incrementQuantity('p1');

      expect(cartProvider.subtotal, 300.0);
      expect(cartProvider.deliveryFee, 0.0);
      expect(cartProvider.finalTotal, 300.0);
    });

    test('Coupon code FRESH50 applies ₹50 discount', () {
      cartProvider.addToCart(testProduct1);
      cartProvider.incrementQuantity('p1');
      cartProvider.incrementQuantity('p1'); // Subtotal = 300, free delivery

      final success = cartProvider.applyCoupon('FRESH50');
      expect(success, true);
      expect(cartProvider.discount, 50.0);
      expect(cartProvider.finalTotal, 250.0);
    });

    test('Invalid coupon code is rejected', () {
      cartProvider.addToCart(testProduct1);
      final success = cartProvider.applyCoupon('INVALIDCODE');

      expect(success, false);
      expect(cartProvider.discount, 0.0);
    });

    test('Clearing cart resets all items and totals', () {
      cartProvider.addToCart(testProduct1);
      cartProvider.addToCart(testProduct2);
      expect(cartProvider.totalItemCount, 2);

      cartProvider.clearCart();
      expect(cartProvider.isEmpty, true);
      expect(cartProvider.totalItemCount, 0);
      expect(cartProvider.finalTotal, 0.0);
    });
  });
}
