import 'adjustment.dart';
import 'currency_config.dart';
import 'diner.dart';
import 'shared_item.dart';

enum DiscountType { fixed, percentage }

class ReceiptInput {
  const ReceiptInput({
    required this.diners,
    this.restaurantName = '',
    this.currency = const CurrencyConfig(),
    this.sharedItems = const [],
    this.adjustments = const [],
    this.serviceRate = 0,
    this.taxRate = 0,
    this.discount = 0,
    this.discountType = DiscountType.fixed,
    this.roundingEnabled = false,
    this.roundingUnit = 1,
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
  final double roundingUnit;

  bool get hasBillItems {
    return diners.any((diner) => diner.items.isNotEmpty) ||
        sharedItems.isNotEmpty;
  }
}
