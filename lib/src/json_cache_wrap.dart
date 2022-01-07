import 'package:json_cache/json_cache.dart';

///  Decorator Envelope of [JsonCache].
///
/// It just forwards method calls to its encapsulated [JsonCache] instance.
abstract class JsonCacheWrap implements JsonCache {
  /// Encapsulates a [JsonCache] instance.
  const JsonCacheWrap(this._wrapped);

  // wrapped instance.
  final JsonCache _wrapped;

  /// Forwards to the [JsonCache.clear] of its wrapped instance.
  @override
  Future<void> clear() => _wrapped.clear();

  /// Forwards to the [JsonCache.remove] of its wrapped instance.
  @override
  Future<void> remove(String key) => _wrapped.remove(key);

  /// Forwards to the [JsonCache.value] of its wrapped instance.
  @override
  Future<Map<String, dynamic>?> value(String key) => _wrapped.value(key);

  /// Forwards to the [JsonCache.refresh] of its wrapped instance.
  @override
  Future<void> refresh(String key, Map<String, dynamic> data) =>
      _wrapped.refresh(key, data);
}
