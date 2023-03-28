// ignore_for_file: avoid_dynamic_calls

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
    final item = await _localStorage.read();
    return item[key] != null;
  }

  @override
  Future<void> refresh(String key, Map<String, dynamic> value) async {
    final data = {key: value};
    await _localStorage.write(data);
  }

  @override
  Future<void> remove(String key) async {
    final data = await _localStorage.read() as Map<String, dynamic>;
    data.removeWhere((keyMap, valueMap) => keyMap == key);
    await _localStorage.write(data);
  }

  @override
  Future<Map<String, dynamic>?> value(String key) async {
    final data = await _localStorage.read();
    return data[key] == null ? null : data[key] as Map<String, dynamic>;
  }
}
