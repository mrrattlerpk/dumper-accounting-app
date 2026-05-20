import '../entities/material.dart';

/// Abstract repository for Material entities.
abstract class MaterialRepository {
  Future<List<MaterialEntity>> getAllMaterials({String? searchQuery});
  Future<MaterialEntity?> getMaterialById(int id);
  Future<void> insertMaterial(MaterialEntity material);
  Future<void> updateMaterial(MaterialEntity material);
  Future<void> deleteMaterial(int id);
  Future<int> getMaterialUsageCount(int materialId);
}