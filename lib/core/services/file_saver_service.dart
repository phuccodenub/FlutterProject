import 'dart:io';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

/// File Saver Service
/// Handles saving files to device storage
class FileSaverService {
  static final Dio _dio = Dio();

  /// Save file from bytes
  static Future<String?> saveFile({
    required Uint8List bytes,
    required String fileName,
    String? mimeType,
  }) async {
    try {
      final String path = await FileSaver.instance.saveFile(
        name: fileName,
        bytes: bytes,
        ext: _getFileExtension(fileName),
        mimeType: mimeType != null ? _parseMimeType(mimeType) : MimeType.other,
      );
      
      if (path.isNotEmpty) {
        debugPrint('✅ File saved: $path');
        return path;
      }

      debugPrint('⚠️ FileSaver returned an empty path while saving "$fileName"');
      return null;
    } catch (e) {
      debugPrint('❌ Error saving file: $e');
      return null;
    }
  }

  /// Save file from File object
  static Future<String?> saveFromFile({
    required File file,
    String? customName,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final fileName = customName ?? file.path.split('/').last;
      
      return await saveFile(
        bytes: bytes,
        fileName: fileName,
      );
    } catch (e) {
      debugPrint('❌ Error saving from file: $e');
      return null;
    }
  }

  /// Download and save file from URL
  static Future<String?> downloadAndSave({
    required String url,
    required String fileName,
    Function(double)? onProgress,
  }) async {
    try {
      debugPrint('📥 Downloading: $url');
      
      // Download file
      final response = await _dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            final progress = received / total;
            onProgress(progress);
            debugPrint('⬇️ Progress: ${(progress * 100).toStringAsFixed(0)}%');
          }
        },
      );

      if (response.statusCode == 200) {
        final bytes = Uint8List.fromList(response.data);
        
        // Save file
        final path = await saveFile(
          bytes: bytes,
          fileName: fileName,
        );
        
        return path;
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error downloading and saving: $e');
      return null;
    }
  }

  /// Save to specific directory
  static Future<String?> saveToDirectory({
    required Uint8List bytes,
    required String fileName,
    required Directory directory,
  }) async {
    try {
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
      debugPrint('✅ File saved to: ${file.path}');
      return file.path;
    } catch (e) {
      debugPrint('❌ Error saving to directory: $e');
      return null;
    }
  }

  /// Save to Downloads folder (Android)
  static Future<String?> saveToDownloads({
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      if (Platform.isAndroid) {
        final directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        return await saveToDirectory(
          bytes: bytes,
          fileName: fileName,
          directory: directory,
        );
      } else if (Platform.isIOS) {
        // iOS doesn't have direct Downloads folder access
        // Use FileSaver which handles platform-specific location
        return await saveFile(
          bytes: bytes,
          fileName: fileName,
        );
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error saving to downloads: $e');
      return null;
    }
  }

  /// Save image to gallery
  static Future<String?> saveImageToGallery({
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      final extension = _getFileExtension(fileName);
      MimeType mimeType;
      
      switch (extension.toLowerCase()) {
        case 'jpg':
        case 'jpeg':
          mimeType = MimeType.jpeg;
          break;
        case 'png':
          mimeType = MimeType.png;
          break;
        default:
          mimeType = MimeType.other;
      }
      
      final String path = await FileSaver.instance.saveFile(
        name: fileName,
        bytes: bytes,
        ext: extension,
        mimeType: mimeType,
      );
      
      if (path.isNotEmpty) {
        debugPrint('✅ Image saved to gallery: $path');
        return path;
      }

      debugPrint('⚠️ FileSaver returned an empty path while saving image "$fileName"');
      return null;
    } catch (e) {
      debugPrint('❌ Error saving image to gallery: $e');
      return null;
    }
  }

  /// Get file extension from filename
  static String _getFileExtension(String fileName) {
    final parts = fileName.split('.');
    if (parts.length > 1) {
      return parts.last;
    }
    return '';
  }

  /// Parse MIME type string to MimeType enum
  static MimeType _parseMimeType(String mimeType) {
    if (mimeType.contains('pdf')) return MimeType.pdf;
    if (mimeType.contains('jpeg') || mimeType.contains('jpg')) return MimeType.jpeg;
    if (mimeType.contains('png')) return MimeType.png;
    if (mimeType.contains('doc')) return MimeType.microsoftWord;
    if (mimeType.contains('xls')) return MimeType.microsoftExcel;
    if (mimeType.contains('ppt')) return MimeType.microsoftPresentation;
    if (mimeType.contains('zip')) return MimeType.zip;
    if (mimeType.contains('video')) return MimeType.avi;
    if (mimeType.contains('audio')) return MimeType.aac;
    return MimeType.other;
  }

  /// Get app documents directory
  static Future<Directory> getAppDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  /// Get temporary directory
  static Future<Directory> getTempDirectory() async {
    return await getTemporaryDirectory();
  }

  /// Check if file exists
  static Future<bool> fileExists(String path) async {
    try {
      final file = File(path);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Delete file
  static Future<bool> deleteFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        debugPrint('✅ File deleted: $path');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error deleting file: $e');
      return false;
    }
  }
}
