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

### Extending the iOS device list

The plugin includes all iPhones from iPhone XS onward (excluding the China XS Max dual-SIM variant). For new devices or iPads, pass additional machine identifiers:

```dart
final supported = await EsimCheck.isSupported(
  additionalModels: ['iPhone20,1', 'iPad15,1'],
);
```

The `additionalModels` parameter is ignored on Android (where the real API is available).

### Platform behavior

| Platform | Method | Fallback |
|---|---|---|
| Android >= API 28 | `EuiccManager.isEnabled()` | — |
| Android < API 28 | — | Returns `false` |
| iOS | Machine identifier lookup | Returns `false` for unknown models |
| Web, desktop | — | Returns `false` |

Note: some Windows/macOS laptops have eSIM hardware but no platform implementation exists for desktop — contributions welcome.

## iOS detection details

Apple's `CTCellularPlanProvisioning.supportsCellularPlan()` requires the `com.apple.developer.networking.cellular-provider` entitlement, which Apple only grants to carriers. Without it, the API always returns `false`.

The `CTTelephonyNetworkInfo` workaround (counting SIM service keys) broke in iOS 16 when Apple deprecated `CTCarrier`.

This plugin uses the device model identifier (`utsname`) instead. All iPhones from iPhone XS (iPhone11,x) onward support eSIM, except `iPhone11,4` (China XS Max with dual physical SIM slot instead of eSIM). Use `additionalModels` to cover new devices before the plugin is updated.
