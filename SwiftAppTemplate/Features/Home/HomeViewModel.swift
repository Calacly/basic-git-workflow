import SwiftUI
import Observation

/// Drives the Home screen. Simulates async loading so the skeleton state and
/// load-in animation are visible. Swap `load()`/`refresh()` for real data.
@MainActor
@Observable
final class HomeViewModel {
    enum LoadState {
        case loading
        case loaded
    }

    private(set) var state: LoadState = .loading
    private(set) var items: [FeedItem] = []

    func load() async {
        guard items.isEmpty else { return }
        state = .loading
        try? await Task.sleep(for: .seconds(1.1))
        items = FeedItem.samples
        withAnimation(.smooth(duration: 0.45)) {
            state = .loaded
        }
    }

    func refresh() async {
        try? await Task.sleep(for: .seconds(0.9))
        withAnimation(.smooth) {
            items.shuffle()
        }
    }
}
