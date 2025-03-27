import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../models/category.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _selectedCategory = "Others";
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.fromDateTime(DateTime.now());
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
  if (!Hive.isBoxOpen('categories')) {
    await Hive.openBox<Category>('categories'); // Open if not already open
  }

  var box = Hive.box<Category>('categories');

  setState(() {
    _categories = box.values.map((category) => category.name).toList();
    
    // If no categories exist, add default ones
    if (_categories.isEmpty) {
      _initializeDefaultCategories(box);
    }
  });
}

// Function to initialize default categories if the box is empty
void _initializeDefaultCategories(Box<Category> box) {
  List<Category> defaultCategories = [
    Category(id: const Uuid().v4(), name: "Others", iconCode: Icons.more_horiz.codePoint, colorValue: 0xFF03A9F4),
    Category(id: const Uuid().v4(), name: "Food", iconCode: Icons.restaurant.codePoint, colorValue: 0xFF4CAF50),
    Category(id: const Uuid().v4(), name: "Shopping", iconCode: Icons.shopping_cart.codePoint, colorValue: 0xFF2196F3),
    Category(id: const Uuid().v4(), name: "Transport", iconCode: Icons.directions_car.codePoint, colorValue: 0xFF47361C),
  ];

  for (var category in defaultCategories) {
    box.add(category);
  }

  setState(() {
    _categories = defaultCategories.map((c) => c.name).toList();
  });
}

  void _showCategorySelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          height: 250,
          child: ListView.builder(
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_categories[index], style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))),
                onTap: () {
                  setState(() {
                    _selectedCategory = _categories[index];
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCategorySelection() {
    return GestureDetector (
      onTap: _showCategorySelection,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Category", style: TextStyle(color: Colors.white)),
            Row(
              children: [
                Text(_selectedCategory ?? "Select", style: TextStyle(color: Colors.white)),
                Icon(Icons.arrow_drop_down, size: 20, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: TextFormField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Amount",
          labelStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
          prefixText: "₹ ",
          prefixStyle: TextStyle(color: Colors.white),
        ),
        style: TextStyle(color: Colors.white, fontSize: 24), // Larger font for amount
      ),
    );
  }

  Widget _buildNoteInput() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: TextFormField(
        controller: _noteController,
        decoration: InputDecoration(
          labelText: "Write a note",
          labelStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
        ),
        maxLines: 2, // Allow multiple lines for notes
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildDateTimePickers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector (
          onTap: _selectDate,
          child: Text(
            DateFormat('d MMM yyyy').format(_selectedDate), // Include year
            style: TextStyle(color: Colors.white),
          ),
        ),
        GestureDetector (
          onTap: _selectTime,
          child: Text(
            _selectedTime.format(context),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(data: ThemeData.dark(), child: child!);
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(data: ThemeData.dark(), child: child!);
      },
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _saveExpense() async {
  String amount = _amountController.text.trim();
  String note = _noteController.text.trim();

  if (_selectedCategory == null || amount.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter all details")),
    );
    return;
  }

  if (!Hive.isBoxOpen('expenses')) {
    await Hive.openBox<Expense>('expenses'); // Open if not already open
  }
  
  var box = Hive.box<Expense>('expenses'); // Access the opened box
  
   // ✅ Ensure category is not null by providing a default value
  String category = _selectedCategory ?? "Uncategorized";

  // ✅ Generate a unique ID (You can use UUID package for better uniqueness)
  String expenseId = DateTime.now().millisecondsSinceEpoch.toString();

  // ✅ Create an Expense object with all required fields
  Expense newExpense = Expense(
    id: expenseId, // Provide required ID
    title: _noteController.text.isNotEmpty ? _noteController.text : "Unknown Expense",
    category: category,   // Ensure this is a non-null String
    amount: double.tryParse(_amountController.text) ?? 0.0, // Ensure it's a valid double
    date: _selectedDate, // Provide a default date
  );

  await box.add(newExpense); // ✅ Save as Expense object

  // Refresh expenses list
  Navigator.pop(context, true); // Pass true to indicate success
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Add transaction", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateTimePickers(),
            const Divider(color: Colors.grey),
            _buildAmountInput(),
            _buildCategorySelection(),
            _buildNoteInput(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,),
                child: const Icon(Icons.save), // Match the image's button text
              ),
            ),
          ],
        ),
      ),
    );
  }
}