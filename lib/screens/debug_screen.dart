import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pennywise/models/budget.dart';
import 'package:pennywise/models/category.dart';
import 'package:flutter/services.dart';
import '../models/expense.dart';

class DebugScreen extends StatefulWidget {
  @override
  _DebugScreenState createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  List<String> debugData = [];

  void copyToClipboard(BuildContext context) {
    final text = debugData.join("\n"); // Join all entries into a single string
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      // Show a SnackBar to inform the user the data was copied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debug data copied to clipboard')),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    fetchHiveData();
  }

  Future<void> fetchHiveData() async {
  // Initialize an empty list to hold all the fetched data
  List<String> allFetchedData = [];

  // Fetch data from 'expenses' box
  if (!Hive.isBoxOpen('expenses')) {
    await Hive.openBox<Expense>('expenses');
  }
  var expensesBox = Hive.box<Expense>('expenses');
  print('Expenses Box contains ${expensesBox.length} entries');
  List<String> fetchedExpenses = expensesBox.values.map((expense) => expense.toString()).toList();
  allFetchedData.addAll(fetchedExpenses);

  // Fetch data from 'categories' box
  if (!Hive.isBoxOpen('categories')) {
    await Hive.openBox<Category>('categories');
  }
  var categoriesBox = Hive.box<Category>('categories');
  print('Categories Box contains ${categoriesBox.length} entries');
  List<String> fetchedCategories = categoriesBox.values.map((category) => category.toString()).toList();
  allFetchedData.addAll(fetchedCategories);

  // Fetch data from 'budgets' box (if necessary)
  if (!Hive.isBoxOpen('budgets')) {
    await Hive.openBox<Budget>('budgets');
  }
  var budgetsBox = Hive.box<Budget>('budgets');
  print('Budgets Box contains ${budgetsBox.length} entries');
  List<String> fetchedBudgets = budgetsBox.values.map((budget) => budget.toString()).toList();
  allFetchedData.addAll(fetchedBudgets);

  // If no data is found, add a default message
  if (allFetchedData.isEmpty) {
    allFetchedData = ["No data found"];
  }

  // Update the debugData state
  setState(() {
    debugData = allFetchedData;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hive Debug Screen"), leading: IconButton(
              onPressed: () => copyToClipboard(context),
              icon: Icon(Icons.copy),
            ),),
      
      body: debugData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: debugData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(debugData[index],
                      style: TextStyle(fontSize: 16, fontFamily: "monospace")),
                );
              },
            ),
    );
  }
}
