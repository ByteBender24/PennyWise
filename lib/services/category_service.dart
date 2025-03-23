import 'package:hive/hive.dart';
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
}
