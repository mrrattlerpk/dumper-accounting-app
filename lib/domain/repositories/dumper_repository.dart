import '../entities/dumper.dart';

/// Abstract repository for Dumper entities.
abstract class DumperRepository {
  Future<List<Dumper>> getAllDumpers({String? searchQuery});
  Future<Dumper?> getDumperById(int id);
  Future<void> insertDumper(Dumper dumper);
  Future<void> updateDumper(Dumper dumper);
  Future<void> deleteDumper(int id);
  Future<int> getDumperTripCount(int dumperId);
  Future<double> getDumperTotalEarnings(int dumperId);
}