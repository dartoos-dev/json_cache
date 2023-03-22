# json_cache

<p align="center">
<img width="156" alt="json_cache_img" src="https://user-images.githubusercontent.com/24878574/161399703-c99ef48d-e193-4e4e-a557-bc511d2dfe5e.png">
</p>

[![EO principles respected
here](https://www.elegantobjects.org/badge.svg)](https://www.elegantobjects.org)
[![DevOps By
Rultor.com](https://www.rultor.com/b/dartoos-dev/json_cache)](https://www.rultor.com/p/dartoos-dev/json_cache)
    
[![pub](https://img.shields.io/pub/v/json_cache)](https://pub.dev/packages/json_cache)
[![license](https://img.shields.io/badge/license-mit-green.svg)](https://github.com/dartoos-dev/json_cache/blob/master/LICENSE)
[![PDD status](https://www.0pdd.com/svg?name=dartoos-dev/json_cache)](https://www.0pdd.com/p?name=dartoos-dev/json_cache)

[![build](https://github.com/dartoos-dev/json_cache/actions/workflows/build.yml/badge.svg)](https://github.com/dartoos-dev/json_cache/actions/)
[![codecov](https://codecov.io/gh/dartoos-dev/json_cache/branch/master/graph/badge.svg?token=W6spF0S796)](https://codecov.io/gh/dartoos-dev/json_cache)
[![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/rafamizes/json_cache)](https://www.codefactor.io/repository/github/rafamizes/json_cache)
[![style: lint](https://img.shields.io/badge/style-lint-4BC0F5.svg)](https://pub.dev/packages/lint)
[![Hits-of-Code](https://hitsofcode.com/github/dartoos-dev/json_cache?branch=master)](https://hitsofcode.com/github/dartoos-dev/json_cache/view?branch=master)

## Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
  - [Storing Simple Values](#storing-simple-values)
  - [Suggested Dependency Relationship](#suggested-dependency-relationship)
- [Implementations](#implementations)
  - [JsonCacheMem — Thread-safe In-memory cache](#jsoncachemem)
  - [JsonCacheTry — Enhanced Diagnostic Messages](#jsoncachetry)
  - [JsonCachePrefs — SharedPreferences](#jsoncacheprefs)
  - [JsonCacheLocalStorage — LocalStorage](#jsoncachelocalstorage)
  - [JsonCacheFlutterSecureStorage — FlutterSecureStorage](#jsoncachefluttersecurestorage)
  - [JsonCacheCrossLocalStorage — CrossLocalStorage](#jsoncachecrosslocalstorage)
  - [JsonCacheHive — Hive](#jsoncachehive)
- [Unit Test Tips](#unit-test-tips)
  - [Mocking](#mocking)
  - [Fake Implementations](#fake-implementations)
  - [Widget Testing](#widget-testing)
    - [Example of Widget Test Code](#example-of-widget-test-code)
  - [SharedPreferences in Tests](#sharedpreferences-in-tests)
- [Demo application](#demo-application)
- [Contribute](#contribute)
- [References](#references)

## Overview

> Cache is a hardware or software component that stores data so that future
> requests for that data can be served faster; the data stored in a cache might
> be the result of an earlier computation or a copy of data stored elsewhere.
>
> — [Cache_(computing) (2021, August 22). In Wikipedia, The Free Encyclopedia.
> Retrieved 09:55, August 22,
> 2021](https://en.wikipedia.org/wiki/Cache_(computing))

**JsonCache** is an object-oriented package for local caching of user data
in json. It can also be considered as a layer on top of Flutter's local storage
packages that aims to unify them with a stable and elegant interface —
_[JsonCache](https://pub.dev/documentation/json_cache/latest/json_cache/JsonCache-class.html)_.

**Why Json?**

- Because most of the local storage packages available for Flutter applications
  use Json as the data format.
- There is a one-to-one relationship between Dart's built-in type `Map<String,
  dynamic>` and Json, which makes encoding/decoding data in Json a trivial task.

## Getting Started

This package gives developers great flexibility by providing a set of classes
that can be selected and grouped in various combinations to meet specific cache
requirements.

[JsonCache](https://pub.dev/documentation/json_cache/latest/json_cache/JsonCache-class.html)
is the core interface of this package and represents the concept of cached data.
It is defined as:

```dart
/// Represents cached data in json format.
abstract class JsonCache {
  /// Frees up storage space — deletes all keys and values.
  Future<void> clear();

  /// Removes cached data located at [key].
  Future<void> remove(String key);

  /// Retrieves cached data located at [key] or `null` if a cache miss occurs.
  Future<Map<String, dynamic>?> value(String key);

  /// It either updates data located at [key] with [value] or, if there is no
  /// data at [key], creates a new cache row at [key] with [value].
  ///
  /// **Note**: [value] must be json encodable.
  Future<void> refresh(String key, Map<String, dynamic> value);

  /// Checks for cached data located at [key].
  ///
  /// Returns `true` if there is cached data at [key]; `false` otherwise.
  Future<bool> contains(String key);
}
```

It is reasonable to consider each cache entry (a key/data pair) as a group of
related data. Thus, it is expected to cache data into groups, where a key
represents the name of a single data group. For example:

```dart
'profile': {'name': 'John Doe', 'email': 'johndoe@email.com', 'accountType': 'premium'};
'preferences': {'theme': {'dark': true}, 'notifications': {'enabled': true}}
```

Above, the _profile_ key is associated with profile-related data, while
the _preferences_ key is associated with the user's preferences.

A typical code for saving the previous _profile_ and _preferences_ data is:

```dart
final JsonCache jsonCache = … retrieve one of the JsonCache implementations.
…
await jsonCache.refresh('profile', {'name': 'John Doe', 'email': 'johndoe@email.com', 'accountType': 'premium'});
await jsonCache.refresh('preferences', {'theme': {'dark': true}, 'notifications':{'enabled': true}});
```
### Storing Simple Values

In order to store a simple value such as a `string`, `int`, `double`, etc,
define it as a **map key** whose associated value is a boolean placeholder value
set to `true`. For example:

```dart
  /// Storing a simple text information.
  jsonCache.refresh('info', {'an important information': true});

  // later on…

  // This variable is a Map containing a single key.
  final cachedInfo = await jsonCache.value('info');
  // The key itself is the content of the stored information.
  final info = cachedInfo?.keys.first;
  print(info); // 'an important information'

```

### Suggested Dependency Relationship

Whenever a function, method, or class needs to interact with cached user data,
this should be done via a reference to the `JsonCache` interface.

See the code snippet below:

```dart
/// Stores/retrieves user data from the device's local storage.
class JsonCacheRepository implements ILocalRepository {
  /// Sets the [JsonCache] instance.
  const JsonCacheRepository(this._cache);
  // This class depends on an interface rather than any actual implementation
  final JsonCache _cache;

  /// Retrieves a cached email by [userId] or `null` if not found.
  @override
  Future<String?> getUserEmail(String userId) async {
    final userData = await _cache.value(userId);
    if (userData != null) {
      // the email value or null if absent.
      return userData['email'] as String?; 
    }
    // There is no data associated with [userId].
    return null;
  }
}
```

By depending on an interface rather than an actual implementation, your code
becomes [loosely coupled](https://en.wikipedia.org/wiki/Loose_coupling) to this
package — which makes unit testing a lot easier.

## Implementations

The library
[JsonCache](https://pub.dev/documentation/json_cache/latest/json_cache/json_cache-library.html)
contains all classes that implement the
[JsonCache](https://pub.dev/documentation/json_cache/latest/json_cache/JsonCache-class.html)
interface with more in-depth details.

The following sections are an overview of each implementation.

### JsonCacheMem

[JsonCacheMem](https://pub.dev/documentation/json_cache/latest/json_cache/JsonCacheMem-class.html)
is a thread-safe in-memory implementation of the `JsonCache` interface.
Moreover, it encapsulates a secondary cache or "slower level2 cache". Typically,
this secondary cache instance is responsible for the local cache; that is, it is
the `JsonCache` implementation that actually persists the data on the user's
device.

#### Typical Usage

Since `JsonCacheMem` is a
[Decorator](https://en.wikipedia.org/wiki/Decorator_pattern), you should
normally pass another `JsonCache` instance to it whenever you instantiate a
`JsonCacheMem` object. For example:

```dart
  …
  /// Cache initialization
  final prefs = await SharedPreferences.getInstance();
  final JsonCacheMem jsonCache = JsonCacheMem(JsonCachePrefs(prefs));
  …
  /// Saving profile and preferences data.
  await jsonCache.refresh('profile', {'name': 'John Doe', 'email': 'johndoe@email.com', 'accountType': 'premium'});
  await jsonCache.refresh('preferences', {'theme': {'dark': true}, 'notifications':{'enabled': true}});
  …
  /// Retrieving preferences data.
  final Map<String, dynamic>? preferences = await jsonCache.value('preferences');
  …
  /// Frees up cached data before the user leaves the application.
  Future<void> signout() async {
    await jsonCache.clear();
  }
  …
  /// Removes cached data related to a specific user.
  Future<void> signoutId(String userId) async
    await jsonCache.remove(userId);
  }
```

#### Cache Initialization

[JsonCacheMem.init](https://p.dev/documentatijson_cache/latest/json_cache/JsonCacheMem/JsonCacheMem.init.html)
is the constructor whose purpose is to initialize the cache upon object
instantiation. The data passed to the `init` parameter is deeply copied to both
the internal in-memory cache and the level2 cache.

```dart
  …
  final LocalStorage storage = LocalStorage('my_data');
  final Map<String, Map<String, dynamic>?> initData = await fetchData();
  final JsonCacheMem jsonCache = JsonCacheMem.init(initData, level2:JsonCacheLocalStorage(storage));
  …
```

### JsonCacheTry

[JsonCacheTry](https://pub.dev/documentation/json_cache/latest/json_cache/JsonCacheTry-class.html)
is an implementation of the `JsonCache` interface whose sole purpose is to
supply enhanced diagnostic information when a cache failure occurs. It does this
by throwing [JsonCacheException](https://pub.dev/documentation/json_cache/latest/json_cache/JsonCacheException-class.html)
with the underlying stack trace.

Since `JsonCacheTry` is a
[Decorator](https://en.wikipedia.org/wiki/Decorator_pattern), you must pass
another `JsonCache` instance to it whenever you instantiate a `JsonCacheTry`
object. For example:

```dart
  …
  // Local storage cache initialization
  final prefs = await SharedPreferences.getInstance();
  // JsonCacheTry instance initialized with in-memory and local storage caches.
  final jsonCacheTry = JsonCacheTry(JsonCacheMem(JsonCachePrefs(prefs)));
  …
```

### JsonCachePrefs

[JsonCachePrefs](https://pub.dev/documentation/json_cache/latest/json_cache/JsonCachePrefs-class.html)
is an implementation on top of the
[shared_preferences](https://pub.dev/packages/shared_preferences) package.

```dart
  …
  final prefs = await SharedPreferences.getInstance();
  final JsonCache jsonCache = JsonCacheMem(JsonCachePrefs(prefs));
  …
```
### JsonCacheLocalStorage

[JsonCacheLocalStorage](https://pub.dev/documentation/json_cache/latest/json_cache/JsonCacheLocalStorage-class.html)
is an implementation on top of the
[localstorage](https://pub.dev/packages/localstorage) package.

```dart
  …
  final LocalStorage storage = LocalStorage('my_data');
  final JsonCache jsonCache = JsonCacheMem(JsonCacheLocalStorage(storage));
  …
```


### JsonCacheFlutterSecureStorage

JsonCacheFlutterSecureStorage
is an implementation on top of the
[flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) package.

```dart
  …
  final flutterSecureStorage = FlutterSecureStorage(…);
  final JsonCache jsonCache = JsonCacheFlutterSecureStorage(flutterSecureStorage);
  // In order to write a string value, define it as a map key whose associated
  // value is a boolean placeholder value set to 'true'.
  jsonCache.refresh('secret', {'a secret info': true});

  // later on…

  final cachedInfo = await jsonCache.value('secret');
  final info = cachedInfo?.keys.first; // 'a secret info'
```

### JsonCacheCrossLocalStorage

[JsonCacheLocalCrossStorage](https://pub.dev/documentation/json_cache/latest/json_cache/JsonCacheCrossLocalStorage-class.html)
is an implementation on top of the
[cross_local_storage](https://pub.dev/packages/cross_local_storage) package.

```dart
  …
  final LocalStorageInterface prefs = await LocalStorage.getInstance();
  final JsonCache jsonCache = JsonCacheMem(JsonCacheCrossLocalStorage(prefs));
```

### JsonCacheHive

[JsonCacheHive](https://pub.dev/documentation/json_cache/latest/json_cache/JsonCacheHive.html)
is an implementation on top of the [hive](https://pub.dev/packages/hive)
package.

```dart
  …
  await Hive.initFlutter(); // mandatory initialization.
  final box = await Hive.openBox<String>('appBox'); // it must be a Box<String>.
  final JsonCache hiveCache = JsonCacheMem(JsonCacheHive(box));
  …
```
## Unit Test Tips

This package has been designed with unit testing in mind. This is one of the
reasons for the existence of the `JsonCache` interface.

### Mocking

Since `JsonCache` is the core interface of this package, you can easily
[mock](https://docs.flutter.dev/cookbook/testing/unit/mocking) a implementation
that suits you when unit testing your code.

For example, with [mocktail](https://pub.dev/packages/mocktail) a mock
implementation should look like this:

```dart
import 'package:mocktail/mocktail.dart';

class JsonCacheMock extends Mock implements JsonCache {}

void main() {
  // the mock instance.
  final jsonCacheMock = JsonCacheMock();

  test('should retrieve the preferences data', () async {
    // Stub the 'value' method.
    when(() => jsonCacheMock.value('preferences')).thenAnswer(
      (_) async => <String, dynamic>{
        'theme': {'dark': true},
        'notifications': {'enabled': true}
      },
    );

    // Verify no interactions have occurred.
    verifyNever(() => jsonCacheMock.value('preferences'));

    // Interact with the jsonCacheMock instance.
    final preferencesData = await jsonCacheMock.value('preferences');

    // Assert
    expect(
      preferencesData,
      equals(
        <String, dynamic>{
          'theme': {'dark': true},
          'notifications': {'enabled': true}
        },
      ),
    );

    // Check if the interaction occurred only once.
    verify(() => jsonCacheMock.value('preferences')).called(1);
  });
}

```

### Fake Implementations

In addition to mocking, there is another approach to unit testing: making use of
a 'fake' implementation. Usually this so-called 'fake' implementation provides
the functionality required by the `JsonCache` interface without touching the
device's local storage. An example of this implementation is the
[JsonCacheFake](https://pub.dev/documentation/json_cache/latest/json_cache/JsonCacheFake-class.html)
class — whose sole purpose is to help developers with unit tests.

### Widget Testing

Because of the asynchronous nature of dealing with cached data, you're better
off putting all your test code inside a `tester.runAsync` method; otherwise,
your test case may stall due to a
[deadlock](https://en.wikipedia.org/wiki/Deadlock) caused by a [race
condition](https://stackoverflow.com/questions/34510/what-is-a-race-condition)
as there might be multiple `Futures` trying to access the same resources at the
same time.

#### Example of Widget Test Code

Your widget test code should look similar to the following code snippet:

```dart
testWidgets('refresh cached value', (WidgetTester tester) async {
  final LocalStorage localStorage = LocalStorage('my_cached_data');
  final jsonCache = JsonCacheMem(JsonCacheLocalStorage(localStorage));
  tester.runAsync(() async {
    // asynchronous code inside runAsync.
    await jsonCache.refresh('test', <String, dynamic>{'aKey': 'aValue'});
  });
});
```

### SharedPreferences in Tests

Whenever you run any unit tests involving the
[shared_preferences](https://pub.dev/packages/shared_preferences) package, you
must call the `SharedPreferences.setMockInitialValues()` function at the very
beginning of the test file; otherwise, the system may throw an error whose
description is: 'Binding has not yet been initialized'.

Example:

```dart

void main() {
  SharedPreferences.setMockInitialValues({});
  // the test cases come below
  … 
}
```

## Demo application

The demo application provides a fully working example, focused on demonstrating
the caching API in action. You can take the code in this demo and experiment
with it.

To run the demo application:

```shell
  git clone https://github.com/dartoos-dev/json_cache.git
  cd json_cache/example/
  flutter run -d chrome
```

This should launch the demo application on Chrome in debug mode.

## Contribute

Contributors are welcome!

1. Open an **issue** regarding an improvement, a bug you noticed, or ask to be
   assigned to an existing one.
2. If the issue is confirmed, **fork** the repository, do the changes on a
   separate branch and make a **Pull Request**.
3. After review and acceptance, the PR is merged and closed.

Make sure the command below **passes** before making a Pull Request.

```shell
  flutter analyze && flutter test
```

## References

- [Dart and race conditions](https://pub.dev/packages/mutex)
