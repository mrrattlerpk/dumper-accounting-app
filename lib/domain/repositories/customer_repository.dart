import '../entities/customer.dart';

/// Abstract repository for Customer entities.
abstract class CustomerRepository {
  Future<List<Customer>> getAllCustomers({String? searchQuery});
  Future<Customer?> getCustomerById(int id);
  Future<void> insertCustomer(Customer customer);
  Future<void> updateCustomer(Customer customer);
  Future<void> deleteCustomer(int id);
  Future<double> getCustomerTotalDue(int customerId);
}