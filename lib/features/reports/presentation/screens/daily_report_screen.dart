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

/// Future provider that fetches a daily report for the selected date.
final dailyReportProvider =
    FutureProvider.autoDispose.family<DailyReportSummary, DateTime>(
        (ref, date) async {
  final useCases = ref.watch(reportUseCasesProvider);
  return await useCases.getDailyReport(date);
});

class DailyReportScreen extends ConsumerStatefulWidget {
  const DailyReportScreen({super.key});

  @override
  ConsumerState<DailyReportScreen> createState() => _DailyReportScreenState();
}

class _DailyReportScreenState extends ConsumerState<DailyReportScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
      // Invalidate the provider to refresh with new date
      ref.invalidate(dailyReportProvider(_selectedDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(dailyReportProvider(_selectedDate));
    final loc = context.loc;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc['daily_report']),
      ),
      body: Column(
        children: [
          // Date selector
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  AppDateUtils.formatDisplay(_selectedDate),
                  style: AppTextStyles.headlineSmall,
                ),
                trailing: const Icon(Icons.edit_calendar),
                onTap: _pickDate,
              ),
            ),
          ),

          // Report content
          Expanded(
            child: reportAsync.when(
              data: (report) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    children: [
                      _SummaryCards(report: report),
                      SizedBox(height: 24.h),
                      // Placeholder for trip list for this date
                      // In a full implementation we'd load trips list too.
                      Text(
                        '${loc['total_trips']}: ${report.tripCount}',
                        style: AppTextStyles.bodyLarge,
                      ),
                    ],
                  ),
                );
              },
              loading: () => const LoadingIndicator(),
              error: (err, _) => Center(
                child: Text(
                  '${loc['error']}: $err',
                  style: AppTextStyles.bodyLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  final DailyReportSummary report;
  const _SummaryCards({required this.report});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: loc['total_earnings'],
            value: 'PKR ${report.totalEarnings.toStringAsFixed(0)}',
            color: Colors.green,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatCard(
            label: loc['paid_amount'],
            value: 'PKR ${report.totalPaid.toStringAsFixed(0)}',
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatCard(
            label: loc['pending'],
            value: 'PKR ${report.totalPending.toStringAsFixed(0)}',
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.amountSmall.copyWith(color: color),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}