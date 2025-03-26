
import 'package:flutter/material.dart';
import 'package:pennywise/screens/analytics_screen.dart';
import 'package:pennywise/screens/budgeting_screen.dart';
import 'package:pennywise/screens/home_screen.dart';
import 'package:pennywise/screens/more_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  initialRoute: '/all_accounts',
  routes: {
    '/analytics': (context) => AnalysisScreen(),
    '/budgeting': (context) => BudgetScreen(),
    '/more': (context) => SettingsScreen(),
    '/home': (context) => const HomeScreen()
  },
  debugShowCheckedModeBanner: false,
  theme: ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
    ),
  ),
);
  }
}

class AccountsScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Accounts'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Add account functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBankAccountsSection(context),
            SizedBox(height: 20),
            _buildCashSection(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAmountInputDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBankAccountsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.account_balance, color: Colors.white),
            SizedBox(width: 10),
            Text('Bank Accounts', style: TextStyle(color: Colors.white)),
          ],
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bank Account', style: TextStyle(color: Colors.white)),
              Row(
                children: [
                  Text('*****', style: TextStyle(color: Colors.white)),
                  Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCashSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.money, color: Colors.white),
            SizedBox(width: 10),
            Text('Cash', style: TextStyle(color: Colors.white)),
          ],
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cash', style: TextStyle(color: Colors.white)),
              Row(
                children: [
                  Text('*****', style: TextStyle(color: Colors.white)),
                  Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey[900],
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
  icon: Icon(Icons.home, color: Colors.grey),
  onPressed: () {
    Navigator.pushNamed(context, '/home');
  },
),
IconButton(
  icon: Icon(Icons.show_chart, color: Colors.grey),
  onPressed: () {
    Navigator.pushNamed(context, '/analytics');
  },
),
IconButton(
  icon: Icon(Icons.account_balance, color: Colors.white),
  onPressed: () {
    Navigator.pushNamed(context, '/all_accounts');
  },
),
IconButton(
  icon: Icon(Icons.more_horiz, color: Colors.grey),
  onPressed: () {
    Navigator.pushNamed(context, '/more');
  },
),
        ],
      ),
    );
  }

  void _showAmountInputDialog(BuildContext context) {
    TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Amount'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(hintText: 'Amount'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle the entered amount here
                double amount = double.tryParse(amountController.text) ?? 0.0;
                print('Entered amount: $amount');
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
