import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/empty_state.dart';
import '../providers/reports_provider.dart';
import '../../../../domain/usecases/report_use_cases.dart';

/// Provider that fetches customer dues summary.
final customerDueReportProvider =
    FutureProvider.autoDispose<List<CustomerDueSummary>>((ref) async {
  final useCases = ref.watch(reportUseCasesProvider);
  return await useCases.getCustomerDues();
});

class CustomerDueReportScreen extends ConsumerWidget {
  const CustomerDueReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(customerDueReportProvider);
    final loc = context.loc;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc['customer_dues']),
      ),
      body: reportAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return EmptyState(message: loc['no_data']);
          }
          return ListView.builder(
            padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return _CustomerDueTile(item: item);
            },
          );
        },
        loading: () => const LoadingIndicator(),
        error: (err, _) => Center(
          child: Text('${loc['error']}: $err', style: AppTextStyles.bodyLarge),
        ),
      ),
    );
  }
}

class _CustomerDueTile extends StatelessWidget {
  final CustomerDueSummary item;
  const _CustomerDueTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        title: Text(item.customerName, style: AppTextStyles.bodyLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${loc['opening_balance']}: PKR ${item.openingBalance.toStringAsFixed(0)}',
              style: AppTextStyles.bodySmall,
            ),
            Row(
              children: [
                Text(
                  '${loc['total_earnings']}: PKR ${item.totalBilled.toStringAsFixed(0)}',
                  style: AppTextStyles.bodySmall,
                ),
                SizedBox(width: 16.w),
                Text(
                  '${loc['paid_amount']}: PKR ${item.totalPaid.toStringAsFixed(0)}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'PKR ${item.currentDue.toStringAsFixed(0)}',
              style: TextStyle(
                color: item.currentDue > 0 ? Colors.red : Colors.green,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
            Text(
              loc['remaining'],
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}