# Pennywise - Expense Tracker

## Project Overview
**Pennywise** is a **Flutter-based expense tracker** integrated with **Firebase** for real-time expense management. The application enables users to **log daily expenses**, **categorize spending**, and **gain insights** through data visualization and AI-powered analytics.

## Key Features
- **Expense Logging:** Users can add expenses with category, amount, and timestamp.
- **Category-wise Breakdown:** Expenses are grouped into predefined categories.
- **Firebase Integration:** Expenses are stored and fetched from Firestore.
- **Analytics & Insights:** AI-powered chatbot provides spending analysis.
- **Receipt Scanning & OCR:** Extract expense details from scanned receipts.
- **Offline-First Approach:** Local database support for quick access.
- **User Authentication:** Sync and backup data across devices.

---

## Tech Stack
- **Frontend:** Flutter, Dart
- **Backend:** Firebase Firestore, Firebase Authentication
- **AI Integration:** Google Gemini API for chatbot-based analytics
- **OCR:** Google ML Kit for text extraction from receipts

---

## 📂 Project Structure

```
Pennywise/
│── lib/
│   ├── main.dart                   # Entry point of the app
│   ├── services/                    # Service layer for API & database interactions
│   │   ├── firebase_service.dart    # Firestore interactions
│   │   ├── chatbot_service.dart     # Google Gemini API integration
│   │   ├── ocr_service.dart         # Receipt scanning & OCR processing
│   ├── screens/                     # UI screens for different features
│   │   ├── home_screen.dart         # Dashboard & expense list
│   │   ├── chatbot_screen.dart      # Chatbot UI
│   │   ├── add_expense_screen.dart  # Expense entry form
│   ├── models/                      # Data models used in the app
│   │   ├── expense_model.dart       # Expense data model
│   ├── utils/                       # Utility functions
│   │   ├── formatters.dart          # Helper functions for formatting
│── pubspec.yaml                      # Dependencies & package management
│── android/ & ios/                   # Platform-specific configurations

```

---

## Setup & Installation
1. **Clone the repository:**
   ```sh
   git clone https://github.com/your-repo/Pennywise.git
   cd Pennywise	
   ```


2.  **Install dependencies:**
    
    ```sh
    flutter pub get
    
    ```
    
3.  **Set up Firebase:**
    
    -   Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
        
    -   Add Firebase config files (`google-services.json` & `GoogleService-Info.plist`)
        
    -   Enable Firestore & Authentication (Google Sign-In)
        
4.  **Run the app:**
    
    ```sh
    flutter run
    
    ```
    

----------

##  Features in Detail

### 📊 Expense Management

-   Users can **add, edit, and delete** expenses.
    
-   Expense **breakdowns by category** with total spending.
    
-   **Offline mode:** Expenses are cached and synced later.
    

### 🤖 AI-Powered Chatbot (Google Gemini API)

-   Users can ask:
    
    -   _"How much did I spend on food this month?"_
        
    -   _"What is my highest spending category?"_
        
-   Chatbot analyzes expenses and provides **intelligent insights**.
    

### 🧾 Receipt Scanning & OCR

-   Users can scan receipts using the **camera**.
    
-   **OCR extracts text**, identifies **categories**, and logs expenses.
    
-   Expenses are auto-categorized and stored in Firestore.
    

### 📡 Firebase Firestore Integration

-   Real-time updates for **expense tracking**.
    
-   Secure **authentication** via Google Sign-In.
    
-   **Cloud backup** and **syncing** across devices.
    

----------

## Example Firestore Expense Entry

```json
{
  "id": "3a0e1898-0f1c-49ca-93aa-8f940def5d4b",
  "title": "Groceries",
  "amount": 1200.0,
  "category": "Food",
  "date": "2025-03-26T20:05:06.717"
}

```

## Example Firestore Bill Entry (OCR)

```json
{
  "billId": "wfyeVjdL1ND3Pr0wFhfp",
  "totalAmount": 27.27,
  "categories": [
    {
      "category": "Household",
      "total": 4.21,
      "items": ["HAND TOWEL", "PUSH PINS"]
    },
    {
      "category": "Beverages",
      "total": 2.9,
      "items": ["GATORADE"]
    }
  ],
  "timestamp": "2025-03-26T20:05:06.717"
}

```

----------

##  Future Enhancements

    
-   **Subscription Management:** Track and analyze recurring payments.
    
-   **Expense Prediction:** AI-based spending forecast.
-  **Split Expenses:** Split function like "Splitwise".
    
-   **Multi-currency Support:** Track expenses in different currencies.
    
----------

## License

This project is licensed under the **MIT License**.

