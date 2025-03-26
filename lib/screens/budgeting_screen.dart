import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../widgets/base_screen.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late Box<Budget> budgetBox;

  @override
  void initState() {
    super.initState();
    budgetBox = Hive.box<Budget>('budgets');
  }

  void _addBudgetDialog() {
    String? selectedCategory;
    double limit = 0.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Set Budget"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Category"),
              value: selectedCategory,
              items: Hive.box<Category>('categories')
                  .values
                  .map((category) => DropdownMenuItem(
                        value: category.name,
                        child: Text(category.name),
                      ))
                  .toList(),
              onChanged: (value) {
                selectedCategory = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Limit"),
              keyboardType: TextInputType.number,
              onChanged: (value) => limit = double.tryParse(value) ?? 0.0,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (selectedCategory != null && limit > 0) {
                saveBudget(selectedCategory!, limit);
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void saveBudget(String category, double limit) {
    final budget = Budget(category: category, limit: limit, spent: 0.0);
    budgetBox.put(category, budget);
    setState(() {}); // Refresh UI
  }

  void _deleteBudget(String category) {
    budgetBox.delete(category);
    setState(() {}); // Refresh UI
  }

  @override
  Widget build(BuildContext context) {
    List<Budget> budgets = budgetBox.values.toList();

    return BaseScreen(
      title: "Budgeting",
      currentIndex: 2,
      body: Column(
        children: [
          ElevatedButton(
              onPressed: _addBudgetDialog, child: Text("Add Budget")),
          Expanded(
            child: ListView.builder(
              itemCount: budgets.length,
              itemBuilder: (context, index) {
                Budget budget = budgets[index];
                double spent = budget.spent;
                double limit = budget.limit;
                double percentage = spent / limit;

                return ListTile(
                  title: Text("${budget.category} - ₹$spent / ₹$limit"),
                  subtitle: LinearProgressIndicator(
                    value: percentage.clamp(0.0, 1.0),
                    backgroundColor: Colors.grey[300],
                    color: percentage > 0.8 ? Colors.red : Colors.green,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteBudget(budget.category);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
