import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Colored chip indicating the payment status of a trip.
class PaymentStatusChip extends StatelessWidget {
  final bool isFullyPaid;
  final double paid;
  final double total;

  const PaymentStatusChip({
    super.key,
    required this.isFullyPaid,
    required this.paid,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final String label;
    final Color backgroundColor;
    final Color textColor;

    if (isFullyPaid) {
      label = loc['fully_paid'];
      backgroundColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
    } else if (paid > 0) {
      label = loc['partially_paid'];
      backgroundColor = Colors.orange.shade100;
      textColor = Colors.orange.shade800;
    } else {
      label = loc['unpaid'];
      backgroundColor = Colors.red.shade100;
      textColor = Colors.red.shade800;
    }

    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
        ),
      ),
      backgroundColor: backgroundColor,
      side: BorderSide.none,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
    );
  }
}