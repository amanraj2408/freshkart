import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../screens/product/product_detail_screen.dart';
import 'fresh_image.dart';
import 'price_badge.dart';
import 'quantity_stepper.dart';

/// Reusable grocery item card with image, rating, tags, and reactive cart stepper.
class ProductCard extends StatelessWidget {
  final Product product;
  final double width;

  const ProductCard({
    super.key,
    required this.product,
    this.width = 165,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final currentQty = cartProvider.getProductQuantity(product.id);

        return Container(
          width: width,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: product),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image + Badges stack
                Stack(
                  children: [
                    Container(
                      height: 132,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppColors.creamBackground,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(22)),
                      ),
                      child: Hero(
                        tag: 'product_img_${product.id}',
                        child: FreshImage(
                          imageUrl: product.imageUrl,
                          height: 132,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(22)),
                        ),
                      ),
                    ),
                    // Badges
                    if (product.isBestseller)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'BESTSELLER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      )
                    else if (product.isOrganic)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'ORGANIC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    // Favorite icon
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Consumer<ProductProvider>(
                        builder: (context, prodProv, _) {
                          final isFav = prodProv.isFavorite(product.id);
                          return IconButton(
                            iconSize: 20,
                            splashRadius: 18,
                            icon: Icon(
                              isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFav
                                  ? AppColors.discountRed
                                  : AppColors.textMuted,
                            ),
                            onPressed: () =>
                                prodProv.toggleFavorite(product.id),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Info Section
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Unit and rating row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.unit,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 14, color: AppColors.accentAmber),
                              const SizedBox(width: 2),
                              Text(
                                product.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Title
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),

                      // Price and Add button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: PriceBadge(
                              price: product.price,
                              originalPrice: product.originalPrice,
                              fontSize: 14,
                              showDiscountTag: false,
                            ),
                          ),
                          QuantityStepper(
                            quantity: currentQty,
                            height: 32,
                            width: 76,
                            onAdd: () => cartProvider.addToCart(product),
                            onIncrement: () =>
                                cartProvider.incrementQuantity(product.id),
                            onDecrement: () =>
                                cartProvider.decrementQuantity(product.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
