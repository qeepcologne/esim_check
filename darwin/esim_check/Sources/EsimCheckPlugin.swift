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

    // Cellular iPad models with eSIM (2018+).
    // WiFi-only iPads never have eSIM. Unlike iPhones there is no clean
    // numbering heuristic, so we list cellular identifiers explicitly.
    private static let esimCapableIPads: Set<String> = [
        // iPad Pro 11" 1st gen (2018)
        "iPad8,3", "iPad8,4",
        // iPad Pro 12.9" 3rd gen (2018)
        "iPad8,7", "iPad8,8",
        // iPad Pro 11" 2nd gen (2020)
        "iPad8,10",
        // iPad Pro 12.9" 4th gen (2020)
        "iPad8,12",
        // iPad mini 5 (2019)
        "iPad11,2",
        // iPad Air 3 (2019)
        "iPad11,4",
        // iPad 8th gen (2020)
        "iPad11,7",
        // iPad 7th gen (2019)
        "iPad7,12",
        // iPad 9th gen (2021)
        "iPad12,2",
        // iPad Air 4 (2020)
        "iPad13,2",
        // iPad Pro 11" 3rd gen (2021)
        "iPad13,6", "iPad13,7",
        // iPad Pro 12.9" 5th gen (2021)
        "iPad13,10", "iPad13,11",
        // iPad Air 5 (2022)
        "iPad13,17",
        // iPad 10th gen (2022)
        "iPad13,19",
        // iPad mini 6 (2021)
        "iPad14,2",
        // iPad Pro 11" 4th gen (2022)
        "iPad14,4",
        // iPad Pro 12.9" 6th gen (2022)
        "iPad14,6",
        // iPad Air 11" M2 (2024)
        "iPad14,9",
        // iPad Air 13" M2 (2024)
        "iPad14,11",
        // iPad mini 7 (2024)
        "iPad16,2",
        // iPad Pro 11" M4 (2024)
        "iPad16,4",
        // iPad Pro 13" M4 (2024)
        "iPad16,6",
        // iPad Air 11" M3 (2025)
        "iPad15,4",
        // iPad Air 13" M3 (2025)
        "iPad15,6",
        // iPad 11th gen A16 (2025)
        "iPad15,8",
        // iPad Pro 11" M5 (2025)
        "iPad17,2",
        // iPad Pro 13" M5 (2025)
        "iPad17,4",
    ]

    private static func isEsimCapable(additionalModels: [String]) -> Bool {
        let machine = machineIdentifier()
        // Simulators return "arm64" or "x86_64" — no match, returns false
        if additionalModels.contains(machine) { return true }

        if machine.hasPrefix("iPad") {
            return esimCapableIPads.contains(machine)
        }

        // All iPhones from iPhone XS (iPhone11,x) onward support eSIM,
        // except iPhone11,4 (China XS Max with dual physical SIM).
        guard machine.hasPrefix("iPhone") else { return false }
        let digits = machine.dropFirst(6)
        guard let comma = digits.firstIndex(of: ","),
              let major = Int(digits[digits.startIndex..<comma]) else { return false }

        if major >= 12 { return true }
        if major == 11 { return machine != "iPhone11,4" }
        return false
    }
}
