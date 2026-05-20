import 'package:flutter/material.dart';

/// Centralized route names for navigation.
class AppRoutes {
  AppRoutes._();

  static const String dashboard = '/';
  static const String tripEntry = '/trip-entry';
  static const String tripList = '/trip-list';
  static const String driverList = '/driver-list';
  static const String driverForm = '/driver-form';
  static const String driverLedger = '/driver-ledger';
  static const String dumperList = '/dumper-list';
  static const String dumperForm = '/dumper-form';
  static const String dumperLedger = '/dumper-ledger';
  static const String customerList = '/customer-list';
  static const String customerForm = '/customer-form';
  static const String materialList = '/material-list';
  static const String materialForm = '/material-form';
  static const String dailyReport = '/report-daily';
  static const String driverEarningReport = '/report-driver-earning';
  static const String customerDueReport = '/report-customer-due';
  static const String cashFlowReport = '/report-cash-flow';
  static const String settings = '/settings';
  static const String backupRestore = '/backup-restore';

  /// Generates named routes map for MaterialApp.
  /// Placeholder: actual screens will be wired in later feature files.
  static Map<String, WidgetBuilder> get routes => {
        // Dashboard screen added via home: instead of route
        // tripEntry: (context) => const TripEntryScreen(),
        // ... etc
      };
}