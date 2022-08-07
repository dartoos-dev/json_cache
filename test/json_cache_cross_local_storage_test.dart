import 'package:cross_local_storage/cross_local_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  group('JsonCacheCrossLocalStorage', () {
    test('clear, recover and refresh', () async {
      final prefs = await LocalStorage.getInstance();
      const profKey = 'profile';
      const profData = <String, Object>{'id': 1, 'name': 'John Due'};
      final JsonCacheCrossLocalStorage crossCache =
          JsonCacheCrossLocalStorage(prefs);
      await crossCache.refresh(profKey, profData);
      var prof = await crossCache.value(profKey);
      expect(prof, profData);
      await crossCache.clear();
      prof = await crossCache.value(profKey);
      expect(prof, isNull);
      await prefs.clear();
    });

    test('contains', () async {
      const profKey = 'profile';
      const prefKey = 'preferences';
      final profData = <String, dynamic>{'id': 1, 'name': 'John Due'};
      final prefData = <String, dynamic>{
        'theme': 'dark',
        'notifications': {'enabled': true}
      };
      final crossLocal =
          JsonCacheCrossLocalStorage(await LocalStorage.getInstance());
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
      final prefs = await LocalStorage.getInstance();
      const profKey = 'profile';
      const prefKey = 'preferences';
      final profData = <String, Object>{'id': 1, 'name': 'John Due'};
      final prefData = <String, Object>{
        'theme': 'dark',
        'notifications': {'enabled': true}
      };
      final JsonCacheCrossLocalStorage crossCache =
          JsonCacheCrossLocalStorage(prefs);
      await crossCache.refresh(profKey, profData);
      await crossCache.refresh(prefKey, prefData);

      var prof = await crossCache.value(profKey);
      expect(prof, profData);

      await crossCache.remove(profKey);
      prof = await crossCache.value(profKey);
      expect(prof, isNull);

      var pref = await crossCache.value(prefKey);
      expect(pref, prefData);
      await crossCache.remove(prefKey);
      pref = await crossCache.value(prefKey);
      expect(pref, isNull);
      await prefs.clear();
    });
  });
}
