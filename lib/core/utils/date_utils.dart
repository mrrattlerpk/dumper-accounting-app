import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// Centralized date formatting helpers.
class AppDateUtils {
  AppDateUtils._();

  /// Format a DateTime for display (e.g., "12 Jun 2025").
  static String formatDisplay(DateTime date) {
    return DateFormat(AppConstants.dateFormatDisplay).format(date);
  }

  /// Format a DateTime for API / file naming (e.g., "2025-06-12").
  static String formatApi(DateTime date) {
    return DateFormat(AppConstants.dateFormatApi).format(date);
  }

  /// Get start of day (00:00:00.000) for a given DateTime.
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day (23:59:59.999) for a given DateTime.
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get a human-friendly "time ago" string.
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  /// Check if two dates are the same calendar day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Get the first day of the current month.
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get the last day of the current month.
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }
}