import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection_container.dart';
import '../../data/models/customer.dart';
import '../../domain/entities/customer.dart' as entity;
import '../../domain/repositories/customer_repository.dart';

/// Riverpod provider for CustomerRepository.
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final isar = ref.watch(isarInstanceProvider);
  return CustomerRepositoryImpl(isar);
});

class CustomerRepositoryImpl implements CustomerRepository {
  final Isar _isar;

  CustomerRepositoryImpl(this._isar);

  entity.Customer _toEntity(Customer c) => entity.Customer(
        id: c.id,
        name: c.name,
        company: c.company,
        phone: c.phone,
        address: c.address,
        notes: c.notes,
        openingBalance: c.openingBalance,
        createdAt: c.createdAt,
        updatedAt: c.updatedAt,
      );

  Customer _toModel(entity.Customer c, {int? existingId}) => Customer()
    ..id = c.id ?? existingId ?? Isar.autoIncrement
    ..name = c.name
    ..company = c.company
    ..phone = c.phone
    ..address = c.address
    ..notes = c.notes
    ..openingBalance = c.openingBalance
    ..createdAt = c.createdAt ?? DateTime.now()
    ..updatedAt = DateTime.now();

  @override
  Future<List<entity.Customer>> getAllCustomers({String? searchQuery}) async {
    final query = _isar.customers.where();
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query.filter()
        ..nameContains(searchQuery, caseSensitive: false)
        ..or()
        ..companyContains(searchQuery, caseSensitive: false)
        ..or()
        ..phoneContains(searchQuery, caseSensitive: false);
    }
    final results = await query.findAll();
    return results.map(_toEntity).toList();
  }

  @override
  Future<entity.Customer?> getCustomerById(int id) async {
    final result = await _isar.customers.get(id);
    return result != null ? _toEntity(result) : null;
  }

  @override
  Future<void> insertCustomer(entity.Customer customer) async {
    final model = _toModel(customer);
    await _isar.writeTxn(() async {
      await _isar.customers.put(model);
    });
  }

  @override
  Future<void> updateCustomer(entity.Customer customer) async {
    if (customer.id == null) throw ArgumentError('Customer id cannot be null for update.');
    final model = _toModel(customer, existingId: customer.id);
    await _isar.writeTxn(() async {
      await _isar.customers.put(model);
    });
  }

  @override
  Future<void> deleteCustomer(int id) async {
    await _isar.writeTxn(() async {
      await _isar.customers.delete(id);
    });
  }

  @override
  Future<double> getCustomerTotalDue(int customerId) async {
    final customer = await _isar.customers.get(customerId);
    if (customer == null) return 0.0;

    final trips = await _isar.trips
        .where()
        .customerIdEqualTo(customerId)
        .findAll();

    final tripDue = trips.fold(0.0, (sum, trip) => sum + trip.remaining);
    return customer.openingBalance + tripDue;
  }
}