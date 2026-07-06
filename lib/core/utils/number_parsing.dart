class NumberParsing {
  const NumberParsing._();

  static double? parseNonNegative(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return null;

    final parsed = double.tryParse(normalized);
    if (parsed == null || parsed.isNaN || parsed.isInfinite || parsed < 0) {
      return null;
    }

    return parsed;
  }

  static bool isValidNonNegative(String value) {
    return parseNonNegative(value) != null;
  }
}
