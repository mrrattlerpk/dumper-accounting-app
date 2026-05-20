import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/dropdown_tile.dart';
import '../../../../core/widgets/numeric_keypad.dart';
import '../../../../data/repositories/driver_repository_impl.dart';
import '../../../../data/repositories/dumper_repository_impl.dart';
import '../../../../data/repositories/customer_repository_impl.dart';
import '../../../../data/repositories/material_repository_impl.dart';
import '../providers/trip_entry_provider.dart';
import '../widgets/payment_status_chip.dart';

// Providers from other features used in this screen
import '../../../drivers/presentation/providers/drivers_provider.dart';
import '../../../dumpers/presentation/providers/dumpers_provider.dart';
import '../../../customers/presentation/providers/customers_provider.dart';
import '../../../materials/presentation/providers/materials_provider.dart';

/// Optimized one-hand trip entry screen.
class TripEntryScreen extends ConsumerStatefulWidget {
  const TripEntryScreen({super.key});

  @override
  ConsumerState<TripEntryScreen> createState() => _TripEntryScreenState();
}

class _TripEntryScreenState extends ConsumerState<TripEntryScreen> {
  final _quantityController = TextEditingController();
  final _rateController = TextEditingController();
  final _paidController = TextEditingController();
  final _notesController = TextEditingController();

  // Focus nodes for keyboard sequence
  final _quantityFocus = FocusNode();
  final _rateFocus = FocusNode();
  final _paidFocus = FocusNode();
  final _notesFocus = FocusNode();

  @override
  void dispose() {
    _quantityController.dispose();
    _rateController.dispose();
    _paidController.dispose();
    _notesController.dispose();
    _quantityFocus.dispose();
    _rateFocus.dispose();
    _paidFocus.dispose();
    _notesFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripEntryProvider);
    final notifier = ref.read(tripEntryProvider.notifier);
    final loc = context.loc;

