import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';

void main() {
  group('JsonCacheMem', () {
    const profKey = 'profile';
    const Map<String, dynamic> profData = <String, dynamic>{
      'id': 1,
      'name': 'John Due'
    };
    group('clear, recover and refresh', () {
      test('default ctor', () async {
        final JsonCacheMem inMemCache = JsonCacheMem(JsonCacheFake());
        await inMemCache.refresh(profKey, profData);
        final result = await inMemCache.recover(profKey);
        expect(profData, result);
        await inMemCache.clear();
        final mustBeNull = await inMemCache.recover(profKey);
        expect(mustBeNull, isNull);
      });
      test('mem ctor', () async {
        final Map<String, Map<String, dynamic>?> copy = {
          profKey: Map<String, dynamic>.of(profData)
        };
        final inMemCache = JsonCacheMem.mem(JsonCacheFake.mem(copy), copy);
        final result = await inMemCache.recover(profKey);
        expect(result, profData);
        await inMemCache.clear();
        expect(copy.isEmpty, true);
        final mustBeNull = await inMemCache.recover(profKey);
        expect(mustBeNull, isNull);
      });
    });

    test('erase', () async {
      const profKey = 'profile';
      const prefsKey = 'preferences';
      final prof = <String, dynamic>{'id': 1, 'name': 'John Due'};
      final prefs = <String, dynamic>{
        'preferences': <String, dynamic>{
          'theme': 'dark',
          'notifications': {'enabled': true}
        }
      };
      final Map<String, Map<String, dynamic>> data = {
        profKey: prof,
        prefsKey: prefs
      };
      expect(data.containsKey(profKey), true);
      expect(data.containsKey(prefsKey), true);
      await JsonCacheMem.mem(JsonCacheFake.mem(data), data).erase(prefsKey);
      expect(data.containsKey(prefsKey), false);
      expect(data.containsKey(profKey), true);
    });
  });
}
