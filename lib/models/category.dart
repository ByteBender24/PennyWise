import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int iconCode; // Stores icon as Unicode codePoint

  @HiveField(3)
  final int colorValue; // Stores color as ARGB integer

  Category({
    required this.id,
    required this.name,
    required this.iconCode, // Example: Icons.shopping_cart.codePoint
    required this.colorValue, // Example: Colors.blue.value
  });

  // ✅ Convert stored iconCode back to IconData
  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');

  // ✅ Convert stored colorValue back to Color
  Color get color => Color(colorValue);
}
