import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';

import 'flutter_secure_storage_mock.dart';

void main() {
  group('JsonCacheFlutterSecureStorage', () {
    test('clear, value, refresh', () async {
      final secStorageMock = FlutterSecureStorageMock();
      final JsonCacheFlutterSecureStorage flutterSecureCache =
          JsonCacheFlutterSecureStorage(secStorageMock);
      const profKey = 'profile';
      const profData = <String, Object>{'id': 1, 'name': 'John Due'};
      await flutterSecureCache.refresh(profKey, profData);
      expect(secStorageMock.writeInvokations, 1);

      var prof = await flutterSecureCache.value(profKey);
      expect(prof, profData);
      expect(secStorageMock.readInvokations, 1);

      await flutterSecureCache.clear();
      expect(secStorageMock.deleteAllInvokations, 1);

      prof = await flutterSecureCache.value(profKey);
      expect(prof, isNull);
      expect(secStorageMock.readInvokations, 2);
    });

    test('contains', () async {
      const profKey = 'profile';
      const prefKey = 'preferences';
      final profData = <String, dynamic>{'id': 1, 'name': 'John Due'};
      final prefData = <String, dynamic>{
        'theme': 'dark',
        'notifications': {'enabled': true}
      };
      final secStorageMock = FlutterSecureStorageMock();
      final JsonCacheFlutterSecureStorage flutterSecureCache =
          JsonCacheFlutterSecureStorage(secStorageMock);
      // update data
      await flutterSecureCache.refresh(profKey, profData);
      await flutterSecureCache.refresh(prefKey, prefData);

      // test for `true`
      expect(await flutterSecureCache.contains(profKey), true);
      expect(await flutterSecureCache.contains(prefKey), true);

      // test for `false`
      expect(await flutterSecureCache.contains('a key'), false);
      await flutterSecureCache.remove(profKey);
      expect(await flutterSecureCache.contains(profKey), false);
      await flutterSecureCache.remove(prefKey);
      expect(await flutterSecureCache.contains(prefKey), false);
    });
    test('remove', () async {
      final secStorageMock = FlutterSecureStorageMock();
      final JsonCacheFlutterSecureStorage flutterSecureCache =
          JsonCacheFlutterSecureStorage(secStorageMock);
      const profKey = 'profile';
      const prefKey = 'preferences';
      final profData = <String, Object>{'id': 1, 'name': 'John Due'};
      final prefData = <String, Object>{
        'theme': 'dark',
        'notifications': {'enabled': true}
      };
      await flutterSecureCache.refresh(profKey, profData);
      await flutterSecureCache.refresh(prefKey, prefData);
      expect(secStorageMock.writeInvokations, 2);

      var prof = await flutterSecureCache.value(profKey);
      expect(prof, profData);
      expect(secStorageMock.readInvokations, 1);

      await flutterSecureCache.remove(profKey);
      expect(secStorageMock.deleteInvokations, 1);
      prof = await flutterSecureCache.value(profKey);
      expect(prof, isNull);
      expect(secStorageMock.readInvokations, 2);

      var pref = await flutterSecureCache.value(prefKey);
      expect(pref, prefData);
      expect(secStorageMock.readInvokations, 3);
      await flutterSecureCache.remove(prefKey);
      expect(secStorageMock.deleteInvokations, 2);
      pref = await flutterSecureCache.value(prefKey);
      expect(pref, isNull);
      expect(secStorageMock.readInvokations, 4);
    });
  });
}
