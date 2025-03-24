// home_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pennywise/screens/add_expense_screen.dart';
import 'package:pennywise/screens/all_expenses_screen.dart';
import 'package:pennywise/widgets/base_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalIncome = 5000; // Placeholder
  double totalExpenses = 3200; // Placeholder
  
  List<Map<String, dynamic>> expenses = [
    {'note': 'Groceries', 'amount': 50.00, 'category': 'Food', 'date': DateTime.now()},
    {'note': 'Transport', 'amount': 15.00, 'category': 'Travel', 'date': DateTime.now()},
    {'note': 'Subscription', 'amount': 10.00, 'category': 'Entertainment', 'date': DateTime.now()},
    {'note': 'Dinner', 'amount': 30.00, 'category': 'Food', 'date': DateTime.now()},
    {'note': 'Electricity Bill', 'amount': 100.00, 'category': 'Utilities', 'date': DateTime.now()},
  ];

  void _addExpense(Map<String, dynamic> newExpense) {
    setState(() {
      expenses.insert(0, newExpense);
      totalExpenses += newExpense['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Column(
        children: [
          _buildSummaryCard(),
          Expanded(child: _buildExpensesList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newExpense = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
          if (newExpense != null) {
            _addExpense(newExpense);
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ), title: 'Home Screen',
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
            const Text("Total Balance", style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              "\$${(totalIncome - totalExpenses).toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
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
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildExpensesList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: expenses.length > 5 ? 5 : expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return ListTile(
                title: Text(expense['note'], style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                  "${expense['category']} - ${DateFormat('yyyy-MM-dd').format(expense['date'])}",
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: Text(
                  "\$${expense['amount'].toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllExpensesScreen(expenses: expenses)),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("View All Expenses", style: TextStyle(color: Colors.green)),
              Icon(Icons.arrow_forward, color: Colors.green)
            ],
          ),
        ),
      ],
    );
  }
}
