import '../entities/driver.dart';

/// Abstract repository for Driver entities.
/// Implementation in data layer.
abstract class DriverRepository {
  Future<List<Driver>> getAllDrivers({String? searchQuery});
  Future<Driver?> getDriverById(int id);
  Future<void> insertDriver(Driver driver);
  Future<void> updateDriver(Driver driver);
  Future<void> deleteDriver(int id);
  Future<double> getDriverTotalEarnings(int driverId);
  Future<int> getDriverTripCount(int driverId);
}