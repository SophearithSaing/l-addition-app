import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/storage_keys.dart';

class ManualDraftStorage {
  const ManualDraftStorage(this._preferences);

  final SharedPreferences _preferences;

  String? read() => _preferences.getString(StorageKeys.manualDraft);

  Future<void> write(String value) {
    return _preferences.setString(StorageKeys.manualDraft, value);
  }

  Future<void> clear() {
    return _preferences.remove(StorageKeys.manualDraft);
  }
}
