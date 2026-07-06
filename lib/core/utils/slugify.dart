class Slugify {
  const Slugify._();

  static String call(String value, {String fallback = 'receipt'}) {
    final slug = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r"[^a-z0-9]+"), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');

    return slug.isEmpty ? fallback : slug;
  }
}
