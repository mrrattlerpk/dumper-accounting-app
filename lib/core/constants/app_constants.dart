/// Application-wide constants for business logic, UI, and formatting.
class AppConstants {
  AppConstants._();

  // --- Currency ---
  static const String currencySymbol = 'PKR';
  static const String currencyLocale = 'ur_PK';

  // --- Dates ---
  static const String dateFormatDisplay = 'dd MMM yyyy';
  static const String dateFormatApi = 'yyyy-MM-dd';

  // --- Page sizes for PDF ---
  static const List<String> pageSizes = ['A4', 'A5', 'Letter', 'Legal'];
  static const String defaultPageSize = 'A4';

  // --- Backup ---
  static const int defaultAutoBackupIntervalHours = 24;
  static const String backupFileExtension = '.zip';

  // --- UI ---
  static const double minTouchTarget = 48.0;
  static const double largeTouchTarget = 56.0;
  static const double inputFieldMinHeight = 52.0;

  // --- Limits ---
  static const int maxSearchResults = 50;
  static const int recentActivityCount = 5;

  // --- Material Units ---
  static const List<String> materialUnits = [
    'Ton',
    'Cubic Feet',
    'Trip',
    'Bag',
  ];
}