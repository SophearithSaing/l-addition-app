import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/utils/date_utils.dart';
import '../../../core/utils/slugify.dart';

class ReceiptExportService {
  const ReceiptExportService();

  Future<Uint8List> capturePng(RenderRepaintBoundary boundary) async {
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw StateError('Could not export receipt image.');
    }

    return byteData.buffer.asUint8List();
  }

  Future<void> saveAndSharePng({
    required Uint8List bytes,
    required String restaurantName,
    DateTime? date,
  }) async {
    final fileName = buildFileName(
      restaurantName: restaurantName,
      date: date ?? DateTime.now(),
    );
    final galleryName = fileName.replaceAll('.png', '');

    await ImageGallerySaverPlus.saveImage(
      bytes,
      name: galleryName,
      quality: 100,
    );

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(bytes, mimeType: 'image/png', name: fileName)],
      ),
    );
  }

  String buildFileName({
    required String restaurantName,
    required DateTime date,
  }) {
    final slug = Slugify.call(restaurantName, fallback: 'receipt');
    final datePart = AppDateUtils.formatReceiptDate(
      date,
    ).toLowerCase().replaceAll(' ', '-');
    return '$slug-$datePart.png';
  }
}
