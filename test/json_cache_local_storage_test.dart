import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';
import 'package:localstorage/localstorage.dart';

void main() {
  final LocalStorage storage =
      LocalStorage('json_cache_local_storage_unit_test');
  group('JsonCacheLocalStorage', () {
    test('clear, recover and refresh', () async {
      const profKey = 'profile';
      const profData = <String, Object>{'id': 1, 'name': 'John Due'};
      final JsonCacheLocalStorage localStorageCache =
          JsonCacheLocalStorage(storage);
      await localStorageCache.refresh(profKey, profData);
      var prof = await localStorageCache.value(profKey);
      expect(prof, profData);
      await localStorageCache.clear();
      prof = await localStorageCache.value(profKey);
      expect(prof, isNull);
    });

    test('remove', () async {
      const profKey = 'profile';
      const prefKey = 'preferences';
      final profData = <String, Object>{'id': 1, 'name': 'John Due'};
      final prefData = <String, Object>{
        'theme': 'dark',
        'notifications': {'enabled': true}
      };
      final JsonCacheLocalStorage localStorageCache =
          JsonCacheLocalStorage(storage);
      await localStorageCache.refresh(profKey, profData);
      await localStorageCache.refresh(prefKey, prefData);

      var prof = await localStorageCache.value(profKey);
      expect(prof, profData);

      await localStorageCache.remove(profKey);
      prof = await localStorageCache.value(profKey);
      expect(prof, isNull);

      var pref = await localStorageCache.value(prefKey);
      expect(pref, prefData);
      await localStorageCache.remove(prefKey);
      pref = await localStorageCache.value(prefKey);
      expect(pref, isNull);
    });
  });
}
