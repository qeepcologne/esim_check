import Flutter
import CoreTelephony

public class EsimCheckPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "esim_check", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(EsimCheckPlugin(), channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isSupported":
            result(CTCellularPlanProvisioning().supportsCellularPlan())
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
