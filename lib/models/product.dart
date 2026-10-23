/// Data model representing a grocery item in FreshKart.
class Product {
  final String id;
  final String name;
  final String categoryId;
  final String unit; // e.g. "500 g", "1 kg", "1 pc", "1 L"
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String description;
  final bool isOrganic;
  final bool isBestseller;
  final bool inStock;

  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.unit,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.rating = 4.5,
    this.reviewCount = 120,
    required this.description,
    this.isOrganic = false,
    this.isBestseller = false,
    this.inStock = true,
  });

  int get discountPercentage {
    if (originalPrice == null || originalPrice! <= price) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  Product copyWith({
    String? id,
    String? name,
    String? categoryId,
    String? unit,
    double? price,
    double? originalPrice,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    String? description,
    bool? isOrganic,
    bool? isBestseller,
    bool? inStock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      description: description ?? this.description,
      isOrganic: isOrganic ?? this.isOrganic,
      isBestseller: isBestseller ?? this.isBestseller,
      inStock: inStock ?? this.inStock,
    );
  }
}
