import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection_container.dart';
import '../../data/models/settings.dart';
import '../../domain/entities/settings.dart' as entity;
import '../../domain/repositories/settings_repository.dart';

/// Riverpod provider for SettingsRepository.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final isar = ref.watch(isarInstanceProvider);
  return SettingsRepositoryImpl(isar);
});

class SettingsRepositoryImpl implements SettingsRepository {
  final Isar _isar;

  SettingsRepositoryImpl(this._isar);

  entity.AppSettings _toEntity(Settings s) => entity.AppSettings(
        id: s.id,
        languageCode: s.languageCode,
        pdfPageSize: s.pdfPageSize,
        autoBackupIntervalHours: s.autoBackupIntervalHours,
        lastAutoBackupAt: s.lastAutoBackupAt,
        businessName: s.businessName,
        businessPhone: s.businessPhone,
        businessAddress: s.businessAddress,
        updatedAt: s.updatedAt,
      );

  Future<Settings> _getOrCreateModel() async {
    return await Settings.getOrCreate(_isar);
  }

  @override
  Future<entity.AppSettings> getSettings() async {
    final model = await _getOrCreateModel();
    return _toEntity(model);
  }

  @override
  Future<void> updateSettings(entity.AppSettings settings) async {
    final model = await _getOrCreateModel();
    model.languageCode = settings.languageCode;
    model.pdfPageSize = settings.pdfPageSize;
    model.autoBackupIntervalHours = settings.autoBackupIntervalHours;
    model.lastAutoBackupAt = settings.lastAutoBackupAt;
    model.businessName = settings.businessName;
    model.businessPhone = settings.businessPhone;
    model.businessAddress = settings.businessAddress;
    model.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.settings.put(model);
    });
  }

  @override
  Future<void> updateLanguage(String languageCode) async {
    final model = await _getOrCreateModel();
    model.languageCode = languageCode;
    model.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.settings.put(model);
    });
  }

  @override
  Future<void> updatePdfPageSize(String pageSize) async {
    final model = await _getOrCreateModel();
    model.pdfPageSize = pageSize;
    model.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.settings.put(model);
    });
  }

  @override
  Future<void> updateAutoBackupInterval(int hours) async {
    final model = await _getOrCreateModel();
    model.autoBackupIntervalHours = hours;
    model.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.settings.put(model);
    });
  }
}