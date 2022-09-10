import 'dart:async';

import 'package:json_cache/json_cache.dart';
import 'package:mutex/mutex.dart';

// ignore_for_file: prefer_void_to_null

/// [JsonCacheMem.init] initialization error callback.
typedef OnInitError = FutureOr<Null> Function(Object, StackTrace);

/// Thread-safe in-memory [JsonCache] decorator.
///
/// It is a kind of _level 1_ cache.
///
/// It encapsulates a slower cache and keeps its own data in-memory.
class JsonCacheMem implements JsonCache {
  /// In-memory _level 1_ cache with an optional _level 2_ instance.
  ///
  /// **Note**: if you do not pass an object to the parameter [level2], the data
  /// will remain cached in-memory only; that is, no data will be persited to
  /// the local storage of the user's device. Indeed, not persisting data on the
  /// user's device might be the desired behavior if you are at the prototyping
  /// or mocking phase. However, its unlikely to be the right behavior in
  /// production code.
  JsonCacheMem([JsonCache? level2])
      : this.mem(_shrMem, level2: level2, mutex: _shrMutex);

  /// Initializes both the internal memory (level 1 cache) and the local storage
  /// of the user's device (level 2 cache — [level2]) with the contents of
  /// [initData].
  ///
  /// This method also provides a kind of transaction guarantee whereby if an
  /// error occurs while copying [initData] to the cache, it will attempt to
  /// revert the cache [level2] to its previous state before rethrowing the
  /// exception that signaled the error. Finally, after reverting the cached
  /// data, it will invoke [onInitError].
  JsonCacheMem.init(
    Map<String, Map<String, dynamic>?> initData, {
    JsonCache? level2,
    OnInitError? onInitError,
  })  : _level2 = level2 ?? const JsonCacheHollow(),
        _memory = _shrMem,
        _mutex = _shrMutex {
    final initFut = _mutex.protectWrite(() async {
      final cachedKeys = <String>[];
      for (final entry in initData.entries) {
        final key = entry.key;
        final value = entry.value;
        if (value != null) {
          cachedKeys.add(key);
          try {
            await _level2.refresh(key, value);
            _memory[key] = value;
          } catch (error) {
            for (final key in cachedKeys) {
              await _level2.remove(key);
              _memory.remove(key);
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
  })  : _memory = mem,
        _level2 = level2 ?? const JsonCacheHollow(),
        _mutex = mutex ?? ReadWriteMutex();

  /// Slower level 2 cache.
  final JsonCache _level2;

  /// In-memory storage.
  final Map<String, Map<String, dynamic>?> _memory;

  /// Mutex lock-guard.
  final ReadWriteMutex _mutex;

  /// in-memory shared storage.
  static final Map<String, Map<String, dynamic>?> _shrMem = {};

  /// shared mutex.
  static final _shrMutex = ReadWriteMutex();

  /// Frees up storage space in both the level2 cache and in-memory cache.
  ///
  /// Throws [JsonCacheException] to indicate operation failure.
  @override
  Future<void> clear() async {
    await _mutex.protectWrite(() async {
      await _level2.clear();
      _memory.clear();
    });
  }

  /// Updates the data located at [key] in both the _level 2_ cache and
  /// in-memory cache.
  ///
  /// Throws [JsonCacheException] to indicate operation failure.
  @override
  Future<void> refresh(String key, Map<String, dynamic> data) async {
    // ATTENTION: It is safer to copy the content of [data] before calling an
    // asynchronous method that will copy it to avoid data races. For example,
    // if the client code clears [data] right after passing it to this method,
    // there's a high chance of having the level 2 cache and this object with
    // different contents.
    //
    // In Dart, synchronous code cannot be interrupted, so there is no need to
    // protect it using mutual exclusion.
    final copy = Map<String, dynamic>.of(data);
    await _mutex.protectWrite(() async {
      await _level2.refresh(key, copy);
      _memory[key] = copy;
    });
  }

  /// Removes the cached value located at [key] from both the _level 2 cache_
  /// and _in-memory cache_.
  @override
  Future<void> remove(String key) async {
    await _mutex.protectWrite(() async {
      await _level2.remove(key);
      _memory.remove(key);
    });
  }

  /// Retrieves the value at [key] or `null` if there is no data.
  @override
  Future<Map<String, dynamic>?> value(String key) {
    return _mutex.protectRead(() async {
      final inMemoryValue = _memory[key];
      if (inMemoryValue != null) {
        return Map<String, dynamic>.of(inMemoryValue);
      }
      final localStorageValue = await _level2.value(key);
      if (localStorageValue != null) {
        _memory[key] = localStorageValue;
        return Map<String, dynamic>.of(localStorageValue);
      }
      return null;
    });
  }

  /// Checks whether the _in-memory_ or the _level 2 cache_ contains cached data
  /// at [key].
  @override
  Future<bool> contains(String key) {
    return _mutex.protectRead(() async {
      final bool foundInMemory = _memory.containsKey(key);
      return foundInMemory ? foundInMemory : await _level2.contains(key);
    });
  }
}
