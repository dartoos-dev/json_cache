## json_cache

<center>
  <img width="406" hight="192" alt="json cache logo" src="https://user-images.githubusercontent.com/24878574/119276278-56ef4a80-bbf0-11eb-8701-53a94f24f75b.png" align="middle">
</center>

[![EO principles respected here](https://www.elegantobjects.org/badge.svg)](https://www.elegantobjects.org)
[![DevOps By Rultor.com](https://www.rultor.com/b/dartoos-dev/json_cache)](https://www.rultor.com/p/dartoos-dev/json_cache)

[![pub](https://img.shields.io/pub/v/json_cache)](https://pub.dev/packages/json_cache)
[![license](https://img.shields.io/badge/license-mit-green.svg)](https://github.com/dartoos-dev/json_cache/blob/master/LICENSE)
[![style: lint](https://img.shields.io/badge/style-lint-4BC0F5.svg)](https://pub.dev/packages/lint)
[![PDD status](https://www.0pdd.com/svg?name=dartoos-dev/json_cache)](https://www.0pdd.com/p?name=dartoos-dev/json_cache)
[![build](https://github.com/dartoos-dev/json_cache/actions/workflows/build.yml/badge.svg)](https://github.com/dartoos-dev/json_cache/actions/)
[![codecov](https://codecov.io/gh/dartoos-dev/json_cache/branch/master/graph/badge.svg?token=7T5VNQIIMZ)](https://codecov.io/gh/dartoos-dev/json_cache)
[![Hits-of-Code](https://hitsofcode.com/github/dartoos-dev/json_cache)](https://hitsofcode.com/github/dartoos-dev/json_cache/view)

**Json Cache** is an object-oriented package to serve as a layer on top of local
storage packages - packages that persist data locally on the user's device
-, unifying them as an elegant cache API.

In addition, this package gives the programmer great flexibility; it provides a
set of classes that can be selected and combined in various ways to address
specific caching requirements.

**Why Json?**

- Because most of the local storage packages available for Flutter applications
  use json as the data format.
- There is an one-to-one relationship between the Dart's built-in type
  ```Map<String, dynamic>``` and json, which makes json encoding/decoding a
  trivial task.

## Getting Started

```JsonCache``` - the core interface of this package - represents the concept of
cached data. It is defined as:

```dart
/// Represents a cached json data.
abstract class JsonCache {
  /// Frees up cache storage space.
  Future<void> clear();

  /// Refreshes some cached data by its associated key.
  Future<void> refresh(String key, Map<String, dynamic> data);

  /// Erases [key] and returns its associated data.
  Future<Map<String, dynamic>?> erase(String key);

  /// Recovers some cached data; null if a cache miss occurs - no [key] found.
  Future<Map<String, dynamic>?> recover(String key);
}
```

It's reasonable to consider each cache entry (pair of key/data) as a group of
related data. Thus, it is expected to cache user data in groups, in which a key
represents the name of a single group of data. Example:

```dart
'profile': {'name': 'John Doe', 'email': 'johndoe@email.com', 'accountType': 'premium'};
'preferences': {'theme': {'dark': true}, 'notifications':{'enabled': true}}
```

Above the _'profile'_ key is associated with the group of profile related data;
_'preferences'_, with preferences data.

<!-- @todo #10 Some implementation is needed to add more examples -->
