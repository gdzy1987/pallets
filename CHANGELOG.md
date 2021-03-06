# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.9.0] - 2020-07-05
### Added
- limit number of jobs in given up set by number (#56)
- job duration and metadata to all task logs (#57)

### Changed
- remove all related workflow keys when giving up on a job (#55)
- support redis-rb ~> 4.2 (#58)

### Removed
- support for configuring custom loggers (#57)

## [0.8.0] - 2020-06-09
### Added
- sync output in CLI (#49)
- support for configuring custom loggers (#50)

### Changed
- improve job scheduling using jobmasks (#52)

## [0.7.0] - 2020-01-19
### Added
- support for Ruby 2.7 (#46)

## [0.6.0] - 2019-09-02
### Added
- define task aliases in order to reuse tasks within a workflow definition (#44)
- define anonymous workflows (#45)

## [0.5.1] - 2019-06-01
### Changed
- fix transaction completeness in Appsignal instrumenter (#43)

## [0.5.0] - 2019-05-12
### Added
- wrap job execution with middleware (#38)
- use `Middleware::JobLogger` for job logging (#39)
- allow Appsignal instrumentation using `Middleware::AppsignalInstrumenter` (#40)

### Removed
- support for Ruby 2.3 (#41)

## [0.4.0] - 2019-04-07
### Added
- give up workflow before it finishes by returning `false` in any of its tasks (#25)
- jobs have a JID (#30)
- Rails support (#27)

### Changed
- contexts are serialized and accept basic Ruby types as values (#24)
- workflow tasks are defined using classes (#26)
- some job and Redis keys have been renamed (#28)
- job retry backoff has a random component (#32)
- missing dependencies raise a `WorkflowError` (#31)
- Redis backend uses `EVALSHA` for Lua scripts (#34)
- the `pool_size` configuration is inferred from `concurrency` (#33)

### Removed
- backend namespaces (#28)

## [0.3.0] - 2019-02-08
### Added
- shared contexts (#9)
- handle TERM and TTIN signals (#15, #17)
- configure how long failed jobs are kept (#21)

### Changed
- use a single Redis connection when picking up work (#11)
- improve logging (#14)
- fix handling empty workflows and contexts (#18)
- fix encoding for msgpack serializer (#19)
- malformed jobs are given up rather than discarded (#22)

### Removed
- support for Ruby 2.1 & 2.2 (#13)

## [0.2.0] - 2018-10-02
### Added
- msgpack serializer (#5)

## 0.1.0 - 2018-09-29
- Pallets' inception <3

[Unreleased]: https://github.com/linkyndy/pallets/compare/compare/v0.5.1...HEAD
[0.5.1]: https://github.com/linkyndy/pallets/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/linkyndy/pallets/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/linkyndy/pallets/compare/v0.3.0...v0.5.0
[0.3.0]: https://github.com/linkyndy/pallets/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/linkyndy/pallets/compare/v0.1.0...v0.2.0
