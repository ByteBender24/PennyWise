import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';

class ExpenseService {
  static final _expenseBox = Hive.box<Expense>('expenses');

  static List<Expense> getExpenses() {
    return _expenseBox.values.toList();
  }

  static void addExpense(Expense expense) {
    _expenseBox.put(expense.id, expense);
  }

  static void deleteExpense(String id) {
    _expenseBox.delete(id);
  }

  // ✅ Initialize default expenses only if the box is empty
  static Future<void> initializeExpenses() async {
  if (_expenseBox.isEmpty) {
    List<Expense> defaultExpenses = [
      Expense(id: const Uuid().v4(), title: 'Groceries', amount: 1200, category: 'Food', date: DateTime.now().subtract(const Duration(days: 1))),
      Expense(id: const Uuid().v4(), title: 'Uber Ride', amount: 250, category: 'Transport', date: DateTime.now().subtract(const Duration(days: 2))),
      Expense(id: const Uuid().v4(), title: 'Netflix', amount: 500, category: 'Entertainment', date: DateTime.now().subtract(const Duration(days: 3))),
    ];

    for (var expense in defaultExpenses) {
      _expenseBox.put(expense.id, expense);
    }

    await _expenseBox.flush(); // Force data to persist
  }
}
}
