import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/trip_repository_impl.dart';
import '../../../../domain/entities/trip.dart';

/// State of the trip entry form – fully mutable.
class TripFormState {
  final int? driverId;
  final int? dumperId;
  final int? customerId;
  final int? materialId;
  final double quantity;
  final double rate;
  final double totalAmount;   // auto-calculated
  final double paidAmount;
  final double remaining;     // auto-calculated
  final DateTime tripDate;
  final String? notes;
  final bool isSaving;

  const TripFormState({
    this.driverId,
    this.dumperId,
    this.customerId,
    this.materialId,
    this.quantity = 0.0,
    this.rate = 0.0,
    this.totalAmount = 0.0,
    this.paidAmount = 0.0,
    this.remaining = 0.0,
    required this.tripDate,
    this.notes,
    this.isSaving = false,
  });

  TripFormState copyWith({
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
    bool? isSaving,
  }) {
    return TripFormState(
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
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

/// Notifier that holds and manipulates the trip entry form.
/// Auto-calculates totals and remaining whenever quantity/rate/paid change.
final tripEntryProvider =
    NotifierProvider<TripEntryNotifier, TripFormState>(
  TripEntryNotifier.new,
);

class TripEntryNotifier extends Notifier<TripFormState> {
  @override
  TripFormState build() {
    return TripFormState(tripDate: DateTime.now());
  }

  void setDriver(int id) => state = state.copyWith(driverId: id);
  void setDumper(int id) => state = state.copyWith(dumperId: id);
  void setCustomer(int id) => state = state.copyWith(customerId: id);
  void setMaterial(int id, {double? defaultRate}) {
    state = state.copyWith(
      materialId: id,
      rate: defaultRate ?? state.rate,
    );
    _recalculate();
  }

  void setQuantity(double qty) {
    state = state.copyWith(quantity: qty);
    _recalculate();
  }

  void setRate(double rate) {
    state = state.copyWith(rate: rate);
    _recalculate();
  }

  void setPaidAmount(double paid) {
    state = state.copyWith(paidAmount: paid);
    _recalculate();
  }

  void setTripDate(DateTime date) => state = state.copyWith(tripDate: date);
  void setNotes(String? notes) => state = state.copyWith(notes: notes);

  void _recalculate() {
    final total = state.quantity * state.rate;
    final remaining = total - state.paidAmount;
    state = state.copyWith(
      totalAmount: total,
      remaining: remaining,
    );
  }

  /// Persist the trip using the repository.
  Future<void> saveTrip() async {
    final s = state;
    if (s.driverId == null || s.dumperId == null ||
        s.customerId == null || s.materialId == null ||
        s.quantity <= 0 || s.rate <= 0) {
      throw StateError('Please fill all required fields');
    }

    state = state.copyWith(isSaving: true);

    try {
      final repo = ref.read(tripRepositoryProvider);
      final trip = Trip(
        driverId: s.driverId!,
        dumperId: s.dumperId!,
        customerId: s.customerId!,
        materialId: s.materialId!,
        quantity: s.quantity,
        rate: s.rate,
        totalAmount: s.totalAmount,
        paidAmount: s.paidAmount,
        remaining: s.remaining,
        tripDate: s.tripDate,
        notes: s.notes,
        isFullyPaid: s.remaining <= 0,
        createdAt: DateTime.now(),
      );

      await repo.insertTrip(trip);

      // Reset form after successful save
      state = TripFormState(tripDate: DateTime.now());
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}