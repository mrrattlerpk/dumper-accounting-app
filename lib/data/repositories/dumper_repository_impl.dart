import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection_container.dart';
import '../../data/models/dumper.dart';
import '../../domain/entities/dumper.dart' as entity;
import '../../domain/repositories/dumper_repository.dart';

/// Riverpod provider for DumperRepository.
final dumperRepositoryProvider = Provider<DumperRepository>((ref) {
  final isar = ref.watch(isarInstanceProvider);
  return DumperRepositoryImpl(isar);
});

class DumperRepositoryImpl implements DumperRepository {
  final Isar _isar;

  DumperRepositoryImpl(this._isar);

  entity.Dumper _toEntity(Dumper d) => entity.Dumper(
        id: d.id,
        registrationNumber: d.registrationNumber,
        model: d.model,
        ownerName: d.ownerName,
        chassisNumber: d.chassisNumber,
        engineNumber: d.engineNumber,
        color: d.color,
        capacityTons: d.capacityTons,
        notes: d.notes,
        isActive: d.isActive,
        createdAt: d.createdAt,
        updatedAt: d.updatedAt,
      );

  Dumper _toModel(entity.Dumper d, {int? existingId}) => Dumper()
    ..id = d.id ?? existingId ?? Isar.autoIncrement
    ..registrationNumber = d.registrationNumber
    ..model = d.model
    ..ownerName = d.ownerName
    ..chassisNumber = d.chassisNumber
    ..engineNumber = d.engineNumber
    ..color = d.color
    ..capacityTons = d.capacityTons
    ..notes = d.notes
    ..isActive = d.isActive
    ..createdAt = d.createdAt ?? DateTime.now()
    ..updatedAt = DateTime.now();

  @override
  Future<List<entity.Dumper>> getAllDumpers({String? searchQuery}) async {
    final query = _isar.dumpers.where();
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query.filter()
        ..registrationNumberContains(searchQuery, caseSensitive: false)
        ..or()
        ..modelContains(searchQuery, caseSensitive: false)
        ..or()
        ..ownerNameContains(searchQuery, caseSensitive: false);
    }
    final results = await query.findAll();
    return results.map(_toEntity).toList();
  }

  @override
  Future<entity.Dumper?> getDumperById(int id) async {
    final result = await _isar.dumpers.get(id);
    return result != null ? _toEntity(result) : null;
  }

  @override
  Future<void> insertDumper(entity.Dumper dumper) async {
    final model = _toModel(dumper);
    await _isar.writeTxn(() async {
      await _isar.dumpers.put(model);
    });
  }

  @override
  Future<void> updateDumper(entity.Dumper dumper) async {
    if (dumper.id == null) throw ArgumentError('Dumper id cannot be null for update.');
    final model = _toModel(dumper, existingId: dumper.id);
    await _isar.writeTxn(() async {
      await _isar.dumpers.put(model);
    });
  }

  @override
  Future<void> deleteDumper(int id) async {
    await _isar.writeTxn(() async {
      await _isar.dumpers.delete(id);
    });
  }

  @override
  Future<int> getDumperTripCount(int dumperId) async {
    return await _isar.trips
        .where()
        .dumperIdEqualTo(dumperId)
        .count();
  }

  @override
  Future<double> getDumperTotalEarnings(int dumperId) async {
    final trips = await _isar.trips
        .where()
        .dumperIdEqualTo(dumperId)
        .findAll();
    return trips.fold(0.0, (sum, trip) => sum + trip.totalAmount);
  }
}