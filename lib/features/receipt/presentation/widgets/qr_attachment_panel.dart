import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';

class QrAttachmentPanel extends StatelessWidget {
  const QrAttachmentPanel({
    super.key,
    required this.qrBytes,
    required this.isLoading,
    required this.onPick,
    required this.onRemove,
  });

  final Uint8List? qrBytes;
  final bool isLoading;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('QR Code', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Attach a payment QR code to the exported receipt.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (qrBytes != null) ...[
            const SizedBox(height: AppSpacing.md),
            Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Image.memory(
                  qrBytes!,
                  width: 160,
                  height: 160,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          AppButton.secondary(
            label: qrBytes == null ? 'Attach QR Code' : 'Replace QR Code',
            onPressed: isLoading ? null : onPick,
            isLoading: isLoading,
          ),
          if (qrBytes != null) ...[
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: isLoading ? null : onRemove,
              child: const Text('Remove QR Code'),
            ),
          ],
        ],
      ),
    );
  }
}
