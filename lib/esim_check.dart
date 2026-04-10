import 'package:flutter/services.dart';

class EsimCheck {
  static const _channel = MethodChannel('esim_check');

  /// Returns `true` if the device has eSIM hardware.
  ///
  /// On iOS, detection uses the device model identifier since Apple's
  /// CTCellularPlanProvisioning API requires a restricted carrier entitlement.
  /// Both parameters are iOS-only — Android uses `EuiccManager` directly.
  /// They override the even-minor heuristic for future iPads (iPad18+) only.
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
    }
  }
}
