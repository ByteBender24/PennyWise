import 'package:flutter/material.dart';
import 'package:pennywise/screens/analytics_screen.dart';
import 'package:pennywise/screens/budgeting_screen.dart';
import 'package:pennywise/screens/home_screen.dart';
import 'package:pennywise/screens/more_screen.dart';


class BaseScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final FloatingActionButton? floatingActionButton;

  const BaseScreen({
    Key? key,
    required this.title,
    required this.body,
    this.floatingActionButton,
  }) : super(key: key);

  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AnalyticsScreen()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BudgetingScreen()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: body,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Colors.black,
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          currentIndex: 0,
          onTap: (index) => _navigateToScreen(context, index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home, size: 20), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.pie_chart, size: 20), label: "Stats"),
            BottomNavigationBarItem(icon: Icon(Icons.book, size: 20), label: "Budgeting"),
            BottomNavigationBarItem(icon: Icon(Icons.more, size: 20), label: "More"),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
