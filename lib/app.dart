import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/localization/app_localizations.dart';
import 'core/localization/locale_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/trips/presentation/screens/trip_entry_screen.dart';
import 'features/trips/presentation/screens/trip_list_screen.dart';
import 'features/drivers/presentation/screens/drivers_list_screen.dart';
import 'features/drivers/presentation/screens/driver_form_screen.dart';
import 'features/dumpers/presentation/screens/dumpers_list_screen.dart';
import 'features/dumpers/presentation/screens/dumper_form_screen.dart';
import 'features/customers/presentation/screens/customers_list_screen.dart';
import 'features/customers/presentation/screens/customer_form_screen.dart';
import 'features/materials/presentation/screens/materials_list_screen.dart';
import 'features/materials/presentation/screens/material_form_screen.dart';
import 'features/reports/presentation/screens/daily_report_screen.dart';
import 'features/reports/presentation/screens/driver_earning_report_screen.dart';
import 'features/reports/presentation/screens/customer_due_report_screen.dart';
import 'features/reports/presentation/screens/cash_flow_report_screen.dart';
import 'features/backup/presentation/screens/backup_restore_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'features/drivers/presentation/screens/driver_ledger_screen.dart';
import 'features/dumpers/presentation/screens/dumper_ledger_screen.dart';

/// The root widget of the application.
class DumperAccountingApp extends ConsumerWidget {
  const DumperAccountingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Dumper Accounting',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: locale,
          supportedLocales: const [
            Locale('en'),
            Locale('ur'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale != null && supportedLocales.contains(locale)) {
              return locale;
            }
            return const Locale('en');
          },
          // Named routes with onGenerateRoute for argument passing
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AppRoutes.dashboard:
                return MaterialPageRoute(
                    builder: (_) => const DashboardScreen());
              case AppRoutes.tripEntry:
                return MaterialPageRoute(
                    builder: (_) => const TripEntryScreen());
              case AppRoutes.tripList:
                return MaterialPageRoute(
                    builder: (_) => const TripListScreen());
              case AppRoutes.driverList:
                return MaterialPageRoute(
                    builder: (_) => const DriversListScreen());
              case AppRoutes.driverForm:
                final driver = settings.arguments;
                return MaterialPageRoute(
                    builder: (_) => DriverFormScreen(driver: driver));
              case AppRoutes.driverLedger:
                final driverId = settings.arguments as int;
                return MaterialPageRoute(
                    builder: (_) => DriverLedgerScreen(driverId: driverId));
              case AppRoutes.dumperList:
                return MaterialPageRoute(
                    builder: (_) => const DumpersListScreen());
              case AppRoutes.dumperForm:
                final dumper = settings.arguments;
                return MaterialPageRoute(
                    builder: (_) => DumperFormScreen(dumper: dumper));
              case AppRoutes.dumperLedger:
                final dumperId = settings.arguments as int;
                return MaterialPageRoute(
                    builder: (_) => DumperLedgerScreen(dumperId: dumperId));
              case AppRoutes.customerList:
                return MaterialPageRoute(
                    builder: (_) => const CustomersListScreen());
              case AppRoutes.customerForm:
                final customer = settings.arguments;
                return MaterialPageRoute(
                    builder: (_) => CustomerFormScreen(customer: customer));
              case AppRoutes.materialList:
                return MaterialPageRoute(
                    builder: (_) => const MaterialsListScreen());
              case AppRoutes.materialForm:
                final material = settings.arguments;
                return MaterialPageRoute(
                    builder: (_) => MaterialFormScreen(material: material));
              case AppRoutes.dailyReport:
                return MaterialPageRoute(
                    builder: (_) => const DailyReportScreen());
              case AppRoutes.driverEarningReport:
                return MaterialPageRoute(
                    builder: (_) => const DriverEarningReportScreen());
              case AppRoutes.customerDueReport:
                return MaterialPageRoute(
                    builder: (_) => const CustomerDueReportScreen());
              case AppRoutes.cashFlowReport:
                return MaterialPageRoute(
                    builder: (_) => const CashFlowReportScreen());
              case AppRoutes.backupRestore:
                return MaterialPageRoute(
                    builder: (_) => const BackupRestoreScreen());
              case AppRoutes.settings:
                return MaterialPageRoute(
                    builder: (_) => const SettingsScreen());
              default:
                return MaterialPageRoute(
                    builder: (_) => const DashboardScreen());
            }
          },
          // Initial route
          initialRoute: AppRoutes.dashboard,
          home: const DashboardScreen(), // fallback
        );
      },
    );
  }
}