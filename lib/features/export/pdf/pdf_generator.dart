import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/constants/app_constants.dart';
import 'pdf_layouts.dart';
import 'pdf_fonts.dart';

/// Central PDF generator for all report types.
/// Handles Urdu + English text, pagination, and professional layouts.
class PdfGenerator {
  final pw.Font? _urduFont;
  final pw.Font? _englishFont;
  final PdfPageFormat _pageFormat;

  PdfGenerator({
    required String pageSize,
  })  : _urduFont = PdfFonts.getUrduFont(),
        _englishFont = PdfFonts.getEnglishFont(),
        _pageFormat = PdfLayouts.getPageFormat(pageSize);

  /// Generate a daily report PDF as bytes.
  Future<Uint8List> generateDailyReport({
    required DateTime date,
    required int tripCount,
    required double totalEarnings,
    required double totalPaid,
    required double totalPending,
    required List<Map<String, dynamic>> trips,
    String? businessName,
    String? businessPhone,
  }) async {
    final doc = pw.Document();
    final titleStyle = pw.TextStyle(
      font: _englishFont,
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
    );
    final headerStyle = pw.TextStyle(
      font: _englishFont,
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
    );
    final normalStyle = pw.TextStyle(
      font: _englishFont,
      fontSize: 12,
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: _pageFormat,
        header: (context) => _buildHeader(
          title: 'Daily Report',
          subtitle: '${date.day}/${date.month}/${date.year}',
          businessName: businessName,
        ),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          // Summary section
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _summaryColumn('Total Trips', tripCount.toString(), normalStyle, headerStyle),
                _summaryColumn('Earnings', 'PKR ${totalEarnings.toStringAsFixed(0)}', normalStyle, headerStyle),
                _summaryColumn('Paid', 'PKR ${totalPaid.toStringAsFixed(0)}', normalStyle, headerStyle),
                _summaryColumn('Pending', 'PKR ${totalPending.toStringAsFixed(0)}', normalStyle, headerStyle),
              ],
            ),
          ),
          pw.SizedBox(height: 16),
          // Table header
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400),
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _tableCell('Trip #', headerStyle, bold: true),
                  _tableCell('Driver', headerStyle, bold: true),
                  _tableCell('Dumper', headerStyle, bold: true),
                  _tableCell('Quantity', headerStyle, bold: true),
                  _tableCell('Amount', headerStyle, bold: true),
                  _tableCell('Paid', headerStyle, bold: true),
                ],
              ),
              // Trip rows
              ...trips.map((trip) {
                return pw.TableRow(
                  children: [
                    _tableCell(trip['id']?.toString() ?? '', normalStyle),
                    _tableCell(trip['driver']?.toString() ?? '', normalStyle),
                    _tableCell(trip['dumper']?.toString() ?? '', normalStyle),
                    _tableCell(trip['quantity']?.toString() ?? '', normalStyle),
                    _tableCell('PKR ${trip['amount'] ?? 0}', normalStyle),
                    _tableCell('PKR ${trip['paid'] ?? 0}', normalStyle),
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );

    return await doc.save();
  }

  /// Generate a generic ledger/report PDF from any table data.
  Future<Uint8List> generateLedgerPdf({
    required String title,
    required String subtitle,
    required List<String> columns,
    required List<List<String>> rows,
    String? businessName,
    String? businessPhone,
    Map<String, double>? summary,
  }) async {
    final doc = pw.Document();
    final headerStyle = pw.TextStyle(
      font: _englishFont,
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
    );
    final normalStyle = pw.TextStyle(
      font: _englishFont,
      fontSize: 12,
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: _pageFormat,
        header: (context) => _buildHeader(
          title: title,
          subtitle: subtitle,
          businessName: businessName,
        ),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          // Optional summary
          if (summary != null) ...[
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              margin: const pw.EdgeInsets.only(bottom: 12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Wrap(
                spacing: 20,
                children: summary.entries.map((e) {
                  return pw.Text(
                    '${e.key}: ${e.value.toStringAsFixed(0)}',
                    style: headerStyle,
                  );
                }).toList(),
              ),
            ),
          ],
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400),
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: columns.map((c) => _tableCell(c, headerStyle, bold: true)).toList(),
              ),
              ...rows.map((row) {
                return pw.TableRow(
                  children: row.map((cell) => _tableCell(cell, normalStyle)).toList(),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );

    return await doc.save();
  }

  pw.Widget _buildHeader({
    required String title,
    required String subtitle,
    String? businessName,
  }) {
    final headerStyle = pw.TextStyle(font: _englishFont, fontSize: 10, color: PdfColors.grey600);
    final titleStyle = pw.TextStyle(font: _englishFont, fontSize: 16, fontWeight: pw.FontWeight.bold);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        if (businessName != null)
          pw.Text(businessName, style: headerStyle, textAlign: pw.TextAlign.right),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(title, style: titleStyle),
            pw.Text(subtitle, style: headerStyle),
          ],
        ),
        pw.Divider(color: PdfColors.grey400, thickness: 1),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: pw.TextStyle(font: _englishFont, fontSize: 8, color: PdfColors.grey600),
        ),
        pw.Text(
          'Generated by Dumper Accounting',
          style: pw.TextStyle(font: _englishFont, fontSize: 8, color: PdfColors.grey600),
        ),
      ],
    );
  }

  pw.Widget _tableCell(String text, pw.TextStyle style, {bool bold = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: style.copyWith(fontWeight: bold ? pw.FontWeight.bold : null),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _summaryColumn(String label, String value, pw.TextStyle normal, pw.TextStyle bold) {
    return pw.Column(
      children: [
        pw.Text(value, style: bold, textAlign: pw.TextAlign.center),
        pw.SizedBox(height: 4),
        pw.Text(label, style: normal, textAlign: pw.TextAlign.center),
      ],
    );
  }

  /// Share or print the PDF using the printing package.
  static Future<void> sharePdf(Uint8List pdfBytes, String fileName) async {
    await Printing.sharePdf(bytes: pdfBytes, filename: '$fileName.pdf');
  }

  /// Save PDF to a local file and return the path.
  static Future<String> savePdfToFile(Uint8List pdfBytes, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${dir.path}/exports');
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    final file = File('${exportDir.path}/$fileName.pdf');
    await file.writeAsBytes(pdfBytes);
    return file.path;
  }
}