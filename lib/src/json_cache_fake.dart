import 'package:json_cache/json_cache.dart';

/// In-memory cache without synchronization.
///
/// It is intended for unit testing and prototyping.
///
/// **Warning**: do not use it in production code. It is not thread safe.
class JsonCacheFake implements JsonCache {
  /// It will share a static memory with other instances.
  JsonCacheFake() : this.mem(_shrMem);

  /// Initializes the cache with [init] — by performing a deep copy.
  JsonCacheFake.init(Map<String, Map<String, dynamic>?> init)
      : this.mem(Map<String, Map<String, dynamic>?>.of(init));

  /// Cache with custom memory.
  JsonCacheFake.mem(this._memory);

  /// in-memory storage.
  final Map<String, Map<String, dynamic>?> _memory;

  static late final Map<String, Map<String, dynamic>?> _shrMem = {};

  /// Clears the internal map.
  @override
  Future<void> clear() async => _memory.clear();

  /// Updates data located at [key].
  @override
  Future<void> refresh(String key, Map<String, dynamic> data) async =>
      _memory[key] = Map<String, dynamic>.of(data);

  /// Removes data located at [key].
  @override
  Future<void> remove(String key) async => _memory.remove(key);

  /// Retrieves a copy of the data at [key] or null if there is no data.
  @override
  Future<Map<String, dynamic>?> value(String key) async {
    final cached = _memory[key];
    return cached == null ? null : Map<String, dynamic>.of(cached);
  }
}
