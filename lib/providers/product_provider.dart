import 'package:flutter/foundation.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../services/mock_data_service.dart';

/// State manager for catalog, search query, category filters, and product details.
class ProductProvider with ChangeNotifier {
  List<Category> _categories = [];
  List<Product> _products = [];
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  final Set<String> _favoriteProductIds = {};

  ProductProvider() {
    _loadInitialData();
  }

  void _loadInitialData() {
    _categories = MockDataService.getCategories();
    _products = MockDataService.getProducts();
  }

  List<Category> get categories => _categories;

  List<Product> get allProducts => _products;

  String get selectedCategoryId => _selectedCategoryId;

  String get searchQuery => _searchQuery;

  List<Product> get filteredProducts {
    return _products.where((product) {
      final matchesCategory = _selectedCategoryId == 'all' ||
          product.categoryId == _selectedCategoryId;

      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<Product> get bestsellerProducts {
    return _products.where((p) => p.isBestseller).toList();
  }

  List<Product> get organicProducts {
    return _products.where((p) => p.isOrganic).toList();
  }

  void selectCategory(String categoryId) {
    if (_selectedCategoryId != categoryId) {
      _selectedCategoryId = categoryId;
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }

  void toggleFavorite(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
