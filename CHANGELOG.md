## 1.1.1

- **iOS**: bump `swift-tools-version` to 6.2 and adopt the Swift 6 language mode. No API or runtime change; the iOS runtime floor stays at 15. Building now requires **Xcode 26+** (Swift 6.2 toolchain).
- **Android**: simplify `build.gradle.kts` — drop the `sourceSets` override (AGP 9's built-in Kotlin recognizes `src/main/kotlin` automatically) and the redundant `compileOptions` Java-level block (the consuming app sets the Java/JVM target across all modules). No build-output change.

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
