import 'bill_item.dart';

class Diner {
  const Diner({required this.id, required this.name, this.items = const []});

  final int id;
  final String name;
  final List<BillItem> items;

  Diner copyWith({int? id, String? name, List<BillItem>? items}) {
    return Diner(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
    );
  }
}
