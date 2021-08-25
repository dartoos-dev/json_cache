# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- JsonCacheHollow: literally a "hollow" implementation of the JsonCache
  interfaces. Indeed, there is no implementation under its methods. It is aimed
  to be used as a placeholder whenever there is no need for a level2 cache.

### Changed

- rename JsonCacheMem.mem constructor to JsonCacheMem.ext — **BREAKING CHANGE**.
- improvements in several unit tests.
- general improvements in many doc comments.

### Fixed

- The internal copying logic of the JsonCacheMem.init contructor.

## [0.2.1] - 2021-08-23

### Added

- JsonCacheLocalStorage: implementation on top of the localstorage package —
  [29](https://github.com/dartoos-dev/json_cache/issues/29).

### Added

- Improvements in README file and documentation in general.

## [0.2.0] - 2021-08-22

### Added

- JsonCachePrefs: implementation on top of the shared_preferences package —
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
