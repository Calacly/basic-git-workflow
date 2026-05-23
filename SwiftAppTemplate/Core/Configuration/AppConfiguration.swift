import Foundation

/// Build-time configuration so feature code never hard-codes environment
/// details. Drive these per build configuration with `.xcconfig` files that
/// set Info.plist keys (e.g. `API_BASE_URL`), and read them here.
enum AppConfiguration {
    /// Logical runtime environment.
    enum Environment: String {
        case development, staging, production
    }

    static var environment: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }

    /// Base URL for the app's API. Points at a placeholder until you set
    /// `API_BASE_URL` in Info.plist / your `.xcconfig`.
    static var apiBaseURL: URL {
        if let raw = infoValue("API_BASE_URL"), let url = URL(string: raw) {
            return url
        }
        return URL(string: "https://api.example.com")!
    }

    static var appVersion: String { infoValue("CFBundleShortVersionString") ?? "1.0" }
    static var buildNumber: String { infoValue("CFBundleVersion") ?? "1" }
    static var isDebug: Bool { environment == .development }

    private static func infoValue(_ key: String) -> String? {
        Bundle.main.object(forInfoDictionaryKey: key) as? String
    }
}
