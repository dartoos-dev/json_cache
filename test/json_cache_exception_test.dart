import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';

void main() {
  group('JsonCacheException', () {
    group('with original exception:', () {
      const errorMsg = 'A caching operation failure has occurred';
      final exception = Exception(errorMsg);
      const extra = 'Error while reading from cache';
      final jsonCacheException = JsonCacheException(
        extra: extra,
        exception: exception,
      );
      test('must keep "extra" instance', () {
        expect(jsonCacheException.extra, same(extra));
      });
      test('must keep original exception instance', () {
        expect(jsonCacheException.exception, same(exception));
      });
      test('"toString()" must produce a prettily formated message', () {
        expect(
          jsonCacheException.toString(),
          'JsonCacheException: $extra\n$exception',
        );
      });
    });
  });

  group('without original exception:', () {
    const extra = 'Error while writing to cache';
    const jsonCacheException = JsonCacheException(extra: extra);
    test('must keep "extra" instance', () {
      expect(jsonCacheException.extra, same(extra));
    });
    test('original exception instance must be "null"', () {
      expect(jsonCacheException.exception, isNull);
    });
    test('"toString()" must prefix "extra" with "JsonCacheException: "', () {
      expect(
        jsonCacheException.toString(),
        equals('JsonCacheException: $extra'),
      );
    });
  });
}
