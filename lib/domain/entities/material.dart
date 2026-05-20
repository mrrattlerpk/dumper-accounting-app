/// Plain entity representing a Material type (e.g., Sand, Gravel).
class MaterialEntity {
  final int? id;
  final String name;
  final String? unit;
  final double defaultRate;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MaterialEntity({
    this.id,
    required this.name,
    this.unit,
    this.defaultRate = 0.0,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  MaterialEntity copyWith({
    int? id,
    String? name,
    String? unit,
    double? defaultRate,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MaterialEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      defaultRate: defaultRate ?? this.defaultRate,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}