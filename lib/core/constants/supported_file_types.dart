class SupportedFileTypes {
  const SupportedFileTypes._();

  static const maxReceiptImageSizeBytes = 10 * 1024 * 1024;

  static const receiptImageMimeTypes = <String>{
    'image/png',
    'image/jpeg',
    'image/webp',
  };

  static const receiptImageExtensions = <String>{
    'png',
    'jpg',
    'jpeg',
    'webp',
  };
}
