import 'package:isar/isar.dart';

part 'driver.g.dart';

@collection
class Driver {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String name;

  @Index(unique: true)
  late String phone;

  String? address;
  String? cnic;        // National ID
  String? licenseNumber;
  String? notes;

  // Timestamps (not indexed)
  DateTime? createdAt;
  DateTime? updatedAt;

  // Computed field example: not stored in DB, but used by Riverpod
  @ignore
  double get totalEarnings => 0; // Will be computed via trip queries
}