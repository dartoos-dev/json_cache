import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';

import 'flutter_secure_storage_mock.dart';

void main() {
  group('JsonCacheSecStorage', () {
    test('clear, value, refresh', () async {
      final secStorageMock = FlutterSecureStorageMock();
      final JsonCacheSecStorage secCache = JsonCacheSecStorage(secStorageMock);
      const profKey = 'profile';
      const profData = <String, Object>{'id': 1, 'name': 'John Due'};
      await secCache.refresh(profKey, profData);
      expect(secStorageMock.writeInvokations, 1);

      var prof = await secCache.value(profKey);
      expect(prof, profData);
      expect(secStorageMock.readInvokations, 1);

      await secCache.clear();
      expect(secStorageMock.deleteAllInvokations, 1);

      prof = await secCache.value(profKey);
      expect(prof, isNull);
      expect(secStorageMock.readInvokations, 2);
    });

    test('remove', () async {
      final secStorageMock = FlutterSecureStorageMock();
      final JsonCacheSecStorage secCache = JsonCacheSecStorage(secStorageMock);
      const profKey = 'profile';
      const prefKey = 'preferences';
      final profData = <String, Object>{'id': 1, 'name': 'John Due'};
      final prefData = <String, Object>{
        'theme': 'dark',
        'notifications': {'enabled': true}
      };
      await secCache.refresh(profKey, profData);
      await secCache.refresh(prefKey, prefData);
      expect(secStorageMock.writeInvokations, 2);

      var prof = await secCache.value(profKey);
      expect(prof, profData);
      expect(secStorageMock.readInvokations, 1);

      await secCache.remove(profKey);
      expect(secStorageMock.deleteInvokations, 1);
      prof = await secCache.value(profKey);
      expect(prof, isNull);
      expect(secStorageMock.readInvokations, 2);

      var pref = await secCache.value(prefKey);
      expect(pref, prefData);
      expect(secStorageMock.readInvokations, 3);
      await secCache.remove(prefKey);
      expect(secStorageMock.deleteInvokations, 2);
      pref = await secCache.value(prefKey);
      expect(pref, isNull);
      expect(secStorageMock.readInvokations, 4);
    });
  });
}
