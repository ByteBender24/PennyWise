import 'package:hive/hive.dart';
import '../models/budget.dart';

class BudgetService {
  static final Box<Budget> _budgetBox = Hive.box<Budget>('budgets');
    
  
  
  static Future<Budget?> getBudget(String category) async {
    print ("🖐Budgets: ${_budgetBox.values.toList()}");
    return _budgetBox.values.firstWhere(
      (budget) => budget.category == category,
      orElse: () => Budget(category: category, limit: 0, spent: 0),
    );
  }

  static Future<void> addBudget(Budget budget) async {
    await _budgetBox.add(budget);
  }

  static Future<void> updateBudget(Budget budget) async {
    final index = _budgetBox.values.toList().indexWhere(
      (b) => b.category == budget.category,
    );

    if (index != -1) {
      await _budgetBox.putAt(index, budget);
    }
  }
}
