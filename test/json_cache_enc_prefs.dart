import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  group('JsonCachePrefs', () {
    test('clear, value, refresh', () async {
      const profKey = 'profile';
      const profData = <String, Object>{'id': 1, 'name': 'John Due'};
      final JsonCacheEncPrefs encPrefsCache =
          JsonCacheEncPrefs(EncryptedSharedPreferences());
      await encPrefsCache.refresh(profKey, profData);
      var prof = await encPrefsCache.value(profKey);
      expect(prof, profData);
      await encPrefsCache.clear();
      prof = await encPrefsCache.value(profKey);
      expect(prof, isNull);
    });

    test('remove', () async {
      const profKey = 'profile';
      const prefKey = 'preferences';
      final profData = <String, Object>{'id': 1, 'name': 'John Due'};
      final prefData = <String, Object>{
        'theme': 'dark',
        'notifications': {'enabled': true}
      };
      final JsonCacheEncPrefs encPrefsCache =
          JsonCacheEncPrefs(EncryptedSharedPreferences());
      await encPrefsCache.refresh(profKey, profData);
      await encPrefsCache.refresh(prefKey, prefData);

      var prof = await encPrefsCache.value(profKey);
      expect(prof, profData);

      await encPrefsCache.remove(profKey);
      prof = await encPrefsCache.value(profKey);
      expect(prof, isNull);

      var pref = await encPrefsCache.value(prefKey);
      expect(pref, prefData);
      await encPrefsCache.remove(prefKey);
      pref = await encPrefsCache.value(prefKey);
      expect(pref, isNull);
    });
  });
}
