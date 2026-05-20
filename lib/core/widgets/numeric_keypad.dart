import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A large, touch-friendly numeric keypad for entering quantities and rates.
/// Designed for one-hand use in trip entry forms.
class NumericKeypad extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool allowDecimal;

  const NumericKeypad({
    super.key,
    required this.controller,
    this.focusNode,
    this.allowDecimal = true,
  });

  void _onKeyTap(String value) {
    final text = controller.text;
    final selection = controller.selection;

    if (value == '⌫') {
      if (text.isEmpty || selection.baseOffset <= 0) return;
      final newText = text.substring(0, selection.baseOffset - 1) +
          text.substring(selection.extentOffset);
      controller.text = newText;
      controller.selection = TextSelection.collapsed(
        offset: (selection.baseOffset - 1).clamp(0, newText.length),
      );
      return;
    }

    if (value == 'C') {
      controller.clear();
      return;
    }

    if (value == '.') {
      if (!allowDecimal || text.contains('.')) return;
      // Insert decimal at cursor
      final newText = text.substring(0, selection.baseOffset) +
          '.' +
          text.substring(selection.extentOffset);
      controller.text = newText;
      controller.selection = TextSelection.collapsed(
        offset: selection.baseOffset + 1,
      );
      return;
    }

    // Normal digit insertion
    final newText = text.substring(0, selection.baseOffset) +
        value +
        text.substring(selection.extentOffset);
    controller.text = newText;
    controller.selection = TextSelection.collapsed(
      offset: selection.baseOffset + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(['1', '2', '3']),
        _row(['4', '5', '6']),
        _row(['7', '8', '9']),
        _row([allowDecimal ? '.' : 'C', '0', '⌫']),
      ],
    );
  }

  Widget _row(List<String> keys) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((key) => _keyButton(key)).toList(),
      ),
    );
  }

  Widget _keyButton(String label) {
    final bool isActionKey = label == '⌫' || label == 'C';

    return SizedBox(
      width: 80.w,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () => _onKeyTap(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isActionKey
              ? Colors.grey.shade300
              : Colors.white,
          foregroundColor: isActionKey
              ? Colors.black54
              : Colors.black87,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}