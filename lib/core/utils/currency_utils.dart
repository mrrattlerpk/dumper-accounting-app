/// Centralized currency formatting helpers for PKR.
class CurrencyUtils {
  CurrencyUtils._();

  /// Formats a double amount as PKR with thousands separators.
  /// Example: 1250000 -> "1,250,000"
  static String formatAmount(double amount) {
    final parts = amount.toStringAsFixed(0).split('');
    final buffer = StringBuffer();
    int count = 0;
    for (int i = parts.length - 1; i >= 0; i--) {
      if (count == 3 && i >= 0) {
        buffer.write(',');
        count = 0;
      }
      buffer.write(parts[i]);
      count++;
    }
    final reversed = buffer.toString().split('').reversed.join('');
    return 'PKR $reversed';
  }

  /// Formats with 2 decimal places.
  static String formatAmountWithCents(double amount) {
    final intPart = amount.floor();
    final cents = ((amount - intPart) * 100).round().toString().padLeft(2, '0');
    return '${formatAmount(intPart.toDouble())}.$cents';
  }

  /// Parse a string like "1,250,000" to double.
  static double parseAmount(String formatted) {
    final cleaned = formatted.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }
}