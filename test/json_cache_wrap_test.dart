import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';

class JsonCacheFakeWrap extends JsonCacheWrap {
  JsonCacheFakeWrap() : super(JsonCacheFake());
}

void main() {
  group('JsonCacheWrap', () {
    const profKey = 'profile';
    const Map<String, dynamic> profData = <String, dynamic>{
      'id': 1,
      'name': 'John Due'
    };
    group('clear, value and refresh', () {
      test('default ctor', () async {
        final JsonCache wrap = JsonCacheFakeWrap();
        await wrap.refresh(profKey, profData);
        final result = await wrap.value(profKey);
        expect(profData, result);
        await wrap.clear();
        final mustBeNull = await wrap.value(profKey);
        expect(mustBeNull, isNull);
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
      final wrap = JsonCacheFakeWrap();
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
