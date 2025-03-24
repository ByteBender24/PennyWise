import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';
import '../widgets/base_screen.dart';

class AnalysisScreen extends StatefulWidget {
  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  String selectedFilter = 'Weekly'; // Default filter
  DateTime startDate = DateTime.now().subtract(Duration(days: 6));
  DateTime endDate = DateTime.now();
  Map<String, double> categoryData = {};
  int totalTransactions = 0;
  double totalSpent = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  /// Fetch expenses from Hive and filter by selected date range
  void _fetchExpenses() async {
    final box = Hive.box<Expense>('expenses');
    List<Expense> expenses = box.values.toList();

    print("Fetched expenses: $expenses"); // Debugging line

    Map<String, double> categoryMap = {};
    double spent = 0.0;
    int count = 0;

    for (var expense in expenses) {
      DateTime expenseDate = expense.date;

      if (expenseDate.isAfter(startDate) && expenseDate.isBefore(endDate)) {
        count++;
        spent += expense.amount;
        categoryMap[expense.category] =
            (categoryMap[expense.category] ?? 0) + expense.amount;
      }
    }

    setState(() {
      totalTransactions = count;
      totalSpent = spent;
      categoryData = categoryMap;
    });

    print("Total Transactions: $totalTransactions, Total Spent: ₹$totalSpent, Data: $categoryData"); // Debugging line
  }

  /// Update the filter (Daily, Weekly, Monthly) and fetch data accordingly
  void _updateFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == 'Daily') {
        startDate = DateTime.now();
        endDate = DateTime.now();
      } else if (filter == 'Weekly') {
        startDate = DateTime.now().subtract(Duration(days: 6));
        endDate = DateTime.now();
      } else if (filter == 'Monthly') {
        startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
        endDate = DateTime.now();
      }
      _fetchExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Expense Analysis",
      currentIndex: 1, // Active tab index for bottom navigation
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(child: _buildPieChart()),
          _buildStats(),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _filterButton('Daily'),
        _filterButton('Weekly'),
        _filterButton('Monthly'),
      ],
    );
  }

  Widget _filterButton(String label) {
    return TextButton(
      onPressed: () => _updateFilter(label),
      child: Text(label, style: TextStyle(color: selectedFilter == label ? Colors.blue : Colors.white)),
    );
  }

  Widget _buildPieChart() {
    return categoryData.isEmpty
        ? Center(child: Text("No data available"))
        : PieChart(
            dataMap: categoryData,
            chartType: ChartType.ring,
            chartValuesOptions: ChartValuesOptions(showChartValuesInPercentage: true),
          );
  }

  Widget _buildStats() {
    return Column(
      children: [
        Text("Total Transactions: $totalTransactions"),
        Text("Total Spent: ₹$totalSpent"),
      ],
    );
  }
}
