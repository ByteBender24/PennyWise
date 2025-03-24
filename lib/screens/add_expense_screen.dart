import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

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
    var box = await Hive.openBox('expenseCategories');
    setState(() {
      _categories = box.values.cast<String>().toList();
      if (_categories.isEmpty) {
        _categories = ["Others", "Food", "Transport", "Shopping"];
      }
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
    return InkWell(
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
        InkWell(
          onTap: _selectDate,
          child: Text(
            DateFormat('d MMM yyyy').format(_selectedDate), // Include year
            style: TextStyle(color: Colors.white),
          ),
        ),
        InkWell(
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

    var box = await Hive.openBox('expenses');
    await box.add({
      "category": _selectedCategory,
      "amount": amount,
      "note": note,
      "date": _selectedDate.toIso8601String(),
      "time": _selectedTime.format(context),
    });

    print("Expense Saved:");
    print("Category: $_selectedCategory");
    print("Amount: $amount");
    print("Note: $note");
    print("Date: $_selectedDate");
    print("Time: $_selectedTime");

    _amountController.clear();
    _noteController.clear();
    setState(() {
      _selectedCategory = "Others";
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.fromDateTime(DateTime.now());
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Expense Saved Successfully!")),
    );
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