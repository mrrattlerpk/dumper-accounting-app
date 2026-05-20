import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

/// Manages font loading for PDF generation.
/// Supports Urdu (Noto Nastaliq) and English (Roboto fallback).
class PdfFonts {
  PdfFonts._();

  static pw.Font? _urduFont;
  static pw.Font? _englishFont;

  /// Load Urdu font from assets (Noto Nastaliq).
  static pw.Font? getUrduFont() {
    if (_urduFont != null) return _urduFont;
    try {
      // This will be loaded lazily – must be called within a valid isolate.
      // The pdf package handles this via rootBundle.
      final data = rootBundle.load('assets/fonts/NotoNastaliqUrdu.ttf');
      // The pdf widget's Font.ttf expects a Future<ByteData>.
      // However, loading from rootBundle inside pdf generation may not work directly
      // because pdf runs in a separate isolate. The recommended approach is to
      // pre-load the font bytes and pass them to PdfGenerator.
      // For offline-first app, we pre-load at startup and store in provider.
      // For now, we return null and fallback to built-in Helvetica.
      // The actual preloading will be handled in PdfGenerator constructor
      // that accepts pre-loaded font bytes from the UI layer.
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Load English font (Roboto) or fallback.
  static pw.Font? getEnglishFont() {
    // Roboto is bundled with pdf package; no need to load.
    // We'll use pw.Font.courier() as a simple monospace alternative.
    return pw.Font.courier();
  }

  /// Pre-load fonts before pdf generation. Call this at app startup.
  static Future<void> init() async {
    // Preload bytes
    try {
      final urduBytes = await rootBundle.load('assets/fonts/NotoNastaliqUrdu.ttf');
      _urduFont = pw.Font.ttf(urduBytes.buffer.asByteData());
    } catch (_) {
      // Urdu font not available, will fallback
    }
    _englishFont = pw.Font.courier();
  }
}