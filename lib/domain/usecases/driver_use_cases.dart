import '../entities/driver.dart';
import '../repositories/driver_repository.dart';

/// Encapsulates all business operations related to Drivers.
class DriverUseCases {
  final DriverRepository _repository;

  DriverUseCases(this._repository);

  Future<List<Driver>> getAllDrivers({String? searchQuery}) =>
      _repository.getAllDrivers(searchQuery: searchQuery);

  Future<Driver?> getDriverById(int id) =>
      _repository.getDriverById(id);

  Future<void> addDriver(Driver driver) async {
    // Any business validation before insert
    if (driver.name.trim().isEmpty) throw ArgumentError('Driver name cannot be empty.');
    if (driver.phone.trim().isEmpty) throw ArgumentError('Phone number is required.');
    await _repository.insertDriver(driver);
  }

  Future<void> updateDriver(Driver driver) async {
    if (driver.id == null) throw ArgumentError('Driver must have an ID to be updated.');
    await _repository.updateDriver(driver);
  }

  Future<void> deleteDriver(int id) =>
      _repository.deleteDriver(id);

  Future<double> getTotalEarnings(int driverId) =>
      _repository.getDriverTotalEarnings(driverId);

  Future<int> getTripCount(int driverId) =>
      _repository.getDriverTripCount(driverId);
}