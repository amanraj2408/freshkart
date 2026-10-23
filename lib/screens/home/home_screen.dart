import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/banner_carousel.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/location_header.dart';
import '../../widgets/product_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../cart/cart_screen.dart';

/// Main grocery catalog screen featuring quick categories, deals, banners, and search.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: Consumer2<ProductProvider, CartProvider>(
          builder: (context, prodProv, cartProv, _) {
            final isSearching = prodProv.searchQuery.isNotEmpty;
            final searchResults = prodProv.filteredProducts;

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // Sticky Location Header & Search Bar
                    SliverToBoxAdapter(
                      child: Container(
                        color: AppColors.creamBackground,
                        child: Column(
                          children: [
                            const LocationHeader(),
                            SearchBarWidget(
                              initialValue: prodProv.searchQuery,
                              onChanged: (query) =>
                                  prodProv.updateSearchQuery(query),
                              onClear: () => prodProv.clearSearch(),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ),

                    // Content: If Searching, show search grid
                    if (isSearching) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Results for "${prodProv.searchQuery}"',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${searchResults.length} items',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (searchResults.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: EmptyStateView(
                            icon: Icons.search_off_rounded,
                            title: 'No matching groceries found',
                            subtitle:
                                'Check spelling or browse through our fresh categories below.',
                            buttonText: 'Clear Search',
                            onButtonPressed: () => prodProv.clearSearch(),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.66,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => ProductCard(
                                product: searchResults[index],
                                width: double.infinity,
                              ),
                              childCount: searchResults.length,
                            ),
                          ),
                        ),
                    ] else ...[
                      // Normal Home Screen Feed
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                          child: _buildMarketIntro(
                            productCount: prodProv.allProducts.length,
                          ),
                        ),
                      ),

                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 18),
                          child: BannerCarousel(),
                        ),
                      ),

                      // Categories Horizontal Scroller
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'The market',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 48,
                              child: ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                scrollDirection: Axis.horizontal,
                                itemCount: prodProv.categories.length,
                                itemBuilder: (context, index) {
                                  final cat = prodProv.categories[index];
                                  final isSelected =
                                      prodProv.selectedCategoryId == cat.id;
                                  return CategoryChip(
                                    category: cat,
                                    isSelected: isSelected,
                                    onTap: () =>
                                        prodProv.selectCategory(cat.id),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

                      // Trending Fresh Deals
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                              title: 'Today’s good picks',
                              subtitle: 'Little treats, lovely prices.',
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 264,
                              child: ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                scrollDirection: Axis.horizontal,
                                itemCount: prodProv.bestsellerProducts.length,
                                itemBuilder: (context, index) {
                                  return ProductCard(
                                    product: prodProv.bestsellerProducts[index],
                                    width: 165,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

                      // 100% Farm Fresh & Organic Section
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                              title: 'Grown with care',
                              subtitle: 'Organic produce from trusted farms.',
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 264,
                              child: ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                scrollDirection: Axis.horizontal,
                                itemCount: prodProv.organicProducts.length,
                                itemBuilder: (context, index) {
                                  return ProductCard(
                                    product: prodProv.organicProducts[index],
                                    width: 165,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

                      // All Groceries Grid Section Title
                      SliverToBoxAdapter(
                        child: _buildSectionTitle(
                          title: prodProv.selectedCategoryId == 'all'
                              ? 'The everyday edit'
                              : 'Selected for you',
                          subtitle: 'Good food for the days you actually live.',
                        ),
                      ),

                      // All Filtered Products Grid
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 90),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.68,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => ProductCard(
                              product: prodProv.filteredProducts[index],
                              width: double.infinity,
                            ),
                            childCount: prodProv.filteredProducts.length,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // Floating Cart Pill (Shows when cart has items)
                if (cartProv.isNotEmpty)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryDark.withValues(
                                alpha: 0.24,
                              ),
                              blurRadius: 22,
                              offset: const Offset(0, 9),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.shopping_bag_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${cartProv.totalItemCount} ${cartProv.totalItemCount == 1 ? 'item' : 'items'} in cart',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${AppConstants.currency}${cartProv.finalTotal.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Row(
                              children: [
                                Text(
                                  'View Cart',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMarketIntro({required int productCount}) {
    return Container(
      height: 218,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -28,
            top: -44,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryLight.withValues(alpha: 0.18),
                  width: 28,
                ),
              ),
            ),
          ),
          Positioned(
            right: 26,
            bottom: 22,
            child: Icon(
              Icons.eco_rounded,
              size: 96,
              color: AppColors.primaryLight.withValues(alpha: 0.92),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'A LITTLE FRESHER',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Good things,\nfrom the ground up.',
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 27,
                    height: 1.08,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  '$productCount market finds · at your door in 10 min',
                  style: TextStyle(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.72),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
