import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/settings_repository_impl.dart';
import '../../../../domain/entities/settings.dart';

/// Provides current AppSettings and exposes update methods.
final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(
  () => SettingsNotifier(),
);

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    final repo = ref.read(settingsRepositoryProvider);
    return await repo.getSettings();
  }

  Future<void> updateSettings(AppSettings updated) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.updateSettings(updated);
    // Refresh state
    state = AsyncData(await repo.getSettings());
  }

  Future<void> updateLanguage(String languageCode) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.updateLanguage(languageCode);
    state = AsyncData(await repo.getSettings());
  }

  Future<void> updatePdfPageSize(String pageSize) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.updatePdfPageSize(pageSize);
    state = AsyncData(await repo.getSettings());
  }

  Future<void> updateAutoBackupInterval(int hours) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.updateAutoBackupInterval(hours);
    state = AsyncData(await repo.getSettings());
  }
}