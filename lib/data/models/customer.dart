import 'package:isar/isar.dart';

part 'customer.g.dart';

@collection
class Customer {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String name;

  String? company;
  String? phone;
  String? address;
  String? notes;

  // Financial tracking (computed/aggregated later)
  double openingBalance = 0.0; // Starting due amount

  DateTime? createdAt;
  DateTime? updatedAt;

  @ignore
  double get currentDue => 0.0; // Computed via trip queries
}