import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/search_bar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/routes/app_router.dart';
import '../providers/materials_provider.dart';

class MaterialsListScreen extends ConsumerStatefulWidget {
  const MaterialsListScreen({super.key});

  @override
  ConsumerState<MaterialsListScreen> createState() =>
      _MaterialsListScreenState();
}

class _MaterialsListScreenState extends ConsumerState<MaterialsListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final materialsAsync = ref.watch(materialsProvider);
    final loc = context.loc;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc['materials']),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(materialsProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          AppSearchBar(
            hintText: loc['search'],
            controller: _searchController,
            onChanged: (query) =>
                ref.read(materialsProvider.notifier).search(query),
            onClear: () => ref.read(materialsProvider.notifier).search(''),
          ),
          Expanded(
            child: materialsAsync.when(
              data: (state) {
                if (state.materials.isEmpty) {
                  return EmptyState(
                    message: loc['no_data'],
                    actionLabel: loc['add_material'],
                    onAction: () =>
                        Navigator.pushNamed(context, AppRoutes.materialForm),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.read(materialsProvider.notifier).refresh(),
                  child: ListView.builder(
                    itemCount: state.materials.length,
                    padding: EdgeInsets.only(bottom: 80.h),
                    itemBuilder: (context, index) {
                      final mat = state.materials[index];
                      return _MaterialTile(material: mat);
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
        onPressed: () => Navigator.pushNamed(context, AppRoutes.materialForm),
        icon: const Icon(Icons.add),
        label: Text(loc['add_material']),
      ),
    );
  }
}

class _MaterialTile extends StatelessWidget {
  final dynamic material;
  const _MaterialTile({required this.material});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(Icons.inventory_2,
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        title: Text(material.name, style: AppTextStyles.bodyLarge),
        subtitle: Row(
          children: [
            if (material.unit != null)
              Text('${material.unit} ', style: AppTextStyles.bodySmall),
            Text('PKR ${material.defaultRate.toStringAsFixed(2)}',
                style: AppTextStyles.bodySmall),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Optionally navigate to edit material
          Navigator.pushNamed(
            context,
            AppRoutes.materialForm,
            arguments: material,
          );
        },
      ),
    );
  }
}