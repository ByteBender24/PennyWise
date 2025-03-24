//all_expenses_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pennywise/widgets/base_screen.dart';


class AllExpensesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> expenses;

  const AllExpensesScreen({Key? key, required this.expenses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "All Expenses",
      body: ListView.builder(
        itemCount: expenses.length,
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
    );
  }
}
