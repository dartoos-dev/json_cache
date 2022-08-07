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

    test('contains', () async {
      const profKey = 'profile';
      const prefKey = 'preferences';
      final profData = <String, dynamic>{'id': 1, 'name': 'John Due'};
      final prefData = <String, dynamic>{
        'theme': 'dark',
        'notifications': {'enabled': true}
      };
      final crossLocal = JsonCacheLocalStorage(storage);
      // update data
      await crossLocal.refresh(profKey, profData);
      await crossLocal.refresh(prefKey, prefData);

      // test for `true`
      expect(await crossLocal.contains(profKey), true);
      expect(await crossLocal.contains(prefKey), true);

      // test for `false`
      expect(await crossLocal.contains('a key'), false);
      await crossLocal.remove(profKey);
      expect(await crossLocal.contains(profKey), false);
      await crossLocal.remove(prefKey);
      expect(await crossLocal.contains(prefKey), false);
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
