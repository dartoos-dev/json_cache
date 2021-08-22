import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'json_cache.dart';

/// Persistent preferences file cache.
class JsonCachePrefs implements JsonCache {
  /// [_prefs] a [SharedPreferences] instance.
  const JsonCachePrefs(this._prefs);

  // The preferences file object.
  final SharedPreferences _prefs;

  /// Frees up the preferences file space.
  @override
  Future<void> clear() async {
    await _prefs.clear();
  }

  /// Removes an entry from the preferences file storage at [key].
  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  /// Writes [value] to the preferences file.
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
}
