import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pennywise/screens/add_expense_screen.dart';
import 'package:pennywise/screens/more_screen.dart';
import 'models/expense.dart';
import 'models/category.dart';
import 'screens/add_categories_screen.dart';
import 'screens/all_expenses_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/budgeting_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Hive.deleteFromDisk(); // Temporary fix (for debugging)
  await Hive.initFlutter();

  var dir = await getApplicationDocumentsDirectory();
  print("Hive DB location: ${dir.path}");
  
   // ✅ Open boxes before modifying them
  Hive.registerAdapter(ExpenseAdapter());
  await Hive.openBox<Expense>('expenses');
  Hive.registerAdapter(CategoryAdapter());
  await Hive.openBox<Category>('categories');
 
  
  

  // ❌ REMOVE deleteFromDisk() or move it correctly
  // ❌ REMOVE clear() if you don't want to reset data every time
  // Optional: If you really need to clear for debugging, do it safely:
  var expenseBox = Hive.box<Expense>('expenses');
  var categoryBox = Hive.box<Category>('categories');

  expenseBox.clear(); // Debugging only
  categoryBox.clear(); // Debugging only

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pennywise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      ),
      routes: {
        '/addExpense': (context) => AddExpenseScreen(), 
        '/analytics': (context) => AnalyticsScreen(),
        '/budgeting': (context) => BudgetingScreen(),
        '/more': (context) => SettingsScreen(),
        '/all_categories': (context) => const CategoriesScreen(),
        '/all_expenses' : (context) => const AllExpensesScreen(),
        '/category_add' : (context) => AddCategoryScreen(),

      },
      home: const HomeScreen(),
    );
  }
}
