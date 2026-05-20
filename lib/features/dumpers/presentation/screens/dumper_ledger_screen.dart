import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../data/repositories/dumper_repository_impl.dart';
import '../../../../data/repositories/trip_repository_impl.dart';
import '../../../../domain/entities/dumper.dart';
import '../../../../domain/entities/trip.dart';
import '../../../../domain/usecases/trip_use_cases.dart';

/// Displays a dumper's full ledger – all trips, earnings, paid, pending.
class DumperLedgerScreen extends ConsumerStatefulWidget {
  final int dumperId;

  const DumperLedgerScreen({super.key, required this.dumperId});

  @override
  ConsumerState<DumperLedgerScreen> createState() =>
      _DumperLedgerScreenState();
}

class _DumperLedgerScreenState extends ConsumerState<DumperLedgerScreen> {
  Dumper? _dumper;
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
      final dumperRepo = ref.read(dumperRepositoryProvider);
      final tripRepo = ref.read(tripRepositoryProvider);
      final tripUseCases = TripUseCases(tripRepo);

      _dumper = await dumperRepo.getDumperById(widget.dumperId);
      _trips = await tripUseCases.getTripsByDumper(widget.dumperId);
      _trips.sort((a, b) => b.tripDate.compareTo(a.tripDate));

      _totalEarnings = _trips.fold(0.0, (sum, t) => sum + t.totalAmount);
      _totalPaid = _trips.fold(0.0, (sum, t) => sum + t.paidAmount);
      _totalPending = _trips.fold(0.0, (sum, t) => sum + t.remaining);
    } catch (e) {
      // ignore, remain default
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final dumperName = _dumper?.registrationNumber ?? loc['ledger'];

    return Scaffold(
      appBar: AppBar(
        title: Text(dumperName),
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : Column(
              children: [
                if (_dumper != null)
                  _SummaryCard(
                    title: dumperName,
                    model: _dumper!.model,
                    totalEarnings: _totalEarnings,
                    totalPaid: _totalPaid,
                    totalPending: _totalPending,
                    tripCount: _trips.length,
                  ),
                SizedBox(height: 8.h),
                Expanded(
                  child: _trips.isEmpty
                      ? Center(child: Text(loc['no_data']))
                      : ListView.builder(
                          padding: EdgeInsets.only(bottom: 16.h),
                          itemCount: _trips.length,
                          itemBuilder: (context, index) =>
                              _TripLedgerTile(trip: _trips[index]),
                        ),
                ),
              ],
            ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String model;
  final double totalEarnings;
  final double totalPaid;
  final double totalPending;
  final int tripCount;

  const _SummaryCard({
    required this.title,
    required this.model,
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
            Text(title, style: AppTextStyles.headlineSmall),
            Text(model, style: AppTextStyles.bodySmall),
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