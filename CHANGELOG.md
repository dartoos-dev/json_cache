# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2022-01-28

### Added

- JsonCacheSecStorage: an implementation on top of the flutter_secure_storage
  package — [58](https://github.com/dartoos-dev/json_cache/issues/58).

## [1.0.0] - 2022-01-08

### Added

- improvements to the README file — [50](https://github.com/dartoos-dev/json_cache/issues/50).

### Changed

- stricter linting rules — [48](https://github.com/dartoos-dev/json_cache/issues/48).
- bump up dependencies — [49](https://github.com/dartoos-dev/json_cache/issues/49).

## [0.3.4] - 2021-08-26

### Added

- significant improvements to the README file.

## [0.3.3] - 2021-08-26

### Added

- JsonCacheEncPrefs: an implementation on top of the
  [encrypted_shared_preferences](https://pub.dev/packages/encrypted_shared_preferences)
  package — [30](https://github.com/dartoos-dev/json_cache/issues/30).

## [0.3.2] - 2021-08-25

### Changed

- removal of _late_ modifier from the attributes of the JsonCacheMem class.

## [0.3.1] - 2021-08-25

### Added

- JsonCacheCrossLocalStorage: an implementation on top of the cross_local_storage
  package — [32](https://github.com/dartoos-dev/json_cache/issues/32).

### Changed

- several fixes and improvements to documentation.
- run flutter format.

## [0.3.0] - 2021-08-25

### Added

- JsonCacheHollow: literally a "hollow" implementation of the JsonCache
  interfaces. Indeed, there is no implementation under its methods. It is aimed
  to be used as a placeholder whenever there is no need for a level2 cache.

### Changed

- JsonCacheMem.mem constructor parameters — **BREAKING CHANGE**.
- improvements in several unit tests.
- general improvements in many doc comments.

### Fixed

- The internal copying logic of the JsonCacheMem.init contructor.

## [0.2.1] - 2021-08-23

### Added

- JsonCacheLocalStorage: an implementation on top of the localstorage package —
  [29](https://github.com/dartoos-dev/json_cache/issues/29).

### Added

- Improvements in README file and documentation in general.

## [0.2.0] - 2021-08-22

### Added

- JsonCachePrefs: an implementation on top of the shared_preferences package —
  [26](https://github.com/dartoos-dev/json_cache/issues/26).

### Changed

- renaming of JsonCache's methods. Method `erase` renamed to `remove`; method
  `recovery`, to `value`. **BREAKING CHANGES**.

## [0.1.0] - 2021-08-22

### Added

- JsonCache interface and the JsonFake, JsonWrap, and JsonMem implementations.

## [0.0.1]

- structural organization:
  - linter setup
  - CI/CD pipelines
  - dependencies
  - README file
  - CHANGELOG file
