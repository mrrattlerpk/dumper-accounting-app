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

/// Provider that fetches cash flow entries for a date range.
final cashFlowReportProvider =
    FutureProvider.autoDispose.family<List<CashFlowEntry>,
        ({DateTime start, DateTime end})>((ref, range) async {
  final useCases = ref.watch(reportUseCasesProvider);
  return await useCases.getCashFlow(start: range.start, end: range.end);
});

class CashFlowReportScreen extends ConsumerStatefulWidget {
  const CashFlowReportScreen({super.key});

  @override
  ConsumerState<CashFlowReportScreen> createState() =>
      _CashFlowReportScreenState();
}

class _CashFlowReportScreenState
    extends ConsumerState<CashFlowReportScreen> {
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
      ref.invalidate(cashFlowReportProvider(
        (start: _selectedRange.start, end: _selectedRange.end),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(cashFlowReportProvider(
      (start: _selectedRange.start, end: _selectedRange.end),
    ));
    final loc = context.loc;

    double totalCashIn = 0.0;

    return Scaffold(
      appBar: AppBar(title: Text(loc['cash_flow'])),
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

          // Total cash in
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc['total_earnings'] + ' (${loc['paid_amount']})',
                      style: AppTextStyles.headlineSmall,
                    ),
                    Text(
                      'PKR ${totalCashIn.toStringAsFixed(0)}',
                      style: AppTextStyles.amountLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // List of cash flow days
          Expanded(
            child: reportAsync.when(
              data: (list) {
                if (list.isEmpty) {
                  return EmptyState(message: loc['no_data']);
                }
                totalCashIn = list.fold(0.0, (sum, e) => sum + e.amountReceived);
                return ListView.builder(
                  padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final entry = list[index];
                    return _CashFlowTile(entry: entry);
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

class _CashFlowTile extends StatelessWidget {
  final CashFlowEntry entry;
  const _CashFlowTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: const Icon(Icons.arrow_downward, color: Colors.green),
        title: Text(
          AppDateUtils.formatDisplay(entry.date),
          style: AppTextStyles.bodyLarge,
        ),
        trailing: Text(
          'PKR ${entry.amountReceived.toStringAsFixed(0)}',
          style: AppTextStyles.amountSmall.copyWith(fontSize: 18.sp),
        ),
      ),
    );
  }
}