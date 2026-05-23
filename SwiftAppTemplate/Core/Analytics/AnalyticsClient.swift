import Foundation

/// A single analytics event. Keep names stable and properties string-valued so
/// they map cleanly onto any provider.
struct AnalyticsEvent {
    var name: String
    var properties: [String: String]

    init(_ name: String, properties: [String: String] = [:]) {
        self.name = name
        self.properties = properties
    }
}

/// Vendor-neutral analytics seam. Implement against your provider of choice;
/// the rest of the app only ever calls `track(_:)`.
protocol AnalyticsClient: Sendable {
    func track(_ event: AnalyticsEvent)
}

/// Logs events to the unified log. Handy default while developing.
struct ConsoleAnalytics: AnalyticsClient {
    func track(_ event: AnalyticsEvent) {
        AppLog.app.debug("analytics • \(event.name, privacy: .public) \(event.properties.description, privacy: .public)")
    }
}

/// Drops all events. Use in tests and previews.
struct NoopAnalytics: AnalyticsClient {
    func track(_ event: AnalyticsEvent) {}
}
