import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/empty_state.dart';
import '../providers/reports_provider.dart';
import '../../../../domain/usecases/report_use_cases.dart';

/// Provider that fetches driver earnings for a date range.
final driverEarningReportProvider =
    FutureProvider.autoDispose.family<List<DriverEarningSummary>,
        ({DateTime start, DateTime end})>((ref, range) async {
  final useCases = ref.watch(reportUseCasesProvider);
  return await useCases.getDriverEarnings(
    start: range.start,
    end: range.end,
  );
});

class DriverEarningReportScreen extends ConsumerStatefulWidget {
  const DriverEarningReportScreen({super.key});

  @override
  ConsumerState<DriverEarningReportScreen> createState() =>
      _DriverEarningReportScreenState();
}

class _DriverEarningReportScreenState
    extends ConsumerState<DriverEarningReportScreen> {
  late DateTimeRange _selectedRange;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedRange = DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: now,
    );
  }

  Future<void> _pickRange() async {
    final range = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (range != null) {
      setState(() => _selectedRange = range);
      ref.invalidate(driverEarningReportProvider(
        (start: _selectedRange.start, end: _selectedRange.end),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(driverEarningReportProvider(
      (start: _selectedRange.start, end: _selectedRange.end),
    ));
    final loc = context.loc;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc['driver_earnings']),
      ),
      body: Column(
        children: [
          // Date range selector
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.date_range),
                title: Text(
                  '${AppDateUtils.formatDisplay(_selectedRange.start)} → ${AppDateUtils.formatDisplay(_selectedRange.end)}',
                  style: AppTextStyles.bodyLarge,
                ),
                trailing: const Icon(Icons.edit_calendar),
                onTap: _pickRange,
              ),
            ),
          ),

          Expanded(
            child: reportAsync.when(
              data: (list) {
                if (list.isEmpty) {
                  return EmptyState(message: loc['no_data']);
                }
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 16.h),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return _DriverEarningTile(item: item);
                  },
                );
              },
              loading: () => const LoadingIndicator(),
              error: (err, _) => Center(
                child: Text('${loc['error']}: $err'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverEarningTile extends StatelessWidget {
  final DriverEarningSummary item;
  const _DriverEarningTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        title: Text(item.driverName, style: AppTextStyles.bodyLarge),
        subtitle: Text(
          '${loc['total_trips']}: ${item.tripCount}',
          style: AppTextStyles.bodySmall,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'PKR ${item.totalEarnings.toStringAsFixed(0)}',
              style: AppTextStyles.amountSmall,
            ),
            Text(
              '${loc['paid_amount']}: PKR ${item.totalPaid.toStringAsFixed(0)}',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}