import '../entities/trip.dart';
import '../repositories/trip_repository.dart';

/// Encapsulates all business operations related to Trips.
class TripUseCases {
  final TripRepository _repository;

  TripUseCases(this._repository);

  Future<List<Trip>> getTripsByDateRange(DateTime start, DateTime end) =>
      _repository.getTripsByDateRange(start, end);

  Future<List<Trip>> getTripsByDriver(int driverId) =>
      _repository.getTripsByDriver(driverId);

  Future<List<Trip>> getTripsByDumper(int dumperId) =>
      _repository.getTripsByDumper(dumperId);

  Future<List<Trip>> getTripsByCustomer(int customerId) =>
      _repository.getTripsByCustomer(customerId);

  Future<void> addTrip(Trip trip) async {
    _validateTrip(trip);
    await _repository.insertTrip(trip);
  }

  Future<void> updateTrip(Trip trip) async {
    if (trip.id == null) throw ArgumentError('Trip must have an ID to be updated.');
    _validateTrip(trip);
    await _repository.updateTrip(trip);
  }

  Future<void> deleteTrip(int id) =>
      _repository.deleteTrip(id);

  Future<double> getTotalEarnings({DateTime? start, DateTime? end}) =>
      _repository.getTotalEarnings(start: start, end: end);

  Future<double> getTotalPendingPayments() =>
      _repository.getTotalPendingPayments();

  Future<int> getTotalTripCount() =>
      _repository.getTotalTripCount();

  Future<List<Trip>> getRecentTrips({int limit = 10}) =>
      _repository.getRecentTrips(limit: limit);

  /// Centralized business validation.
  void _validateTrip(Trip trip) {
    if (trip.driverId <= 0) throw ArgumentError('Driver is required.');
    if (trip.dumperId <= 0) throw ArgumentError('Dumper is required.');
    if (trip.customerId <= 0) throw ArgumentError('Customer is required.');
    if (trip.materialId <= 0) throw ArgumentError('Material is required.');
    if (trip.quantity <= 0) throw ArgumentError('Quantity must be greater than zero.');
    if (trip.rate <= 0) throw ArgumentError('Rate must be greater than zero.');
  }
}