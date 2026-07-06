import 'dart:math' as math;

import 'receipt_input.dart';
import 'receipt_result.dart';

class ReceiptCalculator {
  const ReceiptCalculator._();

  static ReceiptResult calculate(ReceiptInput input) {
    final diners = input.diners;

    if (diners.isEmpty) {
      return ReceiptResult.empty(adjustmentRows: input.adjustments);
    }

    final validDinerIds = diners.map((diner) => diner.id).toSet();
    final dinerSubtotals = <int, double>{};
    final allocatedSharedItems = <int, List<AllocatedSharedItem>>{
      for (final diner in diners) diner.id: <AllocatedSharedItem>[],
    };

    for (final diner in diners) {
      dinerSubtotals[diner.id] = diner.items.fold<double>(
        0,
        (sum, item) => sum + item.amount,
      );
    }

    for (final sharedItem in input.sharedItems) {
      final participantIds = sharedItem.participantIds
          .where(validDinerIds.contains)
          .toList(growable: false);

      if (participantIds.isEmpty) continue;

      final splitAmount = sharedItem.amount / participantIds.length;
      for (final dinerId in participantIds) {
        dinerSubtotals[dinerId] = (dinerSubtotals[dinerId] ?? 0) + splitAmount;
        allocatedSharedItems[dinerId]!.add(
          AllocatedSharedItem(item: sharedItem, amount: splitAmount),
        );
      }
    }

    final subtotal = dinerSubtotals.values.fold<double>(0, _sum);
    final service = subtotal * input.serviceRate / 100;
    final taxableTotal = subtotal + service;
    final tax = taxableTotal * input.taxRate / 100;
    final adjustments = input.adjustments.fold<double>(
      0,
      (sum, adjustment) => sum + adjustment.amount,
    );
    final preDiscountTotal = subtotal + service + tax + adjustments;
    final discount = switch (input.discountType) {
      DiscountType.fixed => input.discount,
      DiscountType.percentage => preDiscountTotal * input.discount / 100,
    };
    final exactTotal = math.max(0.0, preDiscountTotal - discount).toDouble();
    final receiptTotal = input.roundingEnabled
        ? _roundToNearestUnit(exactTotal, input.roundingUnit)
        : exactTotal;

    final dinerCount = diners.length;
    final adjustmentShare = dinerCount == 0 ? 0.0 : adjustments / dinerCount;
    final fixedDiscountShare = dinerCount == 0 ? 0.0 : discount / dinerCount;

    final unroundedDinerResults = <DinerReceiptResult>[];

    for (final diner in diners) {
      final dinerSubtotal = dinerSubtotals[diner.id] ?? 0;
      final dinerService = dinerSubtotal * input.serviceRate / 100;
      final dinerTax = (dinerSubtotal + dinerService) * input.taxRate / 100;
      final dinerPreDiscount =
          dinerSubtotal + dinerService + dinerTax + adjustmentShare;
      final dinerDiscount = switch (input.discountType) {
        DiscountType.fixed => fixedDiscountShare,
        DiscountType.percentage =>
          preDiscountTotal == 0
              ? 0.0
              : discount * (dinerPreDiscount / preDiscountTotal),
      };
      final dinerExactTotal = math
          .max(0.0, dinerPreDiscount - dinerDiscount)
          .toDouble();

      unroundedDinerResults.add(
        DinerReceiptResult(
          dinerId: diner.id,
          dinerName: diner.name,
          items: diner.items,
          sharedItems: allocatedSharedItems[diner.id] ?? const [],
          subtotal: dinerSubtotal,
          service: dinerService,
          tax: dinerTax,
          adjustments: adjustmentShare,
          discount: dinerDiscount,
          exactTotal: dinerExactTotal,
          rounding: 0,
          total: dinerExactTotal,
        ),
      );
    }

    final roundedDinerResults = input.roundingEnabled
        ? _allocateRoundedTotals(
            unroundedDinerResults,
            receiptTotal,
            input.roundingUnit,
          )
        : unroundedDinerResults;

    return ReceiptResult(
      diners: roundedDinerResults,
      adjustmentRows: input.adjustments,
      subtotal: subtotal,
      service: service,
      tax: tax,
      adjustments: adjustments,
      discount: discount,
      exactTotal: exactTotal,
      rounding: receiptTotal - exactTotal,
      total: receiptTotal,
    );
  }

  static double _sum(double a, double b) => a + b;

  static double _roundToNearestUnit(double value, double unit) {
    if (unit <= 0) return value;
    return (value / unit).round() * unit;
  }

  static List<DinerReceiptResult> _allocateRoundedTotals(
    List<DinerReceiptResult> diners,
    double receiptTotal,
    double unit,
  ) {
    if (diners.isEmpty || unit <= 0) return diners;

    final floors = <int, double>{};
    final remainders = <_Remainder>[];

    for (var index = 0; index < diners.length; index++) {
      final diner = diners[index];
      final floored = (diner.exactTotal / unit).floor() * unit;
      floors[diner.dinerId] = floored.toDouble();
      remainders.add(
        _Remainder(
          dinerId: diner.dinerId,
          index: index,
          amount: diner.exactTotal - floored,
        ),
      );
    }

    final flooredTotal = floors.values.fold<double>(0, _sum);
    final unitsToDistribute = math.max(
      0,
      ((receiptTotal - flooredTotal) / unit).round(),
    );

    remainders.sort((a, b) {
      final remainderComparison = b.amount.compareTo(a.amount);
      if (remainderComparison != 0) return remainderComparison;
      return a.index.compareTo(b.index);
    });

    for (
      var index = 0;
      index < unitsToDistribute && index < remainders.length;
      index++
    ) {
      final dinerId = remainders[index].dinerId;
      floors[dinerId] = (floors[dinerId] ?? 0) + unit;
    }

    return diners
        .map((diner) {
          final roundedTotal = floors[diner.dinerId] ?? diner.exactTotal;
          return DinerReceiptResult(
            dinerId: diner.dinerId,
            dinerName: diner.dinerName,
            items: diner.items,
            sharedItems: diner.sharedItems,
            subtotal: diner.subtotal,
            service: diner.service,
            tax: diner.tax,
            adjustments: diner.adjustments,
            discount: diner.discount,
            exactTotal: diner.exactTotal,
            rounding: roundedTotal - diner.exactTotal,
            total: roundedTotal,
          );
        })
        .toList(growable: false);
  }
}

class _Remainder {
  const _Remainder({
    required this.dinerId,
    required this.index,
    required this.amount,
  });

  final int dinerId;
  final int index;
  final double amount;
}
