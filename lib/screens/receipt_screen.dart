import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pennywise/services/receipt_service.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart'; 


class ApiService {
  // Function to load API key from APIs.json
  Future<String> loadApiKey() async {
    // Load the JSON file from assets
    final String response = await rootBundle.loadString('assets/APIs.json');
    
    // Decode JSON
    final data = jsonDecode(response);
    
    // Fetch the API key for gemini_other or another key you want
    return data['gemini_other']['apikey'];
  }
}

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final ReceiptService _receiptService = ReceiptService();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  Uint8List? _webImage;
  String extractedText = "";

  Future<void> _captureImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      String? imageName = await _getImageNameFromUser(); // Prompt user for name

      if (imageName == null || imageName.isEmpty) {
        print("⚠️ Image name is required!");
        return;
      }

      print("📷 Image Name: $imageName");

      if (kIsWeb) {
        Uint8List imageBytes =
            await image.readAsBytes(); // Convert to bytes for web
        setState(() {
          _webImage = imageBytes;
          _selectedImage = null;
        });
      } else {
        setState(() {
          _selectedImage = File(image.path);
          _webImage = null;
        });
      }

      await _extractText(imageName); // Pass imageName
    }
  }

  Future<String?> _getImageNameFromUser() async {
    TextEditingController _controller = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Enter Image Name"),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: "Image name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null), // Cancel
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, _controller.text.trim()), // Confirm
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _extractText(String imageName) async {
    if (_selectedImage == null && _webImage == null) return;

    final inputImage = _selectedImage != null
        ? InputImage.fromFile(_selectedImage!)
        : InputImage.fromBytes(
            bytes: _webImage!,
            metadata: InputImageMetadata(
              size: Size(300, 300),
              rotation: InputImageRotation.rotation0deg,
              format: InputImageFormat.nv21,
              bytesPerRow: 300,
            ),
          );

    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    String extractedText = recognizedText.text;

    print("Extracted Text: $extractedText");

    await sendToGemini(extractedText, imageName); // Pass imageName
  }

  Future<void> sendToGemini(String extractedText, String imageName) async {
    ApiService apiService = ApiService();
    final String apiKey = await apiService.loadApiKey();
  
    final String apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey";  // Use dynamic API key

    String prompt = """
Based on the following receipt data, categorize the items and calculate the total amount for each category. The items are listed first and prices of corresponding items are listed below that. Return the data in a JSON format.

Receipt Data:
$extractedText

Expected JSON format:
{
  "title": "$imageName",
  "categories": [
    {
      "category": "Dairy",
      "items": ["Milk", "Cottage Cheese", "Natural Yogurt"],
      "total": 2.44
    },
    {
      "category": "Vegetables & Fruits",
      "items": ["Cherry Tomatoes 1lb", "Bananas 1lb", "Aubergine"],
      "total": 3.59
    },
    {
      "category": "Snacks",
      "items": ["Cheese Crackers", "Chocolate Cookies"],
      "total": 8.41
    },
    {
      "category": "Meat",
      "items": ["Chicken Breast"],
      "total": 4.98
    },
    {
      "category": "Household",
      "items": ["Toilet Paper", "Baby Wipes"],
      "total": 1.59
    }
  ],
  "totalAmount": 25.97
}

For the title, dont extract from the image instead use $imageName
""";

    final Map<String, dynamic> requestPayload = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestPayload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Extract the text content
        String jsonResponse =
            data["candidates"][0]["content"]["parts"][0]["text"];

        // Trim whitespace and remove unwanted Markdown-style JSON formatting
        jsonResponse = jsonResponse.trim();

        if (jsonResponse.startsWith("```json")) {
          jsonResponse = jsonResponse
              .replaceAll("```json", "")
              .replaceAll("```", "")
              .trim();
        }

        // Ensure the final response is valid JSON
        Map<String, dynamic> parsedJson = jsonDecode(jsonResponse);

        // Save to Firestore
        await _receiptService.saveBillToFirestore(extractedText, jsonEncode(parsedJson));
      } else {
        print("Gemini API Error: ${response.body}");
      }
    } catch (e) {
      print("Error calling Gemini API: $e");
    }
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt, color: Colors.orange),
            title: Text("Upload Bill Image"),
            onTap: () {
              Navigator.pop(context);
              _captureImage();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Good Afternoon", style: TextStyle(fontSize: 16)),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("Balance: \$8,979", style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 20),
            const Text("Recent transactions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: Column(
                children: [],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showUploadOptions,
        tooltip: "Upload Bill or Add Transaction",
        child: Icon(Icons.upload_file),
      ),
    );
  }

  Widget _infoCard(String title, String amount, Color color, IconData icon) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          SizedBox(height: 5),
          Text(title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(amount,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _transactionCard(String amount, String category, String date,
      String details, String paymentMode, String transactionType) {
    return ListTile(
      title: Text(details, style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$transactionType - $category",
              style:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          Text(category, style: TextStyle(color: Colors.grey)),
          Text(date, style: TextStyle(color: Colors.grey)),
          Text("Payment Mode: $paymentMode",
              style: TextStyle(color: Colors.blueGrey)),
        ],
      ),
      trailing: Text("\$$amount",
          style: TextStyle(color: Colors.green, fontSize: 16)),
    );
  }
}
