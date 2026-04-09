# esim_check

Flutter plugin to check eSIM hardware support using native platform APIs.

- **Android**: [`EuiccManager.isEnabled()`](https://developer.android.com/reference/android/telephony/euicc/EuiccManager#isEnabled())
- **iOS**: [`CTCellularPlanProvisioning.supportsCellularPlan()`](https://developer.apple.com/documentation/coretelephony/ctcellularplanprovisioning/3024297-supportscellularplan)

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

## Why not use existing packages?

Every existing Flutter eSIM plugin uses a hardcoded device model whitelist on iOS, which breaks with every new Apple device. This plugin uses the actual platform API instead.
