import 'package:pdf/pdf.dart';

/// Provides standard page formats and layout helpers for PDF generation.
class PdfLayouts {
  PdfLayouts._();

  /// Map a string identifier (from app constants) to a PdfPageFormat.
  static PdfPageFormat getPageFormat(String size) {
    switch (size) {
      case 'A4':
        return PdfPageFormat.a4;
      case 'A5':
        return PdfPageFormat.a5;
      case 'Letter':
        return PdfPageFormat.letter;
      case 'Legal':
        return PdfPageFormat.legal;
      default:
        return PdfPageFormat.a4;
    }
  }

  /// Standard margin for all pages.
  static const EdgeInsets margin = EdgeInsets.all(24);

  /// Header/footer padding.
  static const EdgeInsets headerPadding = EdgeInsets.only(bottom: 8);
  static const EdgeInsets footerPadding = EdgeInsets.only(top: 8);
}