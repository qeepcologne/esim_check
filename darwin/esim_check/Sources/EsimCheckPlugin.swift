import Flutter

public class EsimCheckPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "esim_check", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(EsimCheckPlugin(), channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isSupported":
            let args = call.arguments as? [String: Any]
            let additional = args?["additionalModels"] as? [String] ?? []
            result(Self.isEsimCapable(additionalModels: additional))
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private static func machineIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(cString: $0)
            }
        }
    }

    private static func isEsimCapable(additionalModels: [String]) -> Bool {
        let machine = machineIdentifier()

        if additionalModels.contains(machine) { return true }

        // All iPhones from iPhone XS (iPhone11,x) onward support eSIM,
        // except iPhone11,4 (China XS Max with dual physical SIM).
        guard machine.hasPrefix("iPhone") else { return false }
        let digits = machine.dropFirst(6) // strip "iPhone"
        guard let comma = digits.firstIndex(of: ","),
              let major = Int(digits[digits.startIndex..<comma]) else { return false }

        if major >= 12 { return true }
        if major == 11 { return machine != "iPhone11,4" }
        return false
    }
}
