import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    setState(() {
      _categories = CategoryService.getCategories();
    });
  }

  void _addCategory() {
    if (_categoryController.text.isEmpty) return;

    final category = Category(
      id: const Uuid().v4(),
      name: _categoryController.text,
      icon: 'default',
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
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
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
          Expanded(
            child: _categories.isEmpty
                ? const Center(child: Text("No categories added"))
                : ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return ListTile(
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
}
