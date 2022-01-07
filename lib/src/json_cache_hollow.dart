import 'package:json_cache/json_cache.dart';

/// Hollow (empty) [JsonCache] — It is intended to serve as a placeholder for
/// [JsonCache] instances.
///
/// There will always be at most one [JsonCacheHollow] object in memory during
/// program execution. It doesn't matter how many times someone instantiates
/// objects using `const JsonCacheHollow()`.
///
/// > hollow
/// >
/// > having a hole or empty space inside:
/// > - a hollow tube
/// > - Hollow blocks are used because they are lighter
/// > - a hollow log
/// > — [Cambridge Dictionary](https://dictionary.cambridge.org/dictionary/english/hollow)
class JsonCacheHollow implements JsonCache {
  /// This const constructor ensures that there will be only one
  /// [JsonCacheHollow] instance throughout the program.
  const JsonCacheHollow();

  /// Does nothing.
  @override
  Future<void> clear() async {}

  /// Does nothing.
  @override
  Future<void> refresh(String key, Map<String, dynamic> value) async {}

  /// Does nothing.
  @override
  Future<void> remove(String key) async {}

  /// Does nothing.
  @override
  Future<Map<String, dynamic>?> value(String key) async {}
}
