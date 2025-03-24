import 'package:flutter/material.dart';
import 'package:pennywise/screens/analytics_screen.dart';
import 'package:pennywise/screens/budgeting_screen.dart';
import 'package:pennywise/screens/home_screen.dart';
import 'package:pennywise/screens/more_screen.dart';
import 'package:pennywise/screens/add_expense_screen.dart'; // Import AddExpenseScreen

class BaseScreen extends StatefulWidget {
  final String title;
  final Widget body;
  final int currentIndex; // Track current tab

  const BaseScreen({
    Key? key,
    required this.title,
    required this.body,
    required this.currentIndex, // Required index parameter
  }) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  void _navigateToScreen(BuildContext context, int index) {
    if (index == widget.currentIndex) return; // Avoid unnecessary navigation

    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AnalyticsScreen()));
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BudgetingScreen()));
        break;
      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SettingsScreen()));
        break;
    }
  }

  // Placeholder for _addExpense function
  void _addExpense(dynamic newExpense) {
    // Implement your expense adding logic here
    print("New expense added: $newExpense");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black, // Match the dark theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.body,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // Make it transparent
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          currentIndex: widget.currentIndex, // Dynamic index
          onTap: (index) => _navigateToScreen(context, index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home, size: 20), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.pie_chart, size: 20), label: "Stats"),
            BottomNavigationBarItem(icon: Icon(Icons.book, size: 20), label: "Budgeting"),
            BottomNavigationBarItem(icon: Icon(Icons.more, size: 20), label: "More"),
          ],
        ),
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}