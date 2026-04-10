# esim_check

Flutter plugin to check eSIM hardware support using native platform APIs.

- **Android**: [`EuiccManager.isEnabled()`](https://developer.android.com/reference/android/telephony/euicc/EuiccManager#isEnabled()) — real hardware check, no entitlements needed
- **iOS**: Device model identifier check — Apple's `CTCellularPlanProvisioning` API requires a restricted carrier entitlement, so we match the machine identifier against known eSIM-capable models instead

No permissions required. Works offline and in flight mode.

## Requirements

- Flutter >= 3.41.6
- Android: minSdk 24, AGP 9 (no backward compatibility with older AGP versions)
- iOS: iOS 15+, Swift Package Manager only (no CocoaPods)

## Usage

```dart
import 'package:esim_check/esim_check.dart';

final supported = await EsimCheck.isSupported();
```

Returns `true` if the device has eSIM hardware, `false` otherwise.

### Overriding the iPad18+ heuristic

iPhones and iPads through iPad17 use verified lists. Future iPads (iPad18+) fall back to an even-minor heuristic that may not hold for every model. Use `includeIosModels` and `excludeIosModels` to correct it:

```dart
final supported = await EsimCheck.isSupported(
  includeIosModels: ['iPad19,3'],  // cellular model the heuristic misses
  excludeIosModels: ['iPad18,4'],  // WiFi-only model the heuristic matches
);
```

`excludeIosModels` takes priority. Both parameters are iOS-only and ignored on Android.

### Platform behavior

| Platform | Method | Fallback |
|---|---|---|
| Android >= API 28 | `EuiccManager.isEnabled()` | — |
| Android < API 28 | — | Returns `false` (no Android device with eSIM shipped before API 28) |
| iOS | Machine identifier lookup | Returns `false` for unknown models |
| Android Emulator | `EuiccManager.isEnabled()` | Returns `false` (no eSIM hardware) |
| iOS Simulator | — | Returns `false` (no eSIM hardware) |
| Web, desktop | — | Returns `false` |

Note: some Windows/macOS laptops and tablets (e.g. Surface Pro) have eSIM hardware but no platform implementation exists for desktop — contributions welcome. Apple Watch supports eSIM but Flutter does not run on watchOS.

## iOS detection details

Apple's `CTCellularPlanProvisioning.supportsCellularPlan()` requires the `com.apple.developer.networking.cellular-provider` entitlement, which Apple only grants to carriers. Without it, the API always returns `false`.

The `CTTelephonyNetworkInfo` workaround (counting SIM service keys) broke in iOS 16 when Apple deprecated `CTCarrier`.

This plugin uses the device model identifier (`utsname`) instead:

- **iPhones**: All models from iPhone XS (`iPhone11,x`) onward support eSIM, except `iPhone11,4` (China XS Max with dual physical SIM). Uses major version heuristic — future-proof.
- **iPads (2026+)**: From `iPad18,x` onward, even minor number = cellular = eSIM capable (odd = WiFi-only). Future-proof heuristic. Note: the even-minor pattern broke for `iPad16,8`–`iPad16,11` (2026 iPad Air M4), so all models through `iPad17` are listed explicitly.
- **iPads (2018–2025)**: `iPad7`–`iPad17` cellular models are matched against an explicit list (minor numbering is inconsistent — e.g. `iPad16,9` is cellular while `iPad16,8` is WiFi-only).

Use `includeIosModels`/`excludeIosModels` to correct the iPad18+ heuristic for specific models. Simulators return the host architecture (`arm64`/`x86_64`) which doesn't match any device pattern, so they correctly return `false`.

### Mainland China limitation

Most iPhones sold in mainland China (iPhone XR through iPhone 16) and all cellular iPads have dual physical SIM slots instead of eSIM, but share the same machine identifiers as their global eSIM-capable counterparts. The only exception is `iPhone11,4` (China XS Max), which has a unique identifier and is explicitly excluded. For all other China models, the plugin cannot distinguish them from global variants and will return a **false positive**. This is a fundamental limitation of the device model approach — Apple does not expose eSIM capability through any public API without the restricted carrier entitlement.
