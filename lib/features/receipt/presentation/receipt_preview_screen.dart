import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/loading_state.dart';
import '../../manual_bill/presentation/manual_bill_controller.dart';
import 'receipt_controller.dart';
import 'widgets/classic_receipt.dart';
import 'widgets/polished_receipt.dart';

class ReceiptPreviewScreen extends ConsumerWidget {
  const ReceiptPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receipt = ref.watch(manualReceiptResultProvider);
    final manualBill = ref.watch(manualBillControllerProvider);
    final variant = ref.watch(receiptVariantProvider);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

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
              if (result.diners.isEmpty)
                const Center(
                  child: Text('Add bill items to preview a receipt.'),
                )
              else
                switch (variant) {
                  ReceiptVariant.classic => ClassicReceipt(
                    restaurantName: restaurantName,
                    currencySymbol: currencySymbol,
                    result: result,
                    date: DateTime.now(),
                  ),
                  ReceiptVariant.polished => PolishedReceipt(
                    restaurantName: restaurantName,
                    currencySymbol: currencySymbol,
                    result: result,
                    date: DateTime.now(),
                  ),
                },
            ],
          );
        },
      ),
    );
  }
}
