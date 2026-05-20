/// Plain entity representing application settings.
class AppSettings {
  final int? id;
  final String languageCode;
  final String pdfPageSize;
  final int autoBackupIntervalHours;
  final DateTime? lastAutoBackupAt;
  final String? businessName;
  final String? businessPhone;
  final String? businessAddress;
  final DateTime updatedAt;

  const AppSettings({
    this.id,
    this.languageCode = 'en',
    this.pdfPageSize = 'A4',
    this.autoBackupIntervalHours = 24,
    this.lastAutoBackupAt,
    this.businessName,
    this.businessPhone,
    this.businessAddress,
    required this.updatedAt,
  });

  AppSettings copyWith({
    int? id,
    String? languageCode,
    String? pdfPageSize,
    int? autoBackupIntervalHours,
    DateTime? lastAutoBackupAt,
    String? businessName,
    String? businessPhone,
    String? businessAddress,
    DateTime? updatedAt,
  }) {
    return AppSettings(
      id: id ?? this.id,
      languageCode: languageCode ?? this.languageCode,
      pdfPageSize: pdfPageSize ?? this.pdfPageSize,
      autoBackupIntervalHours: autoBackupIntervalHours ?? this.autoBackupIntervalHours,
      lastAutoBackupAt: lastAutoBackupAt ?? this.lastAutoBackupAt,
      businessName: businessName ?? this.businessName,
      businessPhone: businessPhone ?? this.businessPhone,
      businessAddress: businessAddress ?? this.businessAddress,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}