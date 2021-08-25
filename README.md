# json_cache

<img width="406" hight="192" alt="json cache logo" src="https://user-images.githubusercontent.com/24878574/119276278-56ef4a80-bbf0-11eb-8701-53a94f24f75b.png" align="middle">

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
- [List of JsonCache implementations](#list-of-jsoncache-implementations)
  - [JsonCacheMem — Thread-safe In-memory cache](#jsoncachemem)
  - [JsonCachePrefs — SharedPreferences](#jsoncacheprefs)
  - [JsonCacheLocalStorage — LocalStorage](#jsoncachelocalstorage)
- [Demo application](#demo-application)
- [References](#references)

## Overview


> Cache is a hardware or software component that stores data so that future
> requests for that data can be served faster; the data stored in a cache might
> be the result of an earlier computation or a copy of data stored elsewhere.
>
> — [Cache_(computing) (2021, August 22). In Wikipedia, The Free Encyclopedia.
> Retrieved 09:55, August 22,
> 2021](https://en.wikipedia.org/wiki/Cache_(computing))

**JsonCache** is an object-oriented package to cache user data locally in json.
It can also be thought of as a layer on top of Flutter's local storage packages
like the [sharable_preferences](https://pub.dev/packages/shared_preferences) and
[localstorage](https://pub.dev/packages/localstorage) packages.

Therefore, this package aims to unify most of Flutter's local caching packages
into an elegant caching API.

**Why Json?**

- Because most of the local storage packages available for Flutter applications
  use json as the data format.
- There is a one-to-one relationship between Dart's built-in type `Map<String,
  dynamic>` and json, which makes encoding/decoding data in json a trivial task.

## Getting Started

This package gives developers great flexibility by providing a set of classes that
can be selected and grouped in various combinations to meet specific cache
requirements.

`JsonCache` is the core interface of this package and represents the concept of
cached data. It is defined as:

```dart
/// Represents cached data in json format.
abstract class JsonCache {
  /// Frees up storage space.
  Future<void> clear();

  /// Removes cached data located at [key].
  Future<void> remove(String key);

  /// Retrieves cached data located at [key] or null if a cache miss occurs.
  Future<Map<String, dynamic>?> value(String key);

  /// It either updates data located at [key] with [value] or, if there is no
  /// previous data at [key], creates a new cache row at [key] with [value].
  ///
  /// **Note**: [value] must be json encodable.
  Future<void> refresh(String key, Map<String, dynamic> value);
}
```

It is reasonable to consider each cache entry (a key/data pair) as a group of
related data. Thus, it is expected to cache data into groups, where a key
represents the name of a single data group. For example:

```dart
'profile': {'name': 'John Doe', 'email': 'johndoe@email.com', 'accountType': 'premium'};
'preferences': {'theme': {'dark': true}, 'notifications':{'enabled': true}}
```

Above, the _profile_ key is associated with the profile-related data group,
while the _preferences_ key is associated with the preferences-related data.

A typical code for saving the previous _profile_ and _preferences_ data is:

```dart
final JsonCache jsonCache = … retrieve one of the JsonCache implementations.
…
await jsonCache.refresh('profile', {'name': 'John Doe', 'email': 'johndoe@email.com', 'accountType': 'premium'});
await jsonCache.refresh('preferences', {'theme': {'dark': true}, 'notifications':{'enabled': true}});
```

## List of JsonCache Implementations

The library
[JsonCache](https://pub.dev/documentation/json_cache/latest/json_cache/json_cache-library.html)
contains all classes that implement the
[JsonCache](https://pub.dev/documentation/json_cache/latest/json_cache/JsonCache-class.html)
interface with more in-depth details.

The following sections are an overview of each implementation.

### JsonCacheMem

[JsonCacheMem](https://pub.dev/documentation/json_cache/latest/json_cache/JsonCacheMem-class.html)
is is a thread-safe in-memory implementation of the `JsonCache` interface.
Moreover, it encapsulates a secondary cache or "slower level2 cache". Typically,
the secondary cache instance is responsible for the local cache; that is, it is
the cache instance that persists data on the user's device.

#### Typical Usage

Due to the fact that `JsonCacheMem` is a decorator, you should always pass
another `JsonCache` instance to it whenever you instantiates a `JsonCacheMem`
object. For example:

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
  final Map<String, dynamic> preferences = await jsonCache.value('preferences');
  …
  /// Frees up cached data before the user leaves the application.
  Future<void> signout() async {
    await jsonCache.clear();
  }
  …
  /// Removes cached data related to a specific user.
  Future<void> signoutId(String userId) async {
    await jsonCache.remove(userId);
  }
```

In addition, `JsonCacheMem` has the `JsonCacheMem.init` constructor whose
purpose is the initialize the cache. Data is deep copied from the initialization
buffer to its internal in-memory cache and to its level2 cache as well.

```dart
  …
  final LocalStorage storage = LocalStorage('my_data');
  final Map<String, Map<String, dynamic>?> initData = await fetchInfo();
  final JsonCacheMem jsonCache = JsonCacheMem.init(initData, level2:JsonCacheLocalStorage(storage));
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
[localstorage](https://pub.dev/packages/localstorage)

```dart
  …
  final LocalStorage storage = LocalStorage('my_data');
  final JsonCache jsonCache = JsonCacheMem(JsonCacheLocalStorage(storage));
  …
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

## References

- [Caching for objects](https://www.pragmaticobjects.com/chapters/012_caching_for_objects.html)
- [Dart and race conditions](https://pub.dev/packages/mutex)
