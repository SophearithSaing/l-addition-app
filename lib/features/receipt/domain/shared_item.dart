class SharedItem {
  const SharedItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.participantIds,
  });

  final int id;
  final String name;
  final double amount;
  final Set<int> participantIds;

  SharedItem copyWith({
    int? id,
    String? name,
    double? amount,
    Set<int>? participantIds,
  }) {
    return SharedItem(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      participantIds: participantIds ?? this.participantIds,
    );
  }
}
