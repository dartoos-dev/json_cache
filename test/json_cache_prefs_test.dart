import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  group('JsonCachePrefs', () {
    test('clear, value, refresh', () async {
      const profKey = 'profile';
      const profData = <String, Object>{'id': 1, 'name': 'John Due'};
      final JsonCachePrefs prefsCache =
          JsonCachePrefs(await SharedPreferences.getInstance());
      await prefsCache.refresh(profKey, profData);
      var prof = await prefsCache.value(profKey);
      expect(prof, profData);
      await prefsCache.clear();
      prof = await prefsCache.value(profKey);
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
      final JsonCachePrefs prefs =
          JsonCachePrefs(await SharedPreferences.getInstance());
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
    test('remove', () async {
      const profKey = 'profile';
      const prefKey = 'preferences';
      final profData = <String, Object>{'id': 1, 'name': 'John Due'};
      final prefData = <String, Object>{
        'theme': 'dark',
        'notifications': {'enabled': true}
      };
      final JsonCachePrefs prefsCache =
          JsonCachePrefs(await SharedPreferences.getInstance());
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
