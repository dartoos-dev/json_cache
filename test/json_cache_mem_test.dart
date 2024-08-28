import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Throws an exception after 'N' refreshes.
class _JsonCacheThrowsAfterN extends JsonCacheWrap {
  /// n how many times before throwing.
  _JsonCacheThrowsAfterN(this._n, Map<String, Map<String, dynamic>?> init)
      : super(JsonCacheFake.mem(init));

  final int _n;
  int _count = 0;

  @override
  Future<void> refresh(String key, Map<String, dynamic> value) async {
    await super.refresh(key, value);
    ++_count;
    if (_count == _n) {
      throw Exception('the refresh method has been called $_count times');
    }
  }
}

void main() {
  SharedPreferences.setMockInitialValues({});
  group('JsonCacheMem', () {
    const profKey = 'profile';
    const profData = <String, dynamic>{'id': 1, 'name': 'John Due'};
    const prefKey = 'preferences';
    const prefData = <String, dynamic>{
      'theme': 'dark',
      'notifications': {'enabled': true},
    };
    const data = <String, Map<String, dynamic>?>{
      profKey: profData,
      prefKey: prefData,
    };

    group('JsonCacheMem.init constructor', () {
      const data = <String, Map<String, dynamic>?>{
        'firstRow': <String, dynamic>{'row1': true},
        'secondRow': <String, dynamic>{'row2': false},
      };
      test('data initialization — deep copy', () async {
        final init = <String, Map<String, dynamic>?>{};
        final JsonCacheMem initMemCache =
            JsonCacheMem.init(data, level2: JsonCacheFake.mem(init));
        await initMemCache.value('x'); // wait...
        expect(init, data);
      });
      test('rollback on error', () async {
        final init = <String, Map<String, dynamic>?>{};
        final JsonCacheMem initMemCache = JsonCacheMem.init(
          data,
          level2: _JsonCacheThrowsAfterN(2, init),
          onInitError: (e, s) {},
        );
        await initMemCache.value('key'); // wait..
        /// init should have been reverted to its prevous state by the internal
        /// logic of the init constructor.
        expect(init.isEmpty, true);
      });
      test('onInitError callback', () async {
        final init = <String, Map<String, dynamic>?>{};
        bool invoked = false;
        final JsonCacheMem initMemCache = JsonCacheMem.init(
          data,
          level2: _JsonCacheThrowsAfterN(1, init),
          onInitError: (e, s) {
            invoked = true;
          },
        );
        await initMemCache.value('key'); // wait..
        /// The error callback must have been invoked.
        expect(invoked, true);
      });
    });
    group('clear', () {
      test('default ctor', () async {
        final JsonCacheMem memCache = JsonCacheMem();
        await memCache.refresh(profKey, profData);
        await memCache.refresh(prefKey, prefData);
        await memCache.clear();
        final cachedProf = await memCache.value(profKey);
        expect(cachedProf, isNull);
        final cachedPref = await memCache.value(prefKey);
        expect(cachedPref, isNull);
      });
      test('init ctor', () async {
        final JsonCacheMem initMemCache = JsonCacheMem.init(data);
        await initMemCache.refresh(profKey, profData);
        await initMemCache.refresh(prefKey, prefData);
        await initMemCache.clear();
        final cachedProf = await initMemCache.value(profKey);
        expect(cachedProf, isNull);
        final cachedPref = await initMemCache.value(prefKey);
        expect(cachedPref, isNull);
      });
      test('mem ctor', () async {
        final copy = Map<String, Map<String, dynamic>?>.of(data);
        final JsonCacheMem memCache = JsonCacheMem.mem(copy);
        await memCache.clear();

        final cachedProf = await memCache.value(profKey);
        expect(cachedProf, isNull);

        final cachedPref = await memCache.value(prefKey);
        expect(cachedPref, isNull);

        expect(copy.isEmpty, true);
      });
    });
    test('contains', () async {
      final profData = <String, dynamic>{'id': 1, 'name': 'John Due'};
      final prefData = <String, dynamic>{
        'theme': 'dark',
        'notifications': {'enabled': true},
      };
      final memCache = JsonCacheMem();
      // update data
      await memCache.refresh(profKey, profData);
      await memCache.refresh(prefKey, prefData);

      // test for `true`
      expect(await memCache.contains(profKey), true);
      expect(await memCache.contains(prefKey), true);

      // test for `false`
      await memCache.remove(prefKey);
      expect(await memCache.contains(prefKey), false);
      expect(await memCache.contains('a key'), false);
    });
    test('keys', () async {
      final profData = <String, dynamic>{'id': 1, 'name': 'John Due'};
      final prefData = <String, dynamic>{
        'theme': 'dark',
        'notifications': {'enabled': true},
      };
      final memCache = JsonCacheMem();
      // update data
      await memCache.refresh(profKey, profData);
      await memCache.refresh(prefKey, prefData);

      expect(await memCache.keys(), [profKey, prefKey]);
    });
    group('remove', () {
      test('default ctor', () async {
        final JsonCacheMem memCache = JsonCacheMem();
        await memCache.refresh(profKey, profData);
        await memCache.refresh(prefKey, prefData);
        await memCache.remove(profKey);
        final cachedProf = await memCache.value(profKey);
        expect(cachedProf, isNull);
        await memCache.remove(prefKey);
        final cachedPref = await memCache.value(prefKey);
        expect(cachedPref, isNull);
      });
      test('init ctor', () async {
        final JsonCacheMem initMemCache = JsonCacheMem.init(data);
        await initMemCache.refresh(profKey, profData);
        await initMemCache.refresh(prefKey, prefData);
        await initMemCache.remove(profKey);
        final cachedProf = await initMemCache.value(profKey);
        expect(cachedProf, isNull);

        await initMemCache.remove(prefKey);
        final cachedPref = await initMemCache.value(prefKey);
        expect(cachedPref, isNull);
      });
    });
    group('refresh and value', () {
      test('default ctor', () async {
        final JsonCacheMem memCache = JsonCacheMem();
        await memCache.refresh(profKey, profData);
        await memCache.refresh(prefKey, prefData);

        final cachedProf = await memCache.value(profKey);
        expect(cachedProf, profData);

        final cachedPref = await memCache.value(prefKey);
        expect(cachedPref, prefData);
      });
      test('init ctor', () async {
        final JsonCacheMem initMemCache = JsonCacheMem.init(data);
        await initMemCache.refresh(profKey, profData);
        await initMemCache.refresh(prefKey, prefData);

        final cachedProf = await initMemCache.value(profKey);
        expect(cachedProf, profData);

        final cachedPref = await initMemCache.value(prefKey);
        expect(cachedPref, prefData);
      });
      test('mem ctor', () async {
        final mem = <String, Map<String, dynamic>?>{};
        final JsonCacheMem memCache = JsonCacheMem.mem(mem);
        await memCache.refresh(profKey, profData);
        await memCache.refresh(prefKey, prefData);

        final cachedProf = await memCache.value(profKey);
        expect(cachedProf, profData);

        final cachedPref = await memCache.value(prefKey);
        expect(cachedPref, prefData);
        expect(mem[profKey], profData);
        expect(mem[prefKey], prefData);
      });
      test('value missing from L1 cache', () async {
        const key = 'aValue';
        const value = <String, dynamic>{'must be a json encodable value': true};
        final prefs =
            JsonCacheSharedPreferences(await SharedPreferences.getInstance());
        await prefs.refresh(key, value);
        final JsonCacheMem memCache = JsonCacheMem(prefs);
        final cacheL2Value = await memCache.value(key);
        expect(cacheL2Value, value);
      });
    });
  });
}
