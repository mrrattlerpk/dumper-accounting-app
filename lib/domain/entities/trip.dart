/// Plain entity representing a single Trip entry.
class Trip {
  final int? id;
  final int driverId;
  final int dumperId;
  final int customerId;
  final int materialId;
  final double quantity;
  final double rate;
  final double totalAmount;
  final double paidAmount;
  final double remaining;
  final DateTime tripDate;
  final String? notes;
  final bool isFullyPaid;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Trip({
    this.id,
    required this.driverId,
    required this.dumperId,
    required this.customerId,
    required this.materialId,
    required this.quantity,
    required this.rate,
    required this.totalAmount,
    required this.paidAmount,
    required this.remaining,
    required this.tripDate,
    this.notes,
    required this.isFullyPaid,
    required this.createdAt,
    this.updatedAt,
  });

  Trip copyWith({
    int? id,
    int? driverId,
    int? dumperId,
    int? customerId,
    int? materialId,
    double? quantity,
    double? rate,
    double? totalAmount,
    double? paidAmount,
    double? remaining,
    DateTime? tripDate,
    String? notes,
    bool? isFullyPaid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Trip(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      dumperId: dumperId ?? this.dumperId,
      customerId: customerId ?? this.customerId,
      materialId: materialId ?? this.materialId,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      remaining: remaining ?? this.remaining,
      tripDate: tripDate ?? this.tripDate,
      notes: notes ?? this.notes,
      isFullyPaid: isFullyPaid ?? this.isFullyPaid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}