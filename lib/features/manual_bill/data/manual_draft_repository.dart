import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/storage_keys.dart';
import '../../receipt/domain/adjustment.dart';
import '../../receipt/domain/bill_item.dart';
import '../../receipt/domain/currency_config.dart';
import '../../receipt/domain/diner.dart';
import '../../receipt/domain/receipt_input.dart';
import '../../receipt/domain/shared_item.dart';
import '../domain/manual_bill_state.dart';

class ManualDraftRepository {
  const ManualDraftRepository(this._preferences);

  final SharedPreferences _preferences;

  Future<void> save(ManualBillState state) async {
    await _preferences.setString(
      StorageKeys.manualDraft,
      jsonEncode(_toJson(state)),
    );
  }

  ManualBillState? load() {
    final raw = _preferences.getString(StorageKeys.manualDraft);
    if (raw == null) return null;
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return _fromJson(json);
  }

  Future<void> clear() => _preferences.remove(StorageKeys.manualDraft);

  Map<String, dynamic> _toJson(ManualBillState state) => {
    'restaurantName': state.restaurantName,
    'currencyType': state.currency.type.name,
    'customSymbol': state.currency.customSymbol,
    'serviceRate': state.serviceRate,
    'taxRate': state.taxRate,
    'discount': state.discount,
    'discountType': state.discountType.name,
    'roundingEnabled': state.roundingEnabled,
    'nextId': state.nextId,
    'diners': state.diners
        .map(
          (d) => {
            'id': d.id,
            'name': d.name,
            'items': d.items
                .map((i) => {'id': i.id, 'name': i.name, 'amount': i.amount})
                .toList(),
          },
        )
        .toList(),
    'sharedItems': state.sharedItems
        .map(
          (i) => {
            'id': i.id,
            'name': i.name,
            'amount': i.amount,
            'participantIds': i.participantIds.toList(),
          },
        )
        .toList(),
    'adjustments': state.adjustments
        .map((a) => {'id': a.id, 'label': a.label, 'amount': a.amount})
        .toList(),
  };

  ManualBillState _fromJson(Map<String, dynamic> json) {
    final diners = ((json['diners'] as List?) ?? const [])
        .map(
          (d) => Diner(
            id: d['id'] as int,
            name: d['name'] as String? ?? '',
            items: (((d as Map<String, dynamic>)['items'] as List?) ?? const [])
                .map(
                  (i) => BillItem(
                    id: i['id'] as int,
                    name: i['name'] as String? ?? '',
                    amount: (i['amount'] as num?)?.toDouble() ?? 0,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
    final sharedItems = ((json['sharedItems'] as List?) ?? const [])
        .map(
          (i) => SharedItem(
            id: i['id'] as int,
            name: i['name'] as String? ?? '',
            amount: (i['amount'] as num?)?.toDouble() ?? 0,
            participantIds: Set<int>.from(
              (i['participantIds'] as List?) ?? const [],
            ),
          ),
        )
        .toList();
    final adjustments = ((json['adjustments'] as List?) ?? const [])
        .map(
          (a) => Adjustment(
            id: a['id'] as int,
            label: a['label'] as String? ?? '',
            amount: (a['amount'] as num?)?.toDouble() ?? 0,
          ),
        )
        .toList();
    final currencyType = CurrencyType.values.firstWhere(
      (type) => type.name == json['currencyType'],
      orElse: () => CurrencyType.thb,
    );
    final discountType = DiscountType.values.firstWhere(
      (type) => type.name == json['discountType'],
      orElse: () => DiscountType.fixed,
    );

    final maxExistingId = <int>[
      ...diners.map((d) => d.id),
      ...diners.expand((d) => d.items).map((i) => i.id),
      ...sharedItems.map((i) => i.id),
      ...adjustments.map((a) => a.id),
      (json['nextId'] as int?) ?? 1,
    ].fold<int>(0, (max, id) => id > max ? id : max);

    return ManualBillState(
      restaurantName: json['restaurantName'] as String? ?? '',
      currency: CurrencyConfig(
        type: currencyType,
        customSymbol: json['customSymbol'] as String?,
      ),
      diners: diners,
      sharedItems: sharedItems,
      adjustments: adjustments,
      serviceRate: (json['serviceRate'] as num?)?.toDouble() ?? 0,
      taxRate: (json['taxRate'] as num?)?.toDouble() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      discountType: discountType,
      roundingEnabled: json['roundingEnabled'] as bool? ?? false,
      nextId: maxExistingId + 1,
    );
  }
}
