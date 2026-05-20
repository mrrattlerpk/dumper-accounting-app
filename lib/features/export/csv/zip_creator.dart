import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';

/// Bundles multiple files into a ZIP archive.
class ZipCreator {
  ZipCreator._();

  /// Creates a ZIP file containing the given list of file paths.
  /// Returns the path of the generated ZIP file.
  static Future<String> createZip({
    required List<String> filePaths,
    required String zipFileName,
  }) async {
    final archive = Archive();
    for (final path in filePaths) {
      final file = File(path);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        archive.addFile(ArchiveFile(
          file.uri.pathSegments.last,
          bytes.length,
          bytes,
        ));
      }
    }
    final encoder = ZipEncoder();
    final zipData = encoder.encode(archive);

    final dir = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${dir.path}/exports');
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    final zipPath = '${exportDir.path}/$zipFileName.zip';
    final zipFile = File(zipPath);
    await zipFile.writeAsBytes(zipData);
    return zipPath;
  }
}