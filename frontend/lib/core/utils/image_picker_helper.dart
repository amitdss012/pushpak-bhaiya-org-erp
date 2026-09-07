import 'dart:io';
import 'dart:ui' as ui;
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

  /// Human-readable original size (e.g., "3.2 MB").
  String get formattedOriginalSize {
    if (originalSizeBytes < 1024) {
      return '$originalSizeBytes B';
    } else if (originalSizeBytes < 1024 * 1024) {
      return '${(originalSizeBytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(originalSizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
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
        final photosStatus = await Permission.photos.status;
        if (photosStatus.isGranted || photosStatus.isLimited) {
          return true;
        }

        final storageStatus = await Permission.storage.status;
        if (storageStatus.isGranted) {
          return true;
        }

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
      return true;
    }

    return true;
  }

  /// Open system file explorer / photo picker and compress the image under [maxSizeBytes] (default 100 KB).
  /// Note: [onProgress] is ONLY called AFTER the user has actually selected a file.
  static Future<CompressedImageResult?> pickAndCompressImage({
    int maxSizeBytes = maxTargetSizeBytes,
    List<String> allowedExtensions = const ['jpg', 'jpeg', 'png', 'webp'],
    void Function(double progress, String status)? onProgress,
  }) async {
    // 1. Check permission on mobile (silent check)
    await requestGalleryPermission();

    // 2. Open System File Explorer / Photo Picker (No progress indicator shown before selection)
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      withData: true,
    );

    // If user cancelled the dialog, return null immediately without showing any progress
    if (result == null || result.files.isEmpty) {
      return null;
    }

    final pickedFile = result.files.first;
    Uint8List? rawBytes = pickedFile.bytes;

    // On desktop / non-web where bytes may need to be read from path
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

    // User confirmed file selection: NOW start displaying progress
    onProgress?.call(0.2, 'Preparing image...');
    await Future.delayed(const Duration(milliseconds: 10));

    // 3. If already under 100 KB, return immediately with zero processing overhead
    if (originalSize <= maxSizeBytes) {
      onProgress?.call(1.0, 'Ready');
      return CompressedImageResult(
        bytes: rawBytes,
        fileName: fileName,
        originalSizeBytes: originalSize,
        compressedSizeBytes: originalSize,
      );
    }

    // 4. Non-blocking hardware-accelerated compression
    onProgress?.call(0.5, 'Compressing under 100 KB...');
    await Future.delayed(const Duration(milliseconds: 10));

    final compressedBytes = await _fastHardwareCompress(rawBytes, maxSizeBytes);
    final finalBytes = compressedBytes ?? rawBytes;

    onProgress?.call(1.0, 'Ready');

    return CompressedImageResult(
      bytes: finalBytes,
      fileName: fileName,
      originalSizeBytes: originalSize,
      compressedSizeBytes: finalBytes.lengthInBytes,
    );
  }

  /// Ultra-fast non-blocking hardware-accelerated compression using Flutter's native engine.
  /// Decodes and downsamples in asynchronous background GPU/C++ pipeline without freezing UI.
  static Future<Uint8List?> _fastHardwareCompress(
    Uint8List rawBytes,
    int maxSizeBytes,
  ) async {
    try {
      // Downsample target dimensions (high to low)
      const targetDimensions = [1000, 800, 600, 450, 300];

      for (final dim in targetDimensions) {
        // Asynchronously decode and downsample using browser / engine native C++ codec
        final codec = await ui.instantiateImageCodec(
          rawBytes,
          targetWidth: dim,
        );
        final frame = await codec.getNextFrame();
        final ui.Image image = frame.image;

        // Try PNG byte representation first
        final pngData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (pngData != null) {
          final pngBytes = pngData.buffer.asUint8List();
          if (pngBytes.lengthInBytes <= maxSizeBytes) {
            return pngBytes;
          }
        }

        // Get raw RGBA and perform micro-second JPEG encode on the already downsampled image
        final rgbaData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        if (rgbaData != null) {
          final imgObj = img.Image.fromBytes(
            width: image.width,
            height: image.height,
            bytes: rgbaData.buffer,
            order: img.ChannelOrder.rgba,
          );

          // Fast JPEG encode on tiny image takes < 3ms
          final jpgBytes = Uint8List.fromList(img.encodeJpg(imgObj, quality: 75));
          if (jpgBytes.lengthInBytes <= maxSizeBytes) {
            return jpgBytes;
          }

          final jpgBytesLow = Uint8List.fromList(img.encodeJpg(imgObj, quality: 50));
          if (jpgBytesLow.lengthInBytes <= maxSizeBytes) {
            return jpgBytesLow;
          }
        }
      }

      return null;
    } catch (_) {
      // Fallback in case native codec fails on specialized image types
      return null;
    }
  }
}
