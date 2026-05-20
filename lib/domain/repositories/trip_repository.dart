import '../entities/trip.dart';

/// Abstract repository for Trip entries.
abstract class TripRepository {
  Future<List<Trip>> getTripsByDateRange(DateTime start, DateTime end);
  Future<List<Trip>> getTripsByDriver(int driverId);
  Future<List<Trip>> getTripsByDumper(int dumperId);
  Future<List<Trip>> getTripsByCustomer(int customerId);
  Future<void> insertTrip(Trip trip);
  Future<void> updateTrip(Trip trip);
  Future<void> deleteTrip(int id);
  Future<double> getTotalEarnings({DateTime? start, DateTime? end});
  Future<double> getTotalPendingPayments();
  Future<int> getTotalTripCount();
  Future<List<Trip>> getRecentTrips({int limit = 10});
}