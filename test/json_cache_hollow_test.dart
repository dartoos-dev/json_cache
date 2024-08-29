import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';

void main() {
  group('JsonCacheHollow:', () {
    const profKey = 'profile';
    const prefKey = 'preferences';
    const profData = <String, dynamic>{'id': 1, 'name': 'John Due'};
    const prefData = <String, dynamic>{
      'theme': 'dark',
      'notifications': {'enabled': true},
    };

    test('clear', () async {
      const JsonCacheHollow hollowCache = JsonCacheHollow();
      await hollowCache.refresh(profKey, profData);
      await hollowCache.refresh(prefKey, prefData);
      await hollowCache.clear();
      final cachedProf = await hollowCache.value(profKey);
      expect(cachedProf, isNull);
      final cachedPref = await hollowCache.value(prefKey);
      expect(cachedPref, isNull);
    });

    test('contains', () async {
      const fake = JsonCacheHollow();
      // update data
      await fake.refresh(profKey, profData);
      await fake.refresh(prefKey, prefData);

      expect(await fake.contains(profKey), false);
      expect(await fake.contains(prefKey), false);

      await fake.remove(prefKey);
      expect(await fake.contains(prefKey), false);
      expect(await fake.contains('a key'), false);
    });
    test('keys', () async {
      const hollowCache = JsonCacheHollow();
      await hollowCache.refresh(profKey, profData);
      await hollowCache.refresh(prefKey, prefData);

      final keys = await hollowCache.keys();
      expect(keys, const []);

      // This should not change the 'keys' variable.
      await hollowCache
          .refresh('info', {'This is very important information.': true});
      expect(keys, const []);
    });
    test('remove', () async {
      const JsonCacheHollow hollowCache = JsonCacheHollow();
      await hollowCache.refresh(profKey, profData);
      await hollowCache.refresh(prefKey, prefData);
      await hollowCache.remove(profKey);
      final cachedProf = await hollowCache.value(profKey);
      expect(cachedProf, isNull);
      await hollowCache.remove(prefKey);
      final cachedPref = await hollowCache.value(prefKey);
      expect(cachedPref, isNull);
    });
    test('refresh and value', () async {
      const JsonCacheHollow hollowCache = JsonCacheHollow();
      await hollowCache.refresh(profKey, profData);
      await hollowCache.refresh(prefKey, prefData);

      final cachedProf = await hollowCache.value(profKey);
      expect(cachedProf, isNull);

      final cachedPref = await hollowCache.value(prefKey);
      expect(cachedPref, isNull);
    });
  });
}
