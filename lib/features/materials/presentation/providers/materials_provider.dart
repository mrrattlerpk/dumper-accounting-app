import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/material_repository_impl.dart';
import '../../../../domain/entities/material.dart';
import '../../../../domain/usecases/material_use_cases.dart';

/// State for materials list.
class MaterialsState {
  final List<MaterialEntity> materials;
  final bool isLoading;

  const MaterialsState({
    this.materials = const [],
    this.isLoading = false,
  });

  MaterialsState copyWith({
    List<MaterialEntity>? materials,
    bool? isLoading,
  }) =>
      MaterialsState(
        materials: materials ?? this.materials,
        isLoading: isLoading ?? this.isLoading,
      );
}

/// AsyncNotifier for materials CRUD.
final materialsProvider =
    AsyncNotifierProvider<MaterialsNotifier, MaterialsState>(
  () => MaterialsNotifier(),
);

class MaterialsNotifier extends AsyncNotifier<MaterialsState> {
  late final MaterialUseCases _useCases;
  String _searchQuery = '';

  @override
  Future<MaterialsState> build() async {
    _useCases = MaterialUseCases(ref.read(materialRepositoryProvider));
    return await _loadMaterials();
  }

  Future<MaterialsState> _loadMaterials() async {
    final materials = await _useCases.getAllMaterials(
        searchQuery: _searchQuery.isEmpty ? null : _searchQuery);
    return MaterialsState(materials: materials);
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadMaterials());
  }

  Future<void> deleteMaterial(int id) async {
    await _useCases.deleteMaterial(id);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadMaterials());
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadMaterials());
  }
}