import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/customer_repository_impl.dart';
import '../../../../domain/entities/customer.dart';
import '../../../../domain/usecases/customer_use_cases.dart';

/// State for customer list with due tracking.
class CustomersState {
  final List<Customer> customers;
  final Map<int, double> dueMap; // customerId -> total due
  final bool isLoading;

  const CustomersState({
    this.customers = const [],
    this.dueMap = const {},
    this.isLoading = false,
  });

  CustomersState copyWith({
    List<Customer>? customers,
    Map<int, double>? dueMap,
    bool? isLoading,
  }) =>
      CustomersState(
        customers: customers ?? this.customers,
        dueMap: dueMap ?? this.dueMap,
        isLoading: isLoading ?? this.isLoading,
      );
}

/// AsyncNotifier for customer list and due amounts.
final customersProvider =
    AsyncNotifierProvider<CustomersNotifier, CustomersState>(
  () => CustomersNotifier(),
);

class CustomersNotifier extends AsyncNotifier<CustomersState> {
  late final CustomerUseCases _useCases;
  String _searchQuery = '';

  @override
  Future<CustomersState> build() async {
    _useCases = CustomerUseCases(ref.read(customerRepositoryProvider));
    return await _loadData();
  }

  Future<CustomersState> _loadData() async {
    final customers = await _useCases.getAllCustomers(
        searchQuery: _searchQuery.isEmpty ? null : _searchQuery);
    final Map<int, double> dueMap = {};
    for (final c in customers) {
      dueMap[c.id!] = await _useCases.getTotalDue(c.id!);
    }
    return CustomersState(customers: customers, dueMap: dueMap);
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadData());
  }

  Future<void> deleteCustomer(int id) async {
    await _useCases.deleteCustomer(id);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadData());
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadData());
  }
}