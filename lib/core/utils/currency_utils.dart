class CurrencyUtils {
  const CurrencyUtils._();

  static const thaiBaht = '฿';
  static const usDollar = r'$';

  static String normalizeSymbol(String? symbol) {
    final trimmed = symbol?.trim() ?? '';
    return trimmed.isEmpty ? usDollar : trimmed;
  }

  static String formatAmount(
    num amount, {
    String symbol = thaiBaht,
    int fractionDigits = 2,
  }) {
    final normalizedSymbol = normalizeSymbol(symbol);
    return '$normalizedSymbol${amount.toStringAsFixed(fractionDigits)}';
  }
}
