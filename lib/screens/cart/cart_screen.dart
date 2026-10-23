import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/fresh_image.dart';
import '../../widgets/quantity_stepper.dart';
import '../checkout/checkout_screen.dart';

/// Interactive cart screen with quantity steppers, coupon redemption, and transparent bill breakdown.
class CartScreen extends StatefulWidget {
  final bool isTab;

  const CartScreen({super.key, this.isTab = false});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon(CartProvider cartProv, String code) {
    final success = cartProv.applyCoupon(code);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Coupon "$code" applied! Saved ₹${cartProv.discount.toStringAsFixed(0)}'
              : 'Invalid coupon code. Try FRESH50 or WELCOME100',
        ),
        backgroundColor: success ? AppColors.primary : AppColors.error,
        duration: const Duration(seconds: 2),
      ),
    );
    if (success) {
      _couponController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartProvider, AuthProvider>(
      builder: (context, cartProv, authProv, _) {
        return Scaffold(
          backgroundColor: AppColors.creamBackground,
          appBar: AppBar(
            title: Text(
              'My Cart (${cartProv.totalItemCount} items)',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0.5,
            leading: widget.isTab
                ? null
                : IconButton(
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
            actions: [
              if (cartProv.isNotEmpty)
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        title: const Text('Clear Cart?'),
                        content: const Text(
                            'Are you sure you want to remove all items from your cart?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              cartProv.clearCart();
                              Navigator.pop(ctx);
                            },
                            child: const Text('Clear',
                                style: TextStyle(color: AppColors.error)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
          body: cartProv.isEmpty
              ? EmptyStateView(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Your cart is empty',
                  subtitle:
                      'Add farm fresh veggies, dairy, and daily groceries to start your 10-minute order!',
                  buttonText: 'Explore Fresh Items',
                  onButtonPressed: () {
                    if (!widget.isTab) {
                      Navigator.pop(context);
                    }
                  },
                )
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Free delivery banner
                            _buildFreeDeliveryProgress(cartProv),
                            const SizedBox(height: 16),

                            // Items List Card
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(color: AppColors.borderLight),
                              ),
                              child: Column(
                                children: cartProv.itemsList.map((item) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      children: [
                                        FreshImage(
                                          imageUrl: item.product.imageUrl,
                                          width: 60,
                                          height: 60,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.product.name,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.textPrimary,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                item.product.unit,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: AppColors.textMuted,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${AppConstants.currency}${item.product.price.toStringAsFixed(0)}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        QuantityStepper(
                                          quantity: item.quantity,
                                          height: 32,
                                          width: 78,
                                          onAdd: () =>
                                              cartProv.addToCart(item.product),
                                          onIncrement: () =>
                                              cartProv.incrementQuantity(
                                                  item.product.id),
                                          onDecrement: () =>
                                              cartProv.decrementQuantity(
                                                  item.product.id),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Coupons & Promos Card
                            _buildCouponSection(cartProv),
                            const SizedBox(height: 16),

                            // Bill Summary
                            _buildBillDetails(cartProv),
                            const SizedBox(height: 16),

                            // Cancellation info
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer
                                    .withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.shield_outlined,
                                      size: 20, color: AppColors.primary),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Guaranteed fresh produce. 100% replacement if you are unsatisfied with any item.',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.primaryDark,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),

                    // Floating Checkout Bar
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 16,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Grand Total',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                Text(
                                  '${AppConstants.currency}${cartProv.finalTotal.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const CheckoutScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.arrow_forward_rounded,
                                      color: Colors.white),
                                  label: const Text(
                                    'Proceed to Checkout',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildFreeDeliveryProgress(CartProvider cartProv) {
    final remaining = cartProv.freeDeliveryRemaining;
    final isFree = remaining == 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isFree ? AppColors.primaryContainer : AppColors.accentAmberLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFree ? AppColors.primaryLight : AppColors.accentAmber,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isFree ? Icons.check_circle_rounded : Icons.local_shipping_rounded,
            color: isFree ? AppColors.primary : AppColors.accentAmber,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isFree
                  ? 'Congratulations! You unlocked FREE Delivery on this order.'
                  : 'Add ${AppConstants.currency}${remaining.toStringAsFixed(0)} more to unlock FREE Delivery!',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isFree ? AppColors.primaryDark : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponSection(CartProvider cartProv) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Coupons & Offers',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          if (cartProv.appliedCoupon != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '${cartProv.appliedCoupon} applied (Saved ₹${cartProv.discount.toStringAsFixed(0)})',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: cartProv.removeCoupon,
                    child: const Text('Remove',
                        style: TextStyle(color: AppColors.error, fontSize: 12)),
                  ),
                ],
              ),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Enter promo code',
                      hintStyle: const TextStyle(
                          fontSize: 13, color: AppColors.textMuted),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.borderLight),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_couponController.text.trim().isNotEmpty) {
                      _applyCoupon(cartProv, _couponController.text.trim());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Apply',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Quick Apply Chips
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('FRESH50 (Flat ₹50 OFF)'),
                  labelStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                  backgroundColor: AppColors.primaryContainer,
                  onPressed: () => _applyCoupon(cartProv, 'FRESH50'),
                ),
                ActionChip(
                  label: const Text('WELCOME100 (₹100 OFF)'),
                  labelStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                  backgroundColor: AppColors.primaryContainer,
                  onPressed: () => _applyCoupon(cartProv, 'WELCOME100'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBillDetails(CartProvider cartProv) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bill Details',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildBillRow('Item Total',
              '${AppConstants.currency}${cartProv.subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          _buildBillRow(
            'Delivery Fee',
            cartProv.deliveryFee == 0
                ? 'FREE'
                : '${AppConstants.currency}${cartProv.deliveryFee.toStringAsFixed(0)}',
            isHighlight: cartProv.deliveryFee == 0,
          ),
          if (cartProv.discount > 0) ...[
            const SizedBox(height: 8),
            _buildBillRow(
              'Coupon Savings',
              '-${AppConstants.currency}${cartProv.discount.toStringAsFixed(0)}',
              isHighlight: true,
            ),
          ],
          const Divider(height: 20),
          _buildBillRow(
            'To Pay',
            '${AppConstants.currency}${cartProv.finalTotal.toStringAsFixed(0)}',
            isBold: true,
            fontSize: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(
    String label,
    String value, {
    bool isBold = false,
    bool isHighlight = false,
    double fontSize = 13,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            color: isHighlight
                ? AppColors.primary
                : (isBold ? AppColors.textPrimary : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
