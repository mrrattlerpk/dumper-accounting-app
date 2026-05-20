import 'package:isar/isar.dart';

part 'dumper.g.dart';

@collection
class Dumper {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String registrationNumber;  // e.g., "ABC-1234"

  @Index(type: IndexType.value)
  late String model;               // e.g., "Hino 500"

  String? ownerName;              // Can be separate from driver
  String? chassisNumber;
  String? engineNumber;
  String? color;
  double? capacityTons;           // Tonnage capacity
  String? notes;

  bool isActive = true;           // Whether currently in service

  DateTime? createdAt;
  DateTime? updatedAt;

  @ignore
  int get totalTrips => 0;        // Computed via trip queries
}