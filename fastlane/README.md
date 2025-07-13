fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios api_lint

```sh
[bundle exec] fastlane ios api_lint
```

Validate OpenAPI specification

### ios pre_build_checks

```sh
[bundle exec] fastlane ios pre_build_checks
```

Run all pre-build validations

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Build and deploy beta version

### ios release

```sh
[bundle exec] fastlane ios release
```

Build and deploy release version

### ios test

```sh
[bundle exec] fastlane ios test
```

Run tests

### ios security_scan

```sh
[bundle exec] fastlane ios security_scan
```

Run security scan

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
