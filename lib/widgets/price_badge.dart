import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

/// Renders formatted grocery pricing, strikethrough original price, and savings badge.
class PriceBadge extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final double fontSize;
  final bool showDiscountTag;

  const PriceBadge({
    super.key,
    required this.price,
    this.originalPrice,
    this.fontSize = 15,
    this.showDiscountTag = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = originalPrice != null && originalPrice! > price;
    final discountPercent = hasDiscount
        ? (((originalPrice! - price) / originalPrice!) * 100).round()
        : 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${AppConstants.currency}${price.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        if (hasDiscount) ...[
          const SizedBox(width: 6),
          Text(
            '${AppConstants.currency}${originalPrice!.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: fontSize * 0.8,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          if (showDiscountTag && discountPercent > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.discountRedLight,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$discountPercent% OFF',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.discountRed,
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }
}
