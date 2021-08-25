import 'dart:async';

import 'package:mutex/mutex.dart';

import 'json_cache.dart';
import 'json_cache_hollow.dart';

// ignore_for_file: prefer_void_to_null

/// [JsonCacheMem.init] initialization error callback.
typedef OnInitError = FutureOr<Null> Function(Object, StackTrace);

/// Thread-safe in-memory [JsonCache] decorator.
///
/// It is a kind of level 1 cache.
///
/// TODO: limit the maximum number of cache entries via "size" parameter in
/// constructors.
///
/// It encapsulates a slower cache and keeps its own data in-memory.
class JsonCacheMem implements JsonCache {
  /// In-memory level1 cache with an optional level2 instance.
  ///
  /// ATTENTION: if you do not pass an object to the parameter [level2], the
  /// data will remain cached in-memory only; that is, no data will be persited
  /// to the user's device's local storage area. Indeed, not persisting data on
  /// the user's device might be the desired behavior if you are at the
  /// prototyping or mocking phase. However, its unlikely to be the right
  /// behavior in production code.
  JsonCacheMem([JsonCache? level2])
      : this.mem(_shrMem, level2: level2, mutex: _shrMutex);

  /// Cache with initial data.
  ///
  /// Besides copying data from [init] to its internal shared memory, it
  /// encapsulates a [level2] cache that is supposed to persist data to the
  /// user's device's local storage area.
  ///
  /// It also provides a type of transaction guarantee whereby, if an error
  /// occurs while copying [init] to the cache, it tries to revert the cached
  /// data to its previous state before rethrowing the exception. Finally, after
  /// reverting the cached data, it invokes [onInitError].
  JsonCacheMem.init(
    Map<String, Map<String, dynamic>?> init, {
    JsonCache? level2,
    OnInitError? onInitError,
  })  : _level2 = level2 ?? const JsonCacheHollow(),
        _memory = _shrMem,
        _mutex = _shrMutex {
    final copy = Map<String, Map<String, dynamic>?>.of(init);
    final initFut = _mutex.protectWrite(() async {
      final writes = <String>[]; // the list of written keys.
      for (final entry in copy.entries) {
        final key = entry.key;
        final value = entry.value;
        if (value != null) {
          writes.add(key);
          try {
            await _level2.refresh(key, value);
            _memory[key] = value;
          } catch (error) {
            for (final write in writes) {
              await _level2.remove(write);
              _memory.remove(write);
            }
            rethrow;
          }
        }
      }
    });
    if (onInitError != null) {
      initFut.onError(onInitError);
    }
  }

  /// Cache with an external memory and an optional custom mutex.
  ///
  /// **Note**: the memory [mem] will **not** be copied deeply.
  JsonCacheMem.mem(
    Map<String, Map<String, dynamic>?> mem, {
    JsonCache? level2,
    ReadWriteMutex? mutex,
  })  : _level2 = level2 ?? const JsonCacheHollow(),
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
      final cachedL1 = _memory[key];
      if (cachedL1 != null) return Map<String, dynamic>.of(cachedL1);

      final cachedL2 = await _level2.value(key);
      if (cachedL2 != null) {
        _memory[key] = cachedL2;
        return Map<String, dynamic>.of(cachedL2);
      }

      return null;
    });
  }
}
