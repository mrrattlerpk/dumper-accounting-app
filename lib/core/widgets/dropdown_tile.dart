import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A large, RTL-friendly dropdown widget for one-hand use.
/// Displays a list of items in a dropdown menu with large touch targets.
class DropdownTile<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hintText;
  final bool isRequired;
  final Widget? prefixIcon;

  const DropdownTile({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.hintText,
    this.isRequired = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 4.h, left: 4.w),
              child: Text(
                label + (isRequired ? ' *' : ''),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          DropdownButtonFormField<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            hint: hintText != null ? Text(hintText!) : null,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            isExpanded: true,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            ),
            style: Theme.of(context).textTheme.bodyLarge,
            dropdownColor: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ],
      ),
    );
  }
}