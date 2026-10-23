import 'package:flutter/material.dart';

/// Category model for grocery departments.
class Category {
  final String id;
  final String name;
  final IconData icon;
  final String imageUrl;
  final Color backgroundColor;
  final int itemCount;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.imageUrl,
    required this.backgroundColor,
    this.itemCount = 0,
  });
}
