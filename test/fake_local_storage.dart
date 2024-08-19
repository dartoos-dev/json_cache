import 'package:localstorage/localstorage.dart';

typedef IndexValue = ({int index, String value});

/// {@template fake_local_storage}
///
/// Unit-testing purposes implementation of the [LocalStorage] interface.
///
/// {@endtemplate}
final class FakeLocalStorage implements LocalStorage {
  /// {@macro fake_local_storage}
  FakeLocalStorage();

  final Map<String, IndexValue> _data = {};
  final List<String> _keys = [];

  @override
  void clear() {
    _data.clear();
    _keys.clear();
  }

  @override
  String? getItem(String key) => _data[key]?.value;

  @override
  String? key(int index) {
    if (index >= 0 && index < _keys.length) {
      return _keys[index];
    }
    return null;
  }

  @override
  int get length => _data.keys.length;

  @override
  void removeItem(String key) {
    final pair = _data[key];
    if (pair != null) {
      _removeItemAndDecreaseIndexes(key, pair);
    }
  }

  @override
  void setItem(String key, String value) {
    final pair = _data[key];
    if (pair != null) {
      final currIndex = pair.index;
      _data[key] = (index: currIndex, value: value);
    } else {
      _keys.add(key);
      final newIndex = _keys.length - 1;
      _data[key] = (index: newIndex, value: value);
    }
  }

  void _removeItemAndDecreaseIndexes(
    String key,
    ({int index, String value}) pair,
  ) {
    _keys.removeAt(pair.index);
    _data.remove(key);
    _data.keys.forEach(_decreaseIndexAt);
  }

  void _decreaseIndexAt(String key) {
    final pair = _data[key]!;
    _data[key] = (index: pair.index - 1, value: pair.value);
  }
}
