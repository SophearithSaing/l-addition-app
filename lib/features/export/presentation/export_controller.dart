import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/receipt_export_service.dart';

final receiptExportServiceProvider = Provider<ReceiptExportService>((ref) {
  return const ReceiptExportService();
});

final exportControllerProvider = AsyncNotifierProvider<ExportController, void>(
  ExportController.new,
);

class ExportController extends AsyncNotifier<void> {
  @override
  void build() {}

  Future<void> captureSaveAndShare({
    required RenderRepaintBoundary boundary,
    required String restaurantName,
    DateTime? date,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final service = ref.read(receiptExportServiceProvider);
      final bytes = await service.capturePng(boundary);
      await service.saveAndSharePng(
        bytes: bytes,
        restaurantName: restaurantName,
        date: date,
      );
    });
  }
}
