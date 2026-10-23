import 'package:flutter/material.dart';

/// App-wide color palette for FreshKart's editorial market style.
class AppColors {
  AppColors._();

  // Deep ink and electric-lime accents
  static const Color primary = Color(0xFF183D35);
  static const Color primaryLight = Color(0xFFB9F35A);
  static const Color primaryDark = Color(0xFF102B25);
  static const Color primaryContainer = Color(0xFFE9F4D7);

  // Warm paper surfaces
  static const Color creamBackground = Color(0xFFF4F2EA);
  static const Color cardBackground = Color(0xFFFFFEFA);
  static const Color creamSecondary = Color(0xFFEAE6D8);
  static const Color surfaceLight = Color(0xFFF9F8F3);

  // Accent colors
  static const Color accentAmber = Color(0xFFE99A32);
  static const Color accentAmberLight = Color(0xFFFFE9C8);
  static const Color discountRed = Color(0xFFD85C45);
  static const Color discountRedLight = Color(0xFFF9E4DC);

  // Text colors
  static const Color textPrimary = Color(0xFF202823);
  static const Color textSecondary = Color(0xFF69716A);
  static const Color textMuted = Color(0xFF969B91);
  static const Color textOnPrimary = Color(0xFFFFFEFA);

  // Borders and dividers
  static const Color borderLight = Color(0xFFE4E1D7);
  static const Color divider = Color(0xFFEDEAE1);

  // Status colors
  static const Color success = Color(0xFF33845D);
  static const Color error = Color(0xFFD85C45);
  static const Color warning = Color(0xFFE99A32);
  static const Color info = Color(0xFF5B7D9A);
}
