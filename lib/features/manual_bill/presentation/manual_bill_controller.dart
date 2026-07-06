import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../receipt/domain/adjustment.dart';
import '../../receipt/domain/bill_item.dart';
import '../../receipt/domain/currency_config.dart';
import '../../receipt/domain/diner.dart';
import '../../receipt/domain/receipt_input.dart';
import '../../receipt/domain/shared_item.dart';
import '../data/manual_draft_repository.dart';
import '../domain/manual_bill_state.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

final manualBillControllerProvider =
    AsyncNotifierProvider<ManualBillController, ManualBillState>(
      ManualBillController.new,
    );

class ManualBillController extends AsyncNotifier<ManualBillState> {
  ManualDraftRepository? _repository;

  @override
  Future<ManualBillState> build() async {
    final preferences = await ref.watch(sharedPreferencesProvider.future);
    _repository = ManualDraftRepository(preferences);
    return _repository!.load() ?? const ManualBillState();
  }

  void setRestaurantName(String value) =>
      _update((state) => state.copyWith(restaurantName: value));

  void setCurrency(CurrencyConfig value) =>
      _update((state) => state.copyWith(currency: value));

  void setServiceRate(double value) =>
      _update((state) => state.copyWith(serviceRate: value));

  void setTaxRate(double value) =>
      _update((state) => state.copyWith(taxRate: value));

  void setDiscount(double value) =>
      _update((state) => state.copyWith(discount: value));

  void setDiscountType(DiscountType value) =>
      _update((state) => state.copyWith(discountType: value));

  void setRoundingEnabled(bool value) =>
      _update((state) => state.copyWith(roundingEnabled: value));

  void addDiner() => _update((state) {
    final id = state.nextId;
    return state.copyWith(
      diners: [
        ...state.diners,
        Diner(id: id, name: ''),
      ],
      nextId: id + 1,
    );
  });

  void updateDinerName(int dinerId, String name) => _update((state) {
    return state.copyWith(
      diners: state.diners
          .map((d) => d.id == dinerId ? d.copyWith(name: name) : d)
          .toList(),
    );
  });

  void removeDiner(int dinerId) => _update((state) {
    return state.copyWith(
      diners: state.diners.where((d) => d.id != dinerId).toList(),
      sharedItems: state.sharedItems
          .map(
            (item) => item.copyWith(
              participantIds: {...item.participantIds}..remove(dinerId),
            ),
          )
          .toList(),
    );
  });

  void addDinerItem(int dinerId) => _update((state) {
    final id = state.nextId;
    return state.copyWith(
      diners: state.diners
          .map(
            (d) => d.id == dinerId
                ? d.copyWith(
                    items: [
                      ...d.items,
                      BillItem(id: id, name: '', amount: 0),
                    ],
                  )
                : d,
          )
          .toList(),
      nextId: id + 1,
    );
  });

  void updateDinerItem(
    int dinerId,
    int itemId, {
    String? name,
    double? amount,
  }) => _update((state) {
    return state.copyWith(
      diners: state.diners
          .map(
            (d) => d.id == dinerId
                ? d.copyWith(
                    items: d.items
                        .map(
                          (i) => i.id == itemId
                              ? i.copyWith(name: name, amount: amount)
                              : i,
                        )
                        .toList(),
                  )
                : d,
          )
          .toList(),
    );
  });

  void removeDinerItem(int dinerId, int itemId) => _update((state) {
    return state.copyWith(
      diners: state.diners
          .map(
            (d) => d.id == dinerId
                ? d.copyWith(
                    items: d.items.where((i) => i.id != itemId).toList(),
                  )
                : d,
          )
          .toList(),
    );
  });

  void addSharedItem() => _update((state) {
    final id = state.nextId;
    return state.copyWith(
      sharedItems: [
        ...state.sharedItems,
        SharedItem(
          id: id,
          name: '',
          amount: 0,
          participantIds: state.diners.map((d) => d.id).toSet(),
        ),
      ],
      nextId: id + 1,
    );
  });

  void updateSharedItem(
    int itemId, {
    String? name,
    double? amount,
    Set<int>? participantIds,
  }) => _update((state) {
    return state.copyWith(
      sharedItems: state.sharedItems
          .map(
            (item) => item.id == itemId
                ? item.copyWith(
                    name: name,
                    amount: amount,
                    participantIds: participantIds,
                  )
                : item,
          )
          .toList(),
    );
  });

  void removeSharedItem(int itemId) => _update((state) {
    return state.copyWith(
      sharedItems: state.sharedItems
          .where((item) => item.id != itemId)
          .toList(),
    );
  });

  void addAdjustment() => _update((state) {
    final id = state.nextId;
    return state.copyWith(
      adjustments: [
        ...state.adjustments,
        Adjustment(id: id, label: '', amount: 0),
      ],
      nextId: id + 1,
    );
  });

  void updateAdjustment(int adjustmentId, {String? label, double? amount}) =>
      _update((state) {
        return state.copyWith(
          adjustments: state.adjustments
              .map(
                (adjustment) => adjustment.id == adjustmentId
                    ? adjustment.copyWith(label: label, amount: amount)
                    : adjustment,
              )
              .toList(),
        );
      });

  void removeAdjustment(int adjustmentId) => _update((state) {
    return state.copyWith(
      adjustments: state.adjustments
          .where((a) => a.id != adjustmentId)
          .toList(),
    );
  });

  Future<void> clearBill() async {
    state = const AsyncData(ManualBillState());
    await _repository?.clear();
  }

  void _update(ManualBillState Function(ManualBillState state) transform) {
    final current = state.asData?.value;
    if (current == null) return;
    final next = transform(current);
    state = AsyncData(next);
    _repository?.save(next);
  }
}
