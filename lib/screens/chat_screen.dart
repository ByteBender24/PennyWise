import 'package:flutter/material.dart';
import 'package:pennywise/services/chatbot_service.dart';


class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ChatbotService chatbotService = ChatbotService();
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  void sendMessage() async {
    String query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      messages.add({"user": query});
    });

    String response = await chatbotService.askChatbot(query);

    setState(() {
      messages.add({"bot": response});
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PennyWise Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                String sender = messages[index].keys.first;
                String text = messages[index][sender]!;
                bool isUser = sender == "user";

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(text, style: TextStyle(color: isUser ? Colors.white : Colors.black)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(controller: _controller, decoration: InputDecoration(hintText: "Ask something...")),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
