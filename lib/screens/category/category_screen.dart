import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/product_provider.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/product_card.dart';
import '../../widgets/search_bar_widget.dart';

/// Categories browser with department filtering and reactive grocery grid.
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text(
          'All Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, prodProv, _) {
          final categories = prodProv.categories;
          final products = prodProv.filteredProducts;

          return Column(
            children: [
              // Search in category
              Container(
                color: Colors.white,
                child: SearchBarWidget(
                  initialValue: prodProv.searchQuery,
                  onChanged: (query) => prodProv.updateSearchQuery(query),
                  onClear: () => prodProv.clearSearch(),
                ),
              ),

              // Categories selector
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 16, bottom: 12),
                child: SizedBox(
                  height: 42,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final isSelected = prodProv.selectedCategoryId == cat.id;
                      return CategoryChip(
                        category: cat,
                        isSelected: isSelected,
                        onTap: () => prodProv.selectCategory(cat.id),
                      );
                    },
                  ),
                ),
              ),

              // Products Grid or Empty state
              Expanded(
                child: products.isEmpty
                    ? EmptyStateView(
                        icon: Icons.search_off_rounded,
                        title: 'No groceries found',
                        subtitle:
                            'Try searching for something else or pick a different category.',
                        buttonText: 'Reset Filters',
                        onButtonPressed: () {
                          prodProv.clearSearch();
                          prodProv.selectCategory('all');
                        },
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: products[index],
                            width: double.infinity,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
