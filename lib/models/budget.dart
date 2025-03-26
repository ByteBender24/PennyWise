import 'package:hive/hive.dart';

part 'budget.g.dart';

@HiveType(typeId: 2) // Ensure a unique typeId
class Budget extends HiveObject {
  @HiveField(0)
  final String category;

  @HiveField(1)
  final double limit;

  @HiveField(2)
  double spent; // Track spent amount

  Budget({required this.category, required this.limit, this.spent = 0.0});

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'limit': limit,
      'spent' : spent
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
