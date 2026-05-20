import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/driver_repository_impl.dart';
import '../../../../domain/entities/driver.dart';
import '../../../../domain/usecases/driver_use_cases.dart';

/// State for the driver list screen.
class DriversState {
  final List<Driver> drivers;
  final bool isLoading;

  const DriversState({
    this.drivers = const [],
    this.isLoading = false,
  });

  DriversState copyWith({List<Driver>? drivers, bool? isLoading}) =>
      DriversState(
        drivers: drivers ?? this.drivers,
        isLoading: isLoading ?? this.isLoading,
      );
}

/// Notifier for fetching, searching, and deleting drivers.
final driversProvider =
    AsyncNotifierProvider<DriversNotifier, DriversState>(
  () => DriversNotifier(),
);

class DriversNotifier extends AsyncNotifier<DriversState> {
  late final DriverUseCases _useCases;
  String _searchQuery = '';

  @override
  Future<DriversState> build() async {
    _useCases = DriverUseCases(ref.read(driverRepositoryProvider));
    return await _loadDrivers();
  }

  Future<DriversState> _loadDrivers() async {
    final drivers = await _useCases.getAllDrivers(searchQuery: _searchQuery.isEmpty ? null : _searchQuery);
    return DriversState(drivers: drivers);
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadDrivers());
  }

  Future<void> deleteDriver(int id) async {
    await _useCases.deleteDriver(id);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadDrivers());
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadDrivers());
  }
}