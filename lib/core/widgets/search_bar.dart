import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable search bar with large touch targets and clear button.
class AppSearchBar extends StatelessWidget {
  final String? hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const AppSearchBar({
    super.key,
    this.hintText,
    required this.onChanged,
    this.onClear,
    this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText ?? 'Search...',
          prefixIcon: Icon(Icons.search, size: 24.sp),
          suffixIcon: (controller != null && controller!.text.isNotEmpty)
              ? IconButton(
                  icon: Icon(Icons.clear, size: 24.sp),
                  onPressed: () {
                    controller?.clear();
                    onChanged('');
                    onClear?.call();
                  },
                )
              : null,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}