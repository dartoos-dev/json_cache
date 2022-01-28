import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:json_cache/json_cache.dart';

/// Stores data in secure storage.
///
/// See also:
/// - [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage).
class JsonCacheSecStorage implements JsonCache {
  /// Sets the [FlutterSecureStorage] instance.
  const JsonCacheSecStorage(this._storage);

  // the encapsulated [FlutterSecureStorage] instance.
  final FlutterSecureStorage _storage;

  @override
  Future<void> clear() async {
    await _storage.deleteAll();
  }

  @override
  Future<void> refresh(String key, Map<String, dynamic> value) async {
    await _storage.write(key: key, value: json.encode(value));
  }

  @override
  Future<void> remove(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<Map<String, dynamic>?> value(String key) async {
    final encrypted = await _storage.read(key: key);
    return encrypted == null
        ? null
        : json.decode(encrypted) as Map<String, dynamic>;
  }
}
