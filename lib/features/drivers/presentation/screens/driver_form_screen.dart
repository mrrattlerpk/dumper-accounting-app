import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../data/repositories/driver_repository_impl.dart';
import '../../../../domain/entities/driver.dart';

/// Screen for adding a new driver or editing an existing one.
/// If a driver is passed, the screen works in edit mode.
class DriverFormScreen extends ConsumerStatefulWidget {
  final Driver? driver;

  const DriverFormScreen({super.key, this.driver});

  @override
  ConsumerState<DriverFormScreen> createState() => _DriverFormScreenState();
}

class _DriverFormScreenState extends ConsumerState<DriverFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cnicController;
  late final TextEditingController _licenseController;
  late final TextEditingController _notesController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final d = widget.driver;
    _nameController = TextEditingController(text: d?.name ?? '');
    _phoneController = TextEditingController(text: d?.phone ?? '');
    _addressController = TextEditingController(text: d?.address ?? '');
    _cnicController = TextEditingController(text: d?.cnic ?? '');
    _licenseController = TextEditingController(text: d?.licenseNumber ?? '');
    _notesController = TextEditingController(text: d?.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cnicController.dispose();
    _licenseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(driverRepositoryProvider);
      final driver = Driver(
        id: widget.driver?.id,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        cnic: _cnicController.text.trim(),
        licenseNumber: _licenseController.text.trim(),
        notes: _notesController.text.trim(),
        createdAt: widget.driver?.createdAt,
        updatedAt: DateTime.now(),
      );

      if (widget.driver == null) {
        await repo.insertDriver(driver);
      } else {
        await repo.updateDriver(driver);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.loc['save'] + ' ' + context.loc['success'])),
        );
        Navigator.pop(context, true); // return true to indicate data changed
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
    final isEditing = widget.driver != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? loc['edit'] : loc['add_driver']),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(loc['save'], style: const TextStyle(color: Colors.white, fontSize: 16)),
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
              _buildLabel(loc['driver_name'], required: true),
              TextFormField(
                controller: _nameController,
                validator: (v) => v == null || v.trim().isEmpty ? loc['driver_name'] + ' ' + loc['error'] : null,
                textCapitalization: TextCapitalization.words,
              ),
              SizedBox(height: 16.h),
              _buildLabel(loc['phone'], required: true),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.trim().isEmpty ? loc['phone'] + ' ' + loc['error'] : null,
              ),
              SizedBox(height: 16.h),
              _buildLabel(loc['address']),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
              ),
              SizedBox(height: 16.h),
              _buildLabel(loc['cnic']),
              TextFormField(
                controller: _cnicController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.h),
              _buildLabel(loc['license_number']),
              TextFormField(
                controller: _licenseController,
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
                  child: Text(loc['save'], style: const TextStyle(fontSize: 16)),
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
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}