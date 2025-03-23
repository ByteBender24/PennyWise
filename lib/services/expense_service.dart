import 'package:hive/hive.dart';
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
}
