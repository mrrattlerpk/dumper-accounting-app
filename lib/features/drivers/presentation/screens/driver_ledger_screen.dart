import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../data/repositories/driver_repository_impl.dart';
import '../../../../data/repositories/trip_repository_impl.dart';
import '../../../../domain/entities/driver.dart';
import '../../../../domain/entities/trip.dart';
import '../../../../domain/usecases/trip_use_cases.dart';

/// Screen showing a driver's full ledger (all trips and summary).
class DriverLedgerScreen extends ConsumerStatefulWidget {
  final int driverId;

  const DriverLedgerScreen({super.key, required this.driverId});

  @override
  ConsumerState<DriverLedgerScreen> createState() =>
      _DriverLedgerScreenState();
}

class _DriverLedgerScreenState extends ConsumerState<DriverLedgerScreen> {
  Driver? _driver;
  List<Trip> _trips = [];
  double _totalEarnings = 0.0;
  double _totalPaid = 0.0;
  double _totalPending = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final driverRepo = ref.read(driverRepositoryProvider);
      final tripRepo = ref.read(tripRepositoryProvider);
      final tripUseCases = TripUseCases(tripRepo);

      _driver = await driverRepo.getDriverById(widget.driverId);
      _trips = await tripUseCases.getTripsByDriver(widget.driverId);
      _trips.sort((a, b) => b.tripDate.compareTo(a.tripDate));

      _totalEarnings = _trips.fold(0.0, (sum, t) => sum + t.totalAmount);
      _totalPaid = _trips.fold(0.0, (sum, t) => sum + t.paidAmount);
      _totalPending = _trips.fold(0.0, (sum, t) => sum + t.remaining);
    } catch (e) {
      // Handle error silently, state remains default
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Scaffold(
      appBar: AppBar(
        title: Text(_driver?.name ?? loc['ledger']),
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : Column(
              children: [
                // Summary card
                if (_driver != null) _SummaryCard(
                  driverName: _driver!.name,
                  totalEarnings: _totalEarnings,
                  totalPaid: _totalPaid,
                  totalPending: _totalPending,
                  tripCount: _trips.length,
                ),
                SizedBox(height: 8.h),
                // Trips list
                Expanded(
                  child: _trips.isEmpty
                      ? Center(child: Text(loc['no_data']))
                      : ListView.builder(
                          padding: EdgeInsets.only(bottom: 16.h),
                          itemCount: _trips.length,
                          itemBuilder: (context, index) {
                            final trip = _trips[index];
                            return _TripLedgerTile(trip: trip);
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String driverName;
  final double totalEarnings;
  final double totalPaid;
  final double totalPending;
  final int tripCount;

  const _SummaryCard({
    required this.driverName,
    required this.totalEarnings,
    required this.totalPaid,
    required this.totalPending,
    required this.tripCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12.w),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Text(driverName, style: AppTextStyles.headlineSmall),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: context.loc['total_earnings'],
                  value: 'PKR ${totalEarnings.toStringAsFixed(0)}',
                  color: Colors.green,
                ),
                _StatItem(
                  label: context.loc['paid_amount'],
                  value: 'PKR ${totalPaid.toStringAsFixed(0)}',
                  color: Colors.blue,
                ),
                _StatItem(
                  label: context.loc['pending'],
                  value: 'PKR ${totalPending.toStringAsFixed(0)}',
                  color: Colors.orange,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              '${context.loc['total_trips']}: $tripCount',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.amountSmall.copyWith(color: color)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _TripLedgerTile extends StatelessWidget {
  final Trip trip;
  const _TripLedgerTile({required this.trip});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final dateStr =
        '${trip.tripDate.day}/${trip.tripDate.month}/${trip.tripDate.year}';
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        title: Text(
          '${loc['trip']} #${trip.id} - $dateStr',
          style: AppTextStyles.bodyLarge,
        ),
        subtitle: Row(
          children: [
            Text(
              '${loc['quantity']}: ${trip.quantity}',
              style: AppTextStyles.bodySmall,
            ),
            SizedBox(width: 8.w),
            Text(
              'PKR ${trip.totalAmount.toStringAsFixed(0)}',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'PKR ${trip.paidAmount.toStringAsFixed(0)}',
              style: AppTextStyles.amountSmall,
            ),
            Text(
              trip.isFullyPaid ? loc['fully_paid'] : loc['unpaid'],
              style: TextStyle(
                color: trip.isFullyPaid ? Colors.green : Colors.red,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}