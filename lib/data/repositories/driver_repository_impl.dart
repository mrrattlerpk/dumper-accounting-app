import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection_container.dart';
import '../../data/models/driver.dart';
import '../../domain/entities/driver.dart' as entity;
import '../../domain/repositories/driver_repository.dart';

/// Riverpod provider for DriverRepository.
final driverRepositoryProvider = Provider<DriverRepository>((ref) {
  final isar = ref.watch(isarInstanceProvider);
  return DriverRepositoryImpl(isar);
});

class DriverRepositoryImpl implements DriverRepository {
  final Isar _isar;

  DriverRepositoryImpl(this._isar);

  // Helper to map Isar model to domain entity
  entity.Driver _toEntity(Driver d) => entity.Driver(
        id: d.id,
        name: d.name,
        phone: d.phone,
        address: d.address,
        cnic: d.cnic,
        licenseNumber: d.licenseNumber,
        notes: d.notes,
        createdAt: d.createdAt,
        updatedAt: d.updatedAt,
      );

  // Helper to map domain entity to Isar model
  Driver _toModel(entity.Driver d, {int? existingId}) => Driver()
    ..id = d.id ?? existingId ?? Isar.autoIncrement
    ..name = d.name
    ..phone = d.phone
    ..address = d.address
    ..cnic = d.cnic
    ..licenseNumber = d.licenseNumber
    ..notes = d.notes
    ..createdAt = d.createdAt ?? DateTime.now()
    ..updatedAt = DateTime.now();

  @override
  Future<List<entity.Driver>> getAllDrivers({String? searchQuery}) async {
    final query = _isar.drivers.where();
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query.filter()
        ..nameContains(searchQuery, caseSensitive: false)
        ..or()
        ..phoneContains(searchQuery, caseSensitive: false);
    }
    final results = await query.findAll();
    return results.map(_toEntity).toList();
  }

  @override
  Future<entity.Driver?> getDriverById(int id) async {
    final result = await _isar.drivers.get(id);
    return result != null ? _toEntity(result) : null;
  }

  @override
  Future<void> insertDriver(entity.Driver driver) async {
    final model = _toModel(driver);
    await _isar.writeTxn(() async {
      await _isar.drivers.put(model);
    });
  }

  @override
  Future<void> updateDriver(entity.Driver driver) async {
    if (driver.id == null) throw ArgumentError('Driver id cannot be null for update.');
    final model = _toModel(driver, existingId: driver.id);
    await _isar.writeTxn(() async {
      await _isar.drivers.put(model);
    });
  }

  @override
  Future<void> deleteDriver(int id) async {
    await _isar.writeTxn(() async {
      await _isar.drivers.delete(id);
    });
  }

  @override
  Future<double> getDriverTotalEarnings(int driverId) async {
    final trips = await _isar.trips
        .where()
        .driverIdEqualTo(driverId)
        .findAll();
    return trips.fold(0.0, (sum, trip) => sum + trip.totalAmount);
  }

  @override
  Future<int> getDriverTripCount(int driverId) async {
    return await _isar.trips
        .where()
        .driverIdEqualTo(driverId)
        .count();
  }
}