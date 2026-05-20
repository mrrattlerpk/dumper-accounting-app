import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Generic CSV exporter for any list of maps (rows).
/// Produces Excel-compatible CSV with UTF-8 BOM.
class CsvExporter {
  CsvExporter._();

  /// Writes CSV content to a file and returns the file path.
  static Future<String> exportToFile({
    required List<String> headers,
    required List<Map<String, dynamic>> rows,
    required String fileName,
  }) async {
    final csvString = _generateCsv(headers, rows);
    final dir = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${dir.path}/exports');
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    final filePath = '${exportDir.path}/$fileName.csv';
    final file = File(filePath);
    await file.writeAsString(csvString, encoding: utf8);
    return filePath;
  }

  /// Returns CSV content as a String.
  static String generateCsvString({
    required List<String> headers,
    required List<Map<String, dynamic>> rows,
  }) {
    return _generateCsv(headers, rows);
  }

  /// Internal CSV builder with proper escaping.
  static String _generateCsv(
      List<String> headers, List<Map<String, dynamic>> rows) {
    final buffer = StringBuffer();
    // UTF-8 BOM for Excel compatibility
    buffer.write('\uFEFF');
    // Write header
    buffer.writeln(headers.map(_escapeField).join(','));
    // Write rows
    for (final row in rows) {
      final values = headers.map((header) {
        final val = row[header] ?? '';
        return _escapeField(val.toString());
      }).join(',');
      buffer.writeln(values);
    }
    return buffer.toString();
  }

  /// Escapes a field for CSV: wraps in quotes if contains comma, newline, or quote.
  static String _escapeField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }
}