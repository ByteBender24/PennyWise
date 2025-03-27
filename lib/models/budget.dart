import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'budget.g.dart';

@HiveType(typeId: 2) // Ensure a unique typeId
class Budget extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final double limit;

  @HiveField(3)
  double spent; // Track spent amount

  Budget({
    required this.category,
    required this.limit,
    required this.spent,
    String? id, // Allow auto-generation of ID if not provided
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'limit': limit,
      'spent' : spent
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      category: map['category'],
      limit: map['limit'],
      spent: map['spent'],
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
