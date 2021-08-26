import 'dart:convert';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'json_cache.dart';

/// Shared Preferences as encrypted values.
///
/// See also:
/// -
/// [encrypted_shared_preferences](https://pub.dev/packages/encrypted_shared_preferences)
class JsonCacheEncPrefs implements JsonCache {
  /// [_encPrefs] an [EncryptedSharedPreferences] instance.
  JsonCacheEncPrefs(this._encPrefs);

  // The encrypted preferences file object.
  final EncryptedSharedPreferences _encPrefs;

  @override
  Future<void> clear() async {
    await _encPrefs.clear();
  }

  @override
  Future<void> refresh(String key, Map<String, dynamic> value) async {
    await _encPrefs.setString(key, json.encode(value));
  }

  @override
  Future<void> remove(String key) async {
    await (await _encPrefs.getInstance()).remove(key);
  }

  @override
  Future<Map<String, dynamic>?> value(String key) async {
    final shrPrefs = await _encPrefs.getInstance();
    if (shrPrefs.containsKey(key)) {
      return json.decode(await _encPrefs.getString(key))
          as Map<String, dynamic>;
    }
    return null;
  }
}
