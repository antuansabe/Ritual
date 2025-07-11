# fastlane documentation

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### api_lint

```
fastlane ios api_lint
```

Validate OpenAPI specification

Validates the backend/openapi.yaml file using multiple validation methods:
- redoc-cli for specification building and validation
- openapi-lint-cli for detailed linting (if available)
- YAML structure validation
- Required fields verification
- Breaking changes detection (compares with git history)

**Prerequisites:**
- Node.js and npm installed
- redoc-cli package (auto-installed)
- openapi-lint-cli package (auto-installed)

**Usage:**
```bash
# Run standalone
fastlane ios api_lint

# Automatically runs before beta and release builds
fastlane ios beta
fastlane ios release
```

### pre_build_checks

```
fastlane ios pre_build_checks
```

Run all pre-build validations

Runs comprehensive validation before building:
- API contract validation (api_lint)
- Additional checks can be added here

### beta

```
fastlane ios beta
```

Build and deploy beta version

**Before all actions:**
- Validates OpenAPI specification (api_lint)

**Actions:**
- Increments build number
- Builds app in Release configuration
- Uploads to TestFlight
- Uses ad-hoc provisioning for distribution

### release

```
fastlane ios release
```

Build and deploy release version

**Before all actions:**
- Validates OpenAPI specification (api_lint)

**Actions:**
- Ensures on main branch
- Ensures git status is clean
- Increments version number (patch)
- Increments build number
- Builds app for App Store
- Uploads to App Store Connect
- Commits version bump
- Creates git tag
- Pushes to git remote

### test

```
fastlane ios test
```

Run tests

Runs the test suite using the iPhone 16 Pro simulator.

### security_scan

```
fastlane ios security_scan
```

Run security scan

Executes the security_scan.sh script to check for security vulnerabilities.

## API Validation Details

The `api_lint` lane performs comprehensive validation of the OpenAPI specification:

### Validation Methods

1. **redoc-cli Validation**
   - Attempts to build API documentation
   - Fails if specification has structural issues
   - Most reliable validation method

2. **openapi-lint-cli Validation** (if available)
   - Detailed linting with specific error messages
   - Categorizes issues by severity (error/warning)
   - Provides path-specific feedback

3. **YAML Structure Validation**
   - Validates YAML syntax
   - Checks required OpenAPI 3.x fields
   - Verifies authentication endpoints exist
   - Validates security scheme configuration

4. **Breaking Changes Detection**
   - Compares with previous git version
   - Identifies potential breaking changes
   - Warns about removed endpoints, parameters, or required fields

### Error Handling

- **Build Failure**: Critical validation errors will fail the entire build
- **Warnings**: Non-critical issues are logged but don't stop the build
- **Graceful Degradation**: If advanced tools fail, basic validation still runs

### Setup Requirements

```bash
# Install Node.js dependencies
npm install

# Or install manually
npm install -g redoc-cli openapi-lint-cli

# Install fastlane
gem install fastlane

# Initialize fastlane (if needed)
fastlane init
```

### Configuration

The API validation can be customized by modifying the `validate_openapi_spec` private lane in the Fastfile.

Required endpoints that are validated:
- `/auth/login`
- `/auth/refresh` 
- `/auth/logout`

Required security schemes:
- `BearerAuth` with HTTP Bearer JWT format

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).