import 'dart:collection';

import 'package:json_cache/json_cache.dart';

/// A [JsonCache] decorator that provides improved information about
/// cache-related failures by throwing [JsonCacheException].
final class JsonCacheTry implements JsonCache {
  /// Sets [wrapped] as the instance to which this object will forward all
  /// method calls.
  ///
  /// **Precondition**: the type of [wrapped] must not be `JsonCacheTry`.
  const JsonCacheTry(JsonCache wrapped)
      : assert(wrapped is! JsonCacheTry),
        _wrapped = wrapped;

  /// The JsonCache instance to which this object will forward all method calls.
  final JsonCache _wrapped;

  /// Frees up storage space by clearing cached data.
  ///
  /// Throws [JsonCacheException] to indicate operation failure.
  @override
  Future<void> clear() async {
    try {
      await _wrapped.clear();
    } on Exception catch (ex, st) {
      Error.throwWithStackTrace(
        JsonCacheException(
          extra: 'Error clearing cached data.',
          exception: ex,
        ),
        st,
      );
    }
  }

  /// Updates the data located at [key].
  ///
  /// Throws [JsonCacheException] to indicate operation failure.
  @override
  Future<void> refresh(String key, Map<String, dynamic> value) async {
    try {
      await _wrapped.refresh(key, value);
    } on Exception catch (ex, st) {
      Error.throwWithStackTrace(
        JsonCacheException(
          extra: "Error refreshing cached data at index '$key'.",
          exception: ex,
        ),
        st,
      );
    }
  }

  /// Removes the cached data located at [key].
  ///
  /// Throws [JsonCacheException] to indicate operation failure.
  @override
  Future<void> remove(String key) async {
    try {
      await _wrapped.remove(key);
    } on Exception catch (ex, st) {
      Error.throwWithStackTrace(
        JsonCacheException(
          extra: "Error removing cached data at index '$key'.",
          exception: ex,
        ),
        st,
      );
    }
  }

  /// Retrieves the value located at [key] or `null` if there is no data.
  ///
  /// Throws [JsonCacheException] to indicate operation failure.
  @override
  Future<Map<String, dynamic>?> value(String key) async {
    try {
      return await _wrapped.value(key);
    } on Exception catch (ex, st) {
      Error.throwWithStackTrace(
        JsonCacheException(
          extra: "Error retrieving cached data at index '$key'.",
          exception: ex,
        ),
        st,
      );
    }
  }

  /// Checks for cached data at [key].
  ///
  /// Throws [JsonCacheException] to indicate operation failure.
  @override
  Future<bool> contains(String key) async {
    try {
      return await _wrapped.contains(key);
    } on Exception catch (ex, st) {
      Error.throwWithStackTrace(
        JsonCacheException(
          extra: "Error checking for cached data at index '$key'.",
          exception: ex,
        ),
        st,
      );
    }
  }

  @override
  Future<UnmodifiableListView<String>> keys() async {
    try {
      return await _wrapped.keys();
    } on Exception catch (ex, st) {
      Error.throwWithStackTrace(
        JsonCacheException(
          extra: "Error retreiving the cache keys.",
          exception: ex,
        ),
        st,
      );
    }
  }
}
