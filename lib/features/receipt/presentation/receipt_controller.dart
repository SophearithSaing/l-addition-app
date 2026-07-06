import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../manual_bill/presentation/manual_bill_controller.dart';
import '../domain/receipt_calculator.dart';
import '../domain/receipt_result.dart';

enum ReceiptVariant { classic, polished }

final receiptVariantProvider =
    NotifierProvider<ReceiptVariantController, ReceiptVariant>(
      ReceiptVariantController.new,
    );

class ReceiptVariantController extends Notifier<ReceiptVariant> {
  @override
  ReceiptVariant build() => ReceiptVariant.classic;

  void setVariant(ReceiptVariant variant) {
    state = variant;
  }
}

final manualReceiptResultProvider = Provider<AsyncValue<ReceiptResult>>((ref) {
  final manualBill = ref.watch(manualBillControllerProvider);

  return manualBill.whenData((bill) {
    return ReceiptCalculator.calculate(bill.toReceiptInput());
  });
});
