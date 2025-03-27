import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../models/budget.dart';

class BackupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> backupToFirebase() async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      
      print("No user signed in. Backup failed.");
      throw Exception("No user signed in.");
    }

    try {
      var expenseBox = Hive.box<Expense>('expenses');
      var categoryBox = Hive.box<Category>('categories');
      var budgetBox = Hive.box<Budget>('budgets');

      WriteBatch batch = _firestore.batch();

      for (var expense in expenseBox.values) {
        DocumentReference ref = _firestore
            .collection('users')
            .doc(userId)
            .collection('expenses')
            .doc(expense.id);
        batch.set(ref, expense.toMap());
      }

      await batch.commit();
      batch = _firestore.batch();
      for (var category in categoryBox.values) {
        print("Category ID: ${category.id}, Data: ${category.toMap()}");
        DocumentReference ref = _firestore
            .collection('users')
            .doc(userId)
            .collection('categories')
            .doc(category.id);
        batch.set(ref, category.toMap());
      }
      await batch.commit();
      batch = _firestore.batch();

      for (var budget in budgetBox.values) {
        print("Budget ID: ${budget.id}, Data: ${budget.toMap()}");
        DocumentReference ref = _firestore
            .collection('users')
            .doc(userId)
            .collection('budgets')
            .doc(budget.id);
        batch.set(ref, budget.toMap());
      }
      await batch.commit();
      
      
      
      print("Backup completed successfully!");
    } catch (e) {
      print("Error during backup: $e");
    }
  }
}
