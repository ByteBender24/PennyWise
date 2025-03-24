import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pennywise/screens/add_expense_screen.dart';
import 'package:pennywise/screens/all_expenses_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  double totalIncome = 5000; // Placeholder
  double totalExpenses = 3200; // Placeholder

  final List<Map<String, dynamic>> expenses = [
    {'note': 'Groceries', 'amount': 50.00, 'category': 'Food', 'date': DateTime.now()},
    {'note': 'Transport', 'amount': 15.00, 'category': 'Travel', 'date': DateTime.now()},
    {'note': 'Subscription', 'amount': 10.00, 'category': 'Entertainment', 'date': DateTime.now()},
    {'note': 'Dinner', 'amount': 30.00, 'category': 'Food', 'date': DateTime.now()},
    {'note': 'Electricity Bill', 'amount': 100.00, 'category': 'Utilities', 'date': DateTime.now()},
    {'note': 'Gym Membership', 'amount': 25.00, 'category': 'Health', 'date': DateTime.now()},
    {'note': 'Internet Bill', 'amount': 40.00, 'category': 'Utilities', 'date': DateTime.now()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Pennywise", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.list, color: Colors.white), 
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllExpensesScreen(expenses: expenses)),
              );
            },
          ),
        ],
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
    int endIndex = _currentPage * _itemsPerPage;
    List<Map<String, dynamic>> paginatedExpenses = expenses.sublist(
      0,
      endIndex > expenses.length ? expenses.length : endIndex,
    );

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: paginatedExpenses.length,
            itemBuilder: (context, index) {
              final expense = paginatedExpenses[index];
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
        if (endIndex < expenses.length)
          TextButton(
            onPressed: () {
              setState(() {
                _currentPage++;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Load More", style: TextStyle(color: Colors.green)),
                Icon(Icons.expand_more, color: Colors.green)
              ],
            ),
          ),
      ],
    );
  }

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
          BottomNavigationBarItem(icon: Icon(Icons.book, size: 20), label: "Budgeting"),
          BottomNavigationBarItem(icon: Icon(Icons.more, size: 20), label: "More"),
        ],
      ),
    );
  }
}
