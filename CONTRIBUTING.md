# Contributing to MayR Local Notifications

First off, thank you for considering contributing to MayR Local Notifications! It's people like you that make this plugin better for everyone.

## Code of Conduct

This project and everyone participating in it is governed by basic principles of respect and inclusivity. By participating, you are expected to uphold these values.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

* **Use a clear and descriptive title**
* **Describe the exact steps to reproduce the problem**
* **Provide specific examples** - include code snippets
* **Describe the behavior you observed and what you expected**
* **Include platform details** (Android version, iOS version, Flutter version, etc.)
* **Include logs** if possible (enable debug logs with `enableDebugLogs: true`)

### Suggesting Enhancements

Enhancement suggestions are welcome! Please provide:

* **A clear and descriptive title**
* **A detailed description of the proposed feature**
* **Explain why this enhancement would be useful**
* **Provide examples of how it would be used**

### Pull Requests

1. **Fork the repo** and create your branch from `main`
2. **Make your changes** following the guidelines below
3. **Add or update tests** as appropriate
4. **Update documentation** if you changed APIs
5. **Ensure tests pass** by running `flutter test`
6. **Format your code** with `flutter format .`
7. **Run the analyzer** with `flutter analyze`
8. **Submit a pull request**

## Development Guidelines

### Setting Up Your Development Environment

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/mayr_local_notifications.git
cd mayr_local_notifications

# Get dependencies
flutter pub get

# Run tests
flutter test

# Run the example app
cd example
flutter run
```

### Project Structure

```
mayr_local_notifications/
├── lib/                          # Dart public API
├── android/                      # Android implementation
├── ios/                          # iOS implementation
├── macos/                        # macOS implementation
├── example/                      # Example app
├── test/                         # Unit tests
└── integration_test/             # Integration tests
```

### Code Style

#### Dart

* Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
* Use `flutter format` to format your code
* Maximum line length: 100 characters
* Add documentation comments (`///`) for all public APIs

Example:
```dart
/// Send an immediate notification.
/// 
/// The [title] and [body] parameters are required. An optional [payload]
/// can be attached for custom data.
/// 
/// Throws [PlatformException] if sending fails.
static Future<void> send({
  required String title,
  required String body,
  Map<String, dynamic>? payload,
}) {
  // Implementation
}
```

#### Kotlin (Android)

* Follow Kotlin coding conventions
* Use 4 spaces for indentation
* Add KDoc comments for public methods

#### Swift (iOS/macOS)

* Follow Swift API Design Guidelines
* Use 2 spaces for indentation
* Add documentation comments for public methods

### Testing

#### Running Tests

```bash
# Run all unit tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests (requires a device/emulator)
cd example
flutter test integration_test/
```

#### Writing Tests

* All new features should include tests
* All bug fixes should include a regression test
* Aim for high code coverage (>80%)
* Test both success and error cases

Example:
```dart
test('send notification with payload', () async {
  MockMayrLocalNotificationsPlatform fakePlatform = 
    MockMayrLocalNotificationsPlatform();
  MayrLocalNotificationsPlatform.instance = fakePlatform;

  await MayrLocalNotifications.send(
    title: 'Test',
    body: 'Test body',
    payload: {'key': 'value'},
  );
  
  // Verify the method was called
  expect(fakePlatform.sendCalled, true);
});
```

### Documentation

#### Updating Documentation

When making changes that affect the public API:

1. Update the main README.md
2. Update API.md with detailed API docs
3. Update CHANGELOG.md
4. Add/update code examples in the example app
5. Update inline code documentation

#### Documentation Style

* Use clear, concise language
* Provide code examples for all features
* Explain the "why" not just the "what"
* Include platform-specific notes where relevant

### Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally

Examples:
```
Add support for custom notification icons

Implement custom icon support for Android notifications.
Icons can be specified during initialization.

Fixes #123
```

### Branch Naming

* `feature/description` - for new features
* `fix/description` - for bug fixes
* `docs/description` - for documentation updates
* `refactor/description` - for code refactoring

### Platform-Specific Contributions

#### Android

* Test on multiple Android versions (especially latest and minimum supported)
* Consider backward compatibility with older Android versions
* Use AndroidX libraries, not deprecated support libraries
* Follow Material Design guidelines for notifications

#### iOS/macOS

* Test on multiple iOS/macOS versions
* Use modern UserNotifications framework
* Respect system notification settings
* Consider different device sizes

### Release Process

Releases are managed by maintainers. The process is:

1. Update version in `pubspec.yaml`
2. Update CHANGELOG.md
3. Create a git tag
4. Publish to pub.dev

## Questions?

Don't hesitate to ask questions! You can:

* Open an issue with the "question" label
* Check existing issues and discussions
* Review the documentation in README.md and API.md

## Recognition

Contributors will be recognized in the CHANGELOG and GitHub releases.

Thank you for contributing! 🎉
