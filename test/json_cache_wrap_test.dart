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
    group('clear, recover and refresh', () {
      test('default ctor', () async {
        final JsonCache wrap = JsonCacheFakeWrap();
        await wrap.refresh(profKey, profData);
        final result = await wrap.recover(profKey);
        expect(profData, result);
        await wrap.clear();
        final mustBeNull = await wrap.recover(profKey);
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
      final wrap = JsonCacheFakeWrap();
      await wrap.refresh(prefsKey, prefs);
      final erasedPrefs = await wrap.erase(prefsKey);
      expect(erasedPrefs, prefs);
      final mustBeNull = await wrap.recover(prefsKey);
      expect(mustBeNull, isNull);
    });
  });
}
