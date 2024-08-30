import 'dart:collection';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:json_cache/json_cache.dart';

/// Implementation on top of the Hive package.
///
/// See: [hive](https://pub.dev/packages/hive)
final class JsonCacheHive implements JsonCache {
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

  @override
  Future<UnmodifiableListView<String>> keys() async {
    return UnmodifiableListView(
      _box.keys.map((k) => k as String).toList(growable: false),
    );
  }
}
