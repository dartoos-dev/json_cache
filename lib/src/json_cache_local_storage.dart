import 'package:json_cache/json_cache.dart';
import 'package:localstorage/localstorage.dart';

/// Implementation on top of the LocalStorage package.
///
/// See: [local storage](https://pub.dev/packages/localstorage)
class JsonCacheLocalStorage implements JsonCache {
  /// Encapsulates a [LocalStorage] instance.
  JsonCacheLocalStorage(this._storage);

  final LocalStorage _storage;

  Future<bool> get _getReady => _storage.ready;

  @override
  Future<void> clear() async {
    await _getReady;
    await _storage.clear();
  }

  @override
  Future<void> refresh(String key, Map<String, dynamic> value) async {
    await _getReady;
    await _storage.setItem(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await _getReady;
    await _storage.deleteItem(key);
  }

  @override
  Future<Map<String, dynamic>?> value(String key) async {
    await _getReady;
    return await _storage.getItem(key) as Map<String, dynamic>?;
  }

  @override
  Future<bool> contains(String key) async {
    await _getReady;
    final Object? item = _storage.getItem(key);
    return item != null;
  }
}
