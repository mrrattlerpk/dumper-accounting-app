import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/db_constants.dart';
import '../../data/models/index.dart'; // Barrel file for all Isar schemas

/// Global Isar instance, initialized before app start.
Isar? _isarInstance;

/// Must be called in main() before runApp.
Future<void> initializeDependencies() async {
  final dir = await getApplicationDocumentsDirectory();
  _isarInstance = await Isar.open(
    [
      DriverSchema,
      DumperSchema,
      CustomerSchema,
      MaterialSchema,
      TripSchema,
      SettingsSchema,
    ],
    directory: dir.path,
    name: AppDbConstants.dbName,
  );
}

/// Riverpod provider that exposes the Isar instance.
/// Throws if accessed before initialization.
final isarInstanceProvider = Provider<Isar>((ref) {
  if (_isarInstance == null) {
    throw StateError(
        'Isar has not been initialized. Call initializeDependencies() first.');
  }
  return _isarInstance!;
});