import 'json_cache.dart';

///  Decorator Envelope of [JsonCache].
///
/// It just forwards method calls to its encapsulated [JsonCache] instance.
abstract class JsonCacheWrap implements JsonCache {
  /// Ctor.
  const JsonCacheWrap(this._wrapped);

  // wrapped instance.
  final JsonCache _wrapped;

  /// Forwards to its encapsulated [JsonCache] instance.
  @override
  Future<void> clear() => _wrapped.clear();

  /// Forwards to its encapsulated [JsonCache] instance.
  @override
  Future<Map<String, dynamic>?> erase(String key) => _wrapped.erase(key);

  /// Forwards to its encapsulated [JsonCache] instance.
  @override
  Future<Map<String, dynamic>?> recover(String key) => _wrapped.recover(key);

  /// Forwards to its encapsulated [JsonCache] instance.
  @override
  Future<void> refresh(String key, Map<String, dynamic> data) =>
      _wrapped.refresh(key, data);
}
