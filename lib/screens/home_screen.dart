import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pennywise/screens/add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  double totalIncome = 5000; // Placeholder
  double totalExpenses = 3200; // Placeholder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Pennywise", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSummaryCard(),
            Expanded(child: _buildExpensesList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  /// Income & Expenses Summary
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

  /// Income & Expense Bar
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

  /// Expense List Placeholder
  Widget _buildExpensesList() {
    return ListView.builder(
      itemCount: 5, // Placeholder count
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text("Expense Title", style: TextStyle(color: Colors.white)),
              subtitle: Text(
                "Category - ${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: const Text("\$20.00", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }

  /// Bottom Navigation Bar
  Widget _buildBottomNavBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: Colors.black,
      child: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 20), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart, size: 20), label: "Stats"),
        ],
      ),
    );
  }
}
