import 'package:isar/isar.dart';

part 'trip.g.dart';

@collection
class Trip {
  Id id = Isar.autoIncrement;

  // Foreign keys (no DB-level enforcement; integrity maintained in app)
  @Index()
  late int driverId;

  @Index()
  late int dumperId;

  @Index()
  late int customerId;

  @Index()
  late int materialId;

  // Trip details
  double quantity = 0.0;       // e.g., 10 tons
  double rate = 0.0;           // PKR per unit
  double totalAmount = 0.0;    // quantity * rate
  double paidAmount = 0.0;     // Amount paid immediately
  double remaining = 0.0;      // totalAmount - paidAmount (auto-calc)

  DateTime tripDate = DateTime.now();
  String? notes;

  // Payment status (derived but stored for query efficiency)
  bool isFullyPaid = false;

  // Timestamps
  DateTime createdAt = DateTime.now();
  DateTime? updatedAt;
}