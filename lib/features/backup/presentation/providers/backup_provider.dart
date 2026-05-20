import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/backup_repository_impl.dart';

/// State for backup operations.
class BackupState {
  final bool isBackingUp;
  final bool isRestoring;
  final String? lastBackupPath;
  final DateTime? lastBackupDate;
  final String? message;
  final bool isError;

  const BackupState({
    this.isBackingUp = false,
    this.isRestoring = false,
    this.lastBackupPath,
    this.lastBackupDate,
    this.message,
    this.isError = false,
  });

  BackupState copyWith({
    bool? isBackingUp,
    bool? isRestoring,
    String? lastBackupPath,
    DateTime? lastBackupDate,
    String? message,
    bool? isError,
  }) {
    return BackupState(
      isBackingUp: isBackingUp ?? this.isBackingUp,
      isRestoring: isRestoring ?? this.isRestoring,
      lastBackupPath: lastBackupPath ?? this.lastBackupPath,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
      message: message,
      isError: isError ?? false,
    );
  }
}

/// Notifier that handles backup/restore operations.
final backupProvider =
    AsyncNotifierProvider<BackupNotifier, BackupState>(
  () => BackupNotifier(),
);

class BackupNotifier extends AsyncNotifier<BackupState> {
  @override
  Future<BackupState> build() async {
    final backupRepo = ref.read(backupRepositoryProvider);
    final lastPath = await backupRepo.getLastBackupPath();
    if (lastPath != null) {
      final file = File(lastPath);
      final lastModified = file.lastModifiedSync();
      return BackupState(
        lastBackupPath: lastPath,
        lastBackupDate: lastModified,
      );
    }
    return const BackupState();
  }

  Future<void> createBackup() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final backupRepo = ref.read(backupRepositoryProvider);
      final path = await backupRepo.createBackup();
      final file = File(path);
      return BackupState(
        lastBackupPath: path,
        lastBackupDate: file.lastModifiedSync(),
        message: 'Backup created successfully',
      );
    });
  }

  Future<void> restoreBackup(String filePath) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final backupRepo = ref.read(backupRepositoryProvider);
      await backupRepo.restoreBackup(filePath);
      return BackupState(
        lastBackupPath: filePath,
        lastBackupDate: DateTime.now(),
        message: 'Backup restored successfully',
      );
    });
  }

  Future<void> shareBackup() async {
    final currentState = state.valueOrNull;
    if (currentState?.lastBackupPath == null) return;
    // Will be implemented in UI using share_plus
  }
}