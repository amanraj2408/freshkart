/// Global application constants and configuration values.
class AppConstants {
  AppConstants._();

  static const String appName = 'FreshKart';
  static const String appTagline = 'Fresh Groceries in 10 Minutes';
  static const String currency = '₹';

  // Delivery configuration
  static const double freeDeliveryThreshold = 299.0;
  static const double standardDeliveryFee = 25.0;
  static const double handlingFee = 5.0;

  // Promotional promo codes
  static const Map<String, double> validCoupons = {
    'FRESH50': 50.0,
    'WELCOME100': 100.0,
    'ORGANIC20': 20.0,
  };
}
