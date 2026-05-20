import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection_container.dart';
import '../../data/models/material.dart';
import '../../domain/entities/material.dart' as entity;
import '../../domain/repositories/material_repository.dart';

/// Riverpod provider for MaterialRepository.
final materialRepositoryProvider = Provider<MaterialRepository>((ref) {
  final isar = ref.watch(isarInstanceProvider);
  return MaterialRepositoryImpl(isar);
});

class MaterialRepositoryImpl implements MaterialRepository {
  final Isar _isar;

  MaterialRepositoryImpl(this._isar);

  entity.MaterialEntity _toEntity(Material m) => entity.MaterialEntity(
        id: m.id,
        name: m.name,
        unit: m.unit,
        defaultRate: m.defaultRate,
        description: m.description,
        createdAt: m.createdAt,
        updatedAt: m.updatedAt,
      );

  Material _toModel(entity.MaterialEntity m, {int? existingId}) => Material()
    ..id = m.id ?? existingId ?? Isar.autoIncrement
    ..name = m.name
    ..unit = m.unit
    ..defaultRate = m.defaultRate
    ..description = m.description
    ..createdAt = m.createdAt ?? DateTime.now()
    ..updatedAt = DateTime.now();

  @override
  Future<List<entity.MaterialEntity>> getAllMaterials({String? searchQuery}) async {
    final query = _isar.materials.where();
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query.filter()
        ..nameContains(searchQuery, caseSensitive: false)
        ..or()
        ..descriptionContains(searchQuery, caseSensitive: false);
    }
    final results = await query.findAll();
    return results.map(_toEntity).toList();
  }

  @override
  Future<entity.MaterialEntity?> getMaterialById(int id) async {
    final result = await _isar.materials.get(id);
    return result != null ? _toEntity(result) : null;
  }

  @override
  Future<void> insertMaterial(entity.MaterialEntity material) async {
    final model = _toModel(material);
    await _isar.writeTxn(() async {
      await _isar.materials.put(model);
    });
  }

  @override
  Future<void> updateMaterial(entity.MaterialEntity material) async {
    if (material.id == null) throw ArgumentError('Material id cannot be null for update.');
    final model = _toModel(material, existingId: material.id);
    await _isar.writeTxn(() async {
      await _isar.materials.put(model);
    });
  }

  @override
  Future<void> deleteMaterial(int id) async {
    await _isar.writeTxn(() async {
      await _isar.materials.delete(id);
    });
  }

  @override
  Future<int> getMaterialUsageCount(int materialId) async {
    return await _isar.trips
        .where()
        .materialIdEqualTo(materialId)
        .count();
  }
}