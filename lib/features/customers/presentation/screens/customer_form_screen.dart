import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../data/repositories/customer_repository_impl.dart';
import '../../../../domain/entities/customer.dart';

/// Screen for adding or editing a customer.
class CustomerFormScreen extends ConsumerStatefulWidget {
  final Customer? customer;

  const CustomerFormScreen({super.key, this.customer});

  @override
  ConsumerState<CustomerFormScreen> createState() =>
      _CustomerFormScreenState();
}

class _CustomerFormScreenState extends ConsumerState<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _companyController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _openingBalanceController;
  late final TextEditingController _notesController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _nameController = TextEditingController(text: c?.name ?? '');
    _companyController = TextEditingController(text: c?.company ?? '');
    _phoneController = TextEditingController(text: c?.phone ?? '');
    _addressController = TextEditingController(text: c?.address ?? '');
    _openingBalanceController = TextEditingController(
      text: (c?.openingBalance ?? 0.0).toString(),
    );
    _notesController = TextEditingController(text: c?.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _openingBalanceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(customerRepositoryProvider);
      final balance = double.tryParse(
            _openingBalanceController.text.trim(),
          ) ??
          0.0;

      final customer = Customer(
        id: widget.customer?.id,
        name: _nameController.text.trim(),
        company: _companyController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        notes: _notesController.text.trim(),
        openingBalance: balance,
        createdAt: widget.customer?.createdAt,
        updatedAt: DateTime.now(),
      );

      if (widget.customer == null) {
        await repo.insertCustomer(customer);
      } else {
        await repo.updateCustomer(customer);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${context.loc['save']} ${context.loc['success']}')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.loc['error']}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final isEditing = widget.customer != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? loc['edit'] : loc['add_customer']),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : Text(loc['save'],
                    style:
                        const TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(loc['name'], required: true),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                validator: (v) => v == null || v.trim().isEmpty
                    ? loc['name'] + ' ' + loc['error']
                    : null,
              ),
              SizedBox(height: 16.h),
              _buildLabel(loc['company']),
              TextFormField(controller: _companyController),
              SizedBox(height: 16.h),
              _buildLabel(loc['phone']),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.h),
              _buildLabel(loc['address']),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
              ),
              SizedBox(height: 16.h),
              _buildLabel(loc['opening_balance']),
              TextFormField(
                controller: _openingBalanceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16.h),
              _buildLabel(loc['notes']),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child:
                      Text(loc['save'], style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Text(
        text + (required ? ' *' : ''),
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}