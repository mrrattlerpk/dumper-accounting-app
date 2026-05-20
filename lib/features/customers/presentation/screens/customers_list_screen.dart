import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/search_bar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/routes/app_router.dart';
import '../providers/customers_provider.dart';

class CustomersListScreen extends ConsumerStatefulWidget {
  const CustomersListScreen({super.key});

  @override
  ConsumerState<CustomersListScreen> createState() =>
      _CustomersListScreenState();
}

class _CustomersListScreenState extends ConsumerState<CustomersListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersProvider);
    final loc = context.loc;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc['customers']),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(customersProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          AppSearchBar(
            hintText: loc['search'],
            controller: _searchController,
            onChanged: (query) =>
                ref.read(customersProvider.notifier).search(query),
            onClear: () => ref.read(customersProvider.notifier).search(''),
          ),
          Expanded(
            child: customersAsync.when(
              data: (state) {
                if (state.customers.isEmpty) {
                  return EmptyState(
                    message: loc['no_data'],
                    actionLabel: loc['add_customer'],
                    onAction: () =>
                        Navigator.pushNamed(context, AppRoutes.customerForm),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.read(customersProvider.notifier).refresh(),
                  child: ListView.builder(
                    itemCount: state.customers.length,
                    padding: EdgeInsets.only(bottom: 80.h),
                    itemBuilder: (context, index) {
                      final customer = state.customers[index];
                      final due = state.dueMap[customer.id] ?? 0.0;
                      return _CustomerTile(customer: customer, due: due);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('${loc['error']}: $err'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.customerForm),
        icon: const Icon(Icons.add),
        label: Text(loc['add_customer']),
      ),
    );
  }
}

class _CustomerTile extends StatelessWidget {
  final dynamic customer;
  final double due;

  const _CustomerTile({required this.customer, required this.due});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: CircleAvatar(
          backgroundColor: due > 0 ? Colors.orange.shade100 : Colors.green.shade100,
          child: Icon(
            due > 0 ? Icons.pending : Icons.check_circle,
            color: due > 0 ? Colors.orange : Colors.green,
          ),
        ),
        title: Text(customer.name, style: AppTextStyles.bodyLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (customer.company != null && customer.company!.isNotEmpty)
              Text(customer.company!, style: AppTextStyles.bodySmall),
            if (customer.phone != null)
              Text(customer.phone!, style: AppTextStyles.bodySmall),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${loc['due']}: PKR ${due.toStringAsFixed(0)}',
              style: TextStyle(
                color: due > 0 ? Colors.red : Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
            const SizedBox(height: 4),
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
        onTap: () {
          // Optionally navigate to a customer ledger/details
        },
      ),
    );
  }
}