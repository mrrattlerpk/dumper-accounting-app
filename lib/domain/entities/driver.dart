/// Plain entity representing a Driver, independent of any data source.
class Driver {
  final int? id;
  final String name;
  final String phone;
  final String? address;
  final String? cnic;
  final String? licenseNumber;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Driver({
    this.id,
    required this.name,
    required this.phone,
    this.address,
    this.cnic,
    this.licenseNumber,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  /// Create a copy with optional field changes.
  Driver copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    String? cnic,
    String? licenseNumber,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      cnic: cnic ?? this.cnic,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}