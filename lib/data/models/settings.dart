import 'package:isar/isar.dart';

part 'settings.g.dart';

@collection
class Settings {
  Id id = Isar.autoIncrement;

  // Language preference: 'en' or 'ur'
  @Index()
  String languageCode = 'en';

  // PDF export settings
  String pdfPageSize = 'A4';      // 'A4', 'A5', 'Letter', 'Legal'

  // Backup settings
  int autoBackupIntervalHours = 24;  // 0 = disabled
  DateTime? lastAutoBackupAt;

  // Business defaults
  String? businessName;
  String? businessPhone;
  String? businessAddress;

  // Timestamp
  DateTime updatedAt = DateTime.now();

  /// Helper to ensure there's always a single settings entry.
  static Future<Settings> getOrCreate(Isar isar) async {
    final existing = await isar.settings.where().findFirst();
    if (existing != null) return existing;

    final settings = Settings();
    await isar.writeTxn(() => isar.settings.put(settings));
    return settings;
  }
}