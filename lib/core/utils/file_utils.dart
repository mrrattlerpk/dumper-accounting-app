import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Utility helpers for file I/O and sharing.
class FileUtils {
  FileUtils._();

  /// Get the app's document directory.
  static Future<Directory> getAppDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  /// Get the backup directory, creating it if needed.
  static Future<Directory> getBackupDirectory() async {
    final appDir = await getAppDirectory();
    final backupDir = Directory('${appDir.path}/backups');
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir;
  }

  /// Share a file using the system share sheet.
  static Future<void> shareFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('File not found', filePath);
    }
    await Share.shareXFiles([XFile(filePath)]);
  }

  /// Delete all files in the backup directory.
  static Future<void> clearBackups() async {
    final backupDir = await getBackupDirectory();
    if (await backupDir.exists()) {
      final files = backupDir.listSync();
      for (final file in files) {
        if (file is File) {
          await file.delete();
        }
      }
    }
  }
}