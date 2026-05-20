import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

/// Encapsulates all business operations related to Customers.
class CustomerUseCases {
  final CustomerRepository _repository;

  CustomerUseCases(this._repository);

  Future<List<Customer>> getAllCustomers({String? searchQuery}) =>
      _repository.getAllCustomers(searchQuery: searchQuery);

  Future<Customer?> getCustomerById(int id) =>
      _repository.getCustomerById(id);

  Future<void> addCustomer(Customer customer) async {
    if (customer.name.trim().isEmpty) {
      throw ArgumentError('Customer name cannot be empty.');
    }
    await _repository.insertCustomer(customer);
  }

  Future<void> updateCustomer(Customer customer) async {
    if (customer.id == null) {
      throw ArgumentError('Customer must have an ID to be updated.');
    }
    await _repository.updateCustomer(customer);
  }

  Future<void> deleteCustomer(int id) =>
      _repository.deleteCustomer(id);

  Future<double> getTotalDue(int customerId) =>
      _repository.getCustomerTotalDue(customerId);
}