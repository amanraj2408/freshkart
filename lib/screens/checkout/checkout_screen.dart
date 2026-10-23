import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/custom_button.dart';
import 'order_success_screen.dart';

/// Checkout screen allowing address confirmation, payment method selection, and order placement.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'Cash on Delivery';
  String _deliveryInstruction = 'Leave at door';
  bool _isPlacingOrder = false;

  final List<Map<String, dynamic>> _paymentOptions = [
    {
      'title': 'Cash on Delivery',
      'subtitle': 'Pay cash or UPI to rider upon arrival',
      'icon': Icons.payments_outlined,
    },
    {
      'title': 'UPI (GPay / PhonePe / Paytm)',
      'subtitle': 'Instant payment via installed UPI apps',
      'icon': Icons.account_balance_wallet_outlined,
    },
    {
      'title': 'Credit or Debit Card',
      'subtitle': 'Visa, Mastercard, RuPay & Maestro',
      'icon': Icons.credit_card_outlined,
    },
  ];

  final List<String> _instructionOptions = [
    'Leave at door',
    'Do not ring bell',
    'Avoid calling',
    'Leave with guard',
  ];

  void _handlePlaceOrder() {
    final cartProv = Provider.of<CartProvider>(context, listen: false);
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final orderProv = Provider.of<OrderProvider>(context, listen: false);

    if (cartProv.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;

      final newOrder = orderProv.placeOrder(
        items: cartProv.itemsList,
        subtotal: cartProv.subtotal,
        deliveryFee: cartProv.deliveryFee,
        discount: cartProv.discount,
        total: cartProv.finalTotal,
        deliveryAddress: authProv.activeDeliveryAddress,
        paymentMethod: _selectedPaymentMethod,
      );

      cartProv.clearCart();
      setState(() => _isPlacingOrder = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(order: newOrder),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer2<CartProvider, AuthProvider>(
        builder: (context, cartProv, authProv, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery Address Card
                _buildSectionHeader('DELIVERY ADDRESS'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Deliver to Home',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              authProv.activeDeliveryAddress,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Delivery Time Card
                _buildSectionHeader('DELIVERY ESTIMATE'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.bolt_rounded, color: AppColors.accentAmber, size: 28),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Superfast Delivery in 10 Minutes',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'FreshKart Express Hub',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Delivery Instructions
                _buildSectionHeader('DELIVERY INSTRUCTIONS'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _instructionOptions.map((opt) {
                    final isSelected = _deliveryInstruction == opt;
                    return ChoiceChip(
                      label: Text(opt),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _deliveryInstruction = opt);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Payment Options
                _buildSectionHeader('PAYMENT METHOD'),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    children: _paymentOptions.map((opt) {
                      final isSelected = _selectedPaymentMethod == opt['title'];
                      return ListTile(
                        leading: Icon(
                          opt['icon'] as IconData,
                          color: isSelected ? AppColors.primary : AppColors.textMuted,
                        ),
                        title: Text(
                          opt['title'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          opt['subtitle'] as String,
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        trailing: Radio<String>(
                          value: opt['title'] as String,
                          groupValue: _selectedPaymentMethod,
                          activeColor: AppColors.primary,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedPaymentMethod = val);
                            }
                          },
                        ),
                        onTap: () {
                          setState(() => _selectedPaymentMethod = opt['title'] as String);
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Summary
                _buildSectionHeader('PAYMENT SUMMARY'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    children: [
                      _buildBillRow('Items Total', '${AppConstants.currency}${cartProv.subtotal.toStringAsFixed(0)}'),
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
                          'Coupon Discount (${cartProv.appliedCoupon})',
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
                ),
                const SizedBox(height: 24),

                // Place Order Button
                CustomButton(
                  label: 'Place Order • ${AppConstants.currency}${cartProv.finalTotal.toStringAsFixed(0)}',
                  isLoading: _isPlacingOrder,
                  icon: Icons.lock_outline_rounded,
                  onPressed: _handlePlaceOrder,
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.textMuted,
          letterSpacing: 0.8,
        ),
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
