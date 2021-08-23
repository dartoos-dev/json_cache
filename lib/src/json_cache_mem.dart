import 'package:mutex/mutex.dart';

import 'json_cache.dart';

/// Thread-safe in-memory [JsonCache] decorator.
///
/// It is a kind of level 1 cache.
///
/// TODO: limit the maximum number of cache entries via "size" parameter in
/// constructors.
///
/// It encapsulates a slower chache but keeps its own data in-memory.
class JsonCacheMem implements JsonCache {
  /// Encapsulates a slower [level2] cache and utilizes a static memory that
  /// will be shared (without race conditions) among all [JsonCacheMem] objects
  /// that have been instantiated with this constructor.
  JsonCacheMem(JsonCache level2) : this.mem(level2, _shrMem, _shrMutex);

  /// Cache with custom memory and an optional custom mutex.
  JsonCacheMem.mem(JsonCache level2, Map<String, Map<String, dynamic>?> mem,
      [ReadWriteMutex? mutex])
      : _level2 = level2,
        _memory = mem,
        _mutex = mutex ?? ReadWriteMutex();

  /// Slower cache level.
  final JsonCache _level2;

  /// in-memory storage.
  final Map<String, Map<String, dynamic>?> _memory;

  /// Mutex lock-guard.
  final ReadWriteMutex _mutex;

  /// in-memory shared storage.
  static late final Map<String, Map<String, dynamic>?> _shrMem = {};

  /// shared mutex.
  static late final _shrMutex = ReadWriteMutex();

  /// Frees up storage space in both the level2 cache and in-memory cache.
  @override
  Future<void> clear() async {
    await _mutex.protectWrite(() async {
      await _level2.clear();
      _memory.clear();
    });
  }

  /// Updates data located at [key] in both the level2 cache and in-memory
  /// cache.
  @override
  Future<void> refresh(String key, Map<String, dynamic> data) async {
    /// ATTENTION: It is safer to copy the content of [data] before calling an
    /// asynchronous method that will copy it to avoid data races. For example,
    /// if the client code clears [data] right after passing it to this method,
    /// there's a high chance of having _level2 and this object with different
    /// contents.
    ///
    /// In Dart, synchronous code cannot be interrupted, so there is no need to
    /// protect it using mutual exclusion.
    final copy = Map<String, dynamic>.of(data);
    await _mutex.protectWrite(() async {
      await _level2.refresh(key, copy);
      _memory[key] = copy;
    });
  }

  /// Removes the value located at [key] from both the level2 cache and
  /// in-memory cache.
  @override
  Future<void> remove(String key) async {
    await _mutex.protectWrite(() async {
      await _level2.remove(key);
      _memory.remove(key);
    });
  }

  /// Retrieves the value at [key] or null if there is no data.
  @override
  Future<Map<String, dynamic>?> value(String key) async {
    return _mutex.protectRead(() async {
      if (!_memory.containsKey(key)) {
        _memory[key] = await _level2.value(key);
      }
      final cached = _memory[key];
      return cached == null ? cached : Map<String, dynamic>.of(cached);
    });
  }
}
