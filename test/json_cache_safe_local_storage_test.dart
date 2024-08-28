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
    'notifications': {'enabled': true},
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
        '"refresh", "value", "remove" with one piece of data',
        () async {
          // Insert a single piece of data into the cache
          await jsonCacheSafeLocalStorage.refresh(profKey, profData);

          // Check if the data has been inserted into the cache.
          final profileRetrieved =
              await jsonCacheSafeLocalStorage.value(profKey);
          expect(profileRetrieved, equals(profData));

          // Remove the single piece of data stored.
          await jsonCacheSafeLocalStorage.remove(profKey);

          // No data should remain in the cache.
          final cachedValue = await jsonCacheSafeLocalStorage.value(profKey);
          expect(cachedValue, isNull);
        },
      );

      test(
        '"refresh", "value", "remove" with multiple data',
        () async {
          // Insert multiple data into the cache
          await jsonCacheSafeLocalStorage.refresh(profKey, profData);
          await jsonCacheSafeLocalStorage.refresh(prefKey, prefData);

          // Check if multiple data has been inserted into the cache.
          final profileRetrieved =
              await jsonCacheSafeLocalStorage.value(profKey);
          expect(profileRetrieved, equals(profData));

          final preferencesRetrived =
              await jsonCacheSafeLocalStorage.value(prefKey);
          expect(preferencesRetrived, prefData);

          // Remove data from the cache.
          await jsonCacheSafeLocalStorage.remove(profKey);
          await jsonCacheSafeLocalStorage.remove(prefKey);

          final removedProfValue =
              await jsonCacheSafeLocalStorage.value(profKey);
          expect(removedProfValue, isNull);
          final removedPrefValue =
              await jsonCacheSafeLocalStorage.value(prefKey);
          expect(removedPrefValue, isNull);
        },
      );

      test(
        'contains',
        () async {
          // Insert a single piece of data into the cache.
          await jsonCacheSafeLocalStorage.refresh(profKey, profData);

          // Check
          expect(await jsonCacheSafeLocalStorage.contains(profKey), true);
          expect(await jsonCacheSafeLocalStorage.contains(prefKey), false);

          // Test for keys that doesn't exist
          expect(await jsonCacheSafeLocalStorage.contains('generickey'), false);
          expect(await jsonCacheSafeLocalStorage.contains('PROFKEY'), false);
          expect(await jsonCacheSafeLocalStorage.contains('PREFKEY'), false);

          // Insert a new piece of data into the cache to test more than one key stored.
          await jsonCacheSafeLocalStorage.refresh(prefKey, prefData);

          // Check for multiple data.
          expect(await jsonCacheSafeLocalStorage.contains(profKey), true);
          expect(await jsonCacheSafeLocalStorage.contains(prefKey), true);

          // Remove data from the cache.
          await jsonCacheSafeLocalStorage.remove(profKey);
          expect(await jsonCacheSafeLocalStorage.contains(profKey), false);
          expect(await jsonCacheSafeLocalStorage.contains(prefKey), true);

          // Remove data from the cache.
          await jsonCacheSafeLocalStorage.remove(prefKey);
          expect(await jsonCacheSafeLocalStorage.contains(profKey), false);
          expect(await jsonCacheSafeLocalStorage.contains(prefKey), false);
        },
      );

      test('keys', () async {
        // update data
        await jsonCacheSafeLocalStorage.refresh(profKey, profData);
        await jsonCacheSafeLocalStorage.refresh(prefKey, prefData);

        expect(await jsonCacheSafeLocalStorage.keys(), [profKey, prefKey]);
      });
      test(
        'clear',
        () async {
          // Insert multiple data into the cache.
          await jsonCacheSafeLocalStorage.refresh(profKey, profData);
          await jsonCacheSafeLocalStorage.refresh(prefKey, prefData);

          // Clear it. All data should be deleted with the file.
          await jsonCacheSafeLocalStorage.clear();

          // No data should remain in the cache.
          final cachedValue = await jsonCacheSafeLocalStorage.value(profKey);
          expect(cachedValue, isNull);

          // Insert a single piece of data into the cache. This refresh avoids errors on operational systems.
          await jsonCacheSafeLocalStorage.refresh(profKey, profData);
        },
      );
    },
  );

  tearDown(
    () async {
      await storage.delete();
    },
  );
}
