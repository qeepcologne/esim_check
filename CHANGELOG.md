## 1.2.1

- `includeIosModels`/`excludeIosModels` now apply to every identifier instead of iPad18+ only — they are checked before the verified lists and the even-minor heuristic. A new iPad numbered inside an existing major (e.g. `iPad17,x`) previously fell through to the explicit list and returned `false` with no way to correct it from the app.

## 1.2.0

- Requires **Dart 3.13 / Flutter 3.47** (`sdk: ^3.13.0`, `flutter: >=3.47.0`) — the toolchain this package is now built and tested against.
- `onMethodCall` is a single `when` with a Kotlin guard (`"isSupported" if SDK_INT < P ->`) instead of nested `if`/`else`. No behaviour change; guards need Kotlin 2.2, which AGP 9 already provides.

## 1.1.4

- Return `false` instead of throwing when the native lookup fails (`PlatformException` is now caught, matching the documented contract).
- Compute the iOS machine identifier once instead of on every call.
- Prevent instantiation of the static-only `EsimCheck` class.

## 1.1.3

- Add usage example (`example/lib/main.dart`).
- Add `topics` and `issue_tracker` to pubspec for pub.dev discoverability.
- Remove deprecated `package` attribute from Android manifest (namespace is set in Gradle).

## 1.1.2

- Fix iOS build failure under Swift 6 (`@preconcurrency import Flutter`). 1.1.1 did not compile on iOS.

## 1.1.1

- Build tooling only — Swift 6.2 / Swift 6 language mode (building now requires **Xcode 26+**) and a simpler Android Gradle file.

## 1.1.0

- Add iPad15–17 cellular models to explicit list (iPad Air M3, iPad 11th gen, iPad mini 7, iPad Pro M4/M5, iPad Air M4)
- Fix iPad16,8–11 false positives/negatives where even-minor heuristic broke
- Bump even-minor heuristic from iPad15+ to iPad18+
- Rename `additionalModels` to `includeIosModels`/`excludeIosModels` (iOS-only, iPad18+ heuristic override)
- Document Android emulator behavior in platform table
- Document watchOS and Windows/macOS tablet limitations

## 1.0.0

- Initial release
- eSIM support detection via native APIs
- Android: EuiccManager.isEnabled() with API 28 runtime check
- iOS: device model identifier lookup with future-proof heuristics
