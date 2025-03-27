import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatbotService {
  String apiKey = dotenv.env['API_KEY'] ?? 'No API Key'; // Store securely (e.g., Firebase Remote Config)

  Future<String> getExpenseSummary() async {
    

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('expenses').get();

    double totalSpent = 0;
    Map<String, double> categoryWise = {};

    for (var doc in snapshot.docs) {
      double amount = doc['amount'];
      String category = doc['category'];

      totalSpent += amount;
      categoryWise[category] = (categoryWise[category] ?? 0) + amount;
    }

    String summary =
        "You spent a total of \$${totalSpent.toStringAsFixed(2)}. ";
    categoryWise.forEach((cat, amt) {
      summary += "On $cat: \$${amt.toStringAsFixed(2)}. ";
    });

    return summary;
  }

  Future<String> askChatbot(String userQuery) async {

    print("API Key: $apiKey");

    if (apiKey == 'No API Key') {
      print("API key not found. Please check the .env file.");
      dotenv.load();
      apiKey = dotenv.env['API_KEY'] ?? 'No API Key';
      print("API Key: $apiKey");
    }

    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    String expenseSummary = await getExpenseSummary();
    String prompt =
        "User's expense details: $expenseSummary. User query: $userQuery";

    final response = await model.generateContent([Content.text(prompt)]);

    return response.text ?? "I couldn't process that. Try again!";
  }
}
