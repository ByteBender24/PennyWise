//add_categories_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/category.dart';
import '../services/category_service.dart';
import 'package:uuid/uuid.dart';
import '../widgets/base_screen.dart'; // Import the BaseScreen widget

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.shopping_cart;
  final List<IconData> _icons = [
    Icons.shopping_cart,
    Icons.fastfood,
    Icons.directions_car,
    Icons.home,
    Icons.movie,
    Icons.sports_esports,
    Icons.health_and_safety,
    Icons.flight,
    Icons.school,
    Icons.attach_money
  ];

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pick a color"),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() => _selectedColor = color);
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  void _saveCategory() {
    if (_nameController.text.isEmpty) return;

    final newCategory = Category(
      id: const Uuid().v4(),
      name: _nameController.text,
      colorValue: _selectedColor.value,
      iconCode: _selectedIcon.codePoint,
    );

    CategoryService.addCategory(newCategory);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Category Name"),
          TextField(controller: _nameController),
          const SizedBox(height: 20),
          const Text("Choose an Icon"),
          Wrap(
            spacing: 10,
            children: _icons.map((icon) {
              return GestureDetector(
                onTap: () => setState(() => _selectedIcon = icon),
                child: CircleAvatar(
                  backgroundColor: _selectedIcon == icon ? Colors.green : Colors.grey.shade200,
                  child: Icon(icon, color: Colors.black),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text("Pick a Color: "),
              GestureDetector(
                onTap: _pickColor,
                child: CircleAvatar(backgroundColor: _selectedColor, radius: 15),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _saveCategory,
            child: const Text("Save Category"),
          ),
        ],
      ), title: 'Add Category',
    );
  }
}
