import 'adjustment.dart';
import 'bill_item.dart';
import 'shared_item.dart';

class AllocatedSharedItem {
  const AllocatedSharedItem({required this.item, required this.amount});

  final SharedItem item;
  final double amount;
}

class DinerReceiptResult {
  const DinerReceiptResult({
    required this.dinerId,
    required this.dinerName,
    required this.items,
    required this.sharedItems,
    required this.subtotal,
    required this.service,
    required this.tax,
    required this.adjustments,
    required this.discount,
    required this.exactTotal,
    required this.rounding,
    required this.total,
  });

  final int dinerId;
  final String dinerName;
  final List<BillItem> items;
  final List<AllocatedSharedItem> sharedItems;
  final double subtotal;
  final double service;
  final double tax;
  final double adjustments;
  final double discount;
  final double exactTotal;
  final double rounding;
  final double total;
}

class ReceiptResult {
  const ReceiptResult({
    required this.diners,
    required this.adjustmentRows,
    required this.subtotal,
    required this.service,
    required this.tax,
    required this.adjustments,
    required this.discount,
    required this.exactTotal,
    required this.rounding,
    required this.total,
  });

  final List<DinerReceiptResult> diners;
  final List<Adjustment> adjustmentRows;
  final double subtotal;
  final double service;
  final double tax;
  final double adjustments;
  final double discount;
  final double exactTotal;
  final double rounding;
  final double total;
}
