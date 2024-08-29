import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:json_cache/src/json_cache_hive.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
  });
  tearDown(() async {
    await tearDownTestHive();
  });
  group('JsonCacheHive:', () {
    const profKey = 'profile';
    const prefKey = 'preferences';
    const profData = <String, dynamic>{'id': 1, 'name': 'John Due'};
    const prefData = <String, dynamic>{
      'theme': 'dark',
      'notifications': {'enabled': true},
    };
    test('clear, value, refresh', () async {
      final box = await Hive.openBox<String>('test-clear-value-refresh');
      final JsonCacheHive hiveCache = JsonCacheHive(box);
      await hiveCache.refresh(profKey, profData);
      var prof = await hiveCache.value(profKey);
      expect(prof, profData);
      await hiveCache.clear();
      prof = await hiveCache.value(profKey);
      expect(prof, isNull);
    });

    test('contains', () async {
      final box = await Hive.openBox<String>('test-contains-method');
      final JsonCacheHive hiveCache = JsonCacheHive(box);
      // update data
      await hiveCache.refresh(profKey, profData);
      await hiveCache.refresh(prefKey, prefData);

      // test for `true`
      expect(await hiveCache.contains(profKey), true);
      expect(await hiveCache.contains(prefKey), true);

      // test for `false`
      expect(await hiveCache.contains('a key'), false);
      await hiveCache.remove(profKey);
      expect(await hiveCache.contains(profKey), false);
      await hiveCache.remove(prefKey);
      expect(await hiveCache.contains(prefKey), false);
    });
    group('method "keys"', () {
      late JsonCacheHive hiveCache;
      setUp(() async {
        final box = await Hive.openBox<String>('test-keys-method');
        hiveCache = JsonCacheHive(box);
        // update data
        await hiveCache.refresh(profKey, profData);
        await hiveCache.refresh(prefKey, prefData);
      });
      test('should return the inserted keys', () async {
        expect(await hiveCache.keys(), [prefKey, profKey]);
      });
      test('should keep the returned keys immutable', () async {
        final keys = await hiveCache.keys();
        // This should not change the 'keys' variable.
        await hiveCache
            .refresh('info', {'This is very important information.': true});
        expect(keys, [prefKey, profKey]);
      });
    });
    test('remove', () async {
      final box = await Hive.openBox<String>('test-remove');
      final hiveCache = JsonCacheHive(box);
      await hiveCache.refresh(profKey, profData);
      await hiveCache.refresh(prefKey, prefData);

      var prof = await hiveCache.value(profKey);
      expect(prof, profData);

      await hiveCache.remove(profKey);
      prof = await hiveCache.value(profKey);
      expect(prof, isNull);

      var pref = await hiveCache.value(prefKey);
      expect(pref, prefData);
      await hiveCache.remove(prefKey);
      pref = await hiveCache.value(prefKey);
      expect(pref, isNull);
    });
  });
}
