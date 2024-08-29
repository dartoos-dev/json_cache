import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  group('JsonCacheSharedPreferences:', () {
    const profKey = 'profile';
    const prefKey = 'preferences';
    const profData = <String, dynamic>{'id': 1, 'name': 'John Due'};
    const prefData = <String, dynamic>{
      'theme': 'dark',
      'notifications': {'enabled': true},
    };
    test('clear, value, refresh', () async {
      final JsonCacheSharedPreferences prefsCache =
          JsonCacheSharedPreferences(await SharedPreferences.getInstance());
      await prefsCache.refresh(profKey, profData);
      var prof = await prefsCache.value(profKey);
      expect(prof, profData);
      await prefsCache.clear();
      prof = await prefsCache.value(profKey);
      expect(prof, isNull);
    });

    test('contains', () async {
      final JsonCacheSharedPreferences prefs =
          JsonCacheSharedPreferences(await SharedPreferences.getInstance());
      // update data
      await prefs.refresh(profKey, profData);
      await prefs.refresh(prefKey, prefData);

      // test for `true`
      expect(await prefs.contains(profKey), true);
      expect(await prefs.contains(prefKey), true);

      // test for `false`
      expect(await prefs.contains('a key'), false);
      await prefs.remove(profKey);
      expect(await prefs.contains(profKey), false);
      await prefs.remove(prefKey);
      expect(await prefs.contains(prefKey), false);
    });

    group('method "keys"', () {
      late JsonCacheSharedPreferences prefsCache;
      setUp(() async {
        prefsCache =
            JsonCacheSharedPreferences(await SharedPreferences.getInstance());
        // update data
        await prefsCache.refresh(profKey, profData);
        await prefsCache.refresh(prefKey, prefData);
      });
      test('should return the inserted keys', () async {
        expect(await prefsCache.keys(), [profKey, prefKey]);
      });
      test('should keep the returned keys immutable', () async {
        final keys = await prefsCache.keys();
        // This should not change the 'keys' variable.
        await prefsCache
            .refresh('info', {'This is very important information.': true});
        expect(keys, [profKey, prefKey]);
      });
    });
    test('remove', () async {
      final JsonCacheSharedPreferences prefsCache =
          JsonCacheSharedPreferences(await SharedPreferences.getInstance());
      await prefsCache.refresh(profKey, profData);
      await prefsCache.refresh(prefKey, prefData);

      var prof = await prefsCache.value(profKey);
      expect(prof, profData);

      await prefsCache.remove(profKey);
      prof = await prefsCache.value(profKey);
      expect(prof, isNull);

      var pref = await prefsCache.value(prefKey);
      expect(pref, prefData);
      await prefsCache.remove(prefKey);
      pref = await prefsCache.value(prefKey);
      expect(pref, isNull);
    });
  });
}
