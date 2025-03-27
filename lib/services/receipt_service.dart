import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'package:pennywise/services/auth_service.dart';

class ReceiptService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Add a new transaction to Firestore
  // Future<void> addTransaction(String amount, String transactionType,
  //     String category, String paymentMode, String details) async {
  //   await _firestore.collection('transactions').add({
  //     'amount': amount,
  //     'transactionType': transactionType, // New field for transaction type
  //     'category': category,
  //     'paymentMode': paymentMode,
  //     'details': details,
  //     'date': DateTime.now().toIso8601String(),
  //   });
  // }

  // /// 🔹 Fetch all transactions, ordered by date
  // Future<List<Map<String, dynamic>>> getTransactions() async {
  //   QuerySnapshot querySnapshot = await _firestore
  //       .collection('transactions')
  //       .orderBy('date', descending: true)
  //       .get();

  //   return querySnapshot.docs.map((doc) {
  //     return {
  //       'amount': doc['amount']?.toString(),
  //       'transactionType': doc['transactionType'],
  //       'category': doc['category'],
  //       'date': doc['date'],
  //       'details': doc['details'],
  //       'paymentMode': doc['paymentMode']
  //     };
  //   }).toList();
  // }

  /// 🔥 Save a bill extracted from Gemini API into Firestore
  Future<void> saveBillToFirestore(
      String extractedText, String jsonResponse) async {
    try {
      // Ensure the JSON string is properly formatted
      jsonResponse = jsonResponse.trim();

      // Remove Markdown-style code block if present
      if (jsonResponse.startsWith("json")) {
        jsonResponse = jsonResponse.replaceAll("json", "").replaceAll("", "");
      }

      // Convert JSON string to a map
      Map<String, dynamic> billData = jsonDecode(jsonResponse);

      // Fetch current user
      final AuthService _authService = AuthService();
      User? user = _authService.getCurrentUser();
      print(user);

      // ❗ Handle the case when the user is not logged in
      if (user == null) {
        print("❌ Error: No user is logged in!");
        return; // Exit function early
      }

      var userId = user.uid; // Safe to access now
      print(userId);

      // Save to Firestore
      await _firestore.collection('users').doc(userId).collection('bills').add({
        "timestamp": FieldValue.serverTimestamp(),
        "title": billData["title"],
        "categories": billData["categories"],
        "totalAmount": billData["totalAmount"],
      });

      print("✅ Bill successfully saved in Firestore!");
    } catch (e) {
      print("❌ Error saving bill to Firestore: $e");
    }
  }

  /// 🔹 Fetch all bills, ordered by date
  Future<List<Map<String, dynamic>>> getBills() async {
    try {
      final AuthService _authService = AuthService();
      User? user = _authService.getCurrentUser();

      if (user == null) {
        print("❌ Error: No user is logged in!");
        return [];
      }

      String userId = user.uid;
      print("Fetching bills for user: $userId");

      QuerySnapshot querySnapshot = await _firestore
          .collection("users")
          .doc(userId)
          .collection("bills")
          .orderBy("timestamp", descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        // 🔴 Debugging: Print the raw document before processing
        print("🔥 Raw Firestore Data: $data");

        return {
          "billId": doc.id,
          "timestamp": data["timestamp"],
          "extractedText": data["extractedText"],
          "categories": data["categories"],
          "totalAmount":
              data["totalAmount"], // Ensures type safety
        };
      }).toList();
    } catch (e, stacktrace) {
      print("❌ Error fetching bills: $e");
      print("⚠️ Stacktrace: $stacktrace"); // ✅ Full error details
      return [];
    }
  }
}
