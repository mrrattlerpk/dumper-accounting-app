import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection_container.dart';
import '../../data/models/trip.dart';
import '../../domain/entities/trip.dart' as entity;
import '../../domain/repositories/trip_repository.dart';

/// Riverpod provider for TripRepository.
final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final isar = ref.watch(isarInstanceProvider);
  return TripRepositoryImpl(isar);
});

class TripRepositoryImpl implements TripRepository {
  final Isar _isar;

  TripRepositoryImpl(this._isar);

  entity.Trip _toEntity(Trip t) => entity.Trip(
        id: t.id,
        driverId: t.driverId,
        dumperId: t.dumperId,
        customerId: t.customerId,
        materialId: t.materialId,
        quantity: t.quantity,
        rate: t.rate,
        totalAmount: t.totalAmount,
        paidAmount: t.paidAmount,
        remaining: t.remaining,
        tripDate: t.tripDate,
        notes: t.notes,
        isFullyPaid: t.isFullyPaid,
        createdAt: t.createdAt,
        updatedAt: t.updatedAt,
      );

  Trip _toModel(entity.Trip t, {int? existingId}) => Trip()
    ..id = t.id ?? existingId ?? Isar.autoIncrement
    ..driverId = t.driverId
    ..dumperId = t.dumperId
    ..customerId = t.customerId
    ..materialId = t.materialId
    ..quantity = t.quantity
    ..rate = t.rate
    ..totalAmount = t.totalAmount
    ..paidAmount = t.paidAmount
    ..remaining = t.remaining
    ..tripDate = t.tripDate
    ..notes = t.notes
    ..isFullyPaid = t.isFullyPaid
    ..createdAt = t.createdAt
    ..updatedAt = DateTime.now();

  @override
  Future<List<entity.Trip>> getTripsByDateRange(DateTime start, DateTime end) async {
    final results = await _isar.trips
        .where()
        .tripDateBetween(start, end)
        .findAll();
    return results.map(_toEntity).toList();
  }

  @override
  Future<List<entity.Trip>> getTripsByDriver(int driverId) async {
    final results = await _isar.trips
        .where()
        .driverIdEqualTo(driverId)
        .findAll();
    return results.map(_toEntity).toList();
  }

  @override
  Future<List<entity.Trip>> getTripsByDumper(int dumperId) async {
    final results = await _isar.trips
        .where()
        .dumperIdEqualTo(dumperId)
        .findAll();
    return results.map(_toEntity).toList();
  }

  @override
  Future<List<entity.Trip>> getTripsByCustomer(int customerId) async {
    final results = await _isar.trips
        .where()
        .customerIdEqualTo(customerId)
        .findAll();
    return results.map(_toEntity).toList();
  }

  @override
  Future<void> insertTrip(entity.Trip trip) async {
    final model = _toModel(trip);
    await _isar.writeTxn(() async {
      await _isar.trips.put(model);
    });
  }

  @override
  Future<void> updateTrip(entity.Trip trip) async {
    if (trip.id == null) throw ArgumentError('Trip id cannot be null for update.');
    final model = _toModel(trip, existingId: trip.id);
    await _isar.writeTxn(() async {
      await _isar.trips.put(model);
    });
  }

  @override
  Future<void> deleteTrip(int id) async {
    await _isar.writeTxn(() async {
      await _isar.trips.delete(id);
    });
  }

  @override
  Future<double> getTotalEarnings({DateTime? start, DateTime? end}) async {
    final query = _isar.trips.where();
    if (start != null && end != null) {
      query.tripDateBetween(start, end);
    }
    final trips = await query.findAll();
    return trips.fold(0.0, (sum, t) => sum + t.totalAmount);
  }

  @override
  Future<double> getTotalPendingPayments() async {
    final trips = await _isar.trips.where().isFullyPaidEqualTo(false).findAll();
    return trips.fold(0.0, (sum, t) => sum + t.remaining);
  }

  @override
  Future<int> getTotalTripCount() async {
    return await _isar.trips.count();
  }

  @override
  Future<List<entity.Trip>> getRecentTrips({int limit = 10}) async {
    final results = await _isar.trips
        .where()
        .sortByTripDateDesc()
        .limit(limit)
        .findAll();
    return results.map(_toEntity).toList();
  }
}