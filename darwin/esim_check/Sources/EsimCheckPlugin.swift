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

    // Cellular iPad models with eSIM (iPad7–17). Listed explicitly because
    // the minor numbering is inconsistent (e.g. iPad16,8–11 break even=cellular).
    // From iPad18 onward, even minor = cellular = eSIM (handled by heuristic).
    private static let esimCapableIPads: Set<String> = [
        // iPad 7th gen (2019)
        "iPad7,12",
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
        // iPad Air 11" M3 (2025)
        "iPad15,4",
        // iPad Air 13" M3 (2025)
        "iPad15,6",
        // iPad 11th gen (2025)
        "iPad15,8",
        // iPad mini 7 (2024)
        "iPad16,2",
        // iPad Pro 11" M4 (2024)
        "iPad16,4",
        // iPad Pro 13" M4 (2024)
        "iPad16,6",
        // iPad Air 11" M4 (2026)
        "iPad16,9",
        // iPad Air 13" M4 (2026)
        "iPad16,11",
        // iPad Pro 11" M5 (2025)
        "iPad17,2",
        // iPad Pro 13" M5 (2025)
        "iPad17,4",
    ]

    private static func parseMajorMinor(_ machine: String, prefix: String) -> (Int, Int)? {
        let digits = machine.dropFirst(prefix.count)
        guard let comma = digits.firstIndex(of: ","),
              let major = Int(digits[digits.startIndex..<comma]),
              let minor = Int(digits[digits.index(after: comma)...]) else { return nil }
        return (major, minor)
    }

    private static func isEsimCapable(additionalModels: [String]) -> Bool {
        let machine = machineIdentifier()
        // Simulators return "arm64" or "x86_64" — no match, returns false
        if additionalModels.contains(machine) { return true }

        if machine.hasPrefix("iPad") {
            guard let (major, minor) = parseMajorMinor(machine, prefix: "iPad") else { return false }
            // From iPad18+, even minor = cellular = eSIM capable.
            // Apple pairs each iPad as (odd = WiFi, even = WiFi+Cellular),
            // e.g. iPad15,3/4, iPad17,1/2. This held for iPad15–17 except
            // iPad16,8–11 where Apple skipped ,7 and reset the parity.
            // Those are covered by the explicit list above; the heuristic
            // is a best-effort fallback for future models.
            if major >= 18 { return minor % 2 == 0 }
            // Older iPads: explicit list
            return esimCapableIPads.contains(machine)
        }

        if machine.hasPrefix("iPhone") {
            guard let (major, _) = parseMajorMinor(machine, prefix: "iPhone") else { return false }
            // All iPhones from iPhone XS (iPhone11,x) onward support eSIM,
            // except iPhone11,4 (China XS Max with dual physical SIM).
            if major >= 12 { return true }
            if major == 11 { return machine != "iPhone11,4" }
        }

        return false
    }
}
