import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/src/json_cache_safe_local_storage.dart';
import 'package:safe_local_storage/safe_local_storage.dart';

void main() {
  // Group of elements to 'mock' the temporary directory and file.
  late Directory tempDir;
  late File tempFile;

  late SafeLocalStorage storage;

  late JsonCacheSafeLocalStorage jsonCacheSafeLocalStorage;

  // Profile data
  const profKey = 'profile';
  const profData = {
    'name': 'John Doe',
    'age': 23,
    'email': 'johndoe@example.com',
  };

  // App preferences data
  const prefKey = 'preferences';
  const prefData = {
    'theme': 'light',
    'notifications': {'enabled': true}
  };

  setUp(
    () async {
      tempDir = Directory.systemTemp;
      tempFile = File('${tempDir.path}/temp_file.json');
      storage = SafeLocalStorage(tempFile.path);
      jsonCacheSafeLocalStorage = JsonCacheSafeLocalStorage(storage);
    },
  );

  group(
    'JsonCacheSafeLocalStorage',
    () {
      test(
        'refresh, value, clear, refresh',
        () async {
          await jsonCacheSafeLocalStorage.refresh(profKey, profData);

          final data = await jsonCacheSafeLocalStorage.value(profKey);
          expect(data, profData);
          await jsonCacheSafeLocalStorage.clear();

          final cleanCache = await jsonCacheSafeLocalStorage.value(profKey);
          expect(cleanCache, isNull);
        },
      );

      test(
        'contains',
        () async {
          // Adding content on cache. Each 'refresh' method overrides the last one.
          await jsonCacheSafeLocalStorage.refresh(profKey, profData);
          await jsonCacheSafeLocalStorage.refresh(prefKey, prefData);

          // Returning true if the last content exists on cache based on 'prefKey'.
          expect(await jsonCacheSafeLocalStorage.contains(prefKey), true);
          expect(await jsonCacheSafeLocalStorage.contains(profKey), false);

          await jsonCacheSafeLocalStorage.refresh(profKey, profData);
          // Returning true if the last content exists on cache based on 'profKey'.
          expect(await jsonCacheSafeLocalStorage.contains(profKey), true);
          expect(await jsonCacheSafeLocalStorage.contains(prefKey), false);

          // Test for keys that doesn't exist
          expect(await jsonCacheSafeLocalStorage.contains('generickey'), false);
          expect(await jsonCacheSafeLocalStorage.contains('PROFKEY'), false);
          expect(await jsonCacheSafeLocalStorage.contains('PREFKEY'), false);
        },
      );

      test(
        'remove',
        () async {
          await jsonCacheSafeLocalStorage.refresh(profKey, profData);

          final recoveredData = await jsonCacheSafeLocalStorage.value(profKey);
          expect(recoveredData, profData);

          await jsonCacheSafeLocalStorage.remove(profKey);
          final cleanCache = await jsonCacheSafeLocalStorage.value(profKey);
          expect(cleanCache, isNull);
        },
      );
    },
  );

  tearDown(
    () async {
      await storage.delete();
      await tempDir.delete_();
    },
  );
}
