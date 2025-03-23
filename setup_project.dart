import 'dart:io';

void main() {
  createProjectStructure();
}

void createProjectStructure() {
  try {
    // Create lib directory
    Directory('lib').createSync(recursive: true);

    // Create screens directory
    Directory('lib/screens').createSync(recursive: true);

    // Create models directory
    Directory('lib/models').createSync(recursive: true);

    // Create services directory
    Directory('lib/services').createSync(recursive: true);

    // Create widgets directory
    Directory('lib/widgets').createSync(recursive: true);

    // Create utils directory
    Directory('lib/utils').createSync(recursive: true);

    // Create files
    File('lib/main.dart').createSync();
    File('lib/screens/home_screen.dart').createSync();
    File('lib/screens/add_expense_screen.dart').createSync();
    File('lib/screens/categories_screen.dart').createSync();
    File('lib/models/expense.dart').createSync();
    File('lib/services/expense_service.dart').createSync();
    File('lib/widgets/expense_tile.dart').createSync();
    File('lib/utils/constants.dart').createSync();
    File('lib/utils/theme.dart').createSync();

    print("Project structure created successfully.");
  } catch (e) {
    print("Error creating project structure: $e");
  }
}