import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';
import 'package:mocktail/mocktail.dart';

class JsonCacheMock extends Mock implements JsonCache {}

void main() {
  group('JsonCacheTry', () {
    final jsonCacheMock = JsonCacheMock();
    test('should avoid JsonCacheTry as the wrapped instance', () async {
      expect(
        () => JsonCacheTry(JsonCacheTry(jsonCacheMock)),
        throwsAssertionError,
      );
    });
    test('clear', () async {
      final JsonCacheTry jsonCacheTry = JsonCacheTry(jsonCacheMock);
      // Stub the 'clear' method.
      when(() => jsonCacheMock.clear()).thenThrow(Exception('Cache Failure'));
      // Verify no interactions have occurred.
      verifyNever(() => jsonCacheMock.clear());
      // Interact with the jsonCacheTry instance.
      expect(
        () async => jsonCacheTry.clear(),
        throwsA(const TypeMatcher<JsonCacheException>()),
      );
      // Check if the interaction occurred only once.
      verify(() => jsonCacheMock.clear()).called(1);
    });
    test('contains', () async {
      final JsonCacheTry jsonCacheTry = JsonCacheTry(jsonCacheMock);
      // Stub the 'contains' method.
      when(() => jsonCacheMock.contains('aKey'))
          .thenThrow(Exception('Cache Failure'));
      // Verify no interactions have occurred.
      verifyNever(() => jsonCacheMock.contains('aKey'));
      // Interact with the jsonCacheTry instance.
      expect(
        () async => jsonCacheTry.contains('aKey'),
        throwsA(const TypeMatcher<JsonCacheException>()),
      );
      // Check if the interaction occurred only once.
      verify(() => jsonCacheMock.contains('aKey')).called(1);
    });
    test('refresh', () async {
      final JsonCacheTry jsonCacheTry = JsonCacheTry(jsonCacheMock);
      // Stub the 'refresh' method.
      when(() => jsonCacheMock.refresh('aKey', {}))
          .thenThrow(Exception('Cache Failure'));
      // Verify no interactions have occurred.
      verifyNever(() => jsonCacheMock.refresh('aKey', {}));
      // Interact with the jsonCacheTry instance.
      expect(
        () async => jsonCacheTry.refresh('aKey', {}),
        throwsA(const TypeMatcher<JsonCacheException>()),
      );
      // Check if the interaction occurred only once.
      verify(() => jsonCacheMock.refresh('aKey', {})).called(1);
    });
    test('remove', () async {
      final JsonCacheTry jsonCacheTry = JsonCacheTry(jsonCacheMock);
      // Stub the 'remove' method.
      when(() => jsonCacheMock.remove('aKey'))
          .thenThrow(Exception('Cache Failure'));
      // Verify no interactions have occurred.
      verifyNever(() => jsonCacheMock.remove('aKey'));
      // Interact with the jsonCacheTry instance.
      expect(
        () async => jsonCacheTry.remove('aKey'),
        throwsA(const TypeMatcher<JsonCacheException>()),
      );
      // Check if the interaction occurred only once.
      verify(() => jsonCacheMock.remove('aKey')).called(1);
    });
    test('value', () async {
      final JsonCacheTry jsonCacheTry = JsonCacheTry(jsonCacheMock);
      // Stub the 'value' method.
      when(() => jsonCacheMock.value('aKey'))
          .thenThrow(Exception('Cache Failure'));
      // Verify no interactions have occurred.
      verifyNever(() => jsonCacheMock.value('aKey'));
      // Interact with the jsonCacheTry instance.
      expect(
        () async => jsonCacheTry.value('aKey'),
        throwsA(const TypeMatcher<JsonCacheException>()),
      );
      // Check if the interaction occurred only once.
      verify(() => jsonCacheMock.value('aKey')).called(1);
    });
  });
}
