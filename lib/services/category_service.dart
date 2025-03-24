import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/category.dart';

class CategoryService {
  static final _categoryBox = Hive.box<Category>('categories');

  static List<Category> getCategories() {
    return _categoryBox.values.toList();
  }

  static void addCategory(Category category) {
    _categoryBox.put(category.id, category);
  }

  static void deleteCategory(String id) {
    _categoryBox.delete(id);
  }

  static List<Category> _categories = [];

  // ✅ Initialize default categories only if the list is empty
  static Future<void> initializeCategories() async {
    if (_categories.isEmpty) {
      _categories = [
        Category(id: const Uuid().v4(), name: "Others", iconCode: Icons.more_horiz.codePoint, colorValue: 0xFF03A9F4),
        Category(id: const Uuid().v4(), name: "Food", iconCode: Icons.restaurant.codePoint, colorValue: 0xFFFF5722),
        Category(id: const Uuid().v4(), name: "Shopping", iconCode: Icons.shopping_cart.codePoint, colorValue: 0xFF2196F3),
        Category(id: const Uuid().v4(), name: "Transport", iconCode: Icons.directions_car.codePoint, colorValue: 0xFF47361C),
      ];
    }
  }
}
