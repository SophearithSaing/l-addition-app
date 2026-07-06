import '../../../core/utils/currency_utils.dart';

enum CurrencyType { thb, usd, custom }

class CurrencyConfig {
  const CurrencyConfig({this.type = CurrencyType.thb, this.customSymbol});

  final CurrencyType type;
  final String? customSymbol;

  String get symbol {
    return switch (type) {
      CurrencyType.thb => CurrencyUtils.thaiBaht,
      CurrencyType.usd => CurrencyUtils.usDollar,
      CurrencyType.custom => CurrencyUtils.normalizeSymbol(customSymbol),
    };
  }

  CurrencyConfig copyWith({CurrencyType? type, String? customSymbol}) {
    return CurrencyConfig(
      type: type ?? this.type,
      customSymbol: customSymbol ?? this.customSymbol,
    );
  }
}
