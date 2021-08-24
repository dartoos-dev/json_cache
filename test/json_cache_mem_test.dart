import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';

/// Throws an exception after 'N' refreshes.
class _JsonCacheThrowAfterN extends JsonCacheWrap {
  /// n how many times before throwing.
  _JsonCacheThrowAfterN(this._n, Map<String, Map<String, dynamic>?> init)
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
  group('JsonCacheMem', () {
    const profKey = 'profile';
    const profData = <String, dynamic>{'id': 1, 'name': 'John Due'};
    const prefKey = 'preferences';
    const prefData = <String, dynamic>{
      'theme': 'dark',
      'notifications': {'enabled': true}
    };
    const data = <String, Map<String, dynamic>?>{
      profKey: profData,
      prefKey: prefData
    };

    group('JsonCacheMem.init', () {
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
        final JsonCacheMem initMemCache = JsonCacheMem.init(data,
            level2: _JsonCacheThrowAfterN(2, init),
            onInitError: (Object e, StackTrace s) {});
        await initMemCache.value('key'); // wait..
        /// init should have been reverted to its prevous state by the init's
        /// internal logic.
        expect(init.isEmpty, true);
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
      test('ext ctor', () async {
        final copy = Map<String, Map<String, dynamic>?>.of(data);
        final JsonCacheMem extMemCache = JsonCacheMem.ext(copy);
        await extMemCache.clear();

        final cachedProf = await extMemCache.value(profKey);
        expect(cachedProf, isNull);

        final cachedPref = await extMemCache.value(prefKey);
        expect(cachedPref, isNull);

        expect(copy.isEmpty, true);
      });
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
      test('ext ctor', () async {
        final copy = Map<String, Map<String, dynamic>?>.of(data);
        final JsonCacheMem extMemCache = JsonCacheMem.ext(copy);
        await extMemCache.refresh(profKey, profData);
        await extMemCache.refresh(prefKey, prefData);

        await extMemCache.remove(profKey);
        final cachedProf = await extMemCache.value(profKey);
        expect(cachedProf, isNull);

        await extMemCache.remove(prefKey);
        final cachedPref = await extMemCache.value(prefKey);
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
      test('ext ctor', () async {
        final ext = <String, Map<String, dynamic>?>{};
        final JsonCacheMem extMemCache = JsonCacheMem.ext(ext);
        await extMemCache.refresh(profKey, profData);
        await extMemCache.refresh(prefKey, prefData);

        final cachedProf = await extMemCache.value(profKey);
        expect(cachedProf, profData);

        final cachedPref = await extMemCache.value(prefKey);
        expect(cachedPref, prefData);
        expect(ext[profKey], profData);
        expect(ext[prefKey], prefData);
      });
    });
  });
}
