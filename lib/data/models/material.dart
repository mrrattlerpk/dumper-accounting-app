import 'package:isar/isar.dart';

part 'material.g.dart';

@collection
class Material {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String name;                // e.g., "Sand", "Gravel"

  String? unit;                    // e.g., "Ton", "Cubic Feet"
  double defaultRate = 0.0;       // Rate per unit in PKR
  String? description;

  DateTime? createdAt;
  DateTime? updatedAt;

  @ignore
  int get usageCount => 0;        // Computed via trip queries
}