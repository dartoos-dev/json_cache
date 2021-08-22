import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';

void main() {
  group('JsonCacheMem', () {
    group('clear, recover and refresh', () {
      const profKey = 'profile';
      const profData = <String, dynamic>{'id': 1, 'name': 'John Due'};
      test('default ctor', () async {
        final JsonCacheMem inMemCache = JsonCacheMem(JsonCacheFake());
        await inMemCache.refresh(profKey, profData);
        final result = await inMemCache.value(profKey);
        expect(profData, result);
        await inMemCache.clear();
        final mustBeNull = await inMemCache.value(profKey);
        expect(mustBeNull, isNull);
      });
      test('mem ctor', () async {
        final Map<String, Map<String, dynamic>?> copy = {
          profKey: Map<String, dynamic>.of(profData)
        };
        final inMemCache = JsonCacheMem.mem(JsonCacheFake.mem(copy), copy);
        var prof = await inMemCache.value(profKey);
        expect(prof, profData);
        await inMemCache.clear();
        expect(copy.isEmpty, true);
        prof = await inMemCache.value(profKey);
        expect(prof, isNull);
      });
    });

    test('remove', () async {
      const profKey = 'profile';
      const prefKey = 'preferences';
      final profData = <String, dynamic>{'id': 1, 'name': 'John Due'};
      final prefData = <String, dynamic>{
        'theme': 'dark',
        'notifications': {'enabled': true}
      };
      final mem = JsonCacheMem(JsonCacheFake());
      await mem.refresh(profKey, profData);
      await mem.refresh(prefKey, prefData);

      var prof = await mem.value(profKey);
      expect(prof, profData);

      await mem.remove(profKey);
      prof = await mem.value(profKey);
      expect(prof, isNull);

      var pref = await mem.value(prefKey);
      expect(pref, prefData);
      await mem.remove(prefKey);
      pref = await mem.value(prefKey);
      expect(pref, isNull);
    });
  });
}
