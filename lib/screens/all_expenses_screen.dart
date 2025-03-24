import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pennywise/models/expense.dart';

class AllExpensesScreen extends StatefulWidget {
  const AllExpensesScreen({Key? key}) : super(key: key);

  @override
  _AllExpensesScreenState createState() => _AllExpensesScreenState();
}

class _AllExpensesScreenState extends State<AllExpensesScreen> {
  late Box<Expense> expenseBox;

  @override
  void initState() {
    super.initState();
    expenseBox = Hive.box<Expense>('expenses'); // ✅ Load from Hive
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Expenses')),
      body: ValueListenableBuilder(
        valueListenable: expenseBox.listenable(),
        builder: (context, Box<Expense> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No expenses added yet."));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final expense = box.getAt(index);
              return ListTile(
                title: Text(expense!.title),
                subtitle: Text(
    DateFormat('d MMM yyyy').format(expense.date), // ✅ Use directly
  ),
                trailing: Text(expense.date.toString()), // ✅ Fix Date Format Later
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addExpense');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}