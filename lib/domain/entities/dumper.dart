/// Plain entity representing a Dumper / Truck.
class Dumper {
  final int? id;
  final String registrationNumber;
  final String model;
  final String? ownerName;
  final String? chassisNumber;
  final String? engineNumber;
  final String? color;
  final double? capacityTons;
  final String? notes;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Dumper({
    this.id,
    required this.registrationNumber,
    required this.model,
    this.ownerName,
    this.chassisNumber,
    this.engineNumber,
    this.color,
    this.capacityTons,
    this.notes,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  Dumper copyWith({
    int? id,
    String? registrationNumber,
    String? model,
    String? ownerName,
    String? chassisNumber,
    String? engineNumber,
    String? color,
    double? capacityTons,
    String? notes,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Dumper(
      id: id ?? this.id,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      model: model ?? this.model,
      ownerName: ownerName ?? this.ownerName,
      chassisNumber: chassisNumber ?? this.chassisNumber,
      engineNumber: engineNumber ?? this.engineNumber,
      color: color ?? this.color,
      capacityTons: capacityTons ?? this.capacityTons,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}