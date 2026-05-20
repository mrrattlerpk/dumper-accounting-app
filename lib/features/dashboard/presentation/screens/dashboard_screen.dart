import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/routes/app_router.dart';
import '../providers/dashboard_provider.dart';

/// Main dashboard screen showing business overview.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final loc = context.loc;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc['dashboard']),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(dashboardProvider.notifier).refresh(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
        child: dashboardAsync.when(
          data: (state) => _DashboardContent(state: state),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    '${loc['error']}: $err',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton.icon(
                    onPressed: () => ref.read(dashboardProvider.notifier).refresh(),
                    icon: const Icon(Icons.refresh),
                    label: Text(loc['retry']),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final DashboardState state;
  const _DashboardContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats cards
          _StatsGrid(state: state),
          SizedBox(height: 24.h),
          // Quick actions
          _QuickActionsSection(),
          SizedBox(height: 24.h),
          // Recent activity
          _RecentActivitySection(trips: state.recentTrips),
          // Extra space for bottom navigation
          SizedBox(height: 80.h),
        ],
      ),
    );
  }
}

// --------------- Stats Grid ---------------
class _StatsGrid extends StatelessWidget {
  final DashboardState state;
  const _StatsGrid({required this.state});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      childAspectRatio: 1.3,
      children: [
        _StatsCard(
          title: loc['total_trips'],
          value: state.totalTrips.toString(),
          icon: Icons.local_shipping,
          color: Colors.blue,
        ),
        _StatsCard(
          title: loc['total_earnings'],
          value: 'PKR ${state.totalEarnings.toStringAsFixed(0)}',
          icon: Icons.attach_money,
          color: Colors.green,
        ),
        _StatsCard(
          title: loc['pending_payments'],
          value: 'PKR ${state.pendingPayments.toStringAsFixed(0)}',
          icon: Icons.pending_actions,
          color: Colors.orange,
        ),
        _StatsCard(
          title: loc['drivers'],
          value: state.totalDrivers.toString(),
          icon: Icons.person,
          color: Colors.purple,
        ),
        _StatsCard(
          title: loc['dumpers'],
          value: state.totalDumpers.toString(),
          icon: Icons.fire_truck,
          color: Colors.teal,
        ),
        _StatsCard(
          title: loc['customers'],
          value: state.totalCustomers.toString(),
          icon: Icons.business,
          color: Colors.indigo,
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _StatsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28.sp, color: color),
            SizedBox(height: 8.h),
            Text(
              value,
              style: AppTextStyles.amountLarge.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// --------------- Quick Actions ---------------
class _QuickActionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Text(
            loc['quick_actions'],
            style: AppTextStyles.headlineSmall,
          ),
        ),
        Row(
          children: [
            _ActionChip(
              label: loc['new_trip'],
              icon: Icons.add_road,
              onTap: () => Navigator.pushNamed(context, AppRoutes.tripEntry),
            ),
            SizedBox(width: 8.w),
            _ActionChip(
              label: loc['add_driver'],
              icon: Icons.person_add,
              onTap: () => Navigator.pushNamed(context, AppRoutes.driverForm),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            _ActionChip(
              label: loc['add_dumper'],
              icon: Icons.fire_truck,
              onTap: () => Navigator.pushNamed(context, AppRoutes.dumperForm),
            ),
            SizedBox(width: 8.w),
            _ActionChip(
              label: loc['add_customer'],
              icon: Icons.business,
              onTap: () => Navigator.pushNamed(context, AppRoutes.customerForm),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 56.h,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: 22.sp),
          label: Text(
            label,
            overflow: TextOverflow.ellipsis,
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
          ),
        ),
      ),
    );
  }
}

// --------------- Recent Activity ---------------
class _RecentActivitySection extends StatelessWidget {
  final List trips;
  const _RecentActivitySection({required this.trips});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Text(
            loc['recent_activity'],
            style: AppTextStyles.headlineSmall,
          ),
        ),
        if (trips.isEmpty)
          Card(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Center(
                child: Text(
                  loc['no_data'],
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            ),
          )
        else
          ...trips.map((trip) => _RecentTripTile(trip: trip)),
      ],
    );
  }
}

class _RecentTripTile extends StatelessWidget {
  final trip;
  const _RecentTripTile({required this.trip});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final date = '${trip.tripDate.day}/${trip.tripDate.month}/${trip.tripDate.year}';
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: CircleAvatar(
          backgroundColor: trip.isFullyPaid ? Colors.green.shade100 : Colors.orange.shade100,
          child: Icon(
            trip.isFullyPaid ? Icons.check_circle : Icons.warning_amber_rounded,
            color: trip.isFullyPaid ? Colors.green : Colors.orange,
          ),
        ),
        title: Text(
          '${loc['trip']} #${trip.id} - $date',
          style: AppTextStyles.bodyLarge,
        ),
        subtitle: Text(
          '${loc['quantity']}: ${trip.quantity} | PKR ${trip.totalAmount.toStringAsFixed(0)}',
          style: AppTextStyles.bodySmall,
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
                fontSize: 11.sp,
                color: trip.isFullyPaid ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}