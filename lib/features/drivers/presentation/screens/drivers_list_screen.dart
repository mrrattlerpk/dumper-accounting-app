import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/search_bar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/routes/app_router.dart';
import '../providers/drivers_provider.dart';

class DriversListScreen extends ConsumerStatefulWidget {
  const DriversListScreen({super.key});

  @override
  ConsumerState<DriversListScreen> createState() => _DriversListScreenState();
}

class _DriversListScreenState extends ConsumerState<DriversListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final driversAsync = ref.watch(driversProvider);
    final loc = context.loc;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc['drivers']),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(driversProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          AppSearchBar(
            hintText: loc['search'],
            controller: _searchController,
            onChanged: (query) =>
                ref.read(driversProvider.notifier).search(query),
            onClear: () =>
                ref.read(driversProvider.notifier).search(''),
          ),
          Expanded(
            child: driversAsync.when(
              data: (state) {
                if (state.drivers.isEmpty) {
                  return EmptyState(
                    message: loc['no_data'],
                    actionLabel: loc['add_driver'],
                    onAction: () =>
                        Navigator.pushNamed(context, AppRoutes.driverForm),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.read(driversProvider.notifier).refresh(),
                  child: ListView.builder(
                    itemCount: state.drivers.length,
                    padding: EdgeInsets.only(bottom: 80.h),
                    itemBuilder: (context, index) {
                      final driver = state.drivers[index];
                      return _DriverTile(
                        driver: driver,
                        onTap: () {
                          // Navigate to driver ledger or details
                        },
                      );
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
        onPressed: () => Navigator.pushNamed(context, AppRoutes.driverForm),
        icon: const Icon(Icons.add),
        label: Text(loc['add_driver']),
      ),
    );
  }
}

class _DriverTile extends StatelessWidget {
  final dynamic driver;
  final VoidCallback onTap;

  const _DriverTile({required this.driver, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            driver.name[0].toUpperCase(),
            style: AppTextStyles.bodyLarge,
          ),
        ),
        title: Text(driver.name, style: AppTextStyles.bodyLarge),
        subtitle: Text(driver.phone, style: AppTextStyles.bodySmall),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}