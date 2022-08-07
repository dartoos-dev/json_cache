import 'dart:convert';

import 'package:cross_local_storage/cross_local_storage.dart';
import 'package:json_cache/json_cache.dart';

/// [JsonCache] on top of the Cross Local Storage package.
///
/// See:
/// - [cross local storage](https://pub.dev/packages/cross_local_storage)
class JsonCacheCrossLocalStorage implements JsonCache {
  /// Ctor.
  JsonCacheCrossLocalStorage(this._prefs);

  final LocalStorageInterface _prefs;

  /// Clears user preferences.
  @override
  Future<void> clear() async {
    await _prefs.clear();
  }

  /// Removes an entry located at [key] from persistence storage
  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  /// Writes [value] to persistence storage.
  ///
  /// **Note**: [value] must be json encodable — `json.encode()` is called under
  /// the hood.
  @override
  Future<void> refresh(String key, Map<String, dynamic> value) async {
    await _prefs.setString(key, json.encode(value));
  }

  /// The value at [key] from the preferences file; it returns null if a cache
  /// miss occurs.
  @override
  Future<Map<String, dynamic>?> value(String key) async {
    final strJson = _prefs.getString(key);
    return strJson == null
        ? null
        : json.decode(strJson) as Map<String, dynamic>;
  }

  /// Checks whether there is cached data at [key].
  @override
  Future<bool> contains(String key) async {
    return _prefs.containsKey(key);
  }
}
