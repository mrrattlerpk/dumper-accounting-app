# Dumper Accounting App

Offline-first accounting and trip management system for dumper/truck businesses in Pakistan.

## Features
- Dashboard with key metrics
- Driver, Dumper, Customer, Material CRUD
- Optimized one-hand trip entry with auto calculations
- Ledger views for drivers and dumpers
- Reports: Daily, Driver Earnings, Customer Dues, Cash Flow
- PDF and CSV export (A4, A5, Letter, Legal)
- Local backup/restore with ZIP support
- Urdu and English localization with runtime switching

## Tech Stack
- Flutter (latest stable)
- Isar Database
- Riverpod state management
- Clean Architecture (domain, data, features)

## Getting Started

### Prerequisites
- Flutter SDK >=3.13.0
- Dart SDK >=3.1.0

### Setup
1. Clone the repository
2. Run `flutter pub get`
3. Generate Isar code: `dart run build_runner build --delete-conflicting-outputs`
4. Add `NotoNastaliqUrdu.ttf` font file to `assets/fonts/` (optional, for Urdu PDF)
5. Run the app: `flutter run`

### Build APK

flutter build apk --release



## Project Structure
- `lib/core/` - Cross-cutting concerns, theme, localization, DI, utilities
- `lib/data/` - Isar models, database providers, repository implementations
- `lib/domain/` - Entities, repository interfaces, use cases
- `lib/features/` - Feature modules (dashboard, drivers, dumpers, etc.)
- `assets/locales/` - JSON localization files

## License
Proprietary - All Rights ReservedThe application structure is now complete with all core files. If you need any additional file or modifications, please let me know.

