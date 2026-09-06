import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

/// Encapsulated result returned by [ImagePickerHelper].
class CompressedImageResult {
  final Uint8List bytes;
  final String fileName;
  final int originalSizeBytes;
  final int compressedSizeBytes;

  const CompressedImageResult({
    required this.bytes,
    required this.fileName,
    required this.originalSizeBytes,
    required this.compressedSizeBytes,
  });

  /// Human-readable compressed size (e.g., "78.4 KB").
  String get formattedSize {
    if (compressedSizeBytes < 1024) {
      return '$compressedSizeBytes B';
    } else if (compressedSizeBytes < 1024 * 1024) {
      return '${(compressedSizeBytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(compressedSizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }
}

/// Helper utility for selecting and compressing images under 100 KB across all platforms.
class ImagePickerHelper {
  /// Maximum default file size in bytes (100 KB).
  static const int maxTargetSizeBytes = 100 * 1024; // 102,400 bytes

  /// Request permissions on mobile if needed.
  static Future<bool> requestGalleryPermission() async {
    if (kIsWeb) return true;

    try {
      if (Platform.isAndroid) {
        // Android 13+ (API 33+) uses photos permission, older Android uses storage
        final photosStatus = await Permission.photos.status;
        if (photosStatus.isGranted || photosStatus.isLimited) {
          return true;
        }

        final storageStatus = await Permission.storage.status;
        if (storageStatus.isGranted) {
          return true;
        }

        // Request appropriate permission
        final photosReq = await Permission.photos.request();
        if (photosReq.isGranted || photosReq.isLimited) {
          return true;
        }

        final storageReq = await Permission.storage.request();
        return storageReq.isGranted;
      } else if (Platform.isIOS) {
        final status = await Permission.photos.request();
        return status.isGranted || status.isLimited;
      }
    } catch (_) {
      // Fall back to allowing file_picker to attempt system picker
      return true;
    }

    return true;
  }

  /// Open system file explorer / photo picker and compress the image under [maxSizeBytes] (default 100 KB).
  static Future<CompressedImageResult?> pickAndCompressImage({
    int maxSizeBytes = maxTargetSizeBytes,
    List<String> allowedExtensions = const ['jpg', 'jpeg', 'png', 'webp'],
  }) async {
    // 1. Request permission on mobile
    await requestGalleryPermission();

    // 2. Open System File Explorer / Photo Picker
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final pickedFile = result.files.first;
    Uint8List? rawBytes = pickedFile.bytes;

    // On desktop / non-web where bytes may not be loaded directly
    if (rawBytes == null && pickedFile.path != null && !kIsWeb) {
      final file = File(pickedFile.path!);
      if (await file.exists()) {
        rawBytes = await file.readAsBytes();
      }
    }

    if (rawBytes == null || rawBytes.isEmpty) {
      return null;
    }

    final originalSize = rawBytes.lengthInBytes;
    final fileName = pickedFile.name;

    // 3. If already under 100 KB, return immediately
    if (originalSize <= maxSizeBytes) {
      return CompressedImageResult(
        bytes: rawBytes,
        fileName: fileName,
        originalSizeBytes: originalSize,
        compressedSizeBytes: originalSize,
      );
    }

    // 4. Compress the image in-memory under 100 KB
    final compressedBytes = await compute(
      _compressImageWorker,
      _CompressionPayload(rawBytes, maxSizeBytes),
    );

    final finalBytes = compressedBytes ?? rawBytes;

    return CompressedImageResult(
      bytes: finalBytes,
      fileName: fileName,
      originalSizeBytes: originalSize,
      compressedSizeBytes: finalBytes.lengthInBytes,
    );
  }

  /// Worker function executed in isolate for smooth UI performance.
  static Uint8List? _compressImageWorker(_CompressionPayload payload) {
    try {
      final decoded = img.decodeImage(payload.rawBytes);
      if (decoded == null) return null;

      img.Image currentImage = decoded;

      // Downscale if image dimensions are very large
      const maxInitialDim = 1200;
      if (currentImage.width > maxInitialDim || currentImage.height > maxInitialDim) {
        if (currentImage.width >= currentImage.height) {
          currentImage = img.copyResize(currentImage, width: maxInitialDim);
        } else {
          currentImage = img.copyResize(currentImage, height: maxInitialDim);
        }
      }

      // Quality tiers to test
      final qualitySteps = [80, 65, 50, 35, 20, 15];

      for (final quality in qualitySteps) {
        final encoded = Uint8List.fromList(
          img.encodeJpg(currentImage, quality: quality),
        );
        if (encoded.lengthInBytes <= payload.maxSizeBytes) {
          return encoded;
        }
      }

      // If still above 100 KB, progressively downsample dimensions
      var dim = 800;
      while (dim >= 200) {
        if (currentImage.width >= currentImage.height) {
          currentImage = img.copyResize(currentImage, width: dim);
        } else {
          currentImage = img.copyResize(currentImage, height: dim);
        }

        final encoded = Uint8List.fromList(
          img.encodeJpg(currentImage, quality: 40),
        );
        if (encoded.lengthInBytes <= payload.maxSizeBytes) {
          return encoded;
        }
        dim -= 200;
      }

      // Final fallback lowest compression
      return Uint8List.fromList(
        img.encodeJpg(currentImage, quality: 15),
      );
    } catch (_) {
      return null;
    }
  }
}

class _CompressionPayload {
  final Uint8List rawBytes;
  final int maxSizeBytes;

  const _CompressionPayload(this.rawBytes, this.maxSizeBytes);
}
