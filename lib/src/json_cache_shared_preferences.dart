import 'dart:collection';
import 'dart:convert';

import 'package:json_cache/json_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistent preferences file cache.
class JsonCacheSharedPreferences implements JsonCache {
  /// Sets the [SharedPreferences] instance.
  const JsonCacheSharedPreferences(this._sharedPreferences);

  // The shared preferences file object.
  final SharedPreferences _sharedPreferences;

  /// Frees up the preferences file space.
  @override
  Future<void> clear() async {
    await _sharedPreferences.clear();
  }

  /// Removes an entry from the preferences file storage at [key].
  @override
  Future<void> remove(String key) async {
    await _sharedPreferences.remove(key);
  }

  /// Writes [value] to the preferences file.
  ///
  /// **Note**: [value] must be json encodable because `json.encode()` is called
  /// under the hood.
  @override
  Future<void> refresh(String key, Map<String, dynamic> value) async {
    await _sharedPreferences.setString(key, json.encode(value));
  }

  /// The value at [key] from the preferences file; it returns null if a cache
  /// miss occurs.
  @override
  Future<Map<String, dynamic>?> value(String key) async {
    final strJson = _sharedPreferences.getString(key);
    return strJson == null
        ? null
        : json.decode(strJson) as Map<String, dynamic>;
  }

  /// Checks whether there is data in the preferences at [key].
  @override
  Future<bool> contains(String key) async {
    return _sharedPreferences.containsKey(key);
  }

  @override
  Future<UnmodifiableListView<String>> keys() async {
    return UnmodifiableListView(_sharedPreferences.getKeys());
  }
}
