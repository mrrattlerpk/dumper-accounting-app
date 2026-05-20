import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../data/repositories/dumper_repository_impl.dart';
import '../../../../domain/entities/dumper.dart';

/// Screen for adding or editing a dumper/truck.
class DumperFormScreen extends ConsumerStatefulWidget {
  final Dumper? dumper;

  const DumperFormScreen({super.key, this.dumper});

  @override
  ConsumerState<DumperFormScreen> createState() => _DumperFormScreenState();
}

class _DumperFormScreenState extends ConsumerState<DumperFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _regController;
  late final TextEditingController _modelController;
  late final TextEditingController _ownerController;
  late final TextEditingController _chassisController;
  late final TextEditingController _engineController;
  late final TextEditingController _colorController;
  late final TextEditingController _capacityController;
  late final TextEditingController _notesController;
  bool _isActive = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final d = widget.dumper;
    _regController = TextEditingController(text: d?.registrationNumber ?? '');
    _modelController = TextEditingController(text: d?.model ?? '');
    _ownerController = TextEditingController(text: d?.ownerName ?? '');
    _chassisController = TextEditingController(text: d?.chassisNumber ?? '');
    _engineController = TextEditingController(text: d?.engineNumber ?? '');
    _colorController = TextEditingController(text: d?.color ?? '');
    _capacityController = TextEditingController(
      text: d?.capacityTons?.toString() ?? '',
    );
    _notesController = TextEditingController(text: d?.notes ?? '');
    _isActive = d?.isActive ?? true;
  }

  @override
  void dispose() {
    _regController.dispose();
    _modelController.dispose();
    _ownerController.dispose();
    _chassisController.dispose();
    _engineController.dispose();
    _colorController.dispose();
    _capacityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(dumperRepositoryProvider);
      final capacity = double.tryParse(_capacityController.text.trim()) ?? 0.0;

      final dumper = Dumper(
        id: widget.dumper?.id,
        registrationNumber: _regController.text.trim(),
        model: _modelController.text.trim(),
        ownerName: _ownerController.text.trim(),
        chassisNumber: _chassisController.text.trim(),
        engineNumber: _engineController.text.trim(),
        color: _colorController.text.trim(),
        capacityTons: capacity > 0 ? capacity : null,
        notes: _notesController.text.trim(),
        isActive: _isActive,
        createdAt: widget.dumper?.createdAt,
        updatedAt: DateTime.now(),
      );

      if (widget.dumper == null) {
        await repo.insertDumper(dumper);
      } else {
        await repo.updateDumper(dumper);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.loc['save']} ${context.loc['success']}')),
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
    final isEditing = widget.dumper != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? loc['edit'] : loc['add_dumper']),
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
              _buildLabel(loc['registration_number'], required: true),
              TextFormField(
                controller: _regController,
                textCapitalization: TextCapitalization.characters,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? loc['registration_number'] + ' ' + loc['error'] : null,
              ),
              SizedBox(height: 16.h),
              _buildLabel(loc['model'], required: true),
              TextFormField(
                controller: _modelController,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? loc['model'] + ' ' + loc['error'] : null,
              ),
              SizedBox(height: 16.h),
              _buildLabel(loc['owner_name']),
              TextFormField(controller: _ownerController),
              SizedBox(height: 16.h),
              _buildLabel(loc['chassis_number']),
              TextFormField(controller: _chassisController),
              SizedBox(height: 16.h),
              _buildLabel(loc['engine_number']),
              TextFormField(controller: _engineController),
              SizedBox(height: 16.h),
              _buildLabel(loc['color']),
              TextFormField(controller: _colorController),
              SizedBox(height: 16.h),
              _buildLabel(loc['capacity_tons']),
              TextFormField(
                controller: _capacityController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16.h),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(loc['is_active'], style: const TextStyle(fontSize: 16)),
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
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