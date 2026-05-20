import '../entities/settings.dart';

/// Abstract repository for AppSettings.
abstract class SettingsRepository {
  Future<AppSettings> getSettings();
  Future<void> updateSettings(AppSettings settings);
  Future<void> updateLanguage(String languageCode);
  Future<void> updatePdfPageSize(String pageSize);
  Future<void> updateAutoBackupInterval(int hours);
}