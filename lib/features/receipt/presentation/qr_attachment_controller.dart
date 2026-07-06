import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

final qrAttachmentProvider =
    AsyncNotifierProvider<QrAttachmentController, Uint8List?>(
      QrAttachmentController.new,
    );

class QrAttachmentController extends AsyncNotifier<Uint8List?> {
  final ImagePicker _picker = ImagePicker();

  @override
  Uint8List? build() => null;

  Future<void> pickAndCrop() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.png,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop QR Code',
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop QR Code',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (cropped == null) return state.asData?.value;
      return cropped.readAsBytes();
    });
  }

  void remove() {
    state = const AsyncData(null);
  }
}
