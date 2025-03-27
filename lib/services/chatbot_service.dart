import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import 'package:pennywise/services/auth_service.dart';

class ChatbotService {
  String apiKey = "NULL"; // Store securely (e.g., Firebase Remote Config)
  final AuthService _authService = AuthService();


  Future<String> getExpenseSummary() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = _authService.getCurrentUser(); // Use AuthService to get user
    var userId = user!.uid;
    
    // Reference the correct subcollection inside a user document
    QuerySnapshot snapshot = await firestore
        .collection('users')
        .doc(userId) // Use the specific user's document ID
        .collection('expenses')
        .get();

    print("🔥 Documents Count: ${snapshot.docs.length}");

    double totalSpent = 0;
    Map<String, double> categoryWise = {};

    for (var doc in snapshot.docs) {
      print("📝 Document Data: ${doc.data()}");

      double amount = double.tryParse(doc['amount'].toString()) ?? 0.0;
      String category = doc['category'] ?? "Miscellaneous";

      totalSpent += amount;
      categoryWise[category] = (categoryWise[category] ?? 0) + amount;
    }

    if (totalSpent == 0) return "No expenses recorded.";

    String summary =
        "You spent a total of \$${totalSpent.toStringAsFixed(2)}. ";
    categoryWise.forEach((cat, amt) {
      summary += "On $cat: \$${amt.toStringAsFixed(2)}. ";
    });

    return summary;
  }

  Future<String> askChatbot(String userQuery) async {
    String jsonString =
        await rootBundle.rootBundle.loadString('assets/APIs.json');
    Map<String, dynamic> data = json.decode(jsonString);
    String apiKey = data['gemini']['apikey'];

    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    String expenseSummary = await getExpenseSummary();
    String prompt =
        "User's expense details: $expenseSummary. User query: $userQuery";

    final response = await model.generateContent([Content.text(prompt)]);

    print("🖐🖐🖐🖐");
    print("EXPENSE SUMMARY\n\n\n");
    print(expenseSummary);

    return response.text ?? "I couldn't process that. Try again!";
  }
}
