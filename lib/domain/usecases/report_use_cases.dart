import '../entities/trip.dart';
import '../repositories/trip_repository.dart';
import '../repositories/driver_repository.dart';
import '../repositories/customer_repository.dart';

// -------------------------------------------------------------
// Simple DTOs for report summaries (no external dependencies)
// -------------------------------------------------------------

/// Summary of earnings/expenses for a given day.
class DailyReportSummary {
  final DateTime date;
  final int tripCount;
  final double totalEarnings;
  final double totalPaid;
  final double totalPending;

  const DailyReportSummary({
    required this.date,
    required this.tripCount,
    required this.totalEarnings,
    required this.totalPaid,
    required this.totalPending,
  });
}

/// Earnings summary per driver over a date range.
class DriverEarningSummary {
  final int driverId;
  final String driverName;
  final int tripCount;
  final double totalEarnings;
  final double totalPaid;
  final double totalPending;

  const DriverEarningSummary({
    required this.driverId,
    required this.driverName,
    required this.tripCount,
    required this.totalEarnings,
    required this.totalPaid,
    required this.totalPending,
  });
}

/// Dues summary per customer.
class CustomerDueSummary {
  final int customerId;
  final String customerName;
  final double openingBalance;
  final double totalBilled;
  final double totalPaid;
  final double currentDue;

  const CustomerDueSummary({
    required this.customerId,
    required this.customerName,
    required this.openingBalance,
    required this.totalBilled,
    required this.totalPaid,
    required this.currentDue,
  });
}

/// Cash flow entry for a day (income).
class CashFlowEntry {
  final DateTime date;
  final double amountReceived;

  const CashFlowEntry({
    required this.date,
    required this.amountReceived,
  });
}

/// Encapsulates all report generation logic.
class ReportUseCases {
  final TripRepository _tripRepo;
  final DriverRepository _driverRepo;
  final CustomerRepository _customerRepo;

  ReportUseCases(
    this._tripRepo,
    this._driverRepo,
    this._customerRepo,
  );

  /// Generate a daily report for a specific date.
  Future<DailyReportSummary> getDailyReport(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    final trips = await _tripRepo.getTripsByDateRange(start, end);

    final earnings = trips.fold<double>(0, (sum, t) => sum + t.totalAmount);
    final paid = trips.fold<double>(0, (sum, t) => sum + t.paidAmount);
    final pending = trips.fold<double>(0, (sum, t) => sum + t.remaining);

    return DailyReportSummary(
      date: date,
      tripCount: trips.length,
      totalEarnings: earnings,
      totalPaid: paid,
      totalPending: pending,
    );
  }

  /// Driver earnings summary for a date range.
  Future<List<DriverEarningSummary>> getDriverEarnings({
    required DateTime start,
    required DateTime end,
  }) async {
    final trips = await _tripRepo.getTripsByDateRange(start, end);
    final driverIds = trips.map((t) => t.driverId).toSet();

    final result = <DriverEarningSummary>[];
    for (final id in driverIds) {
      final driver = await _driverRepo.getDriverById(id);
      final driverTrips = trips.where((t) => t.driverId == id).toList();
      final earnings = driverTrips.fold<double>(0, (sum, t) => sum + t.totalAmount);
      final paid = driverTrips.fold<double>(0, (sum, t) => sum + t.paidAmount);
      final pending = driverTrips.fold<double>(0, (sum, t) => sum + t.remaining);

      result.add(DriverEarningSummary(
        driverId: id,
        driverName: driver?.name ?? 'Unknown',
        tripCount: driverTrips.length,
        totalEarnings: earnings,
        totalPaid: paid,
        totalPending: pending,
      ));
    }

    result.sort((a, b) => b.totalEarnings.compareTo(a.totalEarnings));
    return result;
  }

  /// Customer dues summary (all customers).
  Future<List<CustomerDueSummary>> getCustomerDues() async {
    final customers = await _customerRepo.getAllCustomers();
    final result = <CustomerDueSummary>[];

    for (final customer in customers) {
      final customerTrips = await _tripRepo.getTripsByCustomer(customer.id!);
      final totalBilled = customerTrips.fold<double>(0, (sum, t) => sum + t.totalAmount);
      final totalPaid = customerTrips.fold<double>(0, (sum, t) => sum + t.paidAmount);
      final currentDue = customer.openingBalance + totalBilled - totalPaid;

      result.add(CustomerDueSummary(
        customerId: customer.id!,
        customerName: customer.name,
        openingBalance: customer.openingBalance,
        totalBilled: totalBilled,
        totalPaid: totalPaid,
        currentDue: currentDue,
      ));
    }

    result.sort((a, b) => b.currentDue.compareTo(a.currentDue));
    return result;
  }

  /// Cash flow (paid amounts) grouped by day over a date range.
  Future<List<CashFlowEntry>> getCashFlow({
    required DateTime start,
    required DateTime end,
  }) async {
    final trips = await _tripRepo.getTripsByDateRange(start, end);
    final Map<String, double> dailyPayments = {};

    for (final trip in trips) {
      final dateKey = DateTime(trip.tripDate.year, trip.tripDate.month, trip.tripDate.day).toIso8601String();
      dailyPayments[dateKey] = (dailyPayments[dateKey] ?? 0) + trip.paidAmount;
    }

    final entries = dailyPayments.entries.map((e) => CashFlowEntry(
          date: DateTime.parse(e.key),
          amountReceived: e.value,
        )).toList();

    entries.sort((a, b) => a.date.compareTo(b.date));
    return entries;
  }

  /// Ledger for a specific entity (driver/dumper/customer) over all time.
  /// Returns all trips for that entity sorted by date.
  Future<List<Trip>> getEntityLedger({
    int? driverId,
    int? dumperId,
    int? customerId,
  }) async {
    if (driverId != null) {
      final trips = await _tripRepo.getTripsByDriver(driverId);
      trips.sort((a, b) => b.tripDate.compareTo(a.tripDate));
      return trips;
    } else if (dumperId != null) {
      final trips = await _tripRepo.getTripsByDumper(dumperId);
      trips.sort((a, b) => b.tripDate.compareTo(a.tripDate));
      return trips;
    } else if (customerId != null) {
      final trips = await _tripRepo.getTripsByCustomer(customerId);
      trips.sort((a, b) => b.tripDate.compareTo(a.tripDate));
      return trips;
    }
    throw ArgumentError('At least one entity ID must be provided.');
  }
}