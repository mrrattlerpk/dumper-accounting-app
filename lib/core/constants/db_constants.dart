/// Database-related constants used throughout the app.
class AppDbConstants {
  AppDbConstants._();

  /// Isar database file name.
  static const String dbName = 'dumper_accounting_db';

  /// Current schema version (increment when models change).
  static const int schemaVersion = 1;

  /// Backup file naming prefix.
  static const String backupPrefix = 'dumper_backup';
}