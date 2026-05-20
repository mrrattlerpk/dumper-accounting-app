import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/trip_repository_impl.dart';
import '../../../../data/repositories/driver_repository_impl.dart';
import '../../../../data/repositories/dumper_repository_impl.dart';
import '../../../../data/repositories/customer_repository_impl.dart';
import '../../../../domain/usecases/trip_use_cases.dart';
import '../../../../domain/usecases/driver_use_cases.dart';
import '../../../../domain/usecases/dumper_use_cases.dart';
import '../../../../domain/usecases/customer_use_cases.dart';
import '../../../../domain/entities/trip.dart';

/// Immutable dashboard state.
class DashboardState {
  final int totalTrips;
  final double totalEarnings;
  final double pendingPayments;
  final int totalDrivers;
  final int totalDumpers;
  final int totalCustomers;
  final List<Trip> recentTrips;

  const DashboardState({
    this.totalTrips = 0,
    this.totalEarnings = 0.0,
    this.pendingPayments = 0.0,
    this.totalDrivers = 0,
    this.totalDumpers = 0,
    this.totalCustomers = 0,
    this.recentTrips = const [],
  });

  DashboardState copyWith({
    int? totalTrips,
    double? totalEarnings,
    double? pendingPayments,
    int? totalDrivers,
    int? totalDumpers,
    int? totalCustomers,
    List<Trip>? recentTrips,
  }) {
    return DashboardState(
      totalTrips: totalTrips ?? this.totalTrips,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      pendingPayments: pendingPayments ?? this.pendingPayments,
      totalDrivers: totalDrivers ?? this.totalDrivers,
      totalDumpers: totalDumpers ?? this.totalDumpers,
      totalCustomers: totalCustomers ?? this.totalCustomers,
      recentTrips: recentTrips ?? this.recentTrips,
    );
  }
}

/// AsyncNotifier that loads all dashboard stats from repositories.
final dashboardProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardState>(
  () => DashboardNotifier(),
);

class DashboardNotifier extends AsyncNotifier<DashboardState> {
  @override
  Future<DashboardState> build() async {
    return await _loadData();
  }

  Future<DashboardState> _loadData() async {
    final tripRepo = ref.read(tripRepositoryProvider);
    final driverRepo = ref.read(driverRepositoryProvider);
    final dumperRepo = ref.read(dumperRepositoryProvider);
    final customerRepo = ref.read(customerRepositoryProvider);

    final tripUseCases = TripUseCases(tripRepo);
    final driverUseCases = DriverUseCases(driverRepo);
    final dumperUseCases = DumperUseCases(dumperRepo);
    final customerUseCases = CustomerUseCases(customerRepo);

    // Run independent queries concurrently
    final results = await Future.wait([
      tripUseCases.getTotalTripCount(),
      tripUseCases.getTotalEarnings(),
      tripUseCases.getTotalPendingPayments(),
      driverUseCases.getAllDrivers(),
      dumperUseCases.getAllDumpers(),
      customerUseCases.getAllCustomers(),
      tripUseCases.getRecentTrips(limit: 5),
    ]);

    final totalTrips = results[0] as int;
    final totalEarnings = results[1] as double;
    final pendingPayments = results[2] as double;
    final drivers = results[3] as List;
    final dumpers = results[4] as List;
    final customers = results[5] as List;
    final recentTrips = results[6] as List<Trip>;

    return DashboardState(
      totalTrips: totalTrips,
      totalEarnings: totalEarnings,
      pendingPayments: pendingPayments,
      totalDrivers: drivers.length,
      totalDumpers: dumpers.length,
      totalCustomers: customers.length,
      recentTrips: recentTrips,
    );
  }

  /// Refresh data from repositories.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadData());
  }
}