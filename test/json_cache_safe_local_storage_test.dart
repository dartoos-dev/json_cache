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
  const profileKey = 'profile';
  const profData = {
    'name': 'John Doe',
    'age': 23,
    'email': 'johndoe@example.com',
  };

  // App preferences data
  const preferencesKey = 'preferences';
  const prefData = {
    'theme': 'light',
    'notifications': {'enabled': true},
  };

  setUp(
    () {
      tempDir = Directory.systemTemp;
      tempFile = File('${tempDir.path}/temp_file.json');
      storage = SafeLocalStorage(tempFile.path);
      jsonCacheSafeLocalStorage = JsonCacheSafeLocalStorage(storage);
    },
  );

  group(
    'JsonCacheSafeLocalStorage:',
    () {
      test(
        '"refresh", "value", "remove" with one piece of data',
        () async {
          // Insert a single piece of data into the cache
          await jsonCacheSafeLocalStorage.refresh(profileKey, profData);

          // Check if the data has been inserted into the cache.
          final profileRetrieved =
              await jsonCacheSafeLocalStorage.value(profileKey);
          expect(profileRetrieved, equals(profData));

          // Remove the single piece of data stored.
          await jsonCacheSafeLocalStorage.remove(profileKey);

          // No data should remain in the cache.
          final cachedValue = await jsonCacheSafeLocalStorage.value(profileKey);
          expect(cachedValue, isNull);
        },
      );

      test(
        '"refresh", "value", "remove" with multiple data',
        () async {
          // Insert multiple data into the cache
          await jsonCacheSafeLocalStorage.refresh(profileKey, profData);
          await jsonCacheSafeLocalStorage.refresh(preferencesKey, prefData);

          // Check if multiple data has been inserted into the cache.
          final profileRetrieved =
              await jsonCacheSafeLocalStorage.value(profileKey);
          expect(profileRetrieved, equals(profData));

          final preferencesRetrived =
              await jsonCacheSafeLocalStorage.value(preferencesKey);
          expect(preferencesRetrived, prefData);

          // Remove data from the cache.
          await jsonCacheSafeLocalStorage.remove(profileKey);
          await jsonCacheSafeLocalStorage.remove(preferencesKey);

          final removedProfValue =
              await jsonCacheSafeLocalStorage.value(profileKey);
          expect(removedProfValue, isNull);
          final removedPrefValue =
              await jsonCacheSafeLocalStorage.value(preferencesKey);
          expect(removedPrefValue, isNull);
        },
      );

      test(
        'contains',
        () async {
          // Insert a single piece of data into the cache.
          await jsonCacheSafeLocalStorage.refresh(profileKey, profData);

          // Check
          expect(await jsonCacheSafeLocalStorage.contains(profileKey), true);
          expect(
              await jsonCacheSafeLocalStorage.contains(preferencesKey), false);

          // Test for keys that doesn't exist
          expect(await jsonCacheSafeLocalStorage.contains('generickey'), false);
          expect(await jsonCacheSafeLocalStorage.contains('PROFKEY'), false);
          expect(await jsonCacheSafeLocalStorage.contains('PREFKEY'), false);

          // Insert a new piece of data into the cache to test more than one key stored.
          await jsonCacheSafeLocalStorage.refresh(preferencesKey, prefData);

          // Check for multiple data.
          expect(await jsonCacheSafeLocalStorage.contains(profileKey), true);
          expect(
              await jsonCacheSafeLocalStorage.contains(preferencesKey), true);

          // Remove data from the cache.
          await jsonCacheSafeLocalStorage.remove(profileKey);
          expect(await jsonCacheSafeLocalStorage.contains(profileKey), false);
          expect(
              await jsonCacheSafeLocalStorage.contains(preferencesKey), true);

          // Remove data from the cache.
          await jsonCacheSafeLocalStorage.remove(preferencesKey);
          expect(await jsonCacheSafeLocalStorage.contains(profileKey), false);
          expect(
              await jsonCacheSafeLocalStorage.contains(preferencesKey), false);
        },
      );

      test('keys', () async {
        // update data
        await jsonCacheSafeLocalStorage.refresh(profileKey, profData);
        await jsonCacheSafeLocalStorage.refresh(preferencesKey, prefData);

        expect(
          await jsonCacheSafeLocalStorage.keys(),
          [profileKey, preferencesKey],
        );
      });
      group('method "keys"', () {
        setUp(() async {
          // update data
          await jsonCacheSafeLocalStorage.refresh(profileKey, profData);
          await jsonCacheSafeLocalStorage.refresh(preferencesKey, prefData);
        });
        test('should return the inserted keys', () async {
          expect(await jsonCacheSafeLocalStorage.keys(),
              [profileKey, preferencesKey]);
        });
        test('should keep the returned keys immutable', () async {
          final keys = await jsonCacheSafeLocalStorage.keys();
          // This should not change the 'keys' variable.
          await jsonCacheSafeLocalStorage
              .refresh('info', {'This is very important information.': true});
          expect(keys, [profileKey, preferencesKey]);
        });
      });
      test(
        'clear',
        () async {
          // Insert multiple data into the cache.
          await jsonCacheSafeLocalStorage.refresh(profileKey, profData);
          await jsonCacheSafeLocalStorage.refresh(preferencesKey, prefData);

          // Clear it. All data should be deleted with the file.
          await jsonCacheSafeLocalStorage.clear();

          // No data should remain in the cache.
          final cachedValue = await jsonCacheSafeLocalStorage.value(profileKey);
          expect(cachedValue, isNull);

          // Insert a single piece of data into the cache. This refresh avoids errors on operational systems.
          await jsonCacheSafeLocalStorage.refresh(profileKey, profData);
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
