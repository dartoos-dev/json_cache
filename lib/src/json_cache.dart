/// Represents data cached in json.
abstract class JsonCache {
  /// Frees up storage space.
  Future<void> clear();

  /// Updates data at [key], or creates a new cache line at [key] if there is no
  /// previous data there.
  Future<void> refresh(String key, Map<String, dynamic> data);

  /// Removes data from cache at [key] and returns it, or returns null if there
  /// is no data at [key].
  Future<Map<String, dynamic>?> erase(String key);

  /// Retrieves either the data at [key] or null if a cache miss occurs.
  Future<Map<String, dynamic>?> recover(String key);
}
