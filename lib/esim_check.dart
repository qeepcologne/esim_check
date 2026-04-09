import 'package:flutter/services.dart';

class EsimCheck {
  static const _channel = MethodChannel('esim_check');

  /// Returns `true` if the device has eSIM hardware.
  ///
  /// On iOS, detection uses the device model identifier since Apple's
  /// CTCellularPlanProvisioning API requires a restricted carrier entitlement.
  /// Pass [additionalModels] to extend the built-in list with new device
  /// identifiers (e.g. `["iPhone20,1", "iPad15,1"]`).
  ///
  /// On Android, uses EuiccManager — [additionalModels] is ignored.
  static Future<bool> isSupported({
    List<String> additionalModels = const [],
  }) async {
    try {
      return await _channel.invokeMethod<bool>('isSupported', {
            'additionalModels': additionalModels,
          }) ??
          false;
    } on MissingPluginException {
      return false;
    }
  }
}
