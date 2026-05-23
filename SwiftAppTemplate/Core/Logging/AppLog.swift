import Foundation
import OSLog

/// Thin wrapper over `os.Logger` with ready-made categories so logs are
/// structured and filterable in Console.app / Instruments.
///
/// Usage: `AppLog.network.debug("Requesting \(url, privacy: .public)")`.
enum AppLog {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.example.SwiftAppTemplate"

    static let app = Logger(subsystem: subsystem, category: "app")
    static let network = Logger(subsystem: subsystem, category: "network")
    static let ui = Logger(subsystem: subsystem, category: "ui")
    static let data = Logger(subsystem: subsystem, category: "data")
}
