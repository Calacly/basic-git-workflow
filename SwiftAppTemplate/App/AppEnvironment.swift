import SwiftUI
import Observation

/// App-wide, in-memory state shared through the SwiftUI environment.
/// Inject once at the root with `.environment(AppEnvironment())` and read it
/// anywhere with `@Environment(AppEnvironment.self)`.
@Observable
final class AppEnvironment {
    /// The currently selected bottom tab.
    var selectedTab: AppTab = .home
}
