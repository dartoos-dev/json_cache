import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';

void main() {
  group('JsonCacheException', () {
    test('Defined Original Exception', () {
      const errorMessage = 'A caching operation failure has occurred';
      final originalException = Exception(errorMessage);
      const extraInfo = 'Error while reading from cache';
      final jsonCacheException = JsonCacheException(
        extra: extraInfo,
        exception: originalException,
      );
      expect(identical(jsonCacheException.extra, extraInfo), true);
      expect(identical(jsonCacheException.exception, originalException), true);
      expect(jsonCacheException.toString(), '$extraInfo\n$originalException');
    });

    test('Undefined Original Exception', () {
      const extraInfo = 'Error while writing to cache';
      const jsonCacheException = JsonCacheException(extra: extraInfo);
      expect(identical(jsonCacheException.extra, extraInfo), true);
      expect(jsonCacheException.exception, null);
      expect(jsonCacheException.toString(), extraInfo);
    });
  });
}
