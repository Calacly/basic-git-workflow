import Foundation

/// The app's dependency container. Built once at launch and injected through
/// the environment so features read the services they need instead of creating
/// their own. Swap implementations here for previews, tests, or new backends.
struct AppServices {
    var api: APIClient
    var analytics: AnalyticsClient
    var store: FileStore

    static func live() -> AppServices {
        AppServices(
            api: LiveAPIClient(baseURL: AppConfiguration.apiBaseURL),
            analytics: ConsoleAnalytics(),
            store: .shared
        )
    }

    static func preview() -> AppServices {
        AppServices(
            api: MockAPIClient(),
            analytics: NoopAnalytics(),
            store: FileStore(directoryName: "preview-store")
        )
    }
}
