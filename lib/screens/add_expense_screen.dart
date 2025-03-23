import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedCategory = "Food";
  String _selectedPaymentMode = "Cash";
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _currentIndex = 0;

  void _saveExpense() {
    if (_amountController.text.isEmpty) return;

    final expense = Expense(
      id: const Uuid().v4(),
      title: _noteController.text.isEmpty ? 'No Note' : _noteController.text,
      amount: double.tryParse(_amountController.text) ?? 0,
      category: _selectedCategory,
      date: _selectedDate,
    );

    ExpenseService.addExpense(expense);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Add Expense'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTransactionTabs(),
              SizedBox(height: 20),
              _buildDateTimeRow(),
              SizedBox(height: 20),
              _buildAmountInput(),
              SizedBox(height: 20),
              _buildCategorySelection(),
              SizedBox(height: 20),
              _buildPaymentModeSelection(),
              SizedBox(height: 20),
              _buildNoteInput(),
              SizedBox(height: 20),
              _buildAttachmentSection(),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveExpense,
                child: Text("Save Expense"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildTransactionTabs() {
    return Row(
      children: [
        _buildTab('Expense', true),
        _buildTab('Income', false),
        _buildTab('Transfer', false),
      ],
    );
  }

  Widget _buildTab(String title, bool isActive) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.grey[800] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: isActive ? Colors.white : Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeRow() {
    return Row(
      children: [
        Icon(Icons.calendar_today, color: Colors.white),
        SizedBox(width: 10),
        Text('${_selectedDate.day} ${_getMonth(_selectedDate.month)} ${_selectedDate.year}', style: TextStyle(color: Colors.white)),
        Spacer(),
        Icon(Icons.access_time, color: Colors.white),
        SizedBox(width: 10),
        Text('${_selectedTime.format(context)}', style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildAmountInput() {
    return Row(
      children: [
        Text('₹', style: TextStyle(color: Colors.white, fontSize: 20)),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Amount',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelection() {
    return _buildSelectionTile('Category', _selectedCategory, Icons.category);
  }

  Widget _buildPaymentModeSelection() {
    return _buildSelectionTile('Payment Mode', _selectedPaymentMode, Icons.credit_card);
  }

  Widget _buildSelectionTile(String title, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.white)),
        SizedBox(height: 10),
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(width: 10),
              Text(value, style: TextStyle(color: Colors.white)),
              Spacer(),
              Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoteInput() {
    return _buildTextField('Note', 'Write a note', Icons.notes);
  }

  Widget _buildTextField(String title, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.white)),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttachmentSection() {
    return _buildSelectionTile('Attachment', 'Add file', Icons.attach_file);
  }

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      color: Colors.black,
      child: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 20), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart, size: 20), label: "Analysis"),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart, size: 20), label: "Budgeting"),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart, size: 20), label: "More"),
        ],
      ),
    );
  }

  String _getMonth(int month) {
    return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][month - 1];
  }
}
