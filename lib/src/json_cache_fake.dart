import 'package:json_cache/json_cache.dart';

/// In-memory cache. It is intended for unit testing and prototyping.
///
/// **Warning**: do not use it in production code. It is not thread safe.
class JsonCacheFake implements JsonCache {
  /// Default ctor. Shares a static memory with other instances.
  JsonCacheFake() : this.mem(_shrMem);

  /// Cache with custom memory.
  JsonCacheFake.mem(this._memory);

  /// in-memory storage.
  final Map<String, Map<String, dynamic>?> _memory;

  static final Map<String, Map<String, dynamic>> _shrMem = {};

  /// Clears the internal map.
  @override
  Future<void> clear() async => _memory.clear();

  /// Updates data located at [key].
  @override
  Future<void> refresh(String key, Map<String, dynamic> data) async =>
      _memory[key] = Map<String, dynamic>.of(data);

  /// Removes data located at [key].
  @override
  Future<Map<String, dynamic>?> erase(String key) async => _memory.remove(key);

  /// Retrieves the data at [key] or null if there is no data.
  @override
  Future<Map<String, dynamic>?> recover(String key) async {
    final cached = _memory[key];
    return cached == null ? cached : Map<String, dynamic>.of(cached);
  }
}
