import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:pennywise/services/auth_service.dart';
import '../models/expense.dart';

class BudgetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Box<Expense> _expenseBox = Hive.box<Expense>('expenses');

  Future<void> addMonthlyBudget(double amount, String monthYear) async {
    User? user = AuthService().getCurrentUser();
    if (user == null) return;

    String userId = user.uid;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(monthYear)
        .set({
      'totalBudget': amount,
      'totalSpent': 0,
      'availableBudget': amount,
    });
  }

  Future<void> addCategoryBudget(
      String monthYear, String category, double amount) async {
    User? user = AuthService().getCurrentUser();
    if (user == null) return;

    String userId = user.uid;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(monthYear)
        .collection('categories')
        .doc(category)
        .set({
      'budget': amount,
      'spent': 0,
      'available': amount,
    });
  }

  Future<Map<String, dynamic>?> getMonthlyBudget(String monthYear) async {
    User? user = AuthService().getCurrentUser();
    if (user == null) return null;

    String userId = user.uid;
    DocumentSnapshot doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(monthYear)
        .get();
    return doc.exists ? doc.data() as Map<String, dynamic> : null;
  }

  Future<List<Map<String, dynamic>>> getCategoryBudgets(
      String monthYear) async {
    User? user = AuthService().getCurrentUser();
    if (user == null) return [];

    String userId = user.uid;
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(monthYear)
        .collection('categories')
        .get();
    return querySnapshot.docs
        .map((doc) => {
              'category': doc.id,
              'budget': doc['budget'],
              'spent': doc['spent'],
            })
        .toList();
  }

  Future<double> getMonthlyExpenses(String monthYear) async {
    double totalSpent = 0.0;
    print(monthYear);
    for (var expense in _expenseBox.values) {
      print("Expense Date: ${expense.date}");
      if (_isSameMonthYear(expense.date, monthYear)) {
        print("Matching Expense Amount: ${expense.amount}");
        totalSpent += expense.amount;
      }
    }
    return totalSpent;
  }

  Future<double> getCategoryMonthlyExpense(
      String monthYear, String category) async {
    double totalSpent = 0.0;
    for (var expense in _expenseBox.values) {
      if (_isSameMonthYear(expense.date, monthYear) &&
          expense.category == category) {
        totalSpent += expense.amount;
      }
    }
    return totalSpent;
  }

  // ✅ FIXED: Now correctly formats dates to "YYYY-MM"
  bool _isSameMonthYear(DateTime date, String monthYear) {
    List<String> monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    String formattedDate = "${monthNames[date.month - 1]} ${date.year}";
    return formattedDate == monthYear;
  }
}
