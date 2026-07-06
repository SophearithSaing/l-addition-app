import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/loading_state.dart';
import '../../export/presentation/export_controller.dart';
import '../../manual_bill/presentation/manual_bill_controller.dart';
import 'qr_attachment_controller.dart';
import 'receipt_controller.dart';
import 'widgets/classic_receipt.dart';
import 'widgets/polished_receipt.dart';
import 'widgets/qr_attachment_panel.dart';
import 'widgets/receipt_action_bar.dart';
import 'widgets/receipt_capture_boundary.dart';

class ReceiptPreviewScreen extends ConsumerWidget {
  const ReceiptPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receipt = ref.watch(manualReceiptResultProvider);
    final manualBill = ref.watch(manualBillControllerProvider);
    final variant = ref.watch(receiptVariantProvider);
    final exportState = ref.watch(exportControllerProvider);
    final qrAttachment = ref.watch(qrAttachmentProvider);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final receiptBoundaryKey = GlobalKey();

    return Scaffold(
      appBar: AppBar(title: const Text('Receipt Preview')),
      body: receipt.when(
        loading: () => const LoadingState(message: 'Preparing receipt…'),
        error: (error, stackTrace) =>
            Center(child: Text('Could not prepare receipt: $error')),
        data: (result) {
          final bill = manualBill.asData?.value;
          final restaurantName = bill?.restaurantName ?? '';
          final currencySymbol = bill?.currency.symbol ?? '฿';
          final receiptDate = DateTime.now();
          final qrBytes = qrAttachment.asData?.value;
          final receiptWidget = switch (variant) {
            ReceiptVariant.classic => ClassicReceipt(
              restaurantName: restaurantName,
              currencySymbol: currencySymbol,
              result: result,
              date: receiptDate,
              qrBytes: qrBytes,
            ),
            ReceiptVariant.polished => PolishedReceipt(
              restaurantName: restaurantName,
              currencySymbol: currencySymbol,
              result: result,
              date: receiptDate,
              qrBytes: qrBytes,
            ),
          };

          return ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.containerPaddingMobile,
              AppSpacing.containerPaddingMobile,
              AppSpacing.containerPaddingMobile,
              AppSpacing.containerPaddingMobile + bottomInset,
            ),
            children: [
              SegmentedButton<ReceiptVariant>(
                segments: const [
                  ButtonSegment(
                    value: ReceiptVariant.classic,
                    label: Text('Classic'),
                  ),
                  ButtonSegment(
                    value: ReceiptVariant.polished,
                    label: Text('Polished'),
                  ),
                ],
                selected: {variant},
                onSelectionChanged: (selection) {
                  ref
                      .read(receiptVariantProvider.notifier)
                      .setVariant(selection.single);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              QrAttachmentPanel(
                qrBytes: qrBytes,
                isLoading: qrAttachment.isLoading,
                onPick: () =>
                    ref.read(qrAttachmentProvider.notifier).pickAndCrop(),
                onRemove: () =>
                    ref.read(qrAttachmentProvider.notifier).remove(),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (result.diners.isEmpty)
                const Center(
                  child: Text('Add bill items to preview a receipt.'),
                )
              else ...[
                ReceiptCaptureBoundary(
                  boundaryKey: receiptBoundaryKey,
                  child: receiptWidget,
                ),
                const SizedBox(height: AppSpacing.lg),
                ReceiptActionBar(
                  isSharing: exportState.isLoading,
                  onShare: exportState.isLoading
                      ? null
                      : () async {
                          final boundary =
                              receiptBoundaryKey.currentContext
                                      ?.findRenderObject()
                                  as RenderRepaintBoundary?;

                          if (boundary == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Receipt is not ready to export.',
                                ),
                              ),
                            );
                            return;
                          }

                          await ref
                              .read(exportControllerProvider.notifier)
                              .captureSaveAndShare(
                                boundary: boundary,
                                restaurantName: restaurantName,
                                date: receiptDate,
                              );

                          final error = ref
                              .read(exportControllerProvider)
                              .error;
                          if (error != null && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Export failed: $error')),
                            );
                          }
                        },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
