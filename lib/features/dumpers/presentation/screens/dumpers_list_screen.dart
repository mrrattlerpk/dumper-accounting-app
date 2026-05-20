import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/search_bar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/routes/app_router.dart';
import '../providers/dumpers_provider.dart';

class DumpersListScreen extends ConsumerStatefulWidget {
  const DumpersListScreen({super.key});

  @override
  ConsumerState<DumpersListScreen> createState() => _DumpersListScreenState();
}

class _DumpersListScreenState extends ConsumerState<DumpersListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dumpersAsync = ref.watch(dumpersProvider);
    final loc = context.loc;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc['dumpers']),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(dumpersProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          AppSearchBar(
            hintText: loc['search'],
            controller: _searchController,
            onChanged: (query) =>
                ref.read(dumpersProvider.notifier).search(query),
            onClear: () =>
                ref.read(dumpersProvider.notifier).search(''),
          ),
          Expanded(
            child: dumpersAsync.when(
              data: (state) {
                if (state.dumpers.isEmpty) {
                  return EmptyState(
                    message: loc['no_data'],
                    actionLabel: loc['add_dumper'],
                    onAction: () =>
                        Navigator.pushNamed(context, AppRoutes.dumperForm),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.read(dumpersProvider.notifier).refresh(),
                  child: ListView.builder(
                    itemCount: state.dumpers.length,
                    padding: EdgeInsets.only(bottom: 80.h),
                    itemBuilder: (context, index) {
                      final dumper = state.dumpers[index];
                      return _DumperTile(dumper: dumper);
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
        onPressed: () => Navigator.pushNamed(context, AppRoutes.dumperForm),
        icon: const Icon(Icons.add),
        label: Text(loc['add_dumper']),
      ),
    );
  }
}

class _DumperTile extends StatelessWidget {
  final dynamic dumper;
  const _DumperTile({required this.dumper});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.fire_truck,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(dumper.registrationNumber, style: AppTextStyles.bodyLarge),
        subtitle: Text(
          '${dumper.model}${dumper.ownerName != null ? ' • ${dumper.ownerName}' : ''}',
          style: AppTextStyles.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              dumper.isActive ? Icons.check_circle : Icons.cancel,
              size: 18.sp,
              color: dumper.isActive ? Colors.green : Colors.grey,
            ),
            SizedBox(width: 4.w),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () {
          // Navigate to dumper ledger or edit
          Navigator.pushNamed(
            context,
            AppRoutes.dumperLedger,
            arguments: dumper.id,
          );
        },
      ),
    );
  }
}