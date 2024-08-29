// ignore_for_file: avoid_dynamic_calls

import 'dart:collection';

import 'package:json_cache/json_cache.dart';
import 'package:safe_local_storage/safe_local_storage.dart';

/// Implementation on top of the SafeLocalStorage package.
///
/// See: [Safe local storage](https://pub.dev/packages/safe_local_storage)
class JsonCacheSafeLocalStorage implements JsonCache {
  /// Encapsulates a [SafeLocalStorage] instance.
  const JsonCacheSafeLocalStorage(this._localStorage);

  final SafeLocalStorage _localStorage;

  @override
  Future<void> clear() async {
    await _localStorage.delete();
  }

  @override
  Future<bool> contains(String key) async {
    return (await _cachedData).containsKey(key);
  }

  @override
  Future<void> refresh(String key, Map<String, dynamic> value) async {
    final dataCopied = Map<dynamic, dynamic>.of(await _cachedData);
    dataCopied[key] = value;
    await _localStorage.write(dataCopied);
  }

  @override
  Future<void> remove(String key) async {
    final data = await _cachedData;
    if (data.containsKey(key)) {
      data.remove(key);
      await _localStorage.write(data);
    }
  }

  @override
  Future<Map<String, dynamic>?> value(String key) async {
    return (await _cachedData)[key] as Map<String, dynamic>?;
  }

  @override
  Future<UnmodifiableListView<String>> keys() async {
    return UnmodifiableListView(
      (await _cachedData).keys.map((k) => k as String),
    );
  }

  /// Gets the cached data stored in the local storage file.
  Future<Map<dynamic, dynamic>> get _cachedData async {
    return await _localStorage.read() as Map<dynamic, dynamic>;
  }
}
