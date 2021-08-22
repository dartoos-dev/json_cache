# json_cache

<center>
  <img width="406" hight="192" alt="json cache logo" src="https://user-images.githubusercontent.com/24878574/119276278-56ef4a80-bbf0-11eb-8701-53a94f24f75b.png" align="middle">
</center>

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
- [Demo application](#demo-application)
- [References](#references)

## Overview

**Json Cache** is an object-oriented package to cache user data locally in json.
It can also be thought of as a layer on top of Flutter's local storage packages
like [sharable_preferences](https://pub.dev/packages/shared_preferences)that
unifies them as an elegant caching API.


In addition, this package gives developers great flexibility by providing a set
of classes that can be selected and grouped in various combinations to meet
specific cache requirements.

**Why Json?**

- Because most of the local storage packages available for Flutter applications
  use json as the data format.
- There is a one-to-one relationship between Dart's built-in type `Map<String,
  dynamic>` and json, which makes encoding/decoding data in json a trivial task.

## Getting Started

`JsonCache` is the core interface of this package and represents the concept of
cached data. It is defined as:

```dart
/// Represents data cached in json.
abstract class JsonCache {
  /// Frees up storage space.
  Future<void> clear();

  /// Updates data at [key] or creates a new cache line at [key] if there is no
  /// previous data there.
  Future<void> refresh(String key, Map<String, dynamic> data);

  /// Removes data from cache at [key] and returns it or returns null if there
  /// is no data at [key].
  Future<Map<String, dynamic>?> erase(String key);

  /// Retrieves either the data at [key] or null if a cache miss occurs.
  Future<Map<String, dynamic>?> recover(String key);
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

<!-- @todo #10 Some implementation is needed to add more examples -->

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
