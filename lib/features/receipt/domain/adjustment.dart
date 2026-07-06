class Adjustment {
  const Adjustment({
    required this.id,
    required this.label,
    required this.amount,
  });

  final int id;
  final String label;
  final double amount;

  Adjustment copyWith({int? id, String? label, double? amount}) {
    return Adjustment(
      id: id ?? this.id,
      label: label ?? this.label,
      amount: amount ?? this.amount,
    );
  }
}
