import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pennywise/screens/all_expenses_screen.dart';
import 'package:pennywise/widgets/base_screen.dart';
import 'package:uuid/uuid.dart';

import '../models/expense.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box expenseBox;
  double totalIncome = 5000;
  double totalExpenses = 0.0;
  List<Map<String, dynamic>> expenses = [];

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  void _openBox() async {
    if (!Hive.isBoxOpen('expenses')) {
      expenseBox = await Hive.openBox<Expense>('expenses');
    } else {
      expenseBox = Hive.box<Expense>('expenses');
    }
    _calculateTotals();
    _loadExpenses();
  }

  void _calculateTotals() {
    totalExpenses =
        expenseBox.values.fold(0, (sum, expense) => sum + expense.amount);
    setState(() {});
  }

  void _loadExpenses() {
    final List<Map<String, dynamic>> loadedExpenses = [];
    double calculatedTotalExpenses = 0.0;

    for (var expense in expenseBox.values) {
      if (expense is Expense) {
        loadedExpenses.add({
          'title': expense.title,
          'amount': expense.amount,
          'category': expense.category,
          'date': expense.date,
        });
        calculatedTotalExpenses += expense.amount;
      }
    }

    setState(() {
      expenses = loadedExpenses;
      totalExpenses = calculatedTotalExpenses;
    });
  }

  void _addExpense(Map<String, dynamic> newExpense) async {
    String expenseId = Uuid().v4();
    
    await expenseBox.add({
      'title': newExpense['title'],
      'amount': newExpense['amount'],
      'category': newExpense['category'],
      'date': newExpense['date'].toIso8601String(),
    });

    setState(() {
      _loadExpenses();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Home Screen",
      currentIndex: 0,
      body: Column(
        children: [
          _buildSummaryCard(),
          Expanded(child: _buildExpensesList()),
        ],
      )
    );
  }

  Widget _buildSummaryCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Total Balance",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              "\$${(totalIncome - totalExpenses).toStringAsFixed(2)}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIncomeExpenseCard("Income", totalIncome, Colors.green),
                _buildIncomeExpenseCard("Expenses", totalExpenses, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseCard(String title, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: color, fontSize: 14)),
        const SizedBox(height: 5),
        Text(
          "\$${amount.toStringAsFixed(2)}",
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildExpensesList() {
    return Column(
      children: [
        TextButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AllExpensesScreen()),
            );
            setState(() {
              _loadExpenses();
            });
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("View All Expenses", style: TextStyle(color: Colors.green)),
              Icon(Icons.arrow_forward, color: Colors.green)
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: expenses.length > 5 ? 5 : expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return ListTile(
                title: Text(expense['title'],
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                  "${expense['category']} - ${DateFormat('yyyy-MM-dd').format(expense['date'])}",
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: Text(
                  "\$${expense['amount'].toStringAsFixed(2)}",
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
