import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../data/repositories/trip_repository_impl.dart';
import '../../../../domain/entities/trip.dart';
import '../../../../domain/usecases/trip_use_cases.dart';
import '../widgets/payment_status_chip.dart';

/// Provider for the trip list, scoped to this screen.
final _tripListProvider =
    FutureProvider.autoDispose<List<Trip>>((ref) async {
  final repo = ref.watch(tripRepositoryProvider);
  final useCases = TripUseCases(repo);
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day); // today
  final end = start.add(const Duration(days: 1)).subtract(const Duration(seconds: 1));
  return await useCases.getTripsByDateRange(start, end);
});

class TripListScreen extends ConsumerWidget {
  const TripListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(_tripListProvider);
    final loc = context.loc;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc['trips']),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show date range filter – for simplicity, we'll just refresh.
              ref.invalidate(_tripListProvider);
            },
          ),
        ],
      ),
      body: tripsAsync.when(
        data: (trips) {
          if (trips.isEmpty) {
            return EmptyState(
              message: loc['no_data'],
              actionLabel: loc['new_trip'],
              onAction: () => Navigator.pushNamed(context, AppRoutes.tripEntry),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(_tripListProvider),
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 80.h),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return _TripTile(trip: trip);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('${loc['error']}: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.tripEntry),
        icon: const Icon(Icons.add),
        label: Text(loc['new_trip']),
      ),
    );
  }
}

class _TripTile extends StatelessWidget {
  final Trip trip;
  const _TripTile({required this.trip});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final dateStr =
        '${trip.tripDate.day}/${trip.tripDate.month}/${trip.tripDate.year}';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: CircleAvatar(
          backgroundColor: trip.isFullyPaid
              ? Colors.green.shade100
              : Colors.orange.shade100,
          child: Icon(
            trip.isFullyPaid ? Icons.check_circle : Icons.warning_amber,
            color: trip.isFullyPaid ? Colors.green : Colors.orange,
          ),
        ),
        title: Text(
          '${loc['trip']} #${trip.id} - $dateStr',
          style: AppTextStyles.bodyLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${loc['quantity']}: ${trip.quantity}  |  PKR ${trip.totalAmount.toStringAsFixed(0)}',
              style: AppTextStyles.bodySmall,
            ),
            SizedBox(height: 4.h),
            PaymentStatusChip(
              isFullyPaid: trip.isFullyPaid,
              paid: trip.paidAmount,
              total: trip.totalAmount,
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
              loc['paid_amount'],
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}