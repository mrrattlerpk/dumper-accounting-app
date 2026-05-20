/// Abstract repository for backup/restore operations.
abstract class BackupRepository {
  /// Create a backup ZIP file and return the file path.
  Future<String> createBackup();

  /// Restore data from a backup ZIP file.
  Future<void> restoreBackup(String filePath);

  /// Get the path to the last auto-backup file, or null if none.
  Future<String?> getLastBackupPath();

  /// Check if auto-backup is due based on the configured interval.
  Future<bool> isAutoBackupDue();
}