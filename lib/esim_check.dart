import 'package:flutter/services.dart';

class EsimCheck {
  static const _channel = MethodChannel('esim_check');

  /// Returns `true` if the device has eSIM hardware.
  ///
  /// On iOS, detection uses the device model identifier since Apple's
  /// CTCellularPlanProvisioning API requires a restricted carrier entitlement.
  /// Pass [additionalIosModels] to extend the built-in iOS device list with
  /// new machine identifiers (e.g. `["iPhone20,1", "iPad19,2"]`).
  /// Ignored on Android where `EuiccManager` detects eSIM hardware directly.
  static Future<bool> isSupported({
    List<String> additionalIosModels = const [],
  }) async {
    try {
      return await _channel.invokeMethod<bool>('isSupported', {
            'additionalModels': additionalIosModels,
          }) ??
          false;
    } on MissingPluginException {
      return false;
    }
  }
}
