import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';

class JsonCacheTestWrap extends JsonCacheWrap {
  JsonCacheTestWrap() : super(JsonCacheMem());
}

void main() {
  group('JsonCacheWrap', () {
    const profKey = 'profile';
    const prefKey = 'preferences';
    group('clear, value and refresh', () {
      test('default ctor', () async {
        const Map<String, dynamic> data = <String, dynamic>{
          'id': 1,
          'name': 'John Due',
        };
        final JsonCache wrap = JsonCacheTestWrap();
        await wrap.refresh(profKey, data);
        final result = await wrap.value(profKey);
        expect(data, result);
        await wrap.clear();
        final mustBeNull = await wrap.value(profKey);
        expect(mustBeNull, isNull);
      });
    });
    test('contains', () async {
      final profData = <String, dynamic>{'id': 1, 'name': 'John Due'};
      final prefData = <String, dynamic>{
        'theme': 'dark',
        'notifications': {'enabled': true},
      };
      final wrap = JsonCacheTestWrap();

      // update data
      await wrap.refresh(profKey, profData);
      await wrap.refresh(prefKey, prefData);

      // test for `true`
      expect(await wrap.contains(profKey), true);
      expect(await wrap.contains(prefKey), true);

      // test for `false`
      await wrap.remove(prefKey);
      expect(await wrap.contains(prefKey), false);
      expect(await wrap.contains('a key'), false);
    });
    test('remove', () async {
      final profData = <String, dynamic>{'id': 1, 'name': 'John Due'};
      final prefData = <String, dynamic>{
        'theme': 'dark',
        'notifications': {'enabled': true},
      };
      final wrap = JsonCacheTestWrap();
      await wrap.refresh(profKey, profData);
      await wrap.refresh(prefKey, prefData);

      final cachedProf = await wrap.value(profKey);
      expect(cachedProf, profData);
      final cachedPref = await wrap.value(prefKey);
      expect(cachedPref, prefData);

      await wrap.remove(profKey);
      final profMustBeNull = await wrap.value(profKey);
      expect(profMustBeNull, isNull);

      final prefDataMustHaveBeenRetained = await wrap.value(prefKey);
      expect(prefDataMustHaveBeenRetained, prefData);

      await wrap.remove(prefKey);
      final prefMustBeNull = await wrap.value(prefKey);
      expect(prefMustBeNull, isNull);
    });
  });
}
