class BillItem {
  const BillItem({required this.id, required this.name, required this.amount});

  final int id;
  final String name;
  final double amount;

  BillItem copyWith({int? id, String? name, double? amount}) {
    return BillItem(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
    );
  }
}
