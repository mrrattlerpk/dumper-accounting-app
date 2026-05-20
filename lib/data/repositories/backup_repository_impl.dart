import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/di/injection_container.dart';
import '../../domain/repositories/backup_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../repositories/settings_repository_impl.dart';
import '../../core/constants/db_constants.dart';
import '../../core/constants/app_constants.dart';

/// Riverpod provider for BackupRepository.
final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  final isar = ref.watch(isarInstanceProvider);
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  return BackupRepositoryImpl(isar: isar, settingsRepo: settingsRepo);
});

class BackupRepositoryImpl implements BackupRepository {
  final Isar isar;
  final SettingsRepository settingsRepo;

  BackupRepositoryImpl({required this.isar, required this.settingsRepo});

  @override
  Future<String> createBackup() async {
    // 1. Close Isar to ensure DB files are consistent
    final dbPath = isar.directory;

    // 2. Create a temp directory for backup assembly
    final tempDir = await getTemporaryDirectory();
    final backupDir = Directory('${tempDir.path}/backup_${DateTime.now().millisecondsSinceEpoch}');
    await backupDir.create(recursive: true);

    // 3. Copy Isar files to backup dir
    final dbDir = Directory(dbPath);
    final files = dbDir.listSync(recursive: false);
    for (final file in files) {
      if (file is File) {
        final fileName = file.uri.pathSegments.last;
        await file.copy('${backupDir.path}/$fileName');
      }
    }

    // 4. Create ZIP archive
    final encoder = ZipEncoder();
    final archive = Archive();
    final backupFiles = backupDir.listSync(recursive: false);
    for (final file in backupFiles) {
      if (file is File) {
        final bytes = await file.readAsBytes();
        archive.addFile(ArchiveFile(
          file.uri.pathSegments.last,
          bytes.length,
          bytes,
        ));
      }
    }

    final zipData = encoder.encode(archive);

    // 5. Save ZIP to a dedicated backup folder
    final appDir = await getApplicationDocumentsDirectory();
    final backupFolder = Directory('${appDir.path}/backups');
    if (!await backupFolder.exists()) {
      await backupFolder.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final zipFileName = '${AppDbConstants.backupPrefix}_$timestamp${AppConstants.backupFileExtension}';
    final zipFile = File('${backupFolder.path}/$zipFileName');
    await zipFile.writeAsBytes(zipData);

    // 6. Clean up temp directory
    await backupDir.delete(recursive: true);

    // 7. Update settings with last backup time
    final settings = await settingsRepo.getSettings();
    await settingsRepo.updateSettings(
      settings.copyWith(lastAutoBackupAt: DateTime.now(), updatedAt: DateTime.now()),
    );

    return zipFile.path;
  }

  @override
  Future<void> restoreBackup(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('Backup file not found', filePath);
    }

    // 1. Read ZIP bytes
    final zipBytes = await file.readAsBytes();

    // 2. Decode ZIP
    final decoder = ZipDecoder();
    final archive = decoder.decodeBytes(zipBytes);

    // 3. Extract to a temp location
    final tempDir = await getTemporaryDirectory();
    final restoreDir = Directory('${tempDir.path}/restore_${DateTime.now().millisecondsSinceEpoch}');
    await restoreDir.create(recursive: true);

    for (final file in archive) {
      if (file.isFile) {
        final outputFile = File('${restoreDir.path}/${file.name}');
        await outputFile.writeAsBytes(file.content as List<int>);
      }
    }

    // 4. Close Isar, replace DB files, reopen Isar
    await isar.close();

    final dbPath = isar.directory;
    final dbDir = Directory(dbPath);
    if (dbDir.existsSync()) {
      // Clear existing DB files
      await dbDir.delete(recursive: true);
    }
    await dbDir.create(recursive: true);

    // Copy extracted files to DB directory
    final extractedFiles = restoreDir.listSync(recursive: false);
    for (final file in extractedFiles) {
      if (file is File) {
        final fileName = file.uri.pathSegments.last;
        await file.copy('$dbPath/$fileName');
      }
    }

    // Clean up temp
    await restoreDir.delete(recursive: true);

    // Reopen Isar
    await isar.open(
      schemas: isar.schema,
      directory: dbPath,
      name: AppDbConstants.dbName,
    );
  }

  @override
  Future<String?> getLastBackupPath() async {
    final appDir = await getApplicationDocumentsDirectory();
    final backupFolder = Directory('${appDir.path}/backups');
    if (!await backupFolder.exists()) return null;

    final files = backupFolder.listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith(AppConstants.backupFileExtension))
        .toList();

    if (files.isEmpty) return null;

    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    return files.first.path;
  }

  @override
  Future<bool> isAutoBackupDue() async {
    final settings = await settingsRepo.getSettings();
    if (settings.autoBackupIntervalHours == 0) return false;

    final lastBackup = settings.lastAutoBackupAt;
    if (lastBackup == null) return true;

    final nextBackupDue = lastBackup.add(Duration(hours: settings.autoBackupIntervalHours));
    return DateTime.now().isAfter(nextBackupDue);
  }
}