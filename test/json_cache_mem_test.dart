import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';

void main() {
  group('JsonCacheMem', () {
    test('clear', () async {
      final Map<String, Map<String, dynamic>> data = {
        'profile': <String, dynamic>{'id': 1, 'name': 'John Due'}
      };
      await JsonCacheMem.mem(JsonCacheFake.mem(data), data).clear();
      expect(data.isEmpty, true);
    });
  });
}
