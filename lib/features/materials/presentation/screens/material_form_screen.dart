import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../data/repositories/material_repository_impl.dart';
import '../../../../domain/entities/material.dart';

/// Screen for adding or editing a material.
class MaterialFormScreen extends ConsumerStatefulWidget {
  final MaterialEntity? material;

  const MaterialFormScreen({super.key, this.material});

  @override
  ConsumerState<MaterialFormScreen> createState() =>
      _MaterialFormScreenState();
}

class _MaterialFormScreenState extends ConsumerState<MaterialFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _unitController;
  late final TextEditingController _rateController;
  late final TextEditingController _descController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final m = widget.material;
    _nameController = TextEditingController(text: m?.name ?? '');
    _unitController = TextEditingController(text: m?.unit ?? '');
    _rateController = TextEditingController(
      text: m?.defaultRate != null ? m!.defaultRate.toString() : '',
    );
    _descController = TextEditingController(text: m?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _rateController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(materialRepositoryProvider);
      final rate = double.tryParse(_rateController.text.trim()) ?? 0.0;

      final material = MaterialEntity(
        id: widget.material?.id,
        name: _nameController.text.trim(),
        unit: _unitController.text.trim(),
        defaultRate: rate,
        description: _descController.text.trim(),
        createdAt: widget.material?.createdAt,
        updatedAt: DateTime.now(),
      );

      if (widget.material == null) {
        await repo.insertMaterial(material);
      } else {
        await repo.updateMaterial(material);
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
    final isEditing = widget.material != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? loc['edit'] : loc['add_material']),
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
              _buildLabel(loc['material_name'], required: true),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                validator: (v) => v == null || v.trim().isEmpty
                    ? loc['material_name'] + ' ' + loc['error']
                    : null,
              ),
              SizedBox(height: 16.h),
              _buildLabel(loc['unit']),
              TextFormField(controller: _unitController),
              SizedBox(height: 16.h),
              _buildLabel(loc['default_rate'], required: true),
              TextFormField(
                controller: _rateController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return loc['default_rate'] + ' ' + loc['error'];
                  if (double.tryParse(v.trim()) == null)
                    return 'Invalid number';
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              _buildLabel(loc['description']),
              TextFormField(
                controller: _descController,
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