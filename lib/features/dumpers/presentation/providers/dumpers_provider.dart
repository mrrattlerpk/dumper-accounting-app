import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/dumper_repository_impl.dart';
import '../../../../domain/entities/dumper.dart';
import '../../../../domain/usecases/dumper_use_cases.dart';

/// State for dumper list.
class DumpersState {
  final List<Dumper> dumpers;
  final bool isLoading;

  const DumpersState({
    this.dumpers = const [],
    this.isLoading = false,
  });

  DumpersState copyWith({List<Dumper>? dumpers, bool? isLoading}) =>
      DumpersState(
        dumpers: dumpers ?? this.dumpers,
        isLoading: isLoading ?? this.isLoading,
      );
}

/// Notifier for fetching, searching, and deleting dumpers.
final dumpersProvider =
    AsyncNotifierProvider<DumpersNotifier, DumpersState>(
  () => DumpersNotifier(),
);

class DumpersNotifier extends AsyncNotifier<DumpersState> {
  late final DumperUseCases _useCases;
  String _searchQuery = '';

  @override
  Future<DumpersState> build() async {
    _useCases = DumperUseCases(ref.read(dumperRepositoryProvider));
    return await _loadDumpers();
  }

  Future<DumpersState> _loadDumpers() async {
    final dumpers = await _useCases.getAllDumpers(
      searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
    );
    return DumpersState(dumpers: dumpers);
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadDumpers());
  }

  Future<void> deleteDumper(int id) async {
    await _useCases.deleteDumper(id);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadDumpers());
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadDumpers());
  }
}