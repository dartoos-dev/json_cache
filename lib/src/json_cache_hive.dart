import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:json_cache/json_cache.dart';

/// Implementation on top of the Hive package.
///
/// See: [local storage](https://pub.dev/packages/hive)
class JsonCacheHive implements JsonCache {
  /// Sets the Hive [Box] instance.
  const JsonCacheHive(this._box);

  final Box<String> _box;

  @override
  Future<void> clear() async {
    await _box.clear();
  }

  @override
  Future<void> refresh(String key, Map<String, dynamic> value) async {
    await _box.put(key, json.encode(value));
  }

  @override
  Future<void> remove(String key) async {
    await _box.delete(key);
  }

  @override
  Future<Map<String, dynamic>?> value(String key) async {
    final data = _box.get(key);
    return data == null ? null : json.decode(data) as Map<String, dynamic>;
  }

  @override
  Future<bool> contains(String key) async {
    return _box.containsKey(key);
  }
}
