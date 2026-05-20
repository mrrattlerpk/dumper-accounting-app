/// Plain entity representing a Customer / Contractor.
class Customer {
  final int? id;
  final String name;
  final String? company;
  final String? phone;
  final String? address;
  final String? notes;
  final double openingBalance;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Customer({
    this.id,
    required this.name,
    this.company,
    this.phone,
    this.address,
    this.notes,
    this.openingBalance = 0.0,
    this.createdAt,
    this.updatedAt,
  });

  Customer copyWith({
    int? id,
    String? name,
    String? company,
    String? phone,
    String? address,
    String? notes,
    double? openingBalance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      company: company ?? this.company,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      openingBalance: openingBalance ?? this.openingBalance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}