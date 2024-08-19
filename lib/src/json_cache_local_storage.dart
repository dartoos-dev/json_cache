import 'dart:convert';

import 'package:json_cache/json_cache.dart';
import 'package:localstorage/localstorage.dart';

/// {@template json_cache_local_storage}
///
/// Implementation on top of the LocalStorage package.
///
/// Before using it, don't forget to call:
///
/// ```dart
///   WidgetsFlutterBinding.ensureInitialized();
///   await initLocalStorage();
/// ```
///
/// See: [local storage](https://pub.dev/packages/localstorage)
///
/// {@endtemplate}
final class JsonCacheLocalStorage implements JsonCache {
  /// {@macro json_cache_local_storage}
  JsonCacheLocalStorage([LocalStorage? customLocalStorage])
      : _storage = customLocalStorage ?? localStorage;

  final LocalStorage _storage;

  @override
  Future<void> clear() async => _storage.clear();

  @override
  Future<void> refresh(String key, Map<String, dynamic> value) async =>
      _storage.setItem(key, json.encode(value));

  @override
  Future<void> remove(String key) async => _storage.removeItem(key);

  @override
  Future<Map<String, dynamic>?> value(String key) async {
    final strJson = _storage.getItem(key);
    return strJson == null
        ? null
        : json.decode(strJson) as Map<String, dynamic>;
  }

  @override
  Future<bool> contains(String key) async => _storage.getItem(key) != null;
}
