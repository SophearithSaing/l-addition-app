import '../constants/supported_file_types.dart';

class FileValidationResult {
  const FileValidationResult._({this.error});

  const FileValidationResult.valid() : this._();

  const FileValidationResult.invalid(String error) : this._(error: error);

  final String? error;

  bool get isValid => error == null;
}

class FileUtils {
  const FileUtils._();

  static FileValidationResult validateReceiptImage({
    required int sizeBytes,
    required String mimeType,
  }) {
    if (!SupportedFileTypes.receiptImageMimeTypes.contains(mimeType)) {
      return const FileValidationResult.invalid(
        'Unsupported image type. Use PNG, JPG, or WebP.',
      );
    }

    if (sizeBytes > SupportedFileTypes.maxReceiptImageSizeBytes) {
      return const FileValidationResult.invalid(
        'Image must be smaller than 10 MB.',
      );
    }

    return const FileValidationResult.valid();
  }
}
