import '../../receipt/domain/adjustment.dart';
import '../../receipt/domain/currency_config.dart';
import '../../receipt/domain/diner.dart';
import '../../receipt/domain/receipt_input.dart';
import '../../receipt/domain/shared_item.dart';

class ManualBillState {
  const ManualBillState({
    this.restaurantName = '',
    this.currency = const CurrencyConfig(),
    this.diners = const [],
    this.sharedItems = const [],
    this.adjustments = const [],
    this.serviceRate = 0,
    this.taxRate = 0,
    this.discount = 0,
    this.discountType = DiscountType.fixed,
    this.roundingEnabled = false,
    this.nextId = 1,
  });

  final String restaurantName;
  final CurrencyConfig currency;
  final List<Diner> diners;
  final List<SharedItem> sharedItems;
  final List<Adjustment> adjustments;
  final double serviceRate;
  final double taxRate;
  final double discount;
  final DiscountType discountType;
  final bool roundingEnabled;
  final int nextId;

  bool get hasBillItems =>
      diners.any((diner) => diner.items.isNotEmpty) || sharedItems.isNotEmpty;

  ReceiptInput toReceiptInput() => ReceiptInput(
    restaurantName: restaurantName,
    currency: currency,
    diners: diners,
    sharedItems: sharedItems,
    adjustments: adjustments,
    serviceRate: serviceRate,
    taxRate: taxRate,
    discount: discount,
    discountType: discountType,
    roundingEnabled: roundingEnabled,
  );

  ManualBillState copyWith({
    String? restaurantName,
    CurrencyConfig? currency,
    List<Diner>? diners,
    List<SharedItem>? sharedItems,
    List<Adjustment>? adjustments,
    double? serviceRate,
    double? taxRate,
    double? discount,
    DiscountType? discountType,
    bool? roundingEnabled,
    int? nextId,
  }) {
    return ManualBillState(
      restaurantName: restaurantName ?? this.restaurantName,
      currency: currency ?? this.currency,
      diners: diners ?? this.diners,
      sharedItems: sharedItems ?? this.sharedItems,
      adjustments: adjustments ?? this.adjustments,
      serviceRate: serviceRate ?? this.serviceRate,
      taxRate: taxRate ?? this.taxRate,
      discount: discount ?? this.discount,
      discountType: discountType ?? this.discountType,
      roundingEnabled: roundingEnabled ?? this.roundingEnabled,
      nextId: nextId ?? this.nextId,
    );
  }
}
