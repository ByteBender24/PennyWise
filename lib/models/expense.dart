import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String category;

  @HiveField(4)
  DateTime date;

  Expense({
    required this.id,
    this.title = "Unknown Expense",
    this.amount = 0.0,
    required this.category,
    required this.date,
  });
}

