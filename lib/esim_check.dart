import 'package:flutter/services.dart';

class EsimCheck {
  EsimCheck._();

  static const _channel = MethodChannel('esim_check');

  /// Returns `true` if the device has eSIM hardware.
  ///
  /// On iOS, detection uses the device model identifier since Apple's
  /// CTCellularPlanProvisioning API requires a restricted carrier entitlement.
  /// Both parameters are iOS-only — Android uses `EuiccManager` directly.
  /// They are checked before the built-in lists and the even-minor heuristic,
  /// so they can correct any identifier, not just future iPads.
  /// [includeIosModels] forces identifiers to be treated as eSIM-capable.
  /// [excludeIosModels] forces identifiers to be treated as not capable
  /// and takes priority over [includeIosModels].
  static Future<bool> isSupported({
    List<String> includeIosModels = const [],
    List<String> excludeIosModels = const [],
  }) async {
    try {
      return await _channel.invokeMethod<bool>('isSupported', {
            'includeModels': includeIosModels,
            'excludeModels': excludeIosModels,
          }) ??
          false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      // Native lookup failed (e.g. binder error on an OEM device) — treat as
      // unsupported rather than surfacing an exception to the caller.
      return false;
    }
  }
}
