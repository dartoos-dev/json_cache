import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:json_cache/json_cache.dart';

/// Unit-testing purposes implementation of the [FlutterSecureStorage] class.
class FlutterSecureStorageMock implements FlutterSecureStorage {
  /// Uses a instance of [JsonCacheFake] as the internal in-memory cache.
  FlutterSecureStorageMock() : this.fake(JsonCacheFake());

  /// Set the fake cache instance.
  FlutterSecureStorageMock.fake(this._fakeCache);

  final JsonCache _fakeCache;

  /// throws [UnimplementedError].
  @override
  AndroidOptions get aOptions => throw UnimplementedError();

  /// Tells how many times [write] has been invoked.
  int writeInvokations = 0;

  /// Tells how many times [read] has been invoked.
  int readInvokations = 0;

  /// Tells how many times [delete] has been invoked.
  int deleteInvokations = 0;

  /// Tells how many times [deleteAll] has been invoked.
  int deleteAllInvokations = 0;
  @override
  Future<bool> containsKey({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return (await _fakeCache.value(key)) != null;
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    ++deleteInvokations;
    await _fakeCache.remove(key);
  }

  @override
  Future<void> deleteAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    ++deleteAllInvokations;
    await _fakeCache.clear();
  }

  /// throws [UnimplementedError].
  @override
  IOSOptions get iOptions => throw UnimplementedError();

  /// throws [UnimplementedError].
  @override
  LinuxOptions get lOptions => throw UnimplementedError();

  /// throws [UnimplementedError].
  @override
  MacOsOptions get mOptions => throw UnimplementedError();

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    ++readInvokations;
    final jsonObj = await _fakeCache.value(key);
    return jsonObj == null ? null : json.encode(jsonObj);
  }

  /// throws [UnimplementedError].
  @override
  Future<Map<String, String>> readAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) {
    // TODO: implement readAll
    throw UnimplementedError();
  }

  /// throws [UnimplementedError].
  @override
  WindowsOptions get wOptions => throw UnimplementedError();

  /// throws [UnimplementedError].
  @override
  WebOptions get webOptions => throw UnimplementedError();

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    ++writeInvokations;
    if (value != null) {
      await _fakeCache.refresh(key, json.decode(value) as Map<String, dynamic>);
    }
  }
}
