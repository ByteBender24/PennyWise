import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pennywise/widgets/base_screen.dart';
import 'package:uuid/uuid.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _categoryController = TextEditingController();
  List<Category> _categories = [];

  // ✅ Define selected icon and color
  IconData _selectedIcon = Icons.category;
  Color _selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    setState(() {
      _categories = CategoryService.getCategories();
      if (_categories.isEmpty) {
        _categories = [
          Category(id: const Uuid().v4(), name: "Others", iconCode: Icons.more_horiz.codePoint, colorValue: 0xFF03A9F4),
          Category(id: const Uuid().v4(), name: "Food", iconCode: Icons.restaurant.codePoint, colorValue: 0xFF4CAF50),
          Category(id: const Uuid().v4(), name: "Shopping", iconCode: Icons.shopping_cart.codePoint, colorValue: 0xFF2196F3),
          Category(id: const Uuid().v4(), name: "Transport", iconCode: Icons.directions_car.codePoint, colorValue: 0xFF47361C),
        ];
      }
    });
    print("Loaded Categories: $_categories");
  }

  void _addCategory() {
    if (_categoryController.text.isEmpty) return;

    final category = Category(
      id: const Uuid().v4(),
      name: _categoryController.text,
      iconCode: _selectedIcon.codePoint, // ✅ Store icon as int
      colorValue: _selectedColor.value, // ✅ Store color as ARGB int
    );

    CategoryService.addCategory(category);
    _categoryController.clear();
    _loadCategories();
  }

  void _deleteCategory(String id) {
    CategoryService.deleteCategory(id);
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 3,
      title: "Categories",
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(labelText: "Category Name"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addCategory,
                ),
              ],
            ),
          ),
          // ✅ Icon & Color Picker Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Icon Picker
                IconButton(
                  icon: Icon(_selectedIcon, size: 32),
                  onPressed: () {
                    // Open Icon Picker
                    showDialog(
                      context: context,
                      builder: (context) => _buildIconPicker(),
                    );
                  },
                ),
                const SizedBox(width: 16),
                // Color Picker
                GestureDetector(
                  onTap: () {
                    // Open Color Picker
                    showDialog(
                      context: context,
                      builder: (context) => _buildColorPicker(),
                    );
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _selectedColor,
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _categories.isEmpty
                ? const Center(child: Text("No categories added"))
                : ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return ListTile(
                        leading: Icon(IconData(category.iconCode,
                            fontFamily: 'MaterialIcons'), color: Color(category.colorValue)),
                        title: Text(category.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCategory(category.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ✅ Icon Picker Dialog
  Widget _buildIconPicker() {
    List<IconData> icons = [ 
      Icons.more_horiz,
      Icons.restaurant,
      Icons.shopping_cart,
      Icons.fastfood,
      Icons.directions_car,
      Icons.home,
      Icons.movie,
      Icons.sports_esports,
      Icons.health_and_safety,
      Icons.flight,
      Icons.school,
      Icons.gamepad,
      Icons.favorite,
      Icons.attach_money,
      Icons.bathtub,
      Icons.school,
      Icons.receipt,
      Icons.show_chart,
      Icons.home,
      Icons.monetization_on,
      Icons.security,
      Icons.card_giftcard,
    ];

    return AlertDialog(
      title: const Text("Select Icon"),
      content: Wrap(
        spacing: 10,
        children: icons.map((icon) {
          return IconButton(
            icon: Icon(icon),
            onPressed: () {
              setState(() => _selectedIcon = icon);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  // ✅ Color Picker Dialog
  Widget _buildColorPicker() {
    return AlertDialog(
      title: const Text("Select Color"),
      content: SingleChildScrollView(
        child: BlockPicker(
          pickerColor: _selectedColor,
          onColorChanged: (color) {
            setState(() => _selectedColor = color);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