    // Load async reference data for dropdowns
    final driversAsync = ref.watch(driversProvider);
    final dumpersAsync = ref.watch(dumpersProvider);
    final customersAsync = ref.watch(customersProvider);
    final materialsAsync = ref.watch(materialsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc['new_trip']),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            // Step 1: Dumper (largest target, first selection)
            driversAsync.when(
              data: (drivers) => DropdownTile<int>(
                label: loc['select_driver'],
                value: state.driverId,
                items: drivers
                    .map((d) => DropdownMenuItem(
                          value: d.id,
                          child: Text(d.name, style: const TextStyle(fontSize: 16)),
                        ))
                    .toList(),
                onChanged: (id) {
                  if (id != null) notifier.setDriver(id);
                },
                isRequired: true,
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            SizedBox(height: 8.h),

            // Step 2: Dumper
            dumpersAsync.when(
              data: (dumpers) => DropdownTile<int>(
                label: loc['select_dumper'],
                value: state.dumperId,
                items: dumpers
                    .map((d) => DropdownMenuItem(
                          value: d.id,
                          child: Text(d.registrationNumber,
                              style: const TextStyle(fontSize: 16)),
                        ))
                    .toList(),
                onChanged: (id) {
                  if (id != null) notifier.setDumper(id);
                },
                isRequired: true,
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            SizedBox(height: 8.h),

            // Step 3: Customer
            customersAsync.when(
              data: (customers) => DropdownTile<int>(
                label: loc['select_customer'],
                value: state.customerId,
                items: customers
                    .map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name, style: const TextStyle(fontSize: 16)),
                        ))
                    .toList(),
                onChanged: (id) {
                  if (id != null) notifier.setCustomer(id);
                },
                isRequired: true,
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            SizedBox(height: 8.h),

            // Step 4: Material (may auto-fill rate)
            materialsAsync.when(
              data: (mats) => DropdownTile<int>(
                label: loc['select_material'],
                value: state.materialId,
                items: mats
                    .map((m) => DropdownMenuItem(
                          value: m.id,
                          child: Text(
                            '${m.name} (${m.defaultRate})',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ))
                    .toList(),
                onChanged: (id) {
                  final mat = mats.firstWhere((m) => m.id == id);
                  notifier.setMaterial(id!,
                      defaultRate: mat.defaultRate > 0 ? mat.defaultRate : null);
                  // Update rate field
                  _rateController.text =
                      mat.defaultRate > 0 ? mat.defaultRate.toString() : '';
                },
                isRequired: true,
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            SizedBox(height: 8.h),

            // Step 5: Quantity (with numeric keypad)
            Text(loc['quantity'] + ' *', style: AppTextStyles.bodyLarge),
            TextField(
              controller: _quantityController,
              focusNode: _quantityFocus,
              keyboardType: TextInputType.none, // Use custom keypad
              decoration: InputDecoration(
                hintText: '0.0',
                suffixIcon: IconButton(
                  icon: Icon(Icons.keyboard_alt_outlined, size: 24.sp),
                  onPressed: () => _showKeypad(_quantityController, (val) {
                    notifier.setQuantity(double.tryParse(val) ?? 0);
                  }),
                ),
              ),
              onChanged: (val) {
                notifier.setQuantity(double.tryParse(val) ?? 0);
              },
            ),
            SizedBox(height: 8.h),

            // Step 6: Rate
            Text(loc['rate'] + ' *', style: AppTextStyles.bodyLarge),
            TextField(
              controller: _rateController,
              focusNode: _rateFocus,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0.0',
                suffixIcon: IconButton(
                  icon: Icon(Icons.keyboard_alt_outlined, size: 24.sp),
                  onPressed: () => _showKeypad(_rateController, (val) {
                    notifier.setRate(double.tryParse(val) ?? 0);
                  }),
                ),
              ),
              onChanged: (val) {
                notifier.setRate(double.tryParse(val) ?? 0);
              },
            ),
            SizedBox(height: 8.h),

            // Step 7: Paid Amount
            Text(loc['paid_amount'], style: AppTextStyles.bodyLarge),
            TextField(
              controller: _paidController,
              focusNode: _paidFocus,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0.0',
                suffixIcon: IconButton(
                  icon: Icon(Icons.keyboard_alt_outlined, size: 24.sp),
                  onPressed: () => _showKeypad(_paidController, (val) {
                    notifier.setPaidAmount(double.tryParse(val) ?? 0);
                  }),
                ),
              ),
              onChanged: (val) {
                notifier.setPaidAmount(double.tryParse(val) ?? 0);
              },
            ),
            SizedBox(height: 8.h),

            // Step 8: Date
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(loc['trip_date'], style: AppTextStyles.bodyLarge),
              subtitle: Text(
                '${state.tripDate.day}/${state.tripDate.month}/${state.tripDate.year}',
                style: AppTextStyles.bodyMedium,
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: state.tripDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 1)),
                );
                if (date != null) notifier.setTripDate(date);
              },
            ),

            // Step 9: Notes
            Text(loc['notes'], style: AppTextStyles.bodyLarge),
            TextField(
              controller: _notesController,
              focusNode: _notesFocus,
              maxLines: 2,
              onChanged: notifier.setNotes,
            ),
            SizedBox(height: 12.h),

            // Auto-calc summary
            Card(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc['total_amount'],
                          style: AppTextStyles.caption,
                        ),
                        Text(
                          'PKR ${state.totalAmount.toStringAsFixed(2)}',
                          style: AppTextStyles.headlineSmall,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          loc['remaining'],
                          style: AppTextStyles.caption,
                        ),
                        Text(
                          'PKR ${state.remaining.toStringAsFixed(2)}',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: state.remaining <= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
            if (state.totalAmount > 0)
              PaymentStatusChip(
                isFullyPaid: state.remaining <= 0,
                paid: state.paidAmount,
                total: state.totalAmount,
              ),
            SizedBox(height: 16.h),

            CustomButton(
              label: loc['save'],
              onPressed: state.isSaving
                  ? null
                  : () async {
                      try {
                        await notifier.saveTrip();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(loc['success']),
                          ),
                        );
                        // Clear fields
                        _quantityController.clear();
                        _rateController.clear();
                        _paidController.clear();
                        _notesController.clear();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${loc['error']}: $e'),
                          ),
                        );
                      }
                    },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  /// Shows the custom numeric keypad in a modal bottom sheet.
  void _showKeypad(TextEditingController controller, Function(String) onValue) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: NumericKeypad(
          controller: controller,
          allowDecimal: true,
        ),
      ),
    ).then((_) {
      onValue(controller.text);
    });
  }
}