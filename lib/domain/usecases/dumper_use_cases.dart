import '../entities/dumper.dart';
import '../repositories/dumper_repository.dart';

/// Encapsulates all business operations related to Dumpers.
class DumperUseCases {
  final DumperRepository _repository;

  DumperUseCases(this._repository);

  Future<List<Dumper>> getAllDumpers({String? searchQuery}) =>
      _repository.getAllDumpers(searchQuery: searchQuery);

  Future<Dumper?> getDumperById(int id) =>
      _repository.getDumperById(id);

  Future<void> addDumper(Dumper dumper) async {
    if (dumper.registrationNumber.trim().isEmpty) {
      throw ArgumentError('Registration number is required.');
    }
    await _repository.insertDumper(dumper);
  }

  Future<void> updateDumper(Dumper dumper) async {
    if (dumper.id == null) throw ArgumentError('Dumper must have an ID to be updated.');
    await _repository.updateDumper(dumper);
  }

  Future<void> deleteDumper(int id) =>
      _repository.deleteDumper(id);

  Future<int> getTripCount(int dumperId) =>
      _repository.getDumperTripCount(dumperId);

  Future<double> getTotalEarnings(int dumperId) =>
      _repository.getDumperTotalEarnings(dumperId);
}