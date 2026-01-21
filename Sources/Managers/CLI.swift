import Foundation

enum CLI {
    // MARK: - Core
    static func printInfo(_ message: String) {
        print("[INFO] \(message)")
    }

    static func printSuccess(_ message: String) {
        print("[OK] \(message)")
    }

    static func printWarning(_ message: String) {
        print("[WARN] \(message)")
    }

    static func printError(_ message: String) {
        fputs("[ERROR] \(message)\n", stderr)
    }

    // MARK: - Structured output helpers
    static func printHeader(_ title: String) {
        print("=== \(title) ===")
    }

    static func printKeyValue(_ key: String, _ value: String, unit: String? = nil) {
        if let unit {
            print("- \(key): \(value) \(unit)")
        } else {
            print("- \(key): \(value)")
        }
    }

    // MARK: - Domain helpers
    static func printTrakTime(subject: String, seconds: TimeInterval) {
        let formatted = formatHMS(seconds)
        printKeyValue(subject, formatted)
    }

    // MARK: - Formatting helpers
    private static func formatHMS(_ seconds: TimeInterval) -> String {
        let total = Int(seconds.rounded())
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        if h > 0 {
            return String(format: "%02dh %02dm %02ds", h, m, s)
        } else if m > 0 {
            return String(format: "%02dm %02ds", m, s)
        } else {
            return String(format: "%02ds", s)
        }
    }
}
