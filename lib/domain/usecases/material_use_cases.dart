import '../entities/material.dart';
import '../repositories/material_repository.dart';

/// Encapsulates all business operations related to Materials.
class MaterialUseCases {
  final MaterialRepository _repository;

  MaterialUseCases(this._repository);

  Future<List<MaterialEntity>> getAllMaterials({String? searchQuery}) =>
      _repository.getAllMaterials(searchQuery: searchQuery);

  Future<MaterialEntity?> getMaterialById(int id) =>
      _repository.getMaterialById(id);

  Future<void> addMaterial(MaterialEntity material) async {
    if (material.name.trim().isEmpty) {
      throw ArgumentError('Material name cannot be empty.');
    }
    await _repository.insertMaterial(material);
  }

  Future<void> updateMaterial(MaterialEntity material) async {
    if (material.id == null) {
      throw ArgumentError('Material must have an ID to be updated.');
    }
    await _repository.updateMaterial(material);
  }

  Future<void> deleteMaterial(int id) =>
      _repository.deleteMaterial(id);

  Future<int> getUsageCount(int materialId) =>
      _repository.getMaterialUsageCount(materialId);
}