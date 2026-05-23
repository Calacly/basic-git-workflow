import SwiftUI
import Observation

/// App-wide, in-memory state and dependencies shared through the SwiftUI
/// environment. Inject once at the root with `.environment(AppEnvironment())`
/// and read it anywhere with `@Environment(AppEnvironment.self)`.
@Observable
final class AppEnvironment {
    /// The currently selected bottom tab.
    var selectedTab: AppTab = .home

    /// Injected dependencies (networking, analytics, persistence). Read these
    /// from view models rather than constructing services directly.
    let services: AppServices

    init(services: AppServices = .live()) {
        self.services = services
    }
}
