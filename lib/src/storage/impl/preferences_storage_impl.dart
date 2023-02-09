import 'package:weblate_sdk/src/storage/preferences_storage.dart';
import 'package:weblate_sdk/src/util/base_preferences.dart';

class PreferencesStorageImpl extends PreferencesStorage {
  final _preferences = BasePreferences();

  @override
  Future<int> getCacheTimestamp() async {
    return _preferences.get<int>(kCacheWriteTimestampKey, -1);
  }

  @override
  Future<void> saveCacheTimestamp(int value) async {
    await _preferences.put<int>(kCacheWriteTimestampKey, value);
  }
}
