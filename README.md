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

**Json Cache** is an object-oriented package to serve as a layer on top of local
storage packages, unifying them as an elegant caching API.

In addition, this package gives developers great flexibility by providing a set
of classes that can be selected and combined in various ways to meet specific
requirements.

**Why Json?**

- Because most of the local storage packages available for Flutter applications
  use json as the data format.
- There is an one-to-one relationship between the Dart's built-in type
  `Map<String, dynamic>` and json, which makes json encoding/decoding a
  trivial task.

## Getting Started

`JsonCache` is the core interface of this package and represents the concept of
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

It is reasonable to consider each cache entry (a key/data pair) as a group of
related data. Thus, it is expected to cache user data into groups where a key
represents the name of a single data group. For example:

```dart
'profile': {'name': 'John Doe', 'email': 'johndoe@email.com', 'accountType': 'premium'};
'preferences': {'theme': {'dark': true}, 'notifications':{'enabled': true}}
```

Above the _'profile'_ key is associated with the group of profile related data;
_'preferences'_, with preferences data.

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
